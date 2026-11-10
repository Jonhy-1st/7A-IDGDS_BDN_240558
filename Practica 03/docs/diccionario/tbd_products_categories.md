<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbd_products_categories`

Fuente: `240558_Respaldo_com_responsables_dbuser.sql`, líneas 1797–1807. SHA-256: `8242d2e7a82f3e2b2c326fda9989c7d676d061933ad43ad2e750a057d0e7a766`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 5.
- Filas encontradas en sentencias INSERT de este respaldo: 0.
- Claves primarias / índices: 2.
- Claves foráneas: 2.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `category_ID` | `int unsigned` | No | `—` | PK; FK; fk_category → tbc_categories(ID); PRIMARY (category_ID, product_ID) | — | `&#96;category_ID&#96; int unsigned NOT NULL` |
| 2 | `product_ID` | `int unsigned` | No | `—` | PK; índice; FK; fk_product → tb_products(ID); PRIMARY (category_ID, product_ID); fk_product (product_ID) | — | `&#96;product_ID&#96; int unsigned NOT NULL` |
| 3 | `status` | `bit(1)` | No | `b` | — | — | `&#96;status&#96; bit(1) NOT NULL DEFAULT b'1'` |
| 4 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 5 | `last_update` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;last_update&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP` |

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
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`category_ID`,`product_ID`),
  KEY `fk_product` (`product_ID`),
  CONSTRAINT `fk_category` FOREIGN KEY (`category_ID`) REFERENCES `tbc_categories` (`ID`),
  CONSTRAINT `fk_product` FOREIGN KEY (`product_ID`) REFERENCES `tb_products` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
