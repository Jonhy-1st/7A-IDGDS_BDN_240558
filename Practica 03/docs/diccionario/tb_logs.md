<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_logs`

Fuente: `240558_Respaldo_com_responsables_dbuser.sql`, líneas 196–208. SHA-256: `8242d2e7a82f3e2b2c326fda9989c7d676d061933ad43ad2e750a057d0e7a766`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 8.
- Filas encontradas en sentencias INSERT de este respaldo: 50543.
- Claves primarias / índices: 3.
- Claves foráneas: 0.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=50577 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `ID` | `int` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int NOT NULL AUTO_INCREMENT` |
| 2 | `table_name` | `varchar(100)` | No | `—` | — | — | `&#96;table_name&#96; varchar(100) NOT NULL` |
| 3 | `table_operation` | `enum('INSERT','UPDATE','DELETE')` | Sí | `NULL` | — | — | `&#96;table_operation&#96; enum('INSERT','UPDATE','DELETE') DEFAULT NULL` |
| 4 | `operation` | `enum('Create','Read','Update','Delete')` | No | `—` | — | — | `&#96;operation&#96; enum('Create','Read','Update','Delete') NOT NULL` |
| 5 | `db_user` | `varchar(80)` | No | `—` | — | — | `&#96;db_user&#96; varchar(80) NOT NULL` |
| 6 | `operation_description` | `text` | No | `—` | — | — | `&#96;operation_description&#96; text NOT NULL` |
| 7 | `operation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | índice; idx_logs_operation_date (operation_date); idx_tb_logs_operation_date (operation_date) | — | `&#96;operation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 8 | `operation_status` | `bit(1)` | Sí | `b` | — | — | `&#96;operation_status&#96; bit(1) DEFAULT b'1'` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `idx_logs_operation_date` (INDEX): `operation_date`. DDL: `KEY &#96;idx_logs_operation_date&#96; (&#96;operation_date&#96;)`
- `idx_tb_logs_operation_date` (INDEX): `operation_date`. DDL: `KEY &#96;idx_tb_logs_operation_date&#96; (&#96;operation_date&#96;)`

## Claves foráneas

- No se encontraron claves foráneas en el DDL.

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_logs` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `table_name` varchar(100) NOT NULL,
  `table_operation` enum('INSERT','UPDATE','DELETE') DEFAULT NULL,
  `operation` enum('Create','Read','Update','Delete') NOT NULL,
  `db_user` varchar(80) NOT NULL,
  `operation_description` text NOT NULL,
  `operation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `operation_status` bit(1) DEFAULT b'1',
  PRIMARY KEY (`ID`),
  KEY `idx_logs_operation_date` (`operation_date`),
  KEY `idx_tb_logs_operation_date` (`operation_date`)
) ENGINE=InnoDB AUTO_INCREMENT=50577 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
