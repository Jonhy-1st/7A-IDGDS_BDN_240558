<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbd_users_wishlist_products`

Fuente: `240558_Respaldo_com_responsables_dbuser.sql`, líneas 2140–2147. SHA-256: `8242d2e7a82f3e2b2c326fda9989c7d676d061933ad43ad2e750a057d0e7a766`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 5.
- Filas encontradas en sentencias INSERT de este respaldo: 0.
- Claves primarias / índices: 1.
- Claves foráneas: 0.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `user_id` | `int unsigned` | No | `—` | PK; PRIMARY (user_id, product_id) | — | `&#96;user_id&#96; int unsigned NOT NULL` |
| 2 | `product_id` | `int unsigned` | No | `—` | PK; PRIMARY (user_id, product_id) | — | `&#96;product_id&#96; int unsigned NOT NULL` |
| 3 | `is_active` | `bit(1)` | No | `b` | — | — | `&#96;is_active&#96; bit(1) NOT NULL DEFAULT b'1'` |
| 4 | `created_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;created_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 5 | `updated_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;updated_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `user_id, product_id`. DDL: `PRIMARY KEY (&#96;user_id&#96;,&#96;product_id&#96;)`

## Claves foráneas

- No se encontraron claves foráneas en el DDL.

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tbd_users_wishlist_products` (
  `user_id` int unsigned NOT NULL,
  `product_id` int unsigned NOT NULL,
  `is_active` bit(1) NOT NULL DEFAULT b'1',
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
