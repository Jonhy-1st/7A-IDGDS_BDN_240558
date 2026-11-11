<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbd_return_items`

Fuente: `respaldo_compra_usuarios.sql`, líneas 3115–3122. SHA-256: `20eff15c9d28e69975c07c1fb29d265dd8527cefb43781d630567aca1c39e279`.
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
| 2 | `return_id` | `int` | No | `—` | — | — | `&#96;return_id&#96; int NOT NULL` |
| 3 | `order_item_id` | `int` | No | `—` | — | — | `&#96;order_item_id&#96; int NOT NULL` |
| 4 | `quantity` | `int` | No | `—` | — | — | `&#96;quantity&#96; int NOT NULL` |
| 5 | `condition_notes` | `text` | Sí | `—` | — | — | `&#96;condition_notes&#96; text` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `id`. DDL: `PRIMARY KEY (&#96;id&#96;)`

## Claves foráneas

- No se encontraron claves foráneas en el DDL.

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tbd_return_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `return_id` int NOT NULL,
  `order_item_id` int NOT NULL,
  `quantity` int NOT NULL,
  `condition_notes` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
