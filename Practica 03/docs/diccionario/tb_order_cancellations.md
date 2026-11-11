<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_order_cancellations`

Fuente: `respaldo_compra_usuarios.sql`, líneas 416–438. SHA-256: `20eff15c9d28e69975c07c1fb29d265dd8527cefb43781d630567aca1c39e279`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 11.
- Filas encontradas en sentencias INSERT de este respaldo: 0.
- Claves primarias / índices: 6.
- Claves foráneas: 3.
- Restricciones CHECK: 1.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `cancellation_ID` | `bigint unsigned` | No | `—` | PK; PRIMARY (cancellation_ID) | — | `&#96;cancellation_ID&#96; bigint unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `order_ID` | `int unsigned` | No | `—` | índice; FK; fk_cancellation_order → tb_buyer_orders(ID); idx_cancellation_order (order_ID); idx_cancellation_item (order_ID, product_offer_ID) | — | `&#96;order_ID&#96; int unsigned NOT NULL` |
| 3 | `seller_order_ID` | `int unsigned` | Sí | `NULL` | índice; FK; fk_cancellation_seller_order → tb_seller_orders(ID); idx_cancellation_seller_order (seller_order_ID) | — | `&#96;seller_order_ID&#96; int unsigned DEFAULT NULL` |
| 4 | `product_offer_ID` | `int unsigned` | Sí | `NULL` | índice; idx_cancellation_item (order_ID, product_offer_ID) | — | `&#96;product_offer_ID&#96; int unsigned DEFAULT NULL` |
| 5 | `requested_by` | `int` | No | `—` | índice; FK; fk_cancellation_requester → tb_users(ID); fk_cancellation_requester (requested_by) | — | `&#96;requested_by&#96; int NOT NULL` |
| 6 | `cancellation_reason` | `varchar(500)` | No | `—` | — | — | `&#96;cancellation_reason&#96; varchar(500) NOT NULL` |
| 7 | `cancellation_status` | `enum('Requested','Approved','Rejected','Completed')` | No | `'Requested'` | índice; idx_cancellation_status (cancellation_status) | — | `&#96;cancellation_status&#96; enum('Requested','Approved','Rejected','Completed') NOT NULL DEFAULT 'Requested'` |
| 8 | `requested_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;requested_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 9 | `resolved_date` | `datetime` | Sí | `NULL` | — | — | `&#96;resolved_date&#96; datetime DEFAULT NULL` |
| 10 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 11 | `last_update` | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `cancellation_ID`. DDL: `PRIMARY KEY (&#96;cancellation_ID&#96;)`
- `idx_cancellation_order` (INDEX): `order_ID`. DDL: `KEY &#96;idx_cancellation_order&#96; (&#96;order_ID&#96;)`
- `idx_cancellation_seller_order` (INDEX): `seller_order_ID`. DDL: `KEY &#96;idx_cancellation_seller_order&#96; (&#96;seller_order_ID&#96;)`
- `idx_cancellation_status` (INDEX): `cancellation_status`. DDL: `KEY &#96;idx_cancellation_status&#96; (&#96;cancellation_status&#96;)`
- `idx_cancellation_item` (INDEX): `order_ID, product_offer_ID`. DDL: `KEY &#96;idx_cancellation_item&#96; (&#96;order_ID&#96;,&#96;product_offer_ID&#96;)`
- `fk_cancellation_requester` (INDEX): `requested_by`. DDL: `KEY &#96;fk_cancellation_requester&#96; (&#96;requested_by&#96;)`

## Claves foráneas

- `fk_cancellation_order`: (order_ID) → `tb_buyer_orders(ID)`; ON DELETE RESTRICT; ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_cancellation_order&#96; FOREIGN KEY (&#96;order_ID&#96;) REFERENCES &#96;tb_buyer_orders&#96; (&#96;ID&#96;) ON DELETE RESTRICT`
- `fk_cancellation_requester`: (requested_by) → `tb_users(ID)`; ON DELETE RESTRICT; ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_cancellation_requester&#96; FOREIGN KEY (&#96;requested_by&#96;) REFERENCES &#96;tb_users&#96; (&#96;ID&#96;) ON DELETE RESTRICT`
- `fk_cancellation_seller_order`: (seller_order_ID) → `tb_seller_orders(ID)`; ON DELETE RESTRICT; ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_cancellation_seller_order&#96; FOREIGN KEY (&#96;seller_order_ID&#96;) REFERENCES &#96;tb_seller_orders&#96; (&#96;ID&#96;) ON DELETE RESTRICT`

## Restricciones CHECK

- `CONSTRAINT &#96;tb_order_cancellations_chk_1&#96; CHECK (((&#96;resolved_date&#96; is null) or (&#96;resolved_date&#96; >= &#96;requested_date&#96;)))`

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_order_cancellations` (
  `cancellation_ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `order_ID` int unsigned NOT NULL,
  `seller_order_ID` int unsigned DEFAULT NULL,
  `product_offer_ID` int unsigned DEFAULT NULL,
  `requested_by` int NOT NULL,
  `cancellation_reason` varchar(500) NOT NULL,
  `cancellation_status` enum('Requested','Approved','Rejected','Completed') NOT NULL DEFAULT 'Requested',
  `requested_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `resolved_date` datetime DEFAULT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`cancellation_ID`),
  KEY `idx_cancellation_order` (`order_ID`),
  KEY `idx_cancellation_seller_order` (`seller_order_ID`),
  KEY `idx_cancellation_status` (`cancellation_status`),
  KEY `idx_cancellation_item` (`order_ID`,`product_offer_ID`),
  KEY `fk_cancellation_requester` (`requested_by`),
  CONSTRAINT `fk_cancellation_order` FOREIGN KEY (`order_ID`) REFERENCES `tb_buyer_orders` (`ID`) ON DELETE RESTRICT,
  CONSTRAINT `fk_cancellation_requester` FOREIGN KEY (`requested_by`) REFERENCES `tb_users` (`ID`) ON DELETE RESTRICT,
  CONSTRAINT `fk_cancellation_seller_order` FOREIGN KEY (`seller_order_ID`) REFERENCES `tb_seller_orders` (`ID`) ON DELETE RESTRICT,
  CONSTRAINT `tb_order_cancellations_chk_1` CHECK (((`resolved_date` is null) or (`resolved_date` >= `requested_date`)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
