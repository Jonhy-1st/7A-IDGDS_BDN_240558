#!/usr/bin/env node
'use strict';

const fs = require('node:fs');
const path = require('node:path');
const { parseDump } = require('./diccionario_core.js');

const ROOT = path.resolve(__dirname, '..', '..');
const DEFAULT_SOURCE = path.join(ROOT, 'Practica04', 'backups', 'Respaldo_240558_final.sql');
const CANDIDATE = path.join(ROOT, '.archify', 'erd-respaldo-240558-final-20261121-1700', 'candidate.json');
const ENTITY_WIDTHS = {
  tb_order_cancellations: 263, tb_payments: 302, tb_refunds: 257, tb_returns: 309,
  tb_shipments: 282, tb_user_addresses: 277, tbd_address_components: 269,
  tbd_cart_items: 264, tbd_order_items: 257, tbd_user_payment_methods: 283
};
const OUTER_ROUTES = {
  'tb_returns->tb_buyer_orders': { x: 5, fromY: 2524, toY: 1366.5 },
  'tb_returns->tb_users': { x: 11, fromY: 2524, toY: 118.5 },
  'tb_shipments->tb_user_addresses': { x: 17, fromY: 2802, toY: 389 },
  'tb_shipments->tb_seller_orders': { x: 23, fromY: 2802, toY: 1562 }
};
const domains = [
  {
    tag: 'Personas y acceso', col: 0, startRow: 0,
    tables: ['tb_users', 'tb_people', 'tb_user_addresses', 'tbd_address_components', 'tbd_user_payment_methods', 'tbc_payment_methods_types']
  },
  {
    tag: 'Catálogo', col: 0, startRow: 3,
    tables: ['tbd_users_offer_products', 'tb_products', 'tbc_categories', 'tbd_products_categories', 'tbd_wishlist_products', 'tbc_payment_methods_types_res']
  },
  {
    tag: 'Pedidos', col: 0, startRow: 6,
    tables: ['tb_buyer_orders', 'tb_carts', 'tb_seller_orders', 'tbd_cart_items', 'tbd_orders', 'tbd_order_items', 'tb_order_cancellations', 'tbd_cancellation_items']
  },
  {
    tag: 'Pagos y posventa', col: 0, startRow: 10,
    tables: ['tb_payment_transactions', 'tb_payments', 'tb_returns', 'tb_refunds', 'tb_shipments', 'tbd_return_items']
  },
  {
    tag: 'Bitácora', col: 2, startRow: 12,
    tables: ['tb_logs']
  }
];

