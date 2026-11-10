'use strict';

(function () {
  const $ = id => document.getElementById(id);
  const esc = value => String(value ?? '').replace(/[&<>"']/g, ch => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' })[ch]);
  const number = value => Number(value || 0).toLocaleString('es-MX');
  let current = null;
  let selected = '';
  let zoom = 1;

  function prefix(table) {
    if (table.startsWith('tbc_')) return 'tbc_';
    if (table.startsWith('tbd_')) return 'tbd_';
    if (table.startsWith('tb_')) return 'tb_';
    return 'other';
  }

  function visibleTables() {
    const query = $('search').value.trim().toLocaleLowerCase();
    const module = $('module-filter').value;
    return current.tables.filter(table => {
      if (module !== 'all' && prefix(table.name) !== module) return false;
      if (!query) return true;
      return table.name.toLocaleLowerCase().includes(query) || table.columns.some(column => column.name.toLocaleLowerCase().includes(query));
    });
  }

  function renderStats() {
    $('database-title').textContent = current.database;
    $('stat-tables').textContent = number(current.tables.length);
    $('stat-fields').textContent = number(current.totalColumns);
    $('stat-fks').textContent = number(current.totalForeignKeys);
    $('stat-rows').textContent = number(current.totalInsertRows);
    $('source-name').textContent = current.sourceName || 'respaldo seleccionado';
    $('source-hash').textContent = current.sourceHash ? `SHA-256 ${current.sourceHash}` : 'Analizado localmente en el navegador';
    const fks = current.tables.flatMap(table => table.foreignKeys.map(fk => ({ ...fk, source: table.name })));
    const unresolved = fks.filter(fk => !current.tables.some(table => table.name === fk.referencedTable));
    $('edge-count').textContent = `${fks.length - unresolved.length} relación(es) dibujadas`;
    $('unresolved-count').innerHTML = unresolved.length ? `<span class="warn">${unresolved.length} referencia(s) a tablas ausentes</span>` : 'Sin referencias a tablas ausentes';
    $('error-message').style.display = 'none';
  }

  function renderList() {
    const tables = visibleTables();
    $('visible-count').textContent = `${tables.length} / ${current.tables.length}`;
    $('table-list').innerHTML = tables.map(table => `<button type="button" class="table-button ${table.name === selected ? 'active' : ''}" data-table="${esc(table.name)}"><span><span class="prefix">${esc(prefix(table.name))}</span><code>${esc(table.name)}</code></span><small>${number(table.columns.length)} campos · ${number(table.insertRows)} filas</small></button>`).join('') || '<div class="detail-empty">No hay tablas que coincidan con el filtro.</div>';
    $('table-list').querySelectorAll('[data-table]').forEach(button => button.addEventListener('click', () => selectTable(button.dataset.table, true)));
  }

  function renderDiagram() {
    const all = current.tables;
    const tables = visibleTables();
    const index = new Map(all.map((table, i) => [table.name, i]));
    const cols = 4, nodeW = 312, nodeH = 105, gapX = 42, gapY = 48, left = 34, top = 38;
    const rows = Math.max(1, Math.ceil(all.length / cols));
    const width = left * 2 + cols * nodeW + (cols - 1) * gapX;
    const height = top * 2 + rows * nodeH + (rows - 1) * gapY;
    const shown = new Set(tables.map(table => table.name));
    const pos = new Map(all.map((table, i) => [table.name, { x: left + (i % cols) * (nodeW + gapX), y: top + Math.floor(i / cols) * (nodeH + gapY) }]));
    const relations = all.flatMap(table => table.foreignKeys.map(fk => ({ ...fk, source: table.name }))).filter(fk => shown.has(fk.source) && shown.has(fk.referencedTable));
    const edges = relations.map(fk => {
      const a = pos.get(fk.source), b = pos.get(fk.referencedTable);
      const ax = a.x + nodeW / 2, ay = a.y + nodeH / 2, bx = b.x + nodeW / 2, by = b.y + nodeH / 2;
      const midx = (ax + bx) / 2, midy = (ay + by) / 2;
      return `<g><title>${esc(fk.name)}: ${esc(fk.source)} (${esc(fk.columns.join(', '))}) → ${esc(fk.referencedTable)} (${esc(fk.referencedColumns.join(', '))}); ON DELETE ${esc(fk.onDelete || 'sin especificar')}; ON UPDATE ${esc(fk.onUpdate || 'sin especificar')}</title><path class="edge" d="M ${ax} ${ay} L ${bx} ${by}" marker-end="url(#arrow)"/><text class="edge-label" x="${midx}" y="${midy - 5}" text-anchor="middle">${esc(fk.name)}</text></g>`;
    }).join('');
    const nodes = tables.map(table => {
      const p = pos.get(table.name);
      const shownIndex = index.get(table.name);
      const keys = table.indexes.filter(item => item.type === 'PRIMARY').flatMap(item => item.columns);
      const keyText = keys.length ? `PK ${keys.join(', ')}` : `${table.foreignKeys.length} FK`;
      return `<g class="node ${table.name === selected ? 'selected' : ''}" data-node="${esc(table.name)}" tabindex="0" role="button" aria-label="Abrir tabla ${esc(table.name)}"><title>${esc(table.name)} · ${table.columns.length} campos · ${table.insertRows} filas INSERT</title><rect x="${p.x}" y="${p.y}" width="${nodeW}" height="${nodeH}"/><text class="node-title" x="${p.x + 14}" y="${p.y + 27}">${esc(table.name)}</text><text class="node-meta" x="${p.x + 14}" y="${p.y + 52}">${number(table.columns.length)} campos · ${number(table.insertRows)} filas INSERT</text><text class="node-badge" x="${p.x + 14}" y="${p.y + 77}">${esc(prefix(table.name))} · ${esc(keyText)}</text></g>`;
    }).join('');
    const svg = $('diagram');
    svg.setAttribute('viewBox', `0 0 ${width} ${height}`);
    svg.dataset.baseWidth = width;
    svg.dataset.baseHeight = height;
    svg.style.width = `${Math.max(width * zoom, 900)}px`;
    svg.innerHTML = `<defs><marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M 0 0 L 10 5 L 0 10 z" fill="#7898ad"/></marker></defs>${edges}${nodes}`;
    svg.querySelectorAll('[data-node]').forEach(node => {
      node.addEventListener('click', () => selectTable(node.dataset.node, true));
      node.addEventListener('keydown', event => { if (event.key === 'Enter' || event.key === ' ') { event.preventDefault(); selectTable(node.dataset.node, true); } });
    });
  }

  function renderDetail() {
    const table = current.tables.find(item => item.name === selected);
    if (!table) { $('entity-detail').innerHTML = '<div class="detail-empty">Selecciona una tabla del listado o del diagrama para ver sus campos, índices y relaciones.</div>'; return; }
    const fields = table.columns.map(column => {
      const badges = (column.keys || []).map(key => `<span class="badge ${key.toLowerCase()}">${esc(key)}</span>`).join('') || '<span class="muted">—</span>';
      const indexes = table.indexes.filter(index => index.columns.includes(column.name)).map(index => `${index.name} (${index.columns.join(', ')})`);
      const fks = table.foreignKeys.filter(fk => fk.columns.includes(column.name));
      const references = fks.map(fk => `${fk.name}: ${fk.referencedTable}(${fk.referencedColumns.join(', ')})`).join('; ');
      return `<tr><td class="field-name"><code>${esc(column.name)}</code></td><td><code>${esc(column.type)}</code></td><td>${badges}</td><td>${column.nullable ? 'Sí' : 'No'}</td><td><code>${esc(column.default == null ? '—' : column.default)}</code></td><td>${indexes.length ? esc(indexes.join('; ')) : '—'}</td><td>${references ? esc(references) : '—'}</td><td class="sql-def"><code>${esc(column.definition)}</code></td></tr>`;
    }).join('');
    const outgoing = table.foreignKeys.map(fk => {
      const missing = !current.tables.some(item => item.name === fk.referencedTable);
      return `<article class="relation"><b>${esc(fk.name)}</b><p>${esc(fk.columns.join(', '))} → <code>${esc(fk.referencedTable)}(${esc(fk.referencedColumns.join(', '))})</code>${missing ? ' <span class="warn">(destino ausente en este respaldo)</span>' : ''}</p><p>ON DELETE: ${esc(fk.onDelete || '(no especificado en DDL)')} · ON UPDATE: ${esc(fk.onUpdate || '(no especificado en DDL)')}</p></article>`;
    });
    const incoming = current.tables.flatMap(source => source.foreignKeys.filter(fk => fk.referencedTable === table.name).map(fk => ({ source, fk })));
    const relationCards = [...outgoing, ...incoming.map(({ source, fk }) => `<article class="relation"><b>Referencia entrante · ${esc(fk.name)}</b><p><code>${esc(source.name)}(${esc(fk.columns.join(', '))})</code> → esta tabla (${esc(fk.referencedColumns.join(', '))})</p><p>ON DELETE: ${esc(fk.onDelete || '(no especificado en DDL)')} · ON UPDATE: ${esc(fk.onUpdate || '(no especificado en DDL)')}</p></article>`)].join('');
    const indexes = table.indexes.map(index => `<div class="index-card"><code>${esc(index.name)} · ${esc(index.type)}${index.unique ? ' · UNIQUE' : ''}</code><span>${esc(index.columns.join(', '))}</span></div>`).join('');
    const checks = table.checks.length ? table.checks.map(check => `<div class="index-card"><code>${esc(check)}</code></div>`).join('') : '<span class="muted">No hay restricciones CHECK separadas en el DDL.</span>';
    $('entity-detail').innerHTML = `<div class="panel-head"><div><h2>Detalle de entidad</h2><small>DDL en líneas ${table.line}–${table.endLine}</small></div><small>${number(table.columns.length)} campos · ${number(table.insertRows)} filas INSERT</small></div><div class="detail-body"><div class="detail-title"><div><h2>${esc(table.name)}</h2><p>Prefijo: <code>${esc(prefix(table.name))}</code> · El conteo corresponde al respaldo, no a datos en vivo.</p></div></div><div class="tabs"><span class="tab active">Campos</span><span class="tab">Relaciones (${table.foreignKeys.length + incoming.length})</span></div><div class="scroll-table"><table class="fields"><thead><tr><th>Campo</th><th>Tipo SQL</th><th>Clave</th><th>Nulo</th><th>Predeterminado</th><th>Índice</th><th>Referencia</th><th>Definición DDL</th></tr></thead><tbody>${fields}</tbody></table></div><h3>Relaciones declaradas por FK</h3><div class="relations">${relationCards || '<span class="muted">Esta tabla no participa en relaciones FK declaradas.</span>'}</div><h3>Índices y claves</h3><div class="index-list">${indexes || '<span class="muted">No se encontraron índices declarados.</span>'}</div><h3>Restricciones CHECK</h3><div class="index-list">${checks}</div><details><summary>DDL completo de la tabla</summary><pre class="scroll-table" style="padding:14px;white-space:pre-wrap;overflow-wrap:anywhere"><code>${esc(table.ddl)}</code></pre></details></div>`;
  }

  function selectTable(name, scroll) {
    selected = name;
    renderList(); renderDiagram(); renderDetail();
    if (scroll) $('entity-detail').scrollIntoView({ behavior: 'smooth', block: 'start' });
  }

  function render(data, filename, hash) {
    current = data;
    current.sourceName = filename || data.sourceName || 'respaldo seleccionado';
    current.sourceHash = hash || data.sourceHash || '';
    if (!current.tables.some(table => table.name === selected)) selected = current.tables[0]?.name || '';
    renderStats(); renderList(); renderDiagram(); renderDetail();
  }

  function showError(message) {
    const box = $('error-message');
    box.textContent = message;
    box.style.display = 'block';
  }

  $('search').addEventListener('input', () => { renderList(); renderDiagram(); });
  $('module-filter').addEventListener('change', () => { renderList(); renderDiagram(); });
  $('backup-file').addEventListener('change', async event => {
    const file = event.target.files && event.target.files[0];
    if (!file) return;
    if (!file.name.toLowerCase().endsWith('.sql')) { showError('Selecciona un archivo con extensión .sql.'); event.target.value = ''; return; }
    try {
      const sql = await file.text();
      if (!sql.trim()) throw new Error('el archivo está vacío');
      const parsed = window.DiccionarioDB.parseDump(sql);
      if (!parsed.tables.length) throw new Error('no se encontraron declaraciones CREATE TABLE');
      render(parsed, file.name, '');
    } catch (error) {
      showError(`No se pudo leer el respaldo “${file.name}”: ${error.message || 'formato SQL no reconocido'}. El diccionario anterior sigue visible.`);
    } finally { event.target.value = ''; }
  });
  $('zoom-in').addEventListener('click', () => { zoom = Math.min(zoom + .12, 1.8); renderDiagram(); });
  $('zoom-out').addEventListener('click', () => { zoom = Math.max(zoom - .12, .55); renderDiagram(); });
  $('zoom-reset').addEventListener('click', () => { zoom = 1; renderDiagram(); });
  render(window.DICTIONARY_INITIAL_DATA, window.DICTIONARY_INITIAL_DATA.sourceName, window.DICTIONARY_INITIAL_DATA.sourceHash);
})();
