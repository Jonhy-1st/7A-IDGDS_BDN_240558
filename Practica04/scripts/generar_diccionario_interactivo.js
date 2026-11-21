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
const PAGES = path.join(ROOT, 'docs');
const REFERENCE = path.join(BACKUPS, 'Respaldo_240558_final.sql');

const TABLE_DESCRIPTIONS = {
  tb_buyer_orders: 'Guarda el pedido general que hace una persona: quién compra, cuántos artículos incluye, cuánto cuesta y en qué etapa está. Se relaciona con usuarios, pedidos por vendedor, pagos y cancelaciones.',
  tb_carts: 'Guarda los carritos de cada persona antes de confirmar una compra. El estado distingue el carrito activo, convertido o abandonado; la columna calculada permite varios carritos históricos y limita a uno activo por usuario. Los productos están en tbd_cart_items.',
  tb_logs: 'Conserva la bitácora de acciones hechas sobre la base, como altas, cambios y bajas. Guarda la tabla afectada, la cuenta de conexión, la fecha y una descripción para poder rastrear operaciones.',
  tb_order_cancellations: 'Registra una solicitud para cancelar uno o más artículos de un pedido, quién la solicitó, el motivo y si fue solicitada, aprobada, rechazada o completada. Los artículos se detallan en tbd_cancellation_items.',
  tb_payment_transactions: 'Guarda cada evento de un cobro o devolución, por ejemplo creación, autorización, captura, rechazo o reembolso. Cada evento pertenece a un registro de tb_payments.',
  tb_payments: 'Representa un cobro, intento de cobro o cuota de un pedido. Guarda el importe, medio, estado, fechas y referencia al instrumento del cliente; sus eventos se registran en tb_payment_transactions.',
  tb_people: 'Guarda los datos personales de una cuenta, como nombre, apellidos, nacimiento, país y teléfono. Se relaciona con tb_users, que contiene las credenciales de acceso.',
  tb_products: 'Es el catálogo general de productos. Guarda nombre, SKU, precio, existencia general y estado de publicación; las ofertas concretas de vendedores están en tbd_users_offer_products.',
  tb_refunds: 'Registra el dinero que se devuelve por una cancelación o una devolución de producto. Indica el pago de origen, el motivo, el importe y el estado del reembolso.',
  tb_returns: 'Registra la reclamación de un producto entregado, su motivo, cantidad, revisión y resolución. Puede vincular un envío de reemplazo en tb_shipments.',
  tb_seller_orders: 'Divide un pedido general en las partes que prepara cada vendedor. Guarda el vendedor, subtotal, costo de envío y estado de preparación o entrega.',
  tb_shipments: 'Sigue el envío asociado a una parte del pedido de un vendedor: destino, paquetería, guía y estado. También permite indicar entrega en domicilio o recolección en un punto.',
  tb_user_addresses: 'Guarda los domicilios de entrega de cada cuenta, con etiqueta, destinatario, teléfono e instrucciones. Los envíos apuntan aquí cuando se entregan en domicilio.',
  tb_users: 'Contiene las cuentas de acceso de la plataforma: correo, alias, contraseña protegida con hash, estado y rol de plataforma. Los datos personales complementarios se guardan en tb_people.',
  tbc_categories: 'Es el catálogo de categorías que organiza los productos, como ropa o accesorios. La relación entre cada producto y sus categorías está en tbd_products_categories.',
  tbc_payment_methods_types: 'Es el catálogo de tipos de instrumentos que una persona puede guardar, como tarjetas, cuenta SPEI, billetera digital o cupón simulados. Los instrumentos individuales están en tbd_user_payment_methods.',
  tbc_payment_methods_types_res: 'Es un catálogo auxiliar de tipos de medio de pago utilizado por el esquema anterior. Sus nombres y descripciones son referencias de catálogo; el modelo actual de instrumentos usa tbc_payment_methods_types.',
  tbd_address_components: 'Divide un domicilio en partes estructuradas, como componentes geográficos o administrativos. Se relaciona con tb_user_addresses y permite anidar una parte dentro de otra mediante su referencia a sí misma.',
  tbd_cancellation_items: 'Detalla qué renglones y cantidades se solicitan cancelar dentro de una solicitud de tb_order_cancellations. Permite calcular el ajuste y el reembolso usando el precio guardado en tbd_order_items.',
  tbd_cart_items: 'Contiene los productos y cantidades que una persona agrega al carrito. Cada renglón relaciona un carrito con una oferta de vendedor.',
  tbd_order_items: 'Guarda los artículos confirmados dentro de un pedido de vendedor, con el nombre y precio que tenían al comprarse. Conserva la cantidad original y registra aparte las unidades canceladas; el subtotal muestra solo las unidades vigentes.',
  tbd_orders: 'Conserva una estructura de pedido anterior o auxiliar con clave, cantidades, total y estado. En este respaldo no tiene claves foráneas declaradas que la conecten al flujo actual de compra.',
  tbd_products_categories: 'Asocia productos del catálogo con sus categorías. Es una relación de muchos a muchos entre tb_products y tbc_categories.',
  tbd_return_items: 'Detalla los renglones y cantidades que forman parte de una reclamación o devolución, junto con notas sobre la condición recibida. Se complementa con tb_returns y tbd_order_items.',
  tbd_user_payment_methods: 'Guarda instrumentos de pago simulados de cada persona, como tarjeta o cupón: tipo, proveedor, referencia, últimos cuatro dígitos y saldo opcional. Los pagos los referencian sin guardar el número completo de la tarjeta.',
  tbd_users_offer_products: 'Representa la oferta de un producto hecha por un vendedor: quién lo vende, qué producto ofrece, cuántas unidades tiene y si la oferta está activa. Los carritos y pedidos apuntan a esta oferta.',
  tbd_wishlist_products: 'Relaciona los productos que una persona desea guardar para después. Vincula la cuenta con el producto y evita confundir la lista de deseos con el carrito de compra.'
};