function main() {
  const sourcePath = process.argv[2] ? path.resolve(ROOT, process.argv[2]) : DEFAULT_SOURCE;
  if (!fs.existsSync(sourcePath)) throw new Error(`No se encontró el respaldo: ${sourcePath}`);
  const sql = fs.readFileSync(sourcePath, 'utf8');
  const schema = parseDump(sql);
  const tableMap = new Map(schema.tables.map(table => [table.name, table]));
  const positions = new Map();
  for (const domain of domains) {
    domain.tables.forEach((name, index) => positions.set(name, {
      tag: domain.tag,
      row: domain.startRow + Math.floor(index / 2),
      col: domain.col + (index % 2)
    }));
  }

  const missing = schema.tables.map(table => table.name).filter(name => !positions.has(name));
  const extra = [...positions.keys()].filter(name => !tableMap.has(name));
  if (missing.length || extra.length) {
    throw new Error(`Clasificación incompleta. Sin área: ${missing.join(', ') || 'ninguna'}; inexistentes: ${extra.join(', ') || 'ninguna'}`);
  }

  const entities = schema.tables.map(table => {
    const place = positions.get(table.name);
    const attributes = table.columns.map(column => {
      const roles = [];
      if (column.keys.includes('PK')) roles.push('pk');
      if (column.keys.includes('FK')) roles.push('fk');
      if (column.keys.includes('UK')) roles.push('uk');
      const attribute = {
        name: column.name,
        type: column.type.startsWith('enum(') ? 'ENUM' : column.type
      };
      if (roles.length === 1) attribute.key = roles[0];
      else if (roles.length > 1) attribute.key = roles;
      if (roles.includes('fk')) {
        const fk = table.foreignKeys.find(item => item.columns.includes(column.name));
        if (fk) {
          const index = fk.columns.indexOf(column.name);
          attribute.references = `${fk.referencedTable}.${fk.referencedColumns[index]}`;
        }
      }
      return attribute;
    });
    return {
      id: table.name,
      label: table.name,
      tag: place.tag,
      row: place.row,
      col: place.col,
      ...(ENTITY_WIDTHS[table.name] ? { width: ENTITY_WIDTHS[table.name] } : {}),
      sublabel: `${table.columns.length} campos · ${table.insertRows.toLocaleString('es-MX')} filas INSERT`,
      attributes
    };
  });

  let relationIndex = 1;
  const relationships = schema.tables.flatMap(table => table.foreignKeys.map(fk => {
    const parent = tableMap.get(fk.referencedTable);
    if (!parent || parent.name === table.name) return null;
    const isIdentifying = fk.columns.every(name => table.indexes.some(index => index.type === 'PRIMARY' && index.columns.includes(name)));
    const outerRoute = OUTER_ROUTES[`${table.name}->${parent.name}`];
    return {
      id: `fk_${relationIndex++}`,
      from: table.name,
      to: parent.name,
      fromCardinality: 'many',
      fromOptional: fk.columns.every(name => table.columns.find(column => column.name === name)?.nullable),
      toCardinality: 'one',
      identifying: isIdentifying,
      ...(outerRoute ? {
        fromSide: 'left',
        toSide: 'left',
        route: 'orthogonal-v',
        via: [[outerRoute.x, outerRoute.fromY], [outerRoute.x, outerRoute.toY]]
      } : {})
    };
  }).filter(Boolean));

  const candidate = {
    schema_version: 1,
    diagram_type: 'erd',
    meta: {
      title: 'Modelo relacional de db_test',
      subtitle: 'Respaldo final · 27 tablas · 234 campos',
      locale: 'es',
      output: 'docs/diagrama/index.html',
      visual_preset: 'blueprint',
      quality_profile: 'standard',
      legend: {
        mode: 'all',
        entries: {
          pk: { label: 'Clave primaria' },
          fk: { label: 'Clave foránea' },
          uk: { label: 'Índice único' },
          one: { label: 'Uno' },
          many: { label: 'Varios' },
          optional: { label: 'Relación opcional' }
        }
      },
      views: [
        { id: 'personas', label: 'Personas', focus: ['tb_users', 'tb_people', 'tb_user_addresses', 'tbd_address_components', 'tbd_user_payment_methods', 'tbc_payment_methods_types'], note: 'Cuentas, perfiles, domicilios e instrumentos guardados.' },
        { id: 'catalogo', label: 'Catálogo', focus: ['tb_products', 'tbc_categories', 'tbd_products_categories', 'tbd_users_offer_products', 'tbd_wishlist_products', 'tbc_payment_methods_types_res'], note: 'Productos, categorías, ofertas y listas de deseos.' },
        { id: 'pedidos', label: 'Pedidos', focus: ['tb_carts', 'tbd_cart_items', 'tb_buyer_orders', 'tb_seller_orders', 'tbd_order_items', 'tbd_orders', 'tb_order_cancellations', 'tbd_cancellation_items'], note: 'Del carrito al pedido y sus cancelaciones.' },
        { id: 'pagos', label: 'Pagos y posventa', focus: ['tb_payments', 'tb_payment_transactions', 'tb_refunds', 'tb_returns', 'tbd_return_items', 'tb_shipments'], note: 'Cobros, movimientos, reembolsos, devoluciones y envíos.' },
        { id: 'bitacora', label: 'Bitácora', focus: ['tb_logs'], note: 'Registro de operaciones de la base.' }
      ]
    },
    layout: { mode: 'grid', origin: [32, 32], gapX: 64, gapY: 30, entityW: 252, headerH: 32, rowH: 15 },
    entities,
    relationships,
    cards: [{
      dot: 'cyan',
      title: 'Fuente y referencias internas',
      items: [
        'Estructura tomada de Practica04/backups/Respaldo_240558_final.sql.',
        'Se muestran 27 tablas, 234 columnas y 34 claves foráneas declaradas.',
        'Las filas INSERT se indican como conteos del respaldo; no representan consultas en vivo.',
        'Para mantener las tablas legibles, los campos ENUM muestran el tipo; sus valores completos están en el diccionario interactivo.',
        'tbc_categories.sup_id_category modela categorías padre e hija; tbd_address_components.address_sup_ID modela componentes de domicilio anidados.'
      ]
    }]
  };

  fs.mkdirSync(path.dirname(CANDIDATE), { recursive: true });
  fs.writeFileSync(CANDIDATE, `${JSON.stringify(candidate, null, 2)}\n`, 'utf8');
  console.log(`Esquema: ${schema.tables.length} tablas, ${schema.totalColumns} campos, ${relationships.length} relaciones.`);
  console.log(`Candidato: ${path.relative(ROOT, CANDIDATE)}`);
  console.log(`Salida: ${candidate.meta.output}`);
}

try { main(); }
catch (error) { console.error(`No se pudo generar el candidato ERD: ${error.message}`); process.exitCode = 1; }
