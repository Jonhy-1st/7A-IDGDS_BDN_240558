<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_shipments`

Fuente: `respaldo_compra_usuarios.sql`, líneas 1584–1604. SHA-256: `20eff15c9d28e69975c07c1fb29d265dd8527cefb43781d630567aca1c39e279`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 12.
- Filas encontradas en sentencias INSERT de este respaldo: 2.
- Claves primarias / índices: 4.
- Claves foráneas: 2.
- Restricciones CHECK: 1.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `shipment_ID` | `bigint unsigned` | No | `—` | PK; PRIMARY (shipment_ID) | — | `&#96;shipment_ID&#96; bigint unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `seller_order_ID` | `int unsigned` | No | `—` | índice; FK; fk_shipments_seller_order → tb_seller_orders(ID); idx_shipment_order (seller_order_ID) | — | `&#96;seller_order_ID&#96; int unsigned NOT NULL` |
| 3 | `delivery_address_ID` | `bigint unsigned` | Sí | `NULL` | índice; FK; fk_shipments_delivery_address → tb_user_addresses(ID); idx_shipments_delivery_address (delivery_address_ID) | — | `&#96;delivery_address_ID&#96; bigint unsigned DEFAULT NULL` |
| 4 | `carrier` | `varchar(100)` | Sí | `NULL` | — | — | `&#96;carrier&#96; varchar(100) DEFAULT NULL` |
| 5 | `tracking_number` | `varchar(150)` | Sí | `NULL` | índice; idx_shipment_tracking (tracking_number) | — | `&#96;tracking_number&#96; varchar(150) DEFAULT NULL` |
| 6 | `tracking_url` | `varchar(500)` | Sí | `NULL` | — | — | `&#96;tracking_url&#96; varchar(500) DEFAULT NULL` |
| 7 | `shipment_status` | `enum('Pending','Preparing','Shipped','InTransit','OutForDelivery','Delivered','DeliveryFailed','Lost','Returned')` | No | `'Pending'` | — | — | `&#96;shipment_status&#96; enum('Pending','Preparing','Shipped','InTransit','OutForDelivery','Delivered','DeliveryFailed','Lost','Returned') NOT NULL DEFAULT 'Pending'` |
| 8 | `shipped_date` | `datetime` | Sí | `NULL` | — | — | `&#96;shipped_date&#96; datetime DEFAULT NULL` |
| 9 | `estimated_delivery_date` | `datetime` | Sí | `NULL` | — | — | `&#96;estimated_delivery_date&#96; datetime DEFAULT NULL` |
| 10 | `delivered_date` | `datetime` | Sí | `NULL` | — | — | `&#96;delivered_date&#96; datetime DEFAULT NULL` |
| 11 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 12 | `last_update` | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `shipment_ID`. DDL: `PRIMARY KEY (&#96;shipment_ID&#96;)`
- `idx_shipment_order` (INDEX): `seller_order_ID`. DDL: `KEY &#96;idx_shipment_order&#96; (&#96;seller_order_ID&#96;)`
- `idx_shipment_tracking` (INDEX): `tracking_number`. DDL: `KEY &#96;idx_shipment_tracking&#96; (&#96;tracking_number&#96;)`
- `idx_shipments_delivery_address` (INDEX): `delivery_address_ID`. DDL: `KEY &#96;idx_shipments_delivery_address&#96; (&#96;delivery_address_ID&#96;)`

## Claves foráneas

- `fk_shipments_delivery_address`: (delivery_address_ID) → `tb_user_addresses(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_shipments_delivery_address&#96; FOREIGN KEY (&#96;delivery_address_ID&#96;) REFERENCES &#96;tb_user_addresses&#96; (&#96;ID&#96;)`
- `fk_shipments_seller_order`: (seller_order_ID) → `tb_seller_orders(ID)`; ON DELETE RESTRICT; ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_shipments_seller_order&#96; FOREIGN KEY (&#96;seller_order_ID&#96;) REFERENCES &#96;tb_seller_orders&#96; (&#96;ID&#96;) ON DELETE RESTRICT`

## Restricciones CHECK

- `CONSTRAINT &#96;tb_shipments_chk_1&#96; CHECK (((&#96;delivered_date&#96; is null) or (&#96;shipped_date&#96; is null) or (&#96;delivered_date&#96; >= &#96;shipped_date&#96;)))`

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_shipments` (
  `shipment_ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `seller_order_ID` int unsigned NOT NULL,
  `delivery_address_ID` bigint unsigned DEFAULT NULL,
  `carrier` varchar(100) DEFAULT NULL,
  `tracking_number` varchar(150) DEFAULT NULL,
  `tracking_url` varchar(500) DEFAULT NULL,
  `shipment_status` enum('Pending','Preparing','Shipped','InTransit','OutForDelivery','Delivered','DeliveryFailed','Lost','Returned') NOT NULL DEFAULT 'Pending',
  `shipped_date` datetime DEFAULT NULL,
  `estimated_delivery_date` datetime DEFAULT NULL,
  `delivered_date` datetime DEFAULT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`shipment_ID`),
  KEY `idx_shipment_order` (`seller_order_ID`),
  KEY `idx_shipment_tracking` (`tracking_number`),
  KEY `idx_shipments_delivery_address` (`delivery_address_ID`),
  CONSTRAINT `fk_shipments_delivery_address` FOREIGN KEY (`delivery_address_ID`) REFERENCES `tb_user_addresses` (`ID`),
  CONSTRAINT `fk_shipments_seller_order` FOREIGN KEY (`seller_order_ID`) REFERENCES `tb_seller_orders` (`ID`) ON DELETE RESTRICT,
  CONSTRAINT `tb_shipments_chk_1` CHECK (((`delivered_date` is null) or (`shipped_date` is null) or (`delivered_date` >= `shipped_date`)))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
