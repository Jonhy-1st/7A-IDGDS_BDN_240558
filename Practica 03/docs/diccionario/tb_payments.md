<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_payments`

Fuente: `respaldo_casos_compra_final.sql`, líneas 683–709. SHA-256: `52a7d987f2e3f92a75f419de00c360508cf3b3d385ec3f70bcf65815f435a783`.
## Para qué sirve

Representa un cobro, intento de cobro o cuota de un pedido. Guarda el importe, medio, estado, fechas y referencia al instrumento del cliente; sus eventos se registran en tb_payment_transactions.

Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 15.
- Filas encontradas en sentencias INSERT de este respaldo: 2.
- Claves primarias / índices: 5.
- Claves foráneas: 2.
- Restricciones CHECK: 2.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Para qué sirve | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|---|:---:|---|---|---|---|
| 1 | `ID` | Identificador único del registro. | `int unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `order_ID` | Identificador del pedido general al que pertenece el registro. order_ID enlaza con tb_buyer_orders.ID. | `int unsigned` | No | `—` | índice; FK; fk_payment_order → tb_buyer_orders(ID); idx_payments_order (order_ID) | — | `&#96;order_ID&#96; int unsigned NOT NULL` |
| 3 | `user_payment_method_ID` | Identificador del instrumento de pago guardado por el comprador. user_payment_method_ID enlaza con tbd_user_payment_methods.ID. | `bigint unsigned` | Sí | `NULL` | índice; FK; fk_payments_user_method → tbd_user_payment_methods(ID); idx_payments_user_method (user_payment_method_ID) | — | `&#96;user_payment_method_ID&#96; bigint unsigned DEFAULT NULL` |
| 4 | `amount` | Importe del pago, movimiento o reembolso. | `decimal(12,2)` | No | `—` | — | — | `&#96;amount&#96; decimal(12,2) NOT NULL` |
| 5 | `installment_number` | Número de esta cuota dentro del plan de pagos. | `smallint unsigned` | Sí | `NULL` | — | — | `&#96;installment_number&#96; smallint unsigned DEFAULT NULL` |
| 6 | `installment_count` | Cantidad total de cuotas del plan. | `smallint unsigned` | Sí | `NULL` | — | — | `&#96;installment_count&#96; smallint unsigned DEFAULT NULL` |
| 7 | `currency` | Moneda en la que se expresa el importe. | `char(3)` | No | `'MXN'` | — | — | `&#96;currency&#96; char(3) NOT NULL DEFAULT 'MXN'` |
| 8 | `payment_method` | Medio usado para intentar o realizar el pago. | `enum('Card','SPEI','Transfer','Cash','Other')` | No | `—` | — | — | `&#96;payment_method&#96; enum('Card','SPEI','Transfer','Cash','Other') NOT NULL` |
| 9 | `provider` | Proveedor del instrumento o del procesamiento de pago. | `varchar(50)` | Sí | `NULL` | UK; uk_payment_provider_reference (provider, provider_reference) | — | `&#96;provider&#96; varchar(50) DEFAULT NULL` |
| 10 | `provider_reference` | Referencia de la operación en el proveedor de pago. | `varchar(150)` | Sí | `NULL` | UK; uk_payment_provider_reference (provider, provider_reference) | — | `&#96;provider_reference&#96; varchar(150) DEFAULT NULL` |
| 11 | `idempotency_key` | Clave que evita registrar dos veces el mismo intento de pago. | `varchar(100)` | Sí | `NULL` | UK; uk_payment_idempotency (idempotency_key) | — | `&#96;idempotency_key&#96; varchar(100) DEFAULT NULL` |
| 12 | `payment_status` | Resultado o estado del cobro. | `enum('Pending','Authorized','Paid','Failed','Refunded','PartiallyRefunded')` | No | `'Pending'` | — | — | `&#96;payment_status&#96; enum('Pending','Authorized','Paid','Failed','Refunded','PartiallyRefunded') NOT NULL DEFAULT 'Pending'` |
| 13 | `creation_date` | Fecha y hora de creación del registro. | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 14 | `paid_date` | Fecha y hora en que se confirmó el pago. | `datetime` | Sí | `NULL` | — | — | `&#96;paid_date&#96; datetime DEFAULT NULL` |
| 15 | `last_update` | Fecha y hora de la última modificación. | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `uk_payment_provider_reference` (UNIQUE, UNIQUE): `provider, provider_reference`. DDL: `UNIQUE KEY &#96;uk_payment_provider_reference&#96; (&#96;provider&#96;,&#96;provider_reference&#96;)`
- `uk_payment_idempotency` (UNIQUE, UNIQUE): `idempotency_key`. DDL: `UNIQUE KEY &#96;uk_payment_idempotency&#96; (&#96;idempotency_key&#96;)`
- `idx_payments_order` (INDEX): `order_ID`. DDL: `KEY &#96;idx_payments_order&#96; (&#96;order_ID&#96;)`
- `idx_payments_user_method` (INDEX): `user_payment_method_ID`. DDL: `KEY &#96;idx_payments_user_method&#96; (&#96;user_payment_method_ID&#96;)`

