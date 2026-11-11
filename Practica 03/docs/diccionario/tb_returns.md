<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_returns`

Fuente: `respaldo_compra_usuarios.sql`, líneas 1311–1334. SHA-256: `20eff15c9d28e69975c07c1fb29d265dd8527cefb43781d630567aca1c39e279`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 13.
- Filas encontradas en sentencias INSERT de este respaldo: 0.
- Claves primarias / índices: 5.
- Claves foráneas: 2.
- Restricciones CHECK: 2.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `return_ID` | `bigint unsigned` | No | `—` | PK; PRIMARY (return_ID) | — | `&#96;return_ID&#96; bigint unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `order_ID` | `int unsigned` | No | `—` | índice; FK; fk_return_order → tb_buyer_orders(ID); idx_return_order (order_ID); idx_return_item (order_ID, product_offer_ID) | — | `&#96;order_ID&#96; int unsigned NOT NULL` |
| 3 | `product_offer_ID` | `int unsigned` | No | `—` | índice; idx_return_item (order_ID, product_offer_ID) | — | `&#96;product_offer_ID&#96; int unsigned NOT NULL` |
| 4 | `requested_by` | `int` | No | `—` | índice; FK; fk_return_requester → tb_users(ID); fk_return_requester (requested_by) | — | `&#96;requested_by&#96; int NOT NULL` |
| 5 | `quantity` | `int unsigned` | No | `—` | — | — | `&#96;quantity&#96; int unsigned NOT NULL` |
| 6 | `return_reason` | `enum('Defective','Damaged','WrongProduct','NotAsDescribed','WrongSize','ChangedMind','Other')` | No | `'Other'` | — | — | `&#96;return_reason&#96; enum('Defective','Damaged','WrongProduct','NotAsDescribed','WrongSize','ChangedMind','Other') NOT NULL DEFAULT 'Other'` |
| 7 | `return_status` | `enum('Requested','Authorized','Rejected','InTransit','Received','Inspected','Completed')` | No | `'Requested'` | índice; idx_return_status (return_status) | — | `&#96;return_status&#96; enum('Requested','Authorized','Rejected','InTransit','Received','Inspected','Completed') NOT NULL DEFAULT 'Requested'` |
| 8 | `inspection_notes` | `text` | Sí | `—` | — | — | `&#96;inspection_notes&#96; text` |
| 9 | `requested_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;requested_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 10 | `received_date` | `datetime` | Sí | `NULL` | — | — | `&#96;received_date&#96; datetime DEFAULT NULL` |
| 11 | `completed_date` | `datetime` | Sí | `NULL` | — | — | `&#96;completed_date&#96; datetime DEFAULT NULL` |
| 12 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 13 | `last_update` | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `return_ID`. DDL: `PRIMARY KEY (&#96;return_ID&#96;)`
- `idx_return_order` (INDEX): `order_ID`. DDL: `KEY &#96;idx_return_order&#96; (&#96;order_ID&#96;)`
- `idx_return_item` (INDEX): `order_ID, product_offer_ID`. DDL: `KEY &#96;idx_return_item&#96; (&#96;order_ID&#96;,&#96;product_offer_ID&#96;)`
- `idx_return_status` (INDEX): `return_status`. DDL: `KEY &#96;idx_return_status&#96; (&#96;return_status&#96;)`
- `fk_return_requester` (INDEX): `requested_by`. DDL: `KEY &#96;fk_return_requester&#96; (&#96;requested_by&#96;)`

## Claves foráneas

- `fk_return_order`: (order_ID) → `tb_buyer_orders(ID)`; ON DELETE RESTRICT; ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_return_order&#96; FOREIGN KEY (&#96;order_ID&#96;) REFERENCES &#96;tb_buyer_orders&#96; (&#96;ID&#96;) ON DELETE RESTRICT`
- `fk_return_requester`: (requested_by) → `tb_users(ID)`; ON DELETE RESTRICT; ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_return_requester&#96; FOREIGN KEY (&#96;requested_by&#96;) REFERENCES &#96;tb_users&#96; (&#96;ID&#96;) ON DELETE RESTRICT`

## Restricciones CHECK

- `CONSTRAINT &#96;chk_return_dates&#96; CHECK ((((&#96;received_date&#96; is null) or (&#96;received_date&#96; >= &#96;requested_date&#96;)) and ((&#96;completed_date&#96; is null) or (&#96;completed_date&#96; >= &#96;requested_date&#96;))))`
- `CONSTRAINT &#96;chk_return_quantity&#96; CHECK ((&#96;quantity&#96; > 0))`

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_returns` (
  `return_ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_ID` int unsigned NOT NULL,
  `product_offer_ID` int unsigned NOT NULL,
  `requested_by` int NOT NULL,
  `quantity` int unsigned NOT NULL,
  `return_reason` enum('Defective','Damaged','WrongProduct','NotAsDescribed','WrongSize','ChangedMind','Other') NOT NULL DEFAULT 'Other',
  `return_status` enum('Requested','Authorized','Rejected','InTransit','Received','Inspected','Completed') NOT NULL DEFAULT 'Requested',
  `inspection_notes` text,
  `requested_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `received_date` datetime DEFAULT NULL,
  `completed_date` datetime DEFAULT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`return_ID`),
  KEY `idx_return_order` (`order_ID`),
  KEY `idx_return_item` (`order_ID`,`product_offer_ID`),
  KEY `idx_return_status` (`return_status`),
  KEY `fk_return_requester` (`requested_by`),
  CONSTRAINT `fk_return_order` FOREIGN KEY (`order_ID`) REFERENCES `tb_buyer_orders` (`ID`) ON DELETE RESTRICT,
  CONSTRAINT `fk_return_requester` FOREIGN KEY (`requested_by`) REFERENCES `tb_users` (`ID`) ON DELETE RESTRICT,
  CONSTRAINT `chk_return_dates` CHECK ((((`received_date` is null) or (`received_date` >= `requested_date`)) and ((`completed_date` is null) or (`completed_date` >= `requested_date`)))),
  CONSTRAINT `chk_return_quantity` CHECK ((`quantity` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
