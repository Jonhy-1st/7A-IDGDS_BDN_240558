<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbd_cart_items`

Fuente: `240558_Respaldo_com_responsables_dbuser.sql`, líneas 1641–1648. SHA-256: `8242d2e7a82f3e2b2c326fda9989c7d676d061933ad43ad2e750a057d0e7a766`.
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
| 1 | `id` | `int` | No | `—` | PK; PRIMARY (id) | — | `&#96;id&#96; int NOT NULL AUTO_INCREMENT` |
| 2 | `cart_id` | `int` | No | `—` | — | — | `&#96;cart_id&#96; int NOT NULL` |
| 3 | `product_id` | `int` | No | `—` | — | — | `&#96;product_id&#96; int NOT NULL` |
| 4 | `quantity` | `int` | No | `'1'` | — | — | `&#96;quantity&#96; int NOT NULL DEFAULT '1'` |
| 5 | `added_at` | `datetime` | Sí | `CURRENT_TIMESTAMP` | — | — | `&#96;added_at&#96; datetime DEFAULT CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `id`. DDL: `PRIMARY KEY (&#96;id&#96;)`

## Claves foráneas

- No se encontraron claves foráneas en el DDL.

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tbd_cart_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cart_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `added_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
