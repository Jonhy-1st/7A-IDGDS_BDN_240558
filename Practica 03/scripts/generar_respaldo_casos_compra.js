#!/usr/bin/env node
'use strict';

// Genera un respaldo derivado y autocontenido desde el último dump guardado.
// Conserva los datos de origen y materializa las modificaciones de la práctica.
const fs = require('node:fs');
const path = require('node:path');

const practiceDir = path.resolve(__dirname, '..');
const sourcePath = path.join(practiceDir, 'backups', 'respaldo_compra.sql');
const outputPath = path.join(practiceDir, 'backups', 'respaldo_casos_compra_final.sql');
const migrationPath = path.join(__dirname, 'preparar_esquema_casos_compra.sql');
const operationsPath = path.join(__dirname, 'operaciones_casos_compra.sql');

function findCreateTable(sql, tableName) {
  const escaped = tableName.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const match = new RegExp('CREATE\\s+TABLE\\s+`?' + escaped + '`?\\s*\\(', 'i').exec(sql);
  if (!match) throw new Error(`No se encontró CREATE TABLE para ${tableName}`);
  const open = sql.indexOf('(', match.index + match[0].length - 1);
  let depth = 0;
  for (let i = open; i < sql.length; i++) {
    const ch = sql[i];
    if (ch === "'" || ch === '"' || ch === '`') {
      const quote = ch;
      for (i++; i < sql.length; i++) {
        if (sql[i] === '\\') { i++; continue; }
        if (sql[i] === quote) {
          if (sql[i + 1] === quote) { i++; continue; }
          break;
        }
      }
      continue;
    }
    if (ch === '/' && sql[i + 1] === '*') {
      const end = sql.indexOf('*/', i + 2);
      if (end < 0) throw new Error(`Comentario SQL sin cerrar en ${tableName}`);
      i = end + 1;
      continue;
    }
    if (ch === '-' && sql[i + 1] === '-') {
      const end = sql.indexOf('\n', i + 2);
      i = end < 0 ? sql.length : end;
      continue;
    }
    if (ch === '(') depth++;
    else if (ch === ')' && --depth === 0) {
      const semicolon = sql.indexOf(';', i);
      if (semicolon < 0) throw new Error(`CREATE TABLE sin punto y coma: ${tableName}`);
      return { start: match.index, end: semicolon + 1, ddl: sql.slice(match.index, semicolon + 1), close: i - match.index };
    }
  }
  throw new Error(`CREATE TABLE sin paréntesis balanceados: ${tableName}`);
}

function transformTable(sql, tableName, transform) {
  const found = findCreateTable(sql, tableName);
  const updated = transform(found.ddl, found.close);
  if (updated === found.ddl) throw new Error(`No se aplicó la transformación esperada a ${tableName}`);
  return sql.slice(0, found.start) + updated + sql.slice(found.end);
}

function addBeforeTableClose(ddl, close, sqlText) {
  return ddl.slice(0, close) + sqlText + ddl.slice(close);
}

let sql = fs.readFileSync(sourcePath, 'utf8').replace(/\r\n/g, '\n');
const migration = fs.readFileSync(migrationPath, 'utf8');
const procedureStart = migration.indexOf('-- Registra un intento o una cuota simulada');
if (procedureStart < 0) throw new Error('No se encontró el procedimiento de pago en la migración');
const procedure = migration.slice(procedureStart).trim();
const operations = fs.readFileSync(operationsPath, 'utf8');

