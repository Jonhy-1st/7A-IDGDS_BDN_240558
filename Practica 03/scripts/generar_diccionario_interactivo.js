#!/usr/bin/env node
'use strict';

const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const { parseDump } = require('./diccionario_core.js');

const ROOT = path.resolve(__dirname, '..', '..');
const PRACTICE = path.resolve(__dirname, '..');
const BACKUPS = path.join(PRACTICE, 'backups');
const OUTPUT = path.join(PRACTICE, 'diccionario');
const DOCS = path.join(PRACTICE, 'docs');
const DOC_TABLES = path.join(DOCS, 'diccionario');
const REFERENCE = path.join(BACKUPS, '240558_Respaldo_com_responsables_dbuser.sql');

function newestSql(directory) {
  const files = fs.readdirSync(directory, { withFileTypes: true })
    .filter(entry => entry.isFile() && entry.name.toLowerCase().endsWith('.sql'))
    .map(entry => path.join(directory, entry.name))
    .sort((a, b) => fs.statSync(b).mtimeMs - fs.statSync(a).mtimeMs);
  if (!files.length) throw new Error(`No hay archivos .sql en ${directory}`);
  return files[0];
}

function csvCell(value) {
  const text = value == null ? '' : String(value);
  return `"${text.replace(/"/g, '""')}"`;
}

function safeJson(value) {
  return JSON.stringify(value).replace(/</g, '\\u003c').replace(/>/g, '\\u003e').replace(/&/g, '\\u0026').replace(/\u2028/g, '\\u2028').replace(/\u2029/g, '\\u2029');
}

function detailsForColumn(table, column) {
  const indexes = table.indexes.filter(index => index.columns.includes(column.name));
  const fks = table.foreignKeys.filter(fk => fk.columns.includes(column.name));
  return {
    table: table.name,
    field: column.name,
    ordinal: column.ordinal,
    sql_type: column.type,
    sql_definition: column.definition,
    nullable: column.nullable ? 'YES' : 'NO',
    default_value: column.default == null ? '' : column.default,
    auto_increment: column.autoIncrement ? 'YES' : 'NO',
    column_comment: column.comment,
    primary_key: indexes.filter(index => index.type === 'PRIMARY').map(index => index.name).join('; '),
    unique_indexes: indexes.filter(index => index.unique && index.type !== 'PRIMARY').map(index => `${index.name} (${index.columns.join(', ')})`).join('; '),
    indexes: indexes.filter(index => !index.unique && index.type !== 'PRIMARY').map(index => `${index.name} (${index.columns.join(', ')})`).join('; '),
    index_definitions: indexes.map(index => index.definition).join('; '),
    foreign_key: fks.map(fk => fk.name).join('; '),
    references: fks.map(fk => `${fk.referencedTable} (${fk.referencedColumns.join(', ')})`).join('; '),
    foreign_key_definitions: fks.map(fk => fk.definition).join('; '),
    on_delete: fks.map(fk => `${fk.name}: ${fk.onDelete || '(no especificado en DDL)'}`).join('; '),
    on_update: fks.map(fk => `${fk.name}: ${fk.onUpdate || '(no especificado en DDL)'}`).join('; ')
  };
}

function createCsv(schema) {
  const rows = [];
  for (const table of schema.tables) for (const column of table.columns) rows.push(detailsForColumn(table, column));
  const headers = Object.keys(rows[0] || {
    table: '', field: '', ordinal: '', sql_type: '', sql_definition: '', nullable: '', default_value: '', auto_increment: '', column_comment: '', primary_key: '', unique_indexes: '', indexes: '', index_definitions: '', foreign_key: '', references: '', foreign_key_definitions: '', on_delete: '', on_update: ''
  });
  return '\uFEFF' + [headers, ...rows.map(row => headers.map(header => row[header]))].map(row => row.map(csvCell).join(',')).join('\r\n') + '\r\n';
}