// Explicaciones funcionales de los campos para lectores que no conocen SQL.
const FIELD_DESCRIPTIONS = {
  ID: 'Identificador único del registro.', id: 'Identificador único del registro.', person_ID: 'Identificador del registro de datos personales.', cancellation_ID: 'Identificador único de la solicitud de cancelación.', refund_ID: 'Identificador único del reembolso.', return_ID: 'Identificador único de la reclamación o devolución.', shipment_ID: 'Identificador único del envío.', product_offer_ID: 'Identificador de la oferta del producto hecha por un vendedor.',
  key: 'Clave legible o de referencia del registro.', active_user_ID: 'Identificador calculado del usuario mientras el carrito está activo; queda vacío para carritos cerrados.', code: 'Código corto del tipo de instrumento de pago.', user_ID: 'Identificador de la cuenta relacionada.', User_ID: 'Identificador de la cuenta relacionada.', seller_ID: 'Identificador de la cuenta del vendedor.', order_ID: 'Identificador del pedido general al que pertenece el registro.', seller_order_ID: 'Identificador de la parte del pedido que prepara un vendedor.', cart_ID: 'Identificador del carrito al que pertenece el artículo.', product_ID: 'Identificador del producto del catálogo.', category_ID: 'Identificador de la categoría relacionada.', sup_id_category: 'Identificador de la categoría superior, si esta depende de otra.', address_ID: 'Identificador del domicilio al que pertenece el componente.', address_sup_ID: 'Identificador del componente de domicilio superior.', order_item_id: 'Identificador del artículo original del pedido.', cancellation_id: 'Identificador de la solicitud de cancelación relacionada.', return_id: 'Identificador de la reclamación relacionada.', payment_ID: 'Identificador del pago asociado.', replacement_shipment_ID: 'Identificador del envío que reemplaza el producto reclamado.', delivery_address_ID: 'Identificador del domicilio de entrega asociado.', user_payment_method_ID: 'Identificador del instrumento de pago guardado por el comprador.', payment_method_type_ID: 'Identificador del tipo de instrumento de pago.', requested_by: 'Identificador de la persona que solicitó la operación.',
  total_products: 'Cantidad total de unidades incluidas en el pedido.', total_cost: 'Importe total del pedido.', status: 'Indica si el registro está habilitado o activo.', status_string: 'Etapa general del pedido.', creation_date: 'Fecha y hora de creación del registro.', last_update: 'Fecha y hora de la última modificación.', last_login: 'Fecha y hora del último inicio de sesión.', operation_date: 'Fecha y hora en que se registró la acción.', operation_status: 'Resultado o estado de la acción registrada.', source_table_operation: 'Tabla de origen asociada con la acción.', operation_description: 'Explicación de la acción registrada.', table_name: 'Nombre de la tabla afectada.', table_operation: 'Tipo de acción hecha sobre la tabla.', db_user: 'Cuenta de base de datos que realizó la acción.', description: 'Texto que explica el elemento del catálogo o registro.',
  email: 'Correo usado para identificar o contactar la cuenta.', nick: 'Nombre corto o alias de la cuenta.', password: 'Contraseña almacenada; debe estar protegida mediante hash.', platform_role: 'Rol de la persona dentro de la plataforma.', courtesy_title: 'Tratamiento o título de cortesía de la persona.', given_names: 'Nombre o nombres de la persona.', family_names: 'Apellidos de la persona.', birth_date: 'Fecha de nacimiento.', gender_ID: 'Identificador de género, si fue registrado.', country_code: 'Código del país relacionado con la persona.', phone: 'Teléfono de contacto.',
  SKU: 'Código de inventario que identifica el producto.', name: 'Nombre del elemento; puede ser un producto, categoría o tipo de pago según la tabla.', product_name: 'Nombre del producto guardado al momento de la compra.', current_price: 'Precio vigente del producto en el catálogo.', current_stock: 'Existencia general disponible del producto.', available_stock: 'Existencia asignada a la oferta del vendedor.', available_date: 'Fecha desde la que la oferta está disponible.', available_balance: 'Saldo disponible del instrumento; se usa, por ejemplo, para un cupón simulado.', quantity: 'Número de unidades del artículo, reclamación o cancelación.', unit_price: 'Precio de una unidad guardado en el pedido.', subtotal: 'Importe parcial de los artículos o del pedido del vendedor.', shipping_cost: 'Costo de envío correspondiente al pedido del vendedor.', amount: 'Importe del pago, movimiento o reembolso.', currency: 'Moneda en la que se expresa el importe.', installment_number: 'Número de esta cuota dentro del plan de pagos.', installment_count: 'Cantidad total de cuotas del plan.', payment_method: 'Medio usado para intentar o realizar el pago.', payment_status: 'Resultado o estado del cobro.', provider: 'Proveedor del instrumento o del procesamiento de pago.', provider_method_ref: 'Referencia del instrumento en el proveedor de pago.', provider_reference: 'Referencia de la operación en el proveedor de pago.', idempotency_key: 'Clave que evita registrar dos veces el mismo intento de pago.', paid_date: 'Fecha y hora en que se confirmó el pago.', event_type: 'Tipo de evento del historial de pago.', event_reference: 'Referencia externa o interna del evento.', remarks: 'Nota adicional sobre el evento.',
  cancellation_reason: 'Motivo indicado para cancelar artículos.', cancellation_status: 'Etapa de resolución de la solicitud de cancelación.', cancelled_quantity: 'Cantidad de unidades canceladas del renglón; se conserva la cantidad originalmente comprada.', reason: 'Motivo de la cancelación o nota asociada.', refund_reason: 'Motivo por el que se devuelve el dinero.', refund_status: 'Etapa de procesamiento del reembolso.', return_reason: 'Motivo de la reclamación o devolución.', return_status: 'Etapa de revisión y resolución de la reclamación.', inspection_notes: 'Resultado o notas de la inspección del producto devuelto.', condition_notes: 'Descripción del estado físico en que llegó el producto.', requested_date: 'Fecha y hora de solicitud.', resolved_date: 'Fecha y hora de resolución.', received_date: 'Fecha y hora en que se recibió el producto reclamado.', completed_date: 'Fecha y hora en que se completó la operación.',
  fulfillment_status: 'Etapa de preparación o entrega de la parte del pedido del vendedor.', fulfillment_method: 'Forma de entrega: a domicilio o recolección en un punto.', shipment_status: 'Etapa actual del envío.', carrier: 'Paquetería o responsable del transporte.', tracking_number: 'Número o código para identificar el envío o la recolección.', tracking_url: 'Dirección web para consultar el seguimiento.', shipped_date: 'Fecha y hora en que salió el envío.', estimated_delivery_date: 'Fecha estimada de entrega.', delivered_date: 'Fecha y hora en que se registró la entrega o recolección.', pickup_location: 'Lugar donde el comprador puede recoger el pedido.',
  address_label: 'Etiqueta que permite reconocer el domicilio, por ejemplo Casa o Trabajo.', recipient_name: 'Nombre de quien recibirá el paquete.', recipient_phone: 'Teléfono de quien recibirá el paquete.', delivery_instructions: 'Indicaciones para entregar el paquete.', latitude: 'Coordenada geográfica de latitud del domicilio.', longitude: 'Coordenada geográfica de longitud del domicilio.', is_default: 'Indica si este es el domicilio o instrumento predeterminado.', is_active: 'Indica si el elemento del catálogo está activo.', label: 'Nombre elegido para reconocer el instrumento de pago.', last_four: 'Últimos cuatro dígitos visibles del instrumento; no contiene el número completo.', value: 'Valor textual de una parte del domicilio.', component_type: 'Tipo de componente del domicilio, por ejemplo ciudad o código postal.'
};