sql = transformTable(sql, 'tb_buyer_orders', ddl => ddl.replace(
  "enum('Registered','Wishlist','Payed','Canceled','Delivered','Devolved','Attended','Sended')",
  "enum('Registered','Wishlist','Payed','Canceled','Delivered','Devolved','Attended','Sended','PartiallyPaid','PaymentFailed')"
));
sql = transformTable(sql, 'tb_carts', ddl => {
  let changed = ddl.replace(
    "  `status` enum('Active','Converted','Abandoned') NOT NULL DEFAULT 'Active',\n",
    "  `status` enum('Active','Converted','Abandoned') NOT NULL DEFAULT 'Active',\n  `active_user_ID` int GENERATED ALWAYS AS ((case when (`status` = 'Active') then `user_ID` else NULL end)) STORED,\n"
  );
  changed = changed.replace(
    '  UNIQUE KEY `uk_cart_user` (`user_ID`),',
    '  KEY `idx_carts_user` (`user_ID`),\n  UNIQUE KEY `uk_cart_active_user` (`active_user_ID`),'
  );
  if (changed === ddl) throw new Error('No se encontraron las columnas e índice de usuario en tb_carts');
  return changed;
});
sql = transformTable(sql, 'tb_users', ddl => {
  const changed = ddl.replace(
    "  `status` bit(1) NOT NULL DEFAULT b'1',\n",
    "  `status` bit(1) NOT NULL DEFAULT b'1',\n  `platform_role` enum('common_user','buyer') NOT NULL DEFAULT 'common_user',\n"
  );
  if (changed === ddl) throw new Error('No se encontró status en tb_users');
  return changed;
});
sql = transformTable(sql, 'tb_payments', (ddl, close) => {
  const withColumns = ddl.replace(
    "  `amount` decimal(12,2) NOT NULL,\n",
    "  `amount` decimal(12,2) NOT NULL,\n  `installment_number` smallint unsigned DEFAULT NULL,\n  `installment_count` smallint unsigned DEFAULT NULL,\n"
  );
  if (withColumns === ddl) throw new Error('No se encontraron las columnas para añadir cuotas en tb_payments');
  const at = findCreateTable(withColumns, 'tb_payments').close;
  return addBeforeTableClose(withColumns, at,
    ",\n  CONSTRAINT `chk_payment_installment_pair` CHECK (((`installment_number` is null and `installment_count` is null) or (`installment_number` is not null and `installment_count` is not null and `installment_number` > 0 and `installment_count` > 0 and `installment_number` <= `installment_count`)))\n");
});
sql = transformTable(sql, 'tb_shipments', ddl => ddl
  .replace(
    "enum('Pending','Preparing','Shipped','InTransit','OutForDelivery','Delivered','DeliveryFailed','Lost','Returned')",
    "enum('Pending','Preparing','Shipped','InTransit','OutForDelivery','Delivered','DeliveryFailed','Lost','Returned','ReadyForPickup','PickedUp')"
  )
  .replace(
    '  `delivery_address_ID` bigint unsigned DEFAULT NULL,\n',
    "  `delivery_address_ID` bigint unsigned DEFAULT NULL,\n  `fulfillment_method` enum('HomeDelivery','Pickup') NOT NULL DEFAULT 'HomeDelivery',\n  `pickup_location` varchar(255) DEFAULT NULL,\n"
  )
);
sql = transformTable(sql, 'tb_returns', (ddl, close) => {
  let changed = ddl.replace(
    '  `inspection_notes` text,\n',
    '  `inspection_notes` text,\n  `replacement_shipment_ID` bigint unsigned DEFAULT NULL,\n'
  );
  if (changed === ddl) throw new Error('No se encontró inspection_notes en tb_returns');
  const at = findCreateTable(changed, 'tb_returns').close;
  changed = addBeforeTableClose(changed, at,
    ",\n  KEY `idx_returns_replacement_shipment` (`replacement_shipment_ID`),\n  CONSTRAINT `fk_returns_replacement_shipment` FOREIGN KEY (`replacement_shipment_ID`) REFERENCES `tb_shipments` (`shipment_ID`) ON DELETE RESTRICT\n");
  return changed;
});
sql = transformTable(sql, 'tbd_user_payment_methods', ddl => {
  let changed = ddl.replace(
    '  `last_four` char(4) DEFAULT NULL,\n',
    '  `last_four` char(4) DEFAULT NULL,\n  `available_balance` decimal(12,2) DEFAULT NULL,\n'
  );
  if (changed === ddl) throw new Error('No se encontró last_four en tbd_user_payment_methods');
  const at = findCreateTable(changed, 'tbd_user_payment_methods').close;
  changed = addBeforeTableClose(changed, at,
    ",\n  CONSTRAINT `chk_user_payment_method_balance` CHECK ((`available_balance` is null) or (`available_balance` >= 0))\n");
  return changed;
});

