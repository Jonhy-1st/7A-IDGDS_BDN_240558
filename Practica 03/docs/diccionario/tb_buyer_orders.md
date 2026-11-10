<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_buyer_orders`

Fuente: `240558_Respaldo_com_responsables_dbuser.sql`, líneas 33–51. SHA-256: `8242d2e7a82f3e2b2c326fda9989c7d676d061933ad43ad2e750a057d0e7a766`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 10.
- Filas encontradas en sentencias INSERT de este respaldo: 0.
- Claves primarias / índices: 4.
- Claves foráneas: 2.
- Restricciones CHECK: 1.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `ID` | `int unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `order_ID` | `int unsigned` | No | `—` | índice; FK; fk_seller_orders_order → tb_orders(ID); idx_seller_orders_order (order_ID) | — | `&#96;order_ID&#96; int unsigned NOT NULL` |
| 3 | `seller_ID` | `int` | No | `—` | índice; FK; fk_seller_orders_seller → tb_users(ID); idx_seller_orders_seller (seller_ID) | — | `&#96;seller_ID&#96; int NOT NULL` |
| 4 | `seller_order_status` | `enum('Pending','Confirmed','Preparing','Shipped','Delivered','Cancelled','Completed')` | No | `'Pending'` | índice; idx_seller_orders_status (seller_order_status) | — | `&#96;seller_order_status&#96; enum('Pending','Confirmed','Preparing','Shipped','Delivered','Cancelled','Completed') NOT NULL DEFAULT 'Pending'` |
| 5 | `subtotal` | `decimal(12,2)` | No | `'0.00'` | — | — | `&#96;subtotal&#96; decimal(12,2) NOT NULL DEFAULT '0.00'` |
| 6 | `shipping_cost` | `decimal(12,2)` | No | `'0.00'` | — | — | `&#96;shipping_cost&#96; decimal(12,2) NOT NULL DEFAULT '0.00'` |
| 7 | `discount_amount` | `decimal(12,2)` | No | `'0.00'` | — | — | `&#96;discount_amount&#96; decimal(12,2) NOT NULL DEFAULT '0.00'` |
| 8 | `total_amount` | `decimal(12,2)` | Sí | `—` | — | — | `&#96;total_amount&#96; decimal(12,2) GENERATED ALWAYS AS (((&#96;subtotal&#96; + &#96;shipping_cost&#96;) - &#96;discount_amount&#96;)) STORED` |
| 9 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 10 | `last_update` | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `idx_seller_orders_order` (INDEX): `order_ID`. DDL: `KEY &#96;idx_seller_orders_order&#96; (&#96;order_ID&#96;)`
- `idx_seller_orders_seller` (INDEX): `seller_ID`. DDL: `KEY &#96;idx_seller_orders_seller&#96; (&#96;seller_ID&#96;)`
- `idx_seller_orders_status` (INDEX): `seller_order_status`. DDL: `KEY &#96;idx_seller_orders_status&#96; (&#96;seller_order_status&#96;)`

## Claves foráneas

- `fk_seller_orders_order`: (order_ID) → `tb_orders(ID)`; ON DELETE RESTRICT; ON UPDATE CASCADE. DDL: `CONSTRAINT &#96;fk_seller_orders_order&#96; FOREIGN KEY (&#96;order_ID&#96;) REFERENCES &#96;tb_orders&#96; (&#96;ID&#96;) ON DELETE RESTRICT ON UPDATE CASCADE`
- `fk_seller_orders_seller`: (seller_ID) → `tb_users(ID)`; ON DELETE RESTRICT; ON UPDATE CASCADE. DDL: `CONSTRAINT &#96;fk_seller_orders_seller&#96; FOREIGN KEY (&#96;seller_ID&#96;) REFERENCES &#96;tb_users&#96; (&#96;ID&#96;) ON DELETE RESTRICT ON UPDATE CASCADE`

## Restricciones CHECK

- `CONSTRAINT &#96;chk_seller_orders_amounts&#96; CHECK (((&#96;subtotal&#96; >= 0) and (&#96;shipping_cost&#96; >= 0) and (&#96;discount_amount&#96; >= 0) and (&#96;discount_amount&#96; <= (&#96;subtotal&#96; + &#96;shipping_cost&#96;))))`

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_buyer_orders` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `order_ID` int unsigned NOT NULL,
  `seller_ID` int NOT NULL,
  `seller_order_status` enum('Pending','Confirmed','Preparing','Shipped','Delivered','Cancelled','Completed') NOT NULL DEFAULT 'Pending',
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0.00',
  `shipping_cost` decimal(12,2) NOT NULL DEFAULT '0.00',
  `discount_amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `total_amount` decimal(12,2) GENERATED ALWAYS AS (((`subtotal` + `shipping_cost`) - `discount_amount`)) STORED,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_seller_orders_order` (`order_ID`),
  KEY `idx_seller_orders_seller` (`seller_ID`),
  KEY `idx_seller_orders_status` (`seller_order_status`),
  CONSTRAINT `fk_seller_orders_order` FOREIGN KEY (`order_ID`) REFERENCES `tb_orders` (`ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_seller_orders_seller` FOREIGN KEY (`seller_ID`) REFERENCES `tb_users` (`ID`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_seller_orders_amounts` CHECK (((`subtotal` >= 0) and (`shipping_cost` >= 0) and (`discount_amount` >= 0) and (`discount_amount` <= (`subtotal` + `shipping_cost`))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
