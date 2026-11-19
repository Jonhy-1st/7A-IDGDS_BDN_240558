<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_payment_transactions`

Fuente: `respaldo_casos_compra_final.sql`, líneas 514–527. SHA-256: `99067eeb933614e493903c946b5c6f1faf8e214d9c69bc7ae5fa3180809e8010`.
## Para qué sirve

Guarda cada evento de un cobro o devolución, por ejemplo creación, autorización, captura, rechazo o reembolso. Cada evento pertenece a un registro de tb_payments.

Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 7.
- Filas encontradas en sentencias INSERT de este respaldo: 36.
- Claves primarias / índices: 3.
- Claves foráneas: 1.
- Restricciones CHECK: 1.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Para qué sirve | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|---|:---:|---|---|---|---|
| 1 | `ID` | Identificador único del registro. | `int unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `payment_ID` | Identificador del pago asociado. payment_ID enlaza con tb_payments.ID. | `int unsigned` | No | `—` | índice; FK; fk_payment_transaction_payment → tb_payments(ID); idx_payment_transactions_payment (payment_ID) | — | `&#96;payment_ID&#96; int unsigned NOT NULL` |
| 3 | `event_type` | Tipo de evento del historial de pago. | `enum('Created','Authorized','Captured','Failed','Refunded','PartiallyRefunded','Voided')` | No | `—` | — | — | `&#96;event_type&#96; enum('Created','Authorized','Captured','Failed','Refunded','PartiallyRefunded','Voided') NOT NULL` |
| 4 | `amount` | Importe del pago, movimiento o reembolso. | `decimal(12,2)` | No | `'0.00'` | — | — | `&#96;amount&#96; decimal(12,2) NOT NULL DEFAULT '0.00'` |
| 5 | `event_reference` | Referencia externa o interna del evento. | `varchar(150)` | Sí | `NULL` | UK; uk_payment_event_reference (event_reference) | — | `&#96;event_reference&#96; varchar(150) DEFAULT NULL` |
| 6 | `remarks` | Nota adicional sobre el evento. | `text` | Sí | `—` | — | — | `&#96;remarks&#96; text` |
| 7 | `creation_date` | Fecha y hora de creación del registro. | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `uk_payment_event_reference` (UNIQUE, UNIQUE): `event_reference`. DDL: `UNIQUE KEY &#96;uk_payment_event_reference&#96; (&#96;event_reference&#96;)`
- `idx_payment_transactions_payment` (INDEX): `payment_ID`. DDL: `KEY &#96;idx_payment_transactions_payment&#96; (&#96;payment_ID&#96;)`

## Claves foráneas

- `fk_payment_transaction_payment`: (payment_ID) → `tb_payments(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_payment_transaction_payment&#96; FOREIGN KEY (&#96;payment_ID&#96;) REFERENCES &#96;tb_payments&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- `CONSTRAINT &#96;chk_payment_transaction_amount&#96; CHECK ((&#96;amount&#96; >= 0))`

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_payment_transactions` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `payment_ID` int unsigned NOT NULL,
  `event_type` enum('Created','Authorized','Captured','Failed','Refunded','PartiallyRefunded','Voided') NOT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `event_reference` varchar(150) DEFAULT NULL,
  `remarks` text,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_payment_event_reference` (`event_reference`),
  KEY `idx_payment_transactions_payment` (`payment_ID`),
  CONSTRAINT `fk_payment_transaction_payment` FOREIGN KEY (`payment_ID`) REFERENCES `tb_payments` (`ID`),
  CONSTRAINT `chk_payment_transaction_amount` CHECK ((`amount` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
