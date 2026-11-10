'use strict';

// Parser compacto para volcados MySQL. No ejecuta SQL; solo inspecciona DDL e INSERT.
(function (root, factory) {
  const api = factory();
  if (typeof module !== 'undefined' && module.exports) module.exports = api;
  if (root) root.DiccionarioDB = api;
})(typeof globalThis !== 'undefined' ? globalThis : this, function () {
  const IDENT = "(?:`((?:``|[^`])+)`|([A-Za-z0-9_$.-]+))";

  function unquoteIdentifier(value) {
    const text = value.trim();
    if (text.startsWith('`') && text.endsWith('`')) return text.slice(1, -1).replace(/``/g, '`');
    return text;
  }

  function skipQuoted(sql, i) {
    const quote = sql[i];
    let j = i + 1;
    while (j < sql.length) {
      if (sql[j] === '\\') { j += 2; continue; }
      if (sql[j] === quote) {
        if (sql[j + 1] === quote) { j += 2; continue; }
        return j + 1;
      }
      j++;
    }
    return sql.length;
  }

  function skipComment(sql, i) {
    if (sql.startsWith('/*', i)) {
      const end = sql.indexOf('*/', i + 2);
      return end < 0 ? sql.length : end + 2;
    }
    if (sql.startsWith('--', i) && (i + 2 === sql.length || /\s/.test(sql[i + 2]))) {
      const end = sql.indexOf('\n', i + 2);
      return end < 0 ? sql.length : end + 1;
    }
    if (sql[i] === '#') {
      const end = sql.indexOf('\n', i + 1);
      return end < 0 ? sql.length : end + 1;
    }
    return i;
  }

  function findMatchingParen(sql, openAt) {
    let depth = 0;
    for (let i = openAt; i < sql.length;) {
      if (sql[i] === "'" || sql[i] === '"' || sql[i] === '`') { i = skipQuoted(sql, i); continue; }
      const commentEnd = skipComment(sql, i);
      if (commentEnd !== i) { i = commentEnd; continue; }
      if (sql[i] === '(') depth++;
      else if (sql[i] === ')' && --depth === 0) return i;
      i++;
    }
    return -1;
  }

  function splitTopLevel(text, separator = ',') {
    const result = [];
    let start = 0, depth = 0;
    for (let i = 0; i < text.length;) {
      if (text[i] === "'" || text[i] === '"' || text[i] === '`') { i = skipQuoted(text, i); continue; }
      const commentEnd = skipComment(text, i);
      if (commentEnd !== i) { i = commentEnd; continue; }
      if (text[i] === '(') depth++;
      else if (text[i] === ')') depth--;
      else if (text[i] === separator && depth === 0) { result.push(text.slice(start, i).trim()); start = i + 1; }
      i++;
    }
    if (text.slice(start).trim()) result.push(text.slice(start).trim());
    return result;
  }

  function extractParenList(text, startAt) {
    const open = text.indexOf('(', startAt);
    if (open < 0) return { values: [], close: -1 };
    const close = findMatchingParen(text, open);
    return { values: close < 0 ? [] : splitTopLevel(text.slice(open + 1, close)), close };
  }

  function findStatementEnd(sql, startAt) {
    for (let i = startAt; i < sql.length;) {
      if (sql[i] === "'" || sql[i] === '"' || sql[i] === '`') { i = skipQuoted(sql, i); continue; }
      const commentEnd = skipComment(sql, i);
      if (commentEnd !== i) { i = commentEnd; continue; }
      if (sql[i] === ';') return i;
      i++;
    }
    return sql.length;
  }

  function columnNames(list) {
    return list.map(part => {
      const match = part.match(/^\s*(`(?:``|[^`])+`|[A-Za-z0-9_$.-]+)/);
      return match ? unquoteIdentifier(match[1]) : part.trim();
    });
  }

  function readType(definition, afterName) {
    const tail = definition.slice(afterName).trimStart();
    const match = tail.match(/^([A-Za-z]+)(?:\s*\()/);
    if (!match) {
      const word = tail.match(/^([^\s,]+)/);
      if (!word) return '';
      const modifier = tail.slice(word[0].length).match(/^\s+(UNSIGNED|ZEROFILL|BINARY)(?:\s+(?:UNSIGNED|ZEROFILL))?/i);
      return word[1] + (modifier ? modifier[0] : '');
    }
    const typeStart = match[0].length - 1;
    const open = tail.indexOf('(', typeStart);
    if (open < 0) return match[1];
    const close = findMatchingParen(tail, open);
    let type = close < 0 ? tail.slice(0, open + 1) : tail.slice(0, close + 1);
    const modifier = (close < 0 ? '' : tail.slice(close + 1)).match(/^\s+(UNSIGNED|ZEROFILL|BINARY)(?:\s+(?:UNSIGNED|ZEROFILL))?/i);
    if (modifier) type += modifier[0];
    return type.trim();
  }

  function readDefault(definition) {
    const match = /\bDEFAULT\s+/i.exec(definition);
    if (!match) return null;
    let i = match.index + match[0].length;
    if (i >= definition.length) return '';
    if (definition[i] === "'" || definition[i] === '"') return definition.slice(i, skipQuoted(definition, i));
    if (definition[i] === '(') {
      const close = findMatchingParen(definition, i);
      return close < 0 ? definition.slice(i).trim() : definition.slice(i, close + 1);
    }
    const rest = definition.slice(i);
    const val = rest.match(/^(?:CURRENT_TIMESTAMP(?:\s*\(\s*\d*\s*\))?|NULL|TRUE|FALSE|[+-]?(?:\d+(?:\.\d*)?|\.\d+)|[A-Za-z_][A-Za-z0-9_$]*(?:\s*\(\s*\d*\s*\))?)/i);
    return val ? val[0] : rest.split(/\s+(?:NOT NULL|NULL|AUTO_INCREMENT|COMMENT|COLLATE)\b/i)[0].trim();
  }

  function parseCreateTable(sql, start, createMatch, lineAt) {
    let openAt = sql.indexOf('(', createMatch.index + createMatch[0].length);
    if (openAt < 0) return null;
    const closeAt = findMatchingParen(sql, openAt);
    if (closeAt < 0) return null;
    const name = unquoteIdentifier(createMatch[1] || createMatch[2]);
    const body = sql.slice(openAt + 1, closeAt);
    const statementEnd = findStatementEnd(sql, closeAt + 1);
    const table = {
      name, columns: [], indexes: [], foreignKeys: [], checks: [], line: lineAt(start), endLine: lineAt(statementEnd),
      options: sql.slice(closeAt + 1, statementEnd).trim(), ddl: sql.slice(start, statementEnd + (statementEnd < sql.length ? 1 : 0)).trim()
    };

    for (const def of splitTopLevel(body)) {
      let m;
      if (/^(?:CONSTRAINT\b[\s\S]*?\s+)?FOREIGN\s+KEY\b/i.test(def)) {
        const fk = def.match(new RegExp('^(?:CONSTRAINT\\s+(`(?:``|[^`])+`|[A-Za-z0-9_$.-]+)\\s+)?FOREIGN\\s+KEY\\s*(?:(`(?:``|[^`])+`|[A-Za-z0-9_$.-]+)\\s*)?\\(', 'i'));
        const local = extractParenList(def, fk ? fk[0].lastIndexOf('(') : 0);
        const ref = def.match(new RegExp('REFERENCES\\s+(' + IDENT + ')\\s*\\(', 'i'));
        let referenced = { values: [], close: -1 };
        if (ref) referenced = extractParenList(def, ref.index + ref[0].length - 1);
        const actions = {};
        for (const action of ['DELETE', 'UPDATE']) {
          const found = def.match(new RegExp('\\bON\\s+' + action + '\\s+(CASCADE|RESTRICT|SET\\s+NULL|NO\\s+ACTION|SET\\s+DEFAULT)\\b', 'i'));
          actions[action.toLowerCase()] = found ? found[1].replace(/\s+/g, ' ').toUpperCase() : null;
        }
        table.foreignKeys.push({
          name: fk && fk[1] ? unquoteIdentifier(fk[1]) : `fk_${table.name}_${table.foreignKeys.length + 1}`,
          columns: columnNames(local.values),
          referencedTable: ref ? unquoteIdentifier(ref[1] || ref[2] || ref[3]) : '',
          referencedColumns: columnNames(referenced.values),
          onDelete: actions.delete,
          onUpdate: actions.update,
          definition: def
        });
        continue;
      }
      if (/^(?:CONSTRAINT\b[\s\S]*?\s+)?CHECK\s*\(/i.test(def)) {
        table.checks.push(def);
        continue;
      }
      if (/^(?:CONSTRAINT\b[\s\S]*?\s+)?PRIMARY\s+KEY\b/i.test(def)) {
        const list = extractParenList(def, def.search(/PRIMARY\s+KEY/i));
        table.indexes.push({ name: 'PRIMARY', type: 'PRIMARY', unique: true, columns: columnNames(list.values), definition: def });
        continue;
      }
      if (/^(?:CONSTRAINT\b[\s\S]*?\s+)?(?:UNIQUE\s+(?:KEY|INDEX)|(?:FULLTEXT|SPATIAL)\s+(?:KEY|INDEX)|KEY|INDEX)\b/i.test(def)) {
        const head = def.match(/^(?:CONSTRAINT\s+(`(?:``|[^`])+`|[A-Za-z0-9_$.-]+)\s+)?(?:(UNIQUE|FULLTEXT|SPATIAL)\s+)?(?:KEY|INDEX)\s*(`(?:``|[^`])+`|[A-Za-z0-9_$.-]+)?/i);
        const list = extractParenList(def, head ? head[0].length : 0);
        const kind = head && head[2] ? head[2].toUpperCase() : 'INDEX';
        table.indexes.push({ name: unquoteIdentifier((head && (head[3] || head[1])) || `${kind.toLowerCase()}_${table.indexes.length + 1}`), type: kind, unique: kind === 'UNIQUE', columns: columnNames(list.values), definition: def });
        continue;
      }
      m = def.match(/^\s*(`(?:``|[^`])+`|[A-Za-z0-9_$.-]+)\s+/);
      if (!m) continue;
      const nameEnd = m[0].length;
      const column = {
        name: unquoteIdentifier(m[1]),
        ordinal: table.columns.length + 1,
        type: readType(def, nameEnd),
        nullable: !/\bNOT\s+NULL\b/i.test(def),
        default: readDefault(def),
        autoIncrement: /\bAUTO_INCREMENT\b/i.test(def),
        comment: (def.match(/\bCOMMENT\s+'((?:''|\\.|[^'])*)'/i) || [])[1]?.replace(/''/g, "'") || '',
        definition: def,
        keys: []
      };
      table.columns.push(column);
    }

    for (const index of table.indexes) for (const col of index.columns) {
      const found = table.columns.find(c => c.name === col);
      if (found) found.keys.push(index.type === 'PRIMARY' ? 'PK' : index.unique ? 'UK' : 'IDX');
    }
    for (const fk of table.foreignKeys) for (const col of fk.columns) {
      const found = table.columns.find(c => c.name === col);
      if (found) { found.keys.push('FK'); found.foreignKeys = (found.foreignKeys || []).concat(fk.name); }
    }
    for (const col of table.columns) col.keys = [...new Set(col.keys)];
    return { table, end: closeAt + 1 };
  }

  function countInsertTuples(sql, valuesAt) {
    let count = 0;
    for (let i = valuesAt; i < sql.length;) {
      const commentEnd = skipComment(sql, i);
      if (commentEnd !== i) { i = commentEnd; continue; }
      if (sql[i] === "'" || sql[i] === '"' || sql[i] === '`') { i = skipQuoted(sql, i); continue; }
      if (sql[i] === ';') break;
      if (sql[i] === '(') {
        const close = findMatchingParen(sql, i);
        if (close < 0) break;
        count++;
        i = close + 1;
        while (i < sql.length && /\s/.test(sql[i])) i++;
        if (sql[i] === ',') { i++; continue; }
        if (sql[i] === ';') break;
        // Extra clauses such as ON DUPLICATE KEY UPDATE end the row list.
        break;
      }
      if (sql[i] === ';') break;
      i++;
    }
    return count;
  }

  function storedProgramRanges(sql) {
    // mysqldump temporarily changes DELIMITER while defining triggers/routines;
    // INSERTs in those bodies are executable code, not rows stored in the dump.
    const ranges = [];
    const directive = /^\s*DELIMITER\s+(\S+)\s*$/gim;
    let delimiter = ';', start = -1, match;
    while ((match = directive.exec(sql))) {
      const next = match[1];
      if (delimiter === ';' && next !== ';') start = match.index;
      else if (delimiter !== ';' && next === ';' && start >= 0) {
        ranges.push([start, directive.lastIndex]);
        start = -1;
      }
      delimiter = next;
    }
    if (start >= 0) ranges.push([start, sql.length]);
    return ranges;
  }

  function isInsideRange(position, ranges) {
    return ranges.some(([start, end]) => position >= start && position < end);
  }

  function rangeEnd(position, ranges) {
    const range = ranges.find(([start, end]) => position >= start && position < end);
    return range ? range[1] : position;
  }

  function findKeywordOutsideQuotes(sql, startAt, keyword) {
    const upper = keyword.toUpperCase();
    for (let i = startAt; i < sql.length;) {
      if (sql[i] === "'" || sql[i] === '"' || sql[i] === '`') { i = skipQuoted(sql, i); continue; }
      const commentEnd = skipComment(sql, i);
      if (commentEnd !== i) { i = commentEnd; continue; }
      if (sql[i] === ';') return -1;
      if (sql.slice(i, i + upper.length).toUpperCase() === upper &&
          !/[A-Za-z0-9_$]/.test(sql[i - 1] || '') && !/[A-Za-z0-9_$]/.test(sql[i + upper.length] || '')) return i;
      i++;
    }
    return -1;
  }

  function countInsertStatements(sql, rows, programRanges) {
    for (let i = 0; i < sql.length;) {
      if (isInsideRange(i, programRanges)) { i = rangeEnd(i, programRanges); continue; }
      if (sql[i] === "'" || sql[i] === '"' || sql[i] === '`') { i = skipQuoted(sql, i); continue; }
      const commentEnd = skipComment(sql, i);
      if (commentEnd !== i) { i = commentEnd; continue; }
      if (sql.slice(i, i + 6).toUpperCase() !== 'INSERT' || /[A-Za-z0-9_$]/.test(sql[i - 1] || '') || /[A-Za-z0-9_$]/.test(sql[i + 6] || '')) { i++; continue; }
      const valuesAt = findKeywordOutsideQuotes(sql, i + 6, 'VALUES') >= 0
        ? findKeywordOutsideQuotes(sql, i + 6, 'VALUES') + 6
        : findKeywordOutsideQuotes(sql, i + 6, 'VALUE') >= 0 ? findKeywordOutsideQuotes(sql, i + 6, 'VALUE') + 5 : -1;
      if (valuesAt < 0) { i += 6; continue; }
      const header = sql.slice(i, valuesAt);
      const targetRE = new RegExp('^INSERT\\s+(?:(?:LOW_PRIORITY|DELAYED|HIGH_PRIORITY|IGNORE)\\s+)*INTO\\s+' + IDENT, 'i');
      const target = header.match(targetRE);
      if (target) {
        const name = unquoteIdentifier(target[1] || target[2]);
        const count = countInsertTuples(sql, valuesAt);
        rows.set(name, (rows.get(name) || 0) + count);
        const end = findStatementEnd(sql, valuesAt);
        i = end < sql.length ? end + 1 : sql.length;
      } else i = valuesAt;
    }
  }

  function parseDump(sql) {
    const lineAt = index => 1 + (sql.slice(0, index).match(/\n/g) || []).length;
    const tables = [];
    const tableMap = new Map();
    const createRE = new RegExp('CREATE\\s+TABLE\\s+(?:IF\\s+NOT\\s+EXISTS\\s+)?' + IDENT, 'ig');
    let match;
    while ((match = createRE.exec(sql))) {
      const parsed = parseCreateTable(sql, match.index, match, lineAt);
      if (parsed) { tables.push(parsed.table); tableMap.set(parsed.table.name, parsed.table); createRE.lastIndex = parsed.end; }
    }

    const rows = new Map(tables.map(t => [t.name, 0]));
    const programRanges = storedProgramRanges(sql);
    countInsertStatements(sql, rows, programRanges);

    const databaseMatch = sql.match(/CREATE\s+DATABASE\s+(?:IF\s+NOT\s+EXISTS\s+)?(?:`((?:``|[^`])+)`|([\w$-]+))/i) || sql.match(/\bUSE\s+(?:`((?:``|[^`])+)`|([\w$-]+))/i);
    const objects = { views: [], triggers: [], procedures: [], functions: [] };
    for (const [kind, regex] of Object.entries({
      views: /CREATE\s+(?:OR\s+REPLACE\s+)?VIEW\s+(`(?:``|[^`])+`|[\w$.-]+)/ig,
      triggers: /(?:CREATE\s+(?:DEFINER\s*=\s*[^\s]+\s+)?TRIGGER|\/\*!\d+\s+TRIGGER)\s+(`(?:``|[^`])+`|[\w$.-]+)/ig,
      procedures: /CREATE\s+(?:DEFINER\s*=\s*[^\s]+\s+)?PROCEDURE\s+(`(?:``|[^`])+`|[\w$.-]+)/ig,
      functions: /CREATE\s+(?:DEFINER\s*=\s*[^\s]+\s+)?FUNCTION\s+(`(?:``|[^`])+`|[\w$.-]+)/ig
    })) {
      for (const m of sql.matchAll(regex)) objects[kind].push(unquoteIdentifier(m[1]));
    }
    return {
      database: databaseMatch ? unquoteIdentifier(databaseMatch[1] || databaseMatch[2]) : '(sin nombre en CREATE DATABASE/USE)',
      tables: tables.map(t => ({ ...t, insertRows: rows.get(t.name) || 0 })),
      objects,
      totalColumns: tables.reduce((sum, table) => sum + table.columns.length, 0),
      totalForeignKeys: tables.reduce((sum, table) => sum + table.foreignKeys.length, 0),
      totalInsertRows: [...rows.values()].reduce((sum, value) => sum + value, 0)
    };
  }

  return { parseDump, splitTopLevel, unquoteIdentifier };
});
