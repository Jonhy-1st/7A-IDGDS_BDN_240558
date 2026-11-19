<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbc_payment_methods_types_res`

Fuente: `respaldo_casos_compra_final.sql`, líneas 2251–2257. SHA-256: `99067eeb933614e493903c946b5c6f1faf8e214d9c69bc7ae5fa3180809e8010`.
## Para qué sirve

Es un catálogo auxiliar de tipos de medio de pago utilizado por el esquema anterior. Sus nombres y descripciones son referencias de catálogo; el modelo actual de instrumentos usa tbc_payment_methods_types.

Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 4.
- Filas encontradas en sentencias INSERT de este respaldo: 0.
- Claves primarias / índices: 1.
- Claves foráneas: 0.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Para qué sirve | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|---|:---:|---|---|---|---|
| 1 | `id` | Identificador único del registro. | `int` | No | `—` | PK; PRIMARY (id) | — | `&#96;id&#96; int NOT NULL AUTO_INCREMENT` |
| 2 | `name` | Nombre del elemento; puede ser un producto, categoría o tipo de pago según la tabla. | `varchar(100)` | No | `—` | — | — | `&#96;name&#96; varchar(100) NOT NULL` |
| 3 | `description` | Texto que explica el elemento del catálogo o registro. | `text` | Sí | `—` | — | — | `&#96;description&#96; text` |
| 4 | `is_active` | Indica si el elemento del catálogo está activo. | `tinyint(1)` | Sí | `'1'` | — | — | `&#96;is_active&#96; tinyint(1) DEFAULT '1'` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `id`. DDL: `PRIMARY KEY (&#96;id&#96;)`

## Claves foráneas

- No se encontraron claves foráneas en el DDL.

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tbc_payment_methods_types_res` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
