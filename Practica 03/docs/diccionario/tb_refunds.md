<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_refunds`

Fuente: `240558_Respaldo_com_responsables_dbuser.sql`, líneas 828–853. SHA-256: `8242d2e7a82f3e2b2c326fda9989c7d676d061933ad43ad2e750a057d0e7a766`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 13.
- Filas encontradas en sentencias INSERT de este respaldo: 0.
- Claves primarias / índices: 6.
- Claves foráneas: 3.
- Restricciones CHECK: 2.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `refund_ID` | `bigint unsigned` | No | `—` | PK; PRIMARY (refund_ID) | — | `&#96;refund_ID&#96; bigint unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `payment_ID` | `int unsigned` | No | `—` | índice; FK; fk_refund_payment → tb_payments(ID); idx_refund_payment (payment_ID) | — | `&#96;payment_ID&#96; int unsigned NOT NULL` |
| 3 | `cancellation_ID` | `bigint unsigned` | Sí | `NULL` | índice; FK; fk_refund_cancellation → tb_order_cancellations(cancellation_ID); fk_refund_cancellation (cancellation_ID) | — | `&#96;cancellation_ID&#96; bigint unsigned DEFAULT NULL` |
| 4 | `return_ID` | `bigint unsigned` | Sí | `NULL` | índice; FK; fk_refund_return → tb_returns(return_ID); fk_refund_return (return_ID) | — | `&#96;return_ID&#96; bigint unsigned DEFAULT NULL` |
| 5 | `amount` | `decimal(12,2)` | No | `—` | — | — | `&#96;amount&#96; decimal(12,2) NOT NULL` |
| 6 | `currency` | `char(3)` | No | `'MXN'` | — | — | `&#96;currency&#96; char(3) NOT NULL DEFAULT 'MXN'` |
| 7 | `refund_reason` | `varchar(500)` | Sí | `NULL` | — | — | `&#96;refund_reason&#96; varchar(500) DEFAULT NULL` |
| 8 | `refund_status` | `enum('Requested','Approved','Processing','Completed','Failed','Rejected')` | No | `'Requested'` | índice; idx_refund_status (refund_status) | — | `&#96;refund_status&#96; enum('Requested','Approved','Processing','Completed','Failed','Rejected') NOT NULL DEFAULT 'Requested'` |
| 9 | `provider_reference` | `varchar(150)` | Sí | `NULL` | UK; uk_refund_provider_reference (provider_reference) | — | `&#96;provider_reference&#96; varchar(150) DEFAULT NULL` |
| 10 | `requested_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;requested_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 11 | `completed_date` | `datetime` | Sí | `NULL` | — | — | `&#96;completed_date&#96; datetime DEFAULT NULL` |
| 12 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 13 | `last_update` | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `refund_ID`. DDL: `PRIMARY KEY (&#96;refund_ID&#96;)`
- `uk_refund_provider_reference` (UNIQUE, UNIQUE): `provider_reference`. DDL: `UNIQUE KEY &#96;uk_refund_provider_reference&#96; (&#96;provider_reference&#96;)`
- `idx_refund_payment` (INDEX): `payment_ID`. DDL: `KEY &#96;idx_refund_payment&#96; (&#96;payment_ID&#96;)`
- `idx_refund_status` (INDEX): `refund_status`. DDL: `KEY &#96;idx_refund_status&#96; (&#96;refund_status&#96;)`
- `fk_refund_cancellation` (INDEX): `cancellation_ID`. DDL: `KEY &#96;fk_refund_cancellation&#96; (&#96;cancellation_ID&#96;)`
- `fk_refund_return` (INDEX): `return_ID`. DDL: `KEY &#96;fk_refund_return&#96; (&#96;return_ID&#96;)`

## Claves foráneas

- `fk_refund_cancellation`: (cancellation_ID) → `tb_order_cancellations(cancellation_ID)`; ON DELETE RESTRICT; ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_refund_cancellation&#96; FOREIGN KEY (&#96;cancellation_ID&#96;) REFERENCES &#96;tb_order_cancellations&#96; (&#96;cancellation_ID&#96;) ON DELETE RESTRICT`
- `fk_refund_payment`: (payment_ID) → `tb_payments(ID)`; ON DELETE RESTRICT; ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_refund_payment&#96; FOREIGN KEY (&#96;payment_ID&#96;) REFERENCES &#96;tb_payments&#96; (&#96;ID&#96;) ON DELETE RESTRICT`
- `fk_refund_return`: (return_ID) → `tb_returns(return_ID)`; ON DELETE RESTRICT; ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_refund_return&#96; FOREIGN KEY (&#96;return_ID&#96;) REFERENCES &#96;tb_returns&#96; (&#96;return_ID&#96;) ON DELETE RESTRICT`

## Restricciones CHECK

- `CONSTRAINT &#96;tb_refunds_chk_1&#96; CHECK ((&#96;amount&#96; > 0))`
- `CONSTRAINT &#96;tb_refunds_chk_2&#96; CHECK (((&#96;cancellation_ID&#96; is not null) or (&#96;return_ID&#96; is not null)))`

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_refunds` (
  `refund_ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `payment_ID` int unsigned NOT NULL,
  `cancellation_ID` bigint unsigned DEFAULT NULL,
  `return_ID` bigint unsigned DEFAULT NULL,
  `amount` decimal(12,2) NOT NULL,
  `currency` char(3) NOT NULL DEFAULT 'MXN',
  `refund_reason` varchar(500) DEFAULT NULL,
  `refund_status` enum('Requested','Approved','Processing','Completed','Failed','Rejected') NOT NULL DEFAULT 'Requested',
  `provider_reference` varchar(150) DEFAULT NULL,
  `requested_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_date` datetime DEFAULT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`refund_ID`),
  UNIQUE KEY `uk_refund_provider_reference` (`provider_reference`),
  KEY `idx_refund_payment` (`payment_ID`),
  KEY `idx_refund_status` (`refund_status`),
  KEY `fk_refund_cancellation` (`cancellation_ID`),
  KEY `fk_refund_return` (`return_ID`),
  CONSTRAINT `fk_refund_cancellation` FOREIGN KEY (`cancellation_ID`) REFERENCES `tb_order_cancellations` (`cancellation_ID`) ON DELETE RESTRICT,
  CONSTRAINT `fk_refund_payment` FOREIGN KEY (`payment_ID`) REFERENCES `tb_payments` (`ID`) ON DELETE RESTRICT,
  CONSTRAINT `fk_refund_return` FOREIGN KEY (`return_ID`) REFERENCES `tb_returns` (`return_ID`) ON DELETE RESTRICT,
  CONSTRAINT `tb_refunds_chk_1` CHECK ((`amount` > 0)),
  CONSTRAINT `tb_refunds_chk_2` CHECK (((`cancellation_ID` is not null) or (`return_ID` is not null)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
