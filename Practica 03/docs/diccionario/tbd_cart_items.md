<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbd_cart_items`

Fuente: `respaldo_compra_usuarios.sql`, líneas 2484–2495. SHA-256: `20eff15c9d28e69975c07c1fb29d265dd8527cefb43781d630567aca1c39e279`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 5.
- Filas encontradas en sentencias INSERT de este respaldo: 10.
- Claves primarias / índices: 2.
- Claves foráneas: 2.
- Restricciones CHECK: 1.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `cart_ID` | `int unsigned` | No | `—` | PK; FK; fk_cart_item_cart → tb_carts(ID); PRIMARY (cart_ID, product_offer_ID) | — | `&#96;cart_ID&#96; int unsigned NOT NULL` |
| 2 | `product_offer_ID` | `int unsigned` | No | `—` | PK; índice; FK; fk_cart_item_offer → tbd_users_offer_products(product_offer_ID); PRIMARY (cart_ID, product_offer_ID); idx_cart_item_offer (product_offer_ID) | — | `&#96;product_offer_ID&#96; int unsigned NOT NULL` |
| 3 | `quantity` | `int unsigned` | No | `'1'` | — | — | `&#96;quantity&#96; int unsigned NOT NULL DEFAULT '1'` |
| 4 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 5 | `last_update` | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `cart_ID, product_offer_ID`. DDL: `PRIMARY KEY (&#96;cart_ID&#96;,&#96;product_offer_ID&#96;)`
- `idx_cart_item_offer` (INDEX): `product_offer_ID`. DDL: `KEY &#96;idx_cart_item_offer&#96; (&#96;product_offer_ID&#96;)`

## Claves foráneas

- `fk_cart_item_cart`: (cart_ID) → `tb_carts(ID)`; ON DELETE CASCADE; ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_cart_item_cart&#96; FOREIGN KEY (&#96;cart_ID&#96;) REFERENCES &#96;tb_carts&#96; (&#96;ID&#96;) ON DELETE CASCADE`
- `fk_cart_item_offer`: (product_offer_ID) → `tbd_users_offer_products(product_offer_ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_cart_item_offer&#96; FOREIGN KEY (&#96;product_offer_ID&#96;) REFERENCES &#96;tbd_users_offer_products&#96; (&#96;product_offer_ID&#96;)`

## Restricciones CHECK

- `CONSTRAINT &#96;chk_cart_item_quantity&#96; CHECK ((&#96;quantity&#96; > 0))`

## Definición SQL de la tabla

```sql
CREATE TABLE `tbd_cart_items` (
  `cart_ID` int unsigned NOT NULL,
  `product_offer_ID` int unsigned NOT NULL,
  `quantity` int unsigned NOT NULL DEFAULT '1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`cart_ID`,`product_offer_ID`),
  KEY `idx_cart_item_offer` (`product_offer_ID`),
  CONSTRAINT `fk_cart_item_cart` FOREIGN KEY (`cart_ID`) REFERENCES `tb_carts` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `fk_cart_item_offer` FOREIGN KEY (`product_offer_ID`) REFERENCES `tbd_users_offer_products` (`product_offer_ID`),
  CONSTRAINT `chk_cart_item_quantity` CHECK ((`quantity` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
