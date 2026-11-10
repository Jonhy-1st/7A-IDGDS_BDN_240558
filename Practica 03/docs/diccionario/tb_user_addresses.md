<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_user_addresses`

Fuente: `240558_Respaldo_com_responsables_dbuser.sql`, líneas 1113–1123. SHA-256: `8242d2e7a82f3e2b2c326fda9989c7d676d061933ad43ad2e750a057d0e7a766`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 8.
- Filas encontradas en sentencias INSERT de este respaldo: 0.
- Claves primarias / índices: 1.
- Claves foráneas: 0.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `id` | `int` | No | `—` | PK; PRIMARY (id) | — | `&#96;id&#96; int NOT NULL AUTO_INCREMENT` |
| 2 | `user_id` | `int` | No | `—` | — | — | `&#96;user_id&#96; int NOT NULL` |
| 3 | `street` | `varchar(255)` | Sí | `NULL` | — | — | `&#96;street&#96; varchar(255) DEFAULT NULL` |
| 4 | `city` | `varchar(100)` | Sí | `NULL` | — | — | `&#96;city&#96; varchar(100) DEFAULT NULL` |
| 5 | `state` | `varchar(100)` | Sí | `NULL` | — | — | `&#96;state&#96; varchar(100) DEFAULT NULL` |
| 6 | `postal_code` | `varchar(20)` | Sí | `NULL` | — | — | `&#96;postal_code&#96; varchar(20) DEFAULT NULL` |
| 7 | `country` | `varchar(100)` | Sí | `NULL` | — | — | `&#96;country&#96; varchar(100) DEFAULT NULL` |
| 8 | `created_at` | `datetime` | Sí | `CURRENT_TIMESTAMP` | — | — | `&#96;created_at&#96; datetime DEFAULT CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `id`. DDL: `PRIMARY KEY (&#96;id&#96;)`

## Claves foráneas

- No se encontraron claves foráneas en el DDL.

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_user_addresses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `street` varchar(255) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
