<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbd_products_categories`

Fuente: `respaldo_casos_compra_final.sql`, líneas 3000–3010. SHA-256: `52a7d987f2e3f92a75f419de00c360508cf3b3d385ec3f70bcf65815f435a783`.
## Para qué sirve

Asocia productos del catálogo con sus categorías. Es una relación de muchos a muchos entre tb_products y tbc_categories.

Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 5.
- Filas encontradas en sentencias INSERT de este respaldo: 9544.
- Claves primarias / índices: 2.
- Claves foráneas: 2.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Para qué sirve | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|---|:---:|---|---|---|---|
| 1 | `category_ID` | Identificador de la categoría relacionada. category_ID enlaza con tbc_categories.ID. | `int unsigned` | No | `—` | PK; FK; fk_category → tbc_categories(ID); PRIMARY (category_ID, product_ID) | — | `&#96;category_ID&#96; int unsigned NOT NULL` |
| 2 | `product_ID` | Identificador del producto del catálogo. product_ID enlaza con tb_products.ID. | `int unsigned` | No | `—` | PK; índice; FK; fk_product → tb_products(ID); PRIMARY (category_ID, product_ID); fk_product (product_ID) | — | `&#96;product_ID&#96; int unsigned NOT NULL` |
| 3 | `status` | Indica si el registro está habilitado o activo. | `bit(1)` | No | `b` | — | — | `&#96;status&#96; bit(1) NOT NULL DEFAULT b'1'` |
| 4 | `creation_date` | Fecha y hora de creación del registro. | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 5 | `last_update` | Fecha y hora de la última modificación. | `datetime` | No | `—` | — | — | `&#96;last_update&#96; datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `category_ID, product_ID`. DDL: `PRIMARY KEY (&#96;category_ID&#96;,&#96;product_ID&#96;)`
- `fk_product` (INDEX): `product_ID`. DDL: `KEY &#96;fk_product&#96; (&#96;product_ID&#96;)`

## Claves foráneas

- `fk_category`: (category_ID) → `tbc_categories(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_category&#96; FOREIGN KEY (&#96;category_ID&#96;) REFERENCES &#96;tbc_categories&#96; (&#96;ID&#96;)`
- `fk_product`: (product_ID) → `tb_products(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_product&#96; FOREIGN KEY (&#96;product_ID&#96;) REFERENCES &#96;tb_products&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tbd_products_categories` (
  `category_ID` int unsigned NOT NULL,
  `product_ID` int unsigned NOT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_ID`,`product_ID`),
  KEY `fk_product` (`product_ID`),
  CONSTRAINT `fk_category` FOREIGN KEY (`category_ID`) REFERENCES `tbc_categories` (`ID`),
  CONSTRAINT `fk_product` FOREIGN KEY (`product_ID`) REFERENCES `tb_products` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
