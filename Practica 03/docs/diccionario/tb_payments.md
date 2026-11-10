<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_payments`

Fuente: `240558_Respaldo_com_responsables_dbuser.sql`, líneas 488–510. SHA-256: `8242d2e7a82f3e2b2c326fda9989c7d676d061933ad43ad2e750a057d0e7a766`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 12.
- Filas encontradas en sentencias INSERT de este respaldo: 0.
- Claves primarias / índices: 6.
- Claves foráneas: 2.
- Restricciones CHECK: 1.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `ID` | `int unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `order_ID` | `int unsigned` | No | `—` | índice; FK; fk_payment_order → tb_orders(ID); idx_payment_order (order_ID) | — | `&#96;order_ID&#96; int unsigned NOT NULL` |
| 3 | `payment_method_ID` | `int unsigned` | No | `—` | índice; FK; fk_payment_method → tb_payment_methods(ID); fk_payment_method (payment_method_ID) | — | `&#96;payment_method_ID&#96; int unsigned NOT NULL` |
| 4 | `user_payment_method_ID` | `int unsigned` | Sí | `NULL` | índice; fk_payment_user_method (user_payment_method_ID) | — | `&#96;user_payment_method_ID&#96; int unsigned DEFAULT NULL` |
| 5 | `amount` | `decimal(12,2)` | No | `—` | — | — | `&#96;amount&#96; decimal(12,2) NOT NULL` |
| 6 | `currency` | `char(3)` | No | `'MXN'` | — | — | `&#96;currency&#96; char(3) NOT NULL DEFAULT 'MXN'` |
| 7 | `payment_status` | `enum('pending','authorized','completed','failed','refunded','cancelled')` | No | `'pending'` | índice; idx_payment_status (payment_status) | — | `&#96;payment_status&#96; enum('pending','authorized','completed','failed','refunded','cancelled') NOT NULL DEFAULT 'pending'` |
| 8 | `transaction_reference` | `varchar(100)` | Sí | `NULL` | UK; uq_payment_reference (transaction_reference) | — | `&#96;transaction_reference&#96; varchar(100) DEFAULT NULL` |
| 9 | `failure_reason` | `varchar(255)` | Sí | `NULL` | — | — | `&#96;failure_reason&#96; varchar(255) DEFAULT NULL` |
| 10 | `paid_date` | `datetime` | Sí | `NULL` | — | — | `&#96;paid_date&#96; datetime DEFAULT NULL` |
| 11 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 12 | `last_update` | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `uq_payment_reference` (UNIQUE, UNIQUE): `transaction_reference`. DDL: `UNIQUE KEY &#96;uq_payment_reference&#96; (&#96;transaction_reference&#96;)`
- `idx_payment_order` (INDEX): `order_ID`. DDL: `KEY &#96;idx_payment_order&#96; (&#96;order_ID&#96;)`
- `idx_payment_status` (INDEX): `payment_status`. DDL: `KEY &#96;idx_payment_status&#96; (&#96;payment_status&#96;)`
- `fk_payment_method` (INDEX): `payment_method_ID`. DDL: `KEY &#96;fk_payment_method&#96; (&#96;payment_method_ID&#96;)`
- `fk_payment_user_method` (INDEX): `user_payment_method_ID`. DDL: `KEY &#96;fk_payment_user_method&#96; (&#96;user_payment_method_ID&#96;)`

## Claves foráneas

- `fk_payment_method`: (payment_method_ID) → `tb_payment_methods(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_payment_method&#96; FOREIGN KEY (&#96;payment_method_ID&#96;) REFERENCES &#96;tb_payment_methods&#96; (&#96;ID&#96;)`
- `fk_payment_order`: (order_ID) → `tb_orders(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_payment_order&#96; FOREIGN KEY (&#96;order_ID&#96;) REFERENCES &#96;tb_orders&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- `CONSTRAINT &#96;chk_payment_amount&#96; CHECK ((&#96;amount&#96; > 0))`

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_payments` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `order_ID` int unsigned NOT NULL,
  `payment_method_ID` int unsigned NOT NULL,
  `user_payment_method_ID` int unsigned DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` char(3) NOT NULL DEFAULT 'MXN',
  `payment_status` enum('pending','authorized','completed','failed','refunded','cancelled') NOT NULL DEFAULT 'pending',
  `transaction_reference` varchar(100) DEFAULT NULL,
  `failure_reason` varchar(255) DEFAULT NULL,
  `paid_date` datetime DEFAULT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uq_payment_reference` (`transaction_reference`),
  KEY `idx_payment_order` (`order_ID`),
  KEY `idx_payment_status` (`payment_status`),
  KEY `fk_payment_method` (`payment_method_ID`),
  KEY `fk_payment_user_method` (`user_payment_method_ID`),
  CONSTRAINT `fk_payment_method` FOREIGN KEY (`payment_method_ID`) REFERENCES `tb_payment_methods` (`ID`),
  CONSTRAINT `fk_payment_order` FOREIGN KEY (`order_ID`) REFERENCES `tb_orders` (`ID`),
  CONSTRAINT `chk_payment_amount` CHECK ((`amount` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
