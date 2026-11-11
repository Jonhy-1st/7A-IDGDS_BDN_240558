<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_logs`

Fuente: `respaldo_compra_usuarios.sql`, líneas 377–388. SHA-256: `20eff15c9d28e69975c07c1fb29d265dd8527cefb43781d630567aca1c39e279`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 9.
- Filas encontradas en sentencias INSERT de este respaldo: 48775.
- Claves primarias / índices: 1.
- Claves foráneas: 0.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=48776 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `ID` | `int` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int NOT NULL AUTO_INCREMENT` |
| 2 | `table_name` | `varchar(100)` | No | `—` | — | — | `&#96;table_name&#96; varchar(100) NOT NULL` |
| 3 | `table_operation` | `enum('Create','Read','Update','Delete')` | No | `—` | — | — | `&#96;table_operation&#96; enum('Create','Read','Update','Delete') NOT NULL` |
| 4 | `db_user` | `varchar(80)` | No | `—` | — | — | `&#96;db_user&#96; varchar(80) NOT NULL` |
| 5 | `description` | `text` | Sí | `—` | — | — | `&#96;description&#96; text` |
| 6 | `operation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;operation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 7 | `operation_status` | `bit(1)` | Sí | `b` | — | — | `&#96;operation_status&#96; bit(1) DEFAULT b'1'` |
| 8 | `source_table_operation` | `enum('INSERT','UPDATE','DELETE')` | Sí | `NULL` | — | — | `&#96;source_table_operation&#96; enum('INSERT','UPDATE','DELETE') DEFAULT NULL` |
| 9 | `operation_description` | `text` | Sí | `—` | — | — | `&#96;operation_description&#96; text` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`

## Claves foráneas

- No se encontraron claves foráneas en el DDL.

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_logs` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `table_name` varchar(100) NOT NULL,
  `table_operation` enum('Create','Read','Update','Delete') NOT NULL,
  `db_user` varchar(80) NOT NULL,
  `description` text,
  `operation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `operation_status` bit(1) DEFAULT b'1',
  `source_table_operation` enum('INSERT','UPDATE','DELETE') DEFAULT NULL,
  `operation_description` text,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=48776 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
