<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbd_return_items`

Fuente: `240558_Respaldo_com_responsables_dbuser.sql`, líneas 1976–1993. SHA-256: `8242d2e7a82f3e2b2c326fda9989c7d676d061933ad43ad2e750a057d0e7a766`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 10.
- Filas encontradas en sentencias INSERT de este respaldo: 0.
- Claves primarias / índices: 4.
- Claves foráneas: 0.
- Restricciones CHECK: 2.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `ID` | `int unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `return_ID` | `int unsigned` | No | `—` | UK; índice; uk_return_order_item (return_ID, order_item_ID); idx_return_items_return (return_ID) | — | `&#96;return_ID&#96; int unsigned NOT NULL` |
| 3 | `order_item_ID` | `int unsigned` | No | `—` | UK; índice; uk_return_order_item (return_ID, order_item_ID); idx_return_items_order_item (order_item_ID) | — | `&#96;order_item_ID&#96; int unsigned NOT NULL` |
| 4 | `quantity` | `int unsigned` | No | `—` | — | — | `&#96;quantity&#96; int unsigned NOT NULL` |
| 5 | `item_condition` | `enum('Unopened','Unused','Used','Damaged','Defective','Other')` | Sí | `NULL` | — | — | `&#96;item_condition&#96; enum('Unopened','Unused','Used','Damaged','Defective','Other') DEFAULT NULL` |
| 6 | `disposition` | `enum('Pending','Restock','Repair','Dispose','SupplierReturn')` | No | `'Pending'` | — | — | `&#96;disposition&#96; enum('Pending','Restock','Repair','Dispose','SupplierReturn') NOT NULL DEFAULT 'Pending'` |
| 7 | `approved_refund_amount` | `decimal(12,2)` | No | `'0.00'` | — | — | `&#96;approved_refund_amount&#96; decimal(12,2) NOT NULL DEFAULT '0.00'` |
| 8 | `item_status` | `enum('Requested','Approved','Rejected','Received','Refunded')` | No | `'Requested'` | — | — | `&#96;item_status&#96; enum('Requested','Approved','Rejected','Received','Refunded') NOT NULL DEFAULT 'Requested'` |
| 9 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 10 | `last_update` | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `uk_return_order_item` (UNIQUE, UNIQUE): `return_ID, order_item_ID`. DDL: `UNIQUE KEY &#96;uk_return_order_item&#96; (&#96;return_ID&#96;,&#96;order_item_ID&#96;)`
- `idx_return_items_order_item` (INDEX): `order_item_ID`. DDL: `KEY &#96;idx_return_items_order_item&#96; (&#96;order_item_ID&#96;)`
- `idx_return_items_return` (INDEX): `return_ID`. DDL: `KEY &#96;idx_return_items_return&#96; (&#96;return_ID&#96;)`

## Claves foráneas

- No se encontraron claves foráneas en el DDL.

## Restricciones CHECK

- `CONSTRAINT &#96;chk_return_items_quantity&#96; CHECK ((&#96;quantity&#96; > 0))`
- `CONSTRAINT &#96;chk_return_items_refund_amount&#96; CHECK ((&#96;approved_refund_amount&#96; >= 0))`

## Definición SQL de la tabla

```sql
CREATE TABLE `tbd_return_items` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `return_ID` int unsigned NOT NULL,
  `order_item_ID` int unsigned NOT NULL,
  `quantity` int unsigned NOT NULL,
  `item_condition` enum('Unopened','Unused','Used','Damaged','Defective','Other') DEFAULT NULL,
  `disposition` enum('Pending','Restock','Repair','Dispose','SupplierReturn') NOT NULL DEFAULT 'Pending',
  `approved_refund_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `item_status` enum('Requested','Approved','Rejected','Received','Refunded') NOT NULL DEFAULT 'Requested',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_return_order_item` (`return_ID`,`order_item_ID`),
  KEY `idx_return_items_order_item` (`order_item_ID`),
  KEY `idx_return_items_return` (`return_ID`),
  CONSTRAINT `chk_return_items_quantity` CHECK ((`quantity` > 0)),
  CONSTRAINT `chk_return_items_refund_amount` CHECK ((`approved_refund_amount` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