## Claves foráneas

- `fk_payment_order`: (order_ID) → `tb_buyer_orders(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_payment_order&#96; FOREIGN KEY (&#96;order_ID&#96;) REFERENCES &#96;tb_buyer_orders&#96; (&#96;ID&#96;)`
- `fk_payments_user_method`: (user_payment_method_ID) → `tbd_user_payment_methods(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_payments_user_method&#96; FOREIGN KEY (&#96;user_payment_method_ID&#96;) REFERENCES &#96;tbd_user_payment_methods&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- `CONSTRAINT &#96;chk_payment_amount&#96; CHECK ((&#96;amount&#96; > 0))`
- `CONSTRAINT &#96;chk_payment_installment_pair&#96; CHECK (((&#96;installment_number&#96; is null and &#96;installment_count&#96; is null) or (&#96;installment_number&#96; is not null and &#96;installment_count&#96; is not null and &#96;installment_number&#96; > 0 and &#96;installment_count&#96; > 0 and &#96;installment_number&#96; <= &#96;installment_count&#96;)))`

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_payments` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `order_ID` int unsigned NOT NULL,
  `user_payment_method_ID` bigint unsigned DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL,
  `installment_number` smallint unsigned DEFAULT NULL,
  `installment_count` smallint unsigned DEFAULT NULL,
  `currency` char(3) NOT NULL DEFAULT 'MXN',
  `payment_method` enum('Card','SPEI','Transfer','Cash','Other') NOT NULL,
  `provider` varchar(50) DEFAULT NULL,
  `provider_reference` varchar(150) DEFAULT NULL,
  `idempotency_key` varchar(100) DEFAULT NULL,
  `payment_status` enum('Pending','Authorized','Paid','Failed','Refunded','PartiallyRefunded') NOT NULL DEFAULT 'Pending',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `paid_date` datetime DEFAULT NULL,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_payment_provider_reference` (`provider`,`provider_reference`),
  UNIQUE KEY `uk_payment_idempotency` (`idempotency_key`),
  KEY `idx_payments_order` (`order_ID`),
  KEY `idx_payments_user_method` (`user_payment_method_ID`),
  CONSTRAINT `fk_payment_order` FOREIGN KEY (`order_ID`) REFERENCES `tb_buyer_orders` (`ID`),
  CONSTRAINT `fk_payments_user_method` FOREIGN KEY (`user_payment_method_ID`) REFERENCES `tbd_user_payment_methods` (`ID`),
  CONSTRAINT `chk_payment_amount` CHECK ((`amount` > 0))
,
  CONSTRAINT `chk_payment_installment_pair` CHECK (((`installment_number` is null and `installment_count` is null) or (`installment_number` is not null and `installment_count` is not null and `installment_number` > 0 and `installment_count` > 0 and `installment_number` <= `installment_count`)))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
