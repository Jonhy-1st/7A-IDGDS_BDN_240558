<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbd_cancellation_items`

Fuente: `respaldo_casos_compra_final.sql`, líneas 2418–2425. SHA-256: `99067eeb933614e493903c946b5c6f1faf8e214d9c69bc7ae5fa3180809e8010`.
## Para qué sirve

Detalla qué renglones y cantidades se solicitan cancelar dentro de una solicitud de tb_order_cancellations. Permite calcular el ajuste y el reembolso usando el precio guardado en tbd_order_items.

Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 5.
- Filas encontradas en sentencias INSERT de este respaldo: 1.
- Claves primarias / índices: 1.
- Claves foráneas: 0.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Para qué sirve | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|---|:---:|---|---|---|---|
| 1 | `id` | Identificador único del registro. | `int` | No | `—` | PK; PRIMARY (id) | — | `&#96;id&#96; int NOT NULL AUTO_INCREMENT` |
| 2 | `cancellation_id` | Identificador de la solicitud de cancelación relacionada. | `int` | No | `—` | — | — | `&#96;cancellation_id&#96; int NOT NULL` |
| 3 | `order_item_id` | Identificador del artículo original del pedido. | `int` | No | `—` | — | — | `&#96;order_item_id&#96; int NOT NULL` |
| 4 | `quantity` | Número de unidades del artículo, reclamación o cancelación. | `int` | No | `—` | — | — | `&#96;quantity&#96; int NOT NULL` |
| 5 | `reason` | Motivo de la cancelación o nota asociada. | `varchar(255)` | Sí | `NULL` | — | — | `&#96;reason&#96; varchar(255) DEFAULT NULL` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `id`. DDL: `PRIMARY KEY (&#96;id&#96;)`

## Claves foráneas

- No se encontraron claves foráneas en el DDL.

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tbd_cancellation_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cancellation_id` int NOT NULL,
  `order_item_id` int NOT NULL,
  `quantity` int NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
