<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbd_wishlist_products`

Fuente: `Respaldo_Practica4.sql`, líneas 3474–3482. SHA-256: `ed941c888be8bd17d759acbcec9824ba173ad4094795d47012b7cc702bdf3880`.
## Para qué sirve

Relaciona los productos que una persona desea guardar para después. Vincula la cuenta con el producto y evita confundir la lista de deseos con el carrito de compra.

Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 3.
- Filas encontradas en sentencias INSERT de este respaldo: 0.
- Claves primarias / índices: 2.
- Claves foráneas: 2.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Para qué sirve | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|---|:---:|---|---|---|---|
| 1 | `user_ID` | Identificador de la cuenta relacionada. user_ID enlaza con tb_users.ID. | `int` | No | `—` | PK; FK; fk_wishlist_user → tb_users(ID); PRIMARY (user_ID, product_ID) | — | `&#96;user_ID&#96; int NOT NULL` |
| 2 | `product_ID` | Identificador del producto del catálogo. product_ID enlaza con tb_products.ID. | `int unsigned` | No | `—` | PK; índice; FK; fk_wishlist_product → tb_products(ID); PRIMARY (user_ID, product_ID); idx_wishlist_product (product_ID) | — | `&#96;product_ID&#96; int unsigned NOT NULL` |
| 3 | `creation_date` | Fecha y hora de creación del registro. | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `user_ID, product_ID`. DDL: `PRIMARY KEY (&#96;user_ID&#96;,&#96;product_ID&#96;)`
- `idx_wishlist_product` (INDEX): `product_ID`. DDL: `KEY &#96;idx_wishlist_product&#96; (&#96;product_ID&#96;)`

## Claves foráneas

- `fk_wishlist_product`: (product_ID) → `tb_products(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_wishlist_product&#96; FOREIGN KEY (&#96;product_ID&#96;) REFERENCES &#96;tb_products&#96; (&#96;ID&#96;)`
- `fk_wishlist_user`: (user_ID) → `tb_users(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_wishlist_user&#96; FOREIGN KEY (&#96;user_ID&#96;) REFERENCES &#96;tb_users&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tbd_wishlist_products` (
  `user_ID` int NOT NULL,
  `product_ID` int unsigned NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_ID`,`product_ID`),
  KEY `idx_wishlist_product` (`product_ID`),
  CONSTRAINT `fk_wishlist_product` FOREIGN KEY (`product_ID`) REFERENCES `tb_products` (`ID`),
  CONSTRAINT `fk_wishlist_user` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