const methodInsert = /INSERT INTO `tbc_payment_methods_types` VALUES \([\s\S]*?\);/i;
if (!methodInsert.test(sql)) throw new Error('No se encontró el INSERT de tipos de pago en el respaldo');
sql = sql.replace(methodInsert, match => `${match}\nINSERT INTO \`tbc_payment_methods_types\` (\`code\`, \`description\`, \`status\`) VALUES\n  ('CREDIT_CARD_SIM', 'Tarjeta de crédito simulada para pruebas', b'1'),\n  ('DIGITAL_WALLET_SIM', 'Billetera digital simulada Spin para pruebas', b'1'),\n  ('SPEI_ACCOUNT_SIM', 'Cuenta simulada para transferencias SPEI', b'1'),\n  ('GIFT_COUPON_SIM', 'Cupón de regalo simulado con saldo', b'1');`);

// Los INSERT históricos no incluyen columnas. Se nombran las columnas viejas
// para que las nuevas columnas agregadas usen sus valores por defecto/NULL.
const oldInsertColumns = {
  tb_carts: 'ID,user_ID,status,creation_date,last_update',
  tb_users: 'ID,email,nick,password,creation_date,last_update,last_login,status',
  tb_payments: 'ID,order_ID,user_payment_method_ID,amount,currency,payment_method,provider,provider_reference,idempotency_key,payment_status,creation_date,paid_date,last_update',
  tb_shipments: 'shipment_ID,seller_order_ID,delivery_address_ID,carrier,tracking_number,tracking_url,shipment_status,shipped_date,estimated_delivery_date,delivered_date,creation_date,last_update',
  tbd_user_payment_methods: 'ID,user_ID,payment_method_type_ID,provider,provider_method_ref,label,last_four,is_default,status,creation_date,last_update'
};
for (const [tableName, columns] of Object.entries(oldInsertColumns)) {
  const insertPattern = new RegExp('INSERT INTO `' + tableName + '` VALUES', 'i');
  if (!insertPattern.test(sql)) throw new Error(`No se encontró el INSERT histórico de ${tableName}`);
  sql = sql.replace(insertPattern, `INSERT INTO \`${tableName}\` (\`${columns.split(',').join('`,`')}\`) VALUES`);
}

sql += `\n-- Cuentas que ya cubrieron el total de una compra quedan como compradores de plataforma.\nUPDATE tb_users u\nJOIN (\n  SELECT bo.user_ID\n  FROM tb_buyer_orders bo\n  JOIN tb_payments p ON p.order_ID = bo.ID\n  WHERE p.payment_status IN ('Authorized', 'Paid')\n  GROUP BY bo.ID, bo.user_ID, bo.total_cost\n  HAVING SUM(p.amount) >= ROUND(bo.total_cost, 2)\n) paid_users ON paid_users.user_ID = u.ID\nSET u.platform_role = 'buyer';\n`;

sql = `-- Respaldo derivado localmente desde backups/respaldo_compra.sql.\n-- Conserva los datos del dump base; incorpora el esquema y procedimientos de casos de compra.\n-- No representa una extracción nueva de una instancia MySQL en vivo.\n${sql}`;
sql += `\n\n-- Cambios locales para los casos de compra; los datos provienen del dump base.\nDELIMITER //\n${procedure}\n\n${operations}\n`;
fs.writeFileSync(outputPath, sql, 'utf8');
console.log(`Respaldo derivado creado: ${path.relative(practiceDir, outputPath)}`);
console.log('Origen: backups/respaldo_compra.sql; conserva sus INSERT y transforma solo el esquema de compra.');
