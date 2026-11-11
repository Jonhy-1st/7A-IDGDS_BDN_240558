<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_payments`

Fuente: `respaldo_compra_usuarios.sql`, líneas 678–700. SHA-256: `20eff15c9d28e69975c07c1fb29d265dd8527cefb43781d630567aca1c39e279`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 13.
- Filas encontradas en sentencias INSERT de este respaldo: 2.
- Claves primarias / índices: 5.
- Claves foráneas: 2.
- Restricciones CHECK: 1.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `ID` | `int unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `order_ID` | `int unsigned` | No | `—` | índice; FK; fk_payment_order → tb_buyer_orders(ID); idx_payments_order (order_ID) | — | `&#96;order_ID&#96; int unsigned NOT NULL` |
| 3 | `user_payment_method_ID` | `bigint unsigned` | Sí | `NULL` | índice; FK; fk_payments_user_method → tbd_user_payment_methods(ID); idx_payments_user_method (user_payment_method_ID) | — | `&#96;user_payment_method_ID&#96; bigint unsigned DEFAULT NULL` |
| 4 | `amount` | `decimal(12,2)` | No | `—` | — | — | `&#96;amount&#96; decimal(12,2) NOT NULL` |
| 5 | `currency` | `char(3)` | No | `'MXN'` | — | — | `&#96;currency&#96; char(3) NOT NULL DEFAULT 'MXN'` |
| 6 | `payment_method` | `enum('Card','SPEI','Transfer','Cash','Other')` | No | `—` | — | — | `&#96;payment_method&#96; enum('Card','SPEI','Transfer','Cash','Other') NOT NULL` |
| 7 | `provider` | `varchar(50)` | Sí | `NULL` | UK; uk_payment_provider_reference (provider, provider_reference) | — | `&#96;provider&#96; varchar(50) DEFAULT NULL` |
| 8 | `provider_reference` | `varchar(150)` | Sí | `NULL` | UK; uk_payment_provider_reference (provider, provider_reference) | — | `&#96;provider_reference&#96; varchar(150) DEFAULT NULL` |
| 9 | `idempotency_key` | `varchar(100)` | Sí | `NULL` | UK; uk_payment_idempotency (idempotency_key) | — | `&#96;idempotency_key&#96; varchar(100) DEFAULT NULL` |
| 10 | `payment_status` | `enum('Pending','Authorized','Paid','Failed','Refunded','PartiallyRefunded')` | No | `'Pending'` | — | — | `&#96;payment_status&#96; enum('Pending','Authorized','Paid','Failed','Refunded','PartiallyRefunded') NOT NULL DEFAULT 'Pending'` |
| 11 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 12 | `paid_date` | `datetime` | Sí | `NULL` | — | — | `&#96;paid_date&#96; datetime DEFAULT NULL` |
| 13 | `last_update` | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

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

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_payments` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `order_ID` int unsigned NOT NULL,
  `user_payment_method_ID` bigint unsigned DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
