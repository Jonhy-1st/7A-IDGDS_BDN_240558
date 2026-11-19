<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_seller_orders`

Fuente: `Respaldo_Practica4.sql`, líneas 1413–1429. SHA-256: `ed941c888be8bd17d759acbcec9824ba173ad4094795d47012b7cc702bdf3880`.
## Para qué sirve

Divide un pedido general en las partes que prepara cada vendedor. Guarda el vendedor, subtotal, costo de envío y estado de preparación o entrega.

Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 8.
- Filas encontradas en sentencias INSERT de este respaldo: 8.
- Claves primarias / índices: 3.
- Claves foráneas: 2.
- Restricciones CHECK: 2.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Para qué sirve | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|---|:---:|---|---|---|---|
| 1 | `ID` | Identificador único del registro. | `int unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `order_ID` | Identificador del pedido general al que pertenece el registro. order_ID enlaza con tb_buyer_orders.ID. | `int unsigned` | No | `—` | UK; FK; fk_seller_order_order → tb_buyer_orders(ID); uk_order_seller (order_ID, seller_ID) | — | `&#96;order_ID&#96; int unsigned NOT NULL` |
| 3 | `seller_ID` | Identificador de la cuenta del vendedor. seller_ID enlaza con tb_users.ID. | `int` | No | `—` | UK; índice; FK; fk_seller_order_seller → tb_users(ID); uk_order_seller (order_ID, seller_ID); idx_seller_orders_seller (seller_ID) | — | `&#96;seller_ID&#96; int NOT NULL` |
| 4 | `subtotal` | Importe parcial de los artículos o del pedido del vendedor. | `decimal(12,2)` | No | `'0.00'` | — | — | `&#96;subtotal&#96; decimal(12,2) NOT NULL DEFAULT '0.00'` |
| 5 | `shipping_cost` | Costo de envío correspondiente al pedido del vendedor. | `decimal(12,2)` | No | `'0.00'` | — | — | `&#96;shipping_cost&#96; decimal(12,2) NOT NULL DEFAULT '0.00'` |
| 6 | `fulfillment_status` | Etapa de preparación o entrega de la parte del pedido del vendedor. | `enum('Pending','Accepted','Preparing','Sent','Delivered','Canceled','Returned')` | No | `'Pending'` | — | — | `&#96;fulfillment_status&#96; enum('Pending','Accepted','Preparing','Sent','Delivered','Canceled','Returned') NOT NULL DEFAULT 'Pending'` |
| 7 | `creation_date` | Fecha y hora de creación del registro. | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 8 | `last_update` | Fecha y hora de la última modificación. | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `uk_order_seller` (UNIQUE, UNIQUE): `order_ID, seller_ID`. DDL: `UNIQUE KEY &#96;uk_order_seller&#96; (&#96;order_ID&#96;,&#96;seller_ID&#96;)`
- `idx_seller_orders_seller` (INDEX): `seller_ID`. DDL: `KEY &#96;idx_seller_orders_seller&#96; (&#96;seller_ID&#96;)`

## Claves foráneas

- `fk_seller_order_order`: (order_ID) → `tb_buyer_orders(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_seller_order_order&#96; FOREIGN KEY (&#96;order_ID&#96;) REFERENCES &#96;tb_buyer_orders&#96; (&#96;ID&#96;)`
- `fk_seller_order_seller`: (seller_ID) → `tb_users(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_seller_order_seller&#96; FOREIGN KEY (&#96;seller_ID&#96;) REFERENCES &#96;tb_users&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- `CONSTRAINT &#96;chk_seller_order_shipping&#96; CHECK ((&#96;shipping_cost&#96; >= 0))`
- `CONSTRAINT &#96;chk_seller_order_subtotal&#96; CHECK ((&#96;subtotal&#96; >= 0))`

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_seller_orders` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `order_ID` int unsigned NOT NULL,
  `seller_ID` int NOT NULL,
  `subtotal` decimal(12,2) NOT NULL DEFAULT '0.00',
  `shipping_cost` decimal(12,2) NOT NULL DEFAULT '0.00',
  `fulfillment_status` enum('Pending','Accepted','Preparing','Sent','Delivered','Canceled','Returned') NOT NULL DEFAULT 'Pending',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_order_seller` (`order_ID`,`seller_ID`),
  KEY `idx_seller_orders_seller` (`seller_ID`),
  CONSTRAINT `fk_seller_order_order` FOREIGN KEY (`order_ID`) REFERENCES `tb_buyer_orders` (`ID`),
  CONSTRAINT `fk_seller_order_seller` FOREIGN KEY (`seller_ID`) REFERENCES `tb_users` (`ID`),
  CONSTRAINT `chk_seller_order_shipping` CHECK ((`shipping_cost` >= 0)),
  CONSTRAINT `chk_seller_order_subtotal` CHECK ((`subtotal` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
