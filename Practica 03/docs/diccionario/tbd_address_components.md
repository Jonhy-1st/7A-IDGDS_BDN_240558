<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbd_address_components`

Fuente: `240558_Respaldo_com_responsables_dbuser.sql`, líneas 1482–1488. SHA-256: `8242d2e7a82f3e2b2c326fda9989c7d676d061933ad43ad2e750a057d0e7a766`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 4.
- Filas encontradas en sentencias INSERT de este respaldo: 0.
- Claves primarias / índices: 1.
- Claves foráneas: 0.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `id` | `int` | No | `—` | PK; PRIMARY (id) | — | `&#96;id&#96; int NOT NULL AUTO_INCREMENT` |
| 2 | `user_address_id` | `int` | No | `—` | — | — | `&#96;user_address_id&#96; int NOT NULL` |
| 3 | `component_type` | `varchar(50)` | Sí | `NULL` | — | — | `&#96;component_type&#96; varchar(50) DEFAULT NULL` |
| 4 | `component_value` | `varchar(255)` | Sí | `NULL` | — | — | `&#96;component_value&#96; varchar(255) DEFAULT NULL` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `id`. DDL: `PRIMARY KEY (&#96;id&#96;)`

## Claves foráneas

- No se encontraron claves foráneas en el DDL.

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tbd_address_components` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_address_id` int NOT NULL,
  `component_type` varchar(50) DEFAULT NULL,
  `component_value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