function describeColumn(table, column) {
  const meaning = FIELD_DESCRIPTIONS[column.name] || `Dato «${column.name}» registrado por esta tabla.`;
  const references = table.foreignKeys
    .filter(fk => fk.columns.includes(column.name))
    .map(fk => `${column.name} enlaza con ${fk.referencedTable}.${fk.referencedColumns.join(', ')}`);
  return references.length ? `${meaning} ${references.join('; ')}.` : meaning;
}

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
    table_description: table.description || '',
    field: column.name,
    field_description: column.description || '',
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
    table: '', table_description: '', field: '', field_description: '', ordinal: '', sql_type: '', sql_definition: '', nullable: '', default_value: '', auto_increment: '', column_comment: '', primary_key: '', unique_indexes: '', indexes: '', index_definitions: '', foreign_key: '', references: '', foreign_key_definitions: '', on_delete: '', on_update: ''
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
    /* Presentación actualizada: superficie clara, acentos azul petróleo y
       tarjetas con jerarquía visual para lectura prolongada del esquema. */
    :root{color-scheme:light;--bg:#eef3f8;--panel:#fff;--panel2:#f7fafc;--line:#d7e1eb;--ink:#172b45;--muted:#667c93;--cyan:#087f8c;--violet:#7555c7;--amber:#ad6a00;--green:#13805b;--red:#bd4650;font:14px/1.55 Inter,ui-sans-serif,system-ui,"Segoe UI",sans-serif}
    body{background:radial-gradient(ellipse at 88% -15%,rgba(64,174,183,.18),transparent 38%),radial-gradient(ellipse at 0% 30%,rgba(117,85,199,.07),transparent 30%),var(--bg);color:var(--ink)}
    .shell{max-width:1740px;padding-top:34px}
    .top{padding:28px 30px;border:1px solid #d9e5ec;border-radius:22px;background:linear-gradient(120deg,rgba(255,255,255,.98),rgba(244,250,251,.94));box-shadow:0 16px 42px rgba(31,58,82,.08);align-items:center}
    .eyebrow,.label{color:#087f8c;letter-spacing:.14em}
    .top h1{color:#172b45;font-size:clamp(32px,4vw,50px);letter-spacing:-.045em}
    .top p{color:#5f7489;font-size:14px;max-width:900px}
    .source{padding:13px 15px;border:1px solid #dbe6ed;border-radius:13px;background:#f8fbfd;text-align:left;color:#5e7489}
    .source b{color:#18334d}
    .stats{gap:14px;margin:20px 0}
    .stat,.panel{background:#fff;border:1px solid #dbe4ed;border-radius:16px;box-shadow:0 8px 24px rgba(35,58,78,.055)}
    .stat{position:relative;overflow:hidden;padding:17px 19px}
    .stat:before{content:"";position:absolute;inset:0 auto 0 0;width:4px;background:#168995}
    .stat:nth-child(2):before{background:#6b60c8}.stat:nth-child(3):before{background:#d48a28}.stat:nth-child(4):before{background:#2f9a70}
    .stat span{color:#667c93}.stat strong{color:#172f4b;font-size:29px}
    .control{background:#fff;border-color:#d5e0e9;color:#18334d;box-shadow:0 2px 5px rgba(27,54,76,.035)}
    .control:focus{outline:3px solid rgba(8,127,140,.16);border-color:#168995}
    .file-label,.button{background:#e9f6f6;border-color:#b7dddf;color:#086f79}
    .file-label:hover,.button:hover{background:#d9eeee}
    .notice{color:#60778d}
    .panel-head{background:linear-gradient(180deg,#fff,#f8fafc);border-color:#e4ebf1}
    .panel-head h2,.panel-head h3{color:#203b57}
    .table-list{background:#fbfcfe}
    .table-button{color:#263f5b}
    .table-button:hover{background:#eef6f8}
    .table-button.active{border-color:#a8d6da;background:#e8f5f6;color:#075e68}
    .prefix{background:#e8eef4;color:#536b83}
    .prefix[data-prefix="tb_"]{background:#e8f3f6;color:#187887}
    .prefix[data-prefix="tbc_"]{background:#f1ecfb;color:#7057b2}
    .prefix[data-prefix="tbd_"]{background:#eaf4ec;color:#397750}
    .svg-scroll{background-color:#fbfdff;background-image:radial-gradient(#dce6ee .8px,transparent .8px);background-size:18px 18px}
    .edge{stroke:#7890a4;stroke-width:1.35;opacity:.7}
    .edge-label{fill:#587087}
    .node rect{fill:#fff;stroke:#cbd9e4;filter:drop-shadow(0 3px 4px rgba(38,63,87,.08))}
    .node:hover rect,.node.selected rect{stroke:#108792;filter:drop-shadow(0 4px 8px rgba(8,127,140,.18))}
    .node-title{fill:#18334d}.node-meta{fill:#6b8095}.node-badge{fill:#13805b}
    .diagram-caption{border-color:#e4ebf1;color:#63798e}
    .detail-title h2{color:#18334d}
    .tab{border-color:#d7e1eb;color:#63798e}.tab.active{color:#087f8c;border-color:#76b9bf;background:#eff9f9}
    .scroll-table{border-color:#dbe4ed}
    .fields th{background:#edf3f7;color:#506981}
    .fields th,.fields td{border-color:#e5ebf0}
    .fields tbody tr:nth-child(even){background:#fafcfe}
    .field-name{color:#193550}
    .badge{background:#eaf0f5;color:#4c657d}.badge.pk{background:#fff1d7;color:#8a5d08}.badge.fk{background:#e2f4f5;color:#087480}.badge.uk{background:#eee9fb;color:#674da8}
    .sql-def{color:#516a82}.relation,.index-card{background:#f8fafc;border-color:#dce5ed}.relation p,.index-card span{color:#657b90}
    .footer{color:#6d8297}
    @media(max-width:900px){.top{padding:22px}.source{margin-top:18px}.top{display:block}}
    @media(max-width:520px){.top{padding:18px;border-radius:16px}.stat strong{font-size:25px}}
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
    `# Diccionario técnico de \`${schema.database}\``, '',
    `Fuente: respaldo SQL [${sourceName}](../backups/${encodeURIComponent(sourceName).replace(/%2F/g, '/')}).`,
    `Huella SHA-256 del archivo: \`${hash}\`.`,
    '- Este documento se genera desde el respaldo indicado. Sus conteos describen ese archivo, no una consulta en vivo.',
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
    '## Para qué sirve cada tabla', '',
    ...schema.tables.map(table => `- **[${table.name}](diccionario/${table.name}.md):** ${table.description || 'Descripción pendiente.'}`), '',
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
    '## Para qué sirve', '',
    table.description || 'Descripción pendiente.', '',
    'Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.', '',
    '## Resumen DDL', '',
    `- Columnas: ${table.columns.length}.`,
    `- Filas encontradas en sentencias INSERT de este respaldo: ${table.insertRows}.`,
    `- Claves primarias / índices: ${table.indexes.length}.`,
    `- Claves foráneas: ${table.foreignKeys.length}.`,
    `- Restricciones CHECK: ${table.checks.length}.`,
    `- Opciones de tabla tal como aparecen junto al DDL: \`${mdCell(table.options) || '(sin opciones capturadas)'}\`.`, '',
    '## Columnas', '',
    '| # | Columna | Para qué sirve | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |', '|---:|---|---|---|:---:|---|---|---|---|',
    ...table.columns.map(column => {
      const refs = table.foreignKeys.filter(fk => fk.columns.includes(column.name)).map(fk => `${fk.name} → ${fk.referencedTable}(${fk.referencedColumns.join(', ')})`);
      const indexes = table.indexes.filter(index => index.columns.includes(column.name)).map(index => `${index.name} (${index.columns.join(', ')})`);
      const keys = [...column.keys.map(key => key === 'IDX' ? 'índice' : key), ...refs].join('; ') || '—';
      return `| ${column.ordinal} | \`${mdCell(column.name)}\` | ${mdCell(column.description)} | \`${mdCell(column.type)}\` | ${column.nullable ? 'Sí' : 'No'} | \`${mdCell(column.default == null ? '—' : column.default)}\` | ${mdCell(keys)}${indexes.length ? `; ${mdCell(indexes.join('; '))}` : ''} | ${mdCell(column.comment) || '—'} | \`${mdCell(column.definition)}\` |`;
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

function writePagesCopy(html) {
  fs.mkdirSync(path.join(PAGES, 'scripts'), { recursive: true });
  fs.mkdirSync(path.join(PAGES, 'diagrama'), { recursive: true });
  const pagesHtml = html.replace('../scripts/diccionario_core.js', 'scripts/diccionario_core.js');
  fs.writeFileSync(path.join(PAGES, 'diccionario.html'), pagesHtml, 'utf8');
  fs.copyFileSync(path.join(__dirname, 'diccionario_core.js'), path.join(PAGES, 'scripts', 'diccionario_core.js'));
  fs.copyFileSync(path.join(OUTPUT, 'backup-picker.js'), path.join(PAGES, 'backup-picker.js'));
}

function main() {
  const input = process.argv[2] ? path.resolve(ROOT, process.argv[2]) : newestSql(BACKUPS);
  if (!fs.existsSync(input) || !fs.statSync(input).isFile()) throw new Error(`No se encontró el archivo SQL: ${input}`);
  if (path.extname(input).toLowerCase() !== '.sql') throw new Error('La fuente debe ser un archivo con extensión .sql');
  const source = fs.readFileSync(input, 'utf8');
  const schema = parseDump(source);
  if (!schema.tables.length) throw new Error('No se encontraron declaraciones CREATE TABLE en el respaldo.');
  for (const table of schema.tables) {
    table.description = TABLE_DESCRIPTIONS[table.name] || 'Guarda información de apoyo del esquema. Consulta sus columnas y relaciones para identificar su uso dentro del flujo de la base de datos.';
    for (const column of table.columns) column.description = describeColumn(table, column);
  }
  const sourceHash = crypto.createHash('sha256').update(source, 'utf8').digest('hex');
  const sourceName = path.relative(BACKUPS, input).split(path.sep).join('/');
  fs.mkdirSync(OUTPUT, { recursive: true });
  fs.writeFileSync(path.join(OUTPUT, 'campos.csv'), createCsv(schema), 'utf8');
  const html = makeHtml(schema, sourceName, sourceHash);
  fs.writeFileSync(path.join(OUTPUT, 'diccionario.html'), html, 'utf8');
  writePagesCopy(html);
  const normalizedInput = path.resolve(input).toLowerCase();
  if (normalizedInput === path.resolve(REFERENCE).toLowerCase()) {
    writeReferenceDocs(schema, path.basename(input), sourceHash);
    // La generacion por practica no modifica el sitio global de Pages.
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
