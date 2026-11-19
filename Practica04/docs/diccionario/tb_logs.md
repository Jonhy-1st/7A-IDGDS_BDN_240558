<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_logs`

Fuente: `Respaldo_Practica4.sql`, líneas 371–382. SHA-256: `ed941c888be8bd17d759acbcec9824ba173ad4094795d47012b7cc702bdf3880`.
## Para qué sirve

Conserva la bitácora de acciones hechas sobre la base, como altas, cambios y bajas. Guarda la tabla afectada, la cuenta de conexión, la fecha y una descripción para poder rastrear operaciones.

Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 9.
- Filas encontradas en sentencias INSERT de este respaldo: 63970.
- Claves primarias / índices: 1.
- Claves foráneas: 0.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=63971 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Para qué sirve | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|---|:---:|---|---|---|---|
| 1 | `ID` | Identificador único del registro. | `int` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int NOT NULL AUTO_INCREMENT` |
| 2 | `table_name` | Nombre de la tabla afectada. | `varchar(100)` | No | `—` | — | — | `&#96;table_name&#96; varchar(100) NOT NULL` |
| 3 | `table_operation` | Tipo de acción hecha sobre la tabla. | `enum('Create','Read','Update','Delete')` | No | `—` | — | — | `&#96;table_operation&#96; enum('Create','Read','Update','Delete') NOT NULL` |
| 4 | `db_user` | Cuenta de base de datos que realizó la acción. | `varchar(80)` | No | `—` | — | — | `&#96;db_user&#96; varchar(80) NOT NULL` |
| 5 | `description` | Texto que explica el elemento del catálogo o registro. | `text` | Sí | `—` | — | — | `&#96;description&#96; text` |
| 6 | `operation_date` | Fecha y hora en que se registró la acción. | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;operation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 7 | `operation_status` | Resultado o estado de la acción registrada. | `bit(1)` | Sí | `b` | — | — | `&#96;operation_status&#96; bit(1) DEFAULT b'1'` |
| 8 | `source_table_operation` | Tabla de origen asociada con la acción. | `enum('INSERT','UPDATE','DELETE')` | Sí | `NULL` | — | — | `&#96;source_table_operation&#96; enum('INSERT','UPDATE','DELETE') DEFAULT NULL` |
| 9 | `operation_description` | Explicación de la acción registrada. | `text` | Sí | `—` | — | — | `&#96;operation_description&#96; text` |

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
) ENGINE=InnoDB AUTO_INCREMENT=63971 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