function displayAction(value) { return value || '(no especificado en DDL)'; }
function modulePrefix(name) { return name.startsWith('tbc_') ? 'tbc_' : name.startsWith('tbd_') ? 'tbd_' : name.startsWith('tb_') ? 'tb_' : 'otro'; }
function esc(value) { return String(value ?? '').replace(/[&<>"']/g, ch => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[ch]); }
function mdCell(value) { return String(value ?? '').replace(/\|/g, '\\|').replace(/`/g, '&#96;').replace(/\r?\n/g, ' '); }

function makeHtml(schema, sourceName, sourceHash) {
  const initial = safeJson({ ...schema, sourceName, sourceHash });
  return `<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta name="description" content="Diccionario de datos interactivo generado desde un respaldo SQL MySQL.">
  <title>Diccionario de datos · ${esc(schema.database)}</title>
  <style>
    :root{color-scheme:dark;--bg:#0b1017;--panel:#111a25;--panel2:#162331;--line:#28394a;--ink:#e7f0f8;--muted:#91a5b8;--cyan:#61d9e8;--violet:#b4a1ff;--amber:#ffc66d;--green:#78d7a4;--red:#ff8f88;font:14px/1.5 Inter,ui-sans-serif,system-ui,"Segoe UI",sans-serif}*{box-sizing:border-box}body{margin:0;background:radial-gradient(ellipse at 80% -20%,#173142 0,transparent 40%),var(--bg);color:var(--ink)}button,input,select{font:inherit}button{color:inherit}.shell{max-width:1680px;margin:auto;padding:28px clamp(16px,3vw,44px) 60px}.top{display:flex;gap:24px;justify-content:space-between;align-items:flex-start;margin-bottom:22px}.eyebrow,.label{color:var(--cyan);font-size:11px;font-weight:750;letter-spacing:.12em;text-transform:uppercase}.top h1{font-size:clamp(28px,4vw,46px);line-height:1.05;letter-spacing:-.04em;margin:7px 0}.top p{color:var(--muted);margin:8px 0 0;max-width:850px}.source{max-width:340px;text-align:right;color:var(--muted);font-size:12px;overflow-wrap:anywhere}.source b{color:var(--ink)}.source code{font-size:11px}.stats{display:grid;grid-template-columns:repeat(4,minmax(120px,1fr));gap:12px;margin:20px 0}.stat,.panel{background:linear-gradient(145deg,rgba(22,35,49,.97),rgba(15,24,34,.97));border:1px solid var(--line);border-radius:14px}.stat{padding:15px 18px}.stat span{display:block;color:var(--muted);font-size:12px}.stat strong{font-size:26px;letter-spacing:-.04em}.toolbar{display:flex;gap:10px;align-items:center;flex-wrap:wrap;margin:18px 0}.control{background:#101a25;border:1px solid var(--line);color:var(--ink);border-radius:9px;padding:10px 12px}.toolbar input[type=search]{flex:1;min-width:210px}.toolbar select{min-width:185px}.file-label,.button{display:inline-flex;align-items:center;gap:8px;background:#19313c;border:1px solid #315e69;padding:10px 13px;border-radius:9px;cursor:pointer;color:#c7f7fa;font-weight:650}.file-label:hover,.button:hover{background:#234553}.file-label input{position:absolute;width:1px;height:1px;opacity:0}.notice{font-size:12px;color:var(--muted);margin-left:auto}.workspace{display:grid;grid-template-columns:minmax(240px,300px) minmax(0,1fr);gap:14px;align-items:start}.panel{overflow:hidden}.panel-head{padding:15px 17px;border-bottom:1px solid var(--line);display:flex;align-items:center;justify-content:space-between;gap:12px}.panel-head h2,.panel-head h3{font-size:14px;margin:0}.panel-head small{color:var(--muted)}.table-list{max-height:calc(100vh - 260px);min-height:280px;overflow:auto;padding:8px}.table-button{width:100%;display:flex;justify-content:space-between;align-items:center;gap:12px;text-align:left;border:1px solid transparent;border-radius:9px;background:transparent;padding:9px 10px;cursor:pointer}.table-button:hover{background:#1b2b39}.table-button.active{border-color:#356579;background:#17313d}.table-button span:first-child{min-width:0;overflow-wrap:anywhere}.table-button small{color:var(--muted);white-space:nowrap}.prefix{display:inline-block;margin-right:5px;padding:1px 5px;border-radius:4px;background:#283748;color:#b8cbe0;font-size:10px}.main{display:grid;gap:14px;min-width:0}.diagram-wrap{padding:0}.diagram-meta{display:flex;gap:14px;align-items:center;flex-wrap:wrap;color:var(--muted);font-size:12px}.diagram-actions{display:flex;gap:6px}.icon-button{background:#17232f;border:1px solid var(--line);border-radius:7px;padding:4px 9px;cursor:pointer}.svg-scroll{overflow:auto;max-height:640px;background-image:radial-gradient(#314153 1px,transparent 1px);background-size:20px 20px}.svg-scroll svg{display:block;min-width:900px;width:100%;height:auto}.edge{stroke:#58758a;stroke-width:1.25;opacity:.7;fill:none}.edge-label{fill:#9bb1c3;font:10px ui-monospace,monospace}.node{cursor:pointer}.node rect{fill:#142331;stroke:#385064;stroke-width:1.2;rx:10}.node:hover rect,.node.selected rect{stroke:var(--cyan);stroke-width:2}.node-title{fill:#e3f3fa;font:600 13px ui-monospace,monospace}.node-meta{fill:#9bb1c3;font:11px ui-sans-serif,system-ui}.node-badge{fill:#80d9bf;font:10px ui-sans-serif,system-ui}.diagram-caption{padding:9px 15px;color:var(--muted);font-size:11px;border-top:1px solid var(--line)}.detail{scroll-margin-top:14px}.detail-empty{padding:30px;color:var(--muted)}.detail-body{padding:17px}.detail-title{display:flex;align-items:flex-start;justify-content:space-between;gap:16px}.detail-title h2{font:600 23px/1.2 ui-monospace,monospace;margin:0}.detail-title p{margin:6px 0;color:var(--muted);font-size:12px}.tabs{display:flex;gap:8px;margin:16px 0 12px}.tab{background:transparent;border:1px solid var(--line);padding:6px 10px;border-radius:7px;color:var(--muted);cursor:pointer}.tab.active{color:var(--cyan);border-color:#35727c}.scroll-table{overflow:auto;border:1px solid var(--line);border-radius:9px}.fields{border-collapse:collapse;width:100%;min-width:850px;font-size:12px}.fields th{position:sticky;top:0;background:#192837;color:#a9bfd1;text-align:left;font-size:10px;text-transform:uppercase;letter-spacing:.08em}.fields th,.fields td{padding:9px 10px;border-bottom:1px solid #263645;vertical-align:top}.fields code,code{font:11px ui-monospace,SFMono-Regular,Consolas,monospace}.fields tr:last-child td{border-bottom:0}.field-name{color:#f4f7fc;font-weight:650;white-space:nowrap}.muted{color:var(--muted)}.badge{display:inline-block;border-radius:4px;padding:2px 5px;margin:0 3px 2px 0;font-size:9px;font-weight:800;background:#273648;color:#b7cae0}.badge.pk{background:#483c26;color:#ffd996}.badge.fk{background:#153b46;color:#86e5ee}.badge.uk{background:#382e52;color:#d1b7ff}.sql-def{max-width:380px;white-space:normal;overflow-wrap:anywhere;color:#a7bbcc}.relations{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:9px;margin-top:10px}.relation{background:#111d28;border:1px solid var(--line);border-radius:9px;padding:10px 12px;font-size:12px}.relation b{font-family:ui-monospace,monospace}.relation p{margin:5px 0 0;color:var(--muted)}.warn{color:var(--amber)}.index-list{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:8px}.index-card{background:#101b26;border:1px solid var(--line);border-radius:8px;padding:10px;font-size:12px}.index-card code{display:block;color:#e1edf6}.index-card span{color:var(--muted)}.footer{padding:18px 0;color:var(--muted);font-size:11px}.error{border:1px solid #7b3c3c;background:#351c20;color:#ffb4ae;padding:10px 13px;border-radius:8px;margin:10px 0;display:none}.hidden{display:none!important}.archify-link{color:var(--cyan);text-decoration:none;border-bottom:1px dotted #4aa5b0}.sr-only{position:absolute;width:1px;height:1px;padding:0;margin:-1px;overflow:hidden;clip:rect(0,0,0,0);white-space:nowrap;border:0}@media(max-width:900px){.workspace{grid-template-columns:1fr}.table-list{max-height:260px;min-height:auto}.source{text-align:left}.top{display:block}.stats{grid-template-columns:repeat(2,1fr)}.notice{margin-left:0}.toolbar input[type=search]{flex-basis:100%}}@media(max-width:520px){.stats{grid-template-columns:repeat(2,1fr)}.stat{padding:12px}.stat strong{font-size:22px}.shell{padding:18px 12px 42px}}
  </style>
</head>
<body>
  <main class="shell">
    <header class="top"><div><div class="eyebrow">Diccionario de datos · MySQL</div><h1 id="database-title">${esc(schema.database)}</h1><p>Explora el DDL, las claves y los registros que aparecen en el respaldo seleccionado. Los conteos describen sentencias <code>INSERT</code> del archivo, no una instancia en vivo.</p></div><div class="source"><b>Respaldo cargado</b><br><span id="source-name">${esc(sourceName)}</span><br><span id="source-hash"></span></div></header>
    <section class="stats" aria-label="Resumen del esquema"><div class="stat"><span>Tablas</span><strong id="stat-tables">—</strong></div><div class="stat"><span>Campos</span><strong id="stat-fields">—</strong></div><div class="stat"><span>Claves foráneas</span><strong id="stat-fks">—</strong></div><div class="stat"><span>Filas encontradas en INSERT</span><strong id="stat-rows">—</strong></div></section>
    <div class="toolbar"><label class="file-label">Abrir otro respaldo SQL<input id="backup-file" type="file" accept=".sql,application/sql,text/plain"></label><input class="control" id="search" type="search" placeholder="Buscar tabla o campo…" aria-label="Buscar tabla o campo"><select class="control" id="module-filter" aria-label="Filtrar por prefijo"><option value="all">Todos los prefijos</option><option value="tb_">Prefijo tb_</option><option value="tbc_">Prefijo tbc_</option><option value="tbd_">Prefijo tbd_</option><option value="other">Otros prefijos</option></select><span class="notice">El archivo se analiza localmente en tu navegador.</span></div>
    <div id="error-message" class="error" role="alert"></div>
    <section class="workspace"><aside class="panel"><div class="panel-head"><h2>Tablas</h2><small id="visible-count"></small></div><div id="table-list" class="table-list"></div></aside><div class="main"><section class="panel diagram-wrap"><div class="panel-head"><div><h2>Diagrama de relaciones</h2><div class="diagram-meta"><span id="edge-count"></span><span id="unresolved-count"></span></div></div><div class="diagram-actions"><button class="icon-button" id="zoom-out" aria-label="Alejar">−</button><button class="icon-button" id="zoom-reset" aria-label="Restablecer zoom">100%</button><button class="icon-button" id="zoom-in" aria-label="Acercar">+</button></div></div><div class="svg-scroll" id="diagram-scroll"><svg id="diagram" viewBox="0 0 1450 1300" role="img" aria-label="Diagrama ER navegable"></svg></div><div class="diagram-caption">Cada conexión corresponde a una FK declarada en el DDL. Referencias cuyo destino no está definido en este respaldo se listan como incidencias y no crean tablas ficticias. Usa búsqueda, zoom y clic en una entidad para abrir sus campos.</div></section><section id="entity-detail" class="panel detail" aria-live="polite"><div class="detail-empty">Selecciona una tabla del listado o del diagrama para ver sus campos, índices y relaciones.</div></section></div></section>
    <footer class="footer">El selector no sube ni envía archivos. Las definiciones y filas mostradas se vuelven a calcular desde el SQL escogido.</footer>
  </main>
  <script>window.DICTIONARY_INITIAL_DATA = ${initial};</script>
  <script src="../scripts/diccionario_core.js"></script>
  <script src="backup-picker.js"></script>
</body>
</html>
`;
}

function makeOverview(schema, sourceName, hash) {
  const fks = schema.tables.flatMap(table => table.foreignKeys.map(fk => ({ ...fk, table: table.name })));
  const resolved = fks.filter(fk => schema.tables.some(table => table.name === fk.referencedTable));
  const unresolved = fks.filter(fk => !schema.tables.some(table => table.name === fk.referencedTable));
  const lines = [
    '# Diccionario técnico de `db_test`', '',
    `Fuente: respaldo SQL [${sourceName}](../backups/${encodeURIComponent(sourceName).replace(/%2F/g, '/')}).`,
    `Huella SHA-256 del archivo: \`${hash}\`.`,
    'Esta ficha resume exclusivamente declaraciones y sentencias encontradas en ese respaldo. No documenta reglas funcionales que no estén expresadas en el DDL.', '',
    '## Resumen del archivo', '',
    `- Base indicada por el dump: \`${schema.database}\`.`,
    `- Tablas: ${schema.tables.length}; columnas: ${schema.totalColumns}; claves foráneas declaradas: ${schema.totalForeignKeys}.`,
    `- Filas en sentencias \`INSERT\` del dump: ${schema.totalInsertRows}. Este conteo no representa el estado actual de una instancia.`,
    `- Objetos nombrados en el archivo: ${schema.objects.views.length} vistas, ${schema.objects.triggers.length} triggers, ${schema.objects.procedures.length} procedimientos y ${schema.objects.functions.length} funciones.`,
    `- Referencias FK con tabla destino también declarada: ${resolved.length}; con tabla destino ausente en el respaldo: ${unresolved.length}.`, '',
    '## Tablas y filas `INSERT`', '',
    '| Tabla | Columnas | Filas encontradas en INSERT | Índices | FKs |', '|---|---:|---:|---:|---:|',
    ...schema.tables.map(table => `| [\`${table.name}\`](diccionario/${table.name}.md) | ${table.columns.length} | ${table.insertRows} | ${table.indexes.length} | ${table.foreignKeys.length} |`), '',
    '## Objetos referenciados por el DDL', '',
    '### Vistas', '', ...(schema.objects.views.length ? schema.objects.views.map(name => `- \`${name}\``) : ['- No se encontraron declaraciones de vistas.']), '',
    '### Triggers', '', ...(schema.objects.triggers.length ? schema.objects.triggers.map(name => `- \`${name}\``) : ['- No se encontraron declaraciones de triggers.']), '',
    '### Procedimientos y funciones', '', ...(schema.objects.procedures.length ? schema.objects.procedures.map(name => `- Procedimiento: \`${name}\``) : ['- No se encontraron procedimientos.']), ...(schema.objects.functions.length ? schema.objects.functions.map(name => `- Función: \`${name}\``) : ['- No se encontraron funciones.']), '',
    '## Claves foráneas cuyo destino no está declarado', '',
    ...(unresolved.length ? unresolved.map(fk => `- \`${fk.table}.${fk.name}\`: (${fk.columns.join(', ')}) → \`${fk.referencedTable}(${fk.referencedColumns.join(', ')})\`; ON DELETE ${displayAction(fk.onDelete)}; ON UPDATE ${displayAction(fk.onUpdate)}.`) : ['- Ninguna.']), '',
    'Las relaciones con destinos ausentes se conservan como declaraciones del SQL; este documento no agrega entidades implícitas para resolverlas.', '',
    '## Archivos asociados', '',
    '- [CSV por campo](../diccionario/campos.csv)',
    '- [Explorador HTML](../diccionario/diccionario.html)',
    '- Fichas individuales en `diccionario/`, una por tabla.',
    '- El explorador permite cargar otro `.sql` local. Esa selección actualiza la interfaz en el navegador y no envía el archivo a un servidor.', ''
  ];
  return lines.join('\n');
}

function makeTableDoc(table, schema, sourceName, hash) {
  const lines = [
    `# Tabla \`${table.name}\``, '',
    `Fuente: \`${sourceName}\`, líneas ${table.line}–${table.endLine}. SHA-256: \`${hash}\`.`,
    'Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.', '',
    '## Resumen DDL', '',
    `- Columnas: ${table.columns.length}.`,
    `- Filas encontradas en sentencias INSERT de este respaldo: ${table.insertRows}.`,
    `- Claves primarias / índices: ${table.indexes.length}.`,
    `- Claves foráneas: ${table.foreignKeys.length}.`,
    `- Restricciones CHECK: ${table.checks.length}.`,
    `- Opciones de tabla tal como aparecen junto al DDL: \`${mdCell(table.options) || '(sin opciones capturadas)'}\`.`, '',
    '## Columnas', '',
    '| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |', '|---:|---|---|:---:|---|---|---|---|',
    ...table.columns.map(column => {
      const refs = table.foreignKeys.filter(fk => fk.columns.includes(column.name)).map(fk => `${fk.name} → ${fk.referencedTable}(${fk.referencedColumns.join(', ')})`);
      const indexes = table.indexes.filter(index => index.columns.includes(column.name)).map(index => `${index.name} (${index.columns.join(', ')})`);
      const keys = [...column.keys.map(key => key === 'IDX' ? 'índice' : key), ...refs].join('; ') || '—';
      return `| ${column.ordinal} | \`${mdCell(column.name)}\` | \`${mdCell(column.type)}\` | ${column.nullable ? 'Sí' : 'No'} | \`${mdCell(column.default == null ? '—' : column.default)}\` | ${mdCell(keys)}${indexes.length ? `; ${mdCell(indexes.join('; '))}` : ''} | ${mdCell(column.comment) || '—'} | \`${mdCell(column.definition)}\` |`;
    }), '',
    '## Claves primarias e índices', '',
    ...(table.indexes.length ? table.indexes.map(index => `- \`${index.name}\` (${index.type}${index.unique ? ', UNIQUE' : ''}): \`${index.columns.join(', ')}\`. DDL: \`${mdCell(index.definition)}\``) : ['- No se encontraron definiciones de índices en el DDL.']), '',
    '## Claves foráneas', '',
    ...(table.foreignKeys.length ? table.foreignKeys.map(fk => `- \`${fk.name}\`: (${fk.columns.join(', ')}) → \`${fk.referencedTable}(${fk.referencedColumns.join(', ')})\`; ON DELETE ${displayAction(fk.onDelete)}; ON UPDATE ${displayAction(fk.onUpdate)}. DDL: \`${mdCell(fk.definition)}\``) : ['- No se encontraron claves foráneas en el DDL.']), '',
    '## Restricciones CHECK', '',
    ...(table.checks.length ? table.checks.map(check => `- \`${mdCell(check)}\``) : ['- No se encontraron restricciones CHECK separadas en el DDL.']), '',
    '## Definición SQL de la tabla', '',
    '```sql', table.ddl, '```', ''
  ];
  return lines.join('\n');
}

function writeReferenceDocs(schema, sourceName, hash) {
  fs.mkdirSync(DOC_TABLES, { recursive: true });
  fs.writeFileSync(path.join(DOCS, 'DOCUMENTACION_DB_TEST.md'), makeOverview(schema, sourceName, hash), 'utf8');
  const generatedMarker = '<!-- generado por generar_diccionario_interactivo.js -->';
  for (const table of schema.tables) fs.writeFileSync(path.join(DOC_TABLES, `${table.name}.md`), `${generatedMarker}\n${makeTableDoc(table, schema, sourceName, hash)}`, 'utf8');
  const active = new Set(schema.tables.map(table => `${table.name}.md`).map(name => path.resolve(DOC_TABLES, name)));
  for (const entry of fs.readdirSync(DOC_TABLES, { withFileTypes: true })) {
    if (!entry.isFile() || !entry.name.endsWith('.md')) continue;
    const file = path.resolve(DOC_TABLES, entry.name);
    if (active.has(file)) continue;
    const old = fs.readFileSync(file, 'utf8');
    if (old.startsWith(generatedMarker)) fs.unlinkSync(file);
  }
}

function main() {
  const input = process.argv[2] ? path.resolve(ROOT, process.argv[2]) : newestSql(BACKUPS);
  if (!fs.existsSync(input) || !fs.statSync(input).isFile()) throw new Error(`No se encontró el archivo SQL: ${input}`);
  if (path.extname(input).toLowerCase() !== '.sql') throw new Error('La fuente debe ser un archivo con extensión .sql');
  const source = fs.readFileSync(input, 'utf8');
  const schema = parseDump(source);
  if (!schema.tables.length) throw new Error('No se encontraron declaraciones CREATE TABLE en el respaldo.');
  const sourceHash = crypto.createHash('sha256').update(source, 'utf8').digest('hex');
  const sourceName = path.relative(BACKUPS, input).split(path.sep).join('/');
  fs.mkdirSync(OUTPUT, { recursive: true });
  fs.writeFileSync(path.join(OUTPUT, 'campos.csv'), createCsv(schema), 'utf8');
  fs.writeFileSync(path.join(OUTPUT, 'diccionario.html'), makeHtml(schema, sourceName, sourceHash), 'utf8');
  const normalizedInput = path.resolve(input).toLowerCase();
  if (normalizedInput === path.resolve(REFERENCE).toLowerCase()) {
    writeReferenceDocs(schema, path.basename(input), sourceHash);
  }
  const unresolved = schema.tables.flatMap(table => table.foreignKeys.filter(fk => !schema.tables.some(target => target.name === fk.referencedTable)).map(fk => `${table.name}.${fk.name} → ${fk.referencedTable}`));
  console.log(`Fuente: ${path.relative(ROOT, input)}`);
  console.log(`Esquema ${schema.database}: ${schema.tables.length} tablas, ${schema.totalColumns} campos, ${schema.totalForeignKeys} FKs, ${schema.totalInsertRows} filas en INSERT.`);
  console.log(`CSV: ${path.relative(ROOT, path.join(OUTPUT, 'campos.csv'))}`);
  console.log(`HTML: ${path.relative(ROOT, path.join(OUTPUT, 'diccionario.html'))}`);
  if (normalizedInput === path.resolve(REFERENCE).toLowerCase()) console.log(`Documentación de referencia actualizada: ${path.relative(ROOT, DOCS)}`);
  else console.log(`La fuente no es el respaldo de referencia; se conservaron las fichas de ${path.relative(ROOT, REFERENCE)}.`);
  if (unresolved.length) console.warn(`Aviso: ${unresolved.length} FK(s) refieren tablas ausentes en el DDL: ${unresolved.join('; ')}`);
}

try { main(); }
catch (error) { console.error(`Error al generar el diccionario: ${error.message}`); process.exitCode = 1; }
