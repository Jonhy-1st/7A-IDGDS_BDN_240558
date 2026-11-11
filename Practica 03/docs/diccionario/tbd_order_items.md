<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbd_order_items`

Fuente: `respaldo_compra_usuarios.sql`, líneas 2631–2647. SHA-256: `20eff15c9d28e69975c07c1fb29d265dd8527cefb43781d630567aca1c39e279`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 8.
- Filas encontradas en sentencias INSERT de este respaldo: 10.
- Claves primarias / índices: 3.
- Claves foráneas: 2.
- Restricciones CHECK: 2.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `ID` | `int unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `seller_order_ID` | `int unsigned` | No | `—` | índice; FK; fk_order_item_seller_order → tb_seller_orders(ID); idx_order_items_seller_order (seller_order_ID) | — | `&#96;seller_order_ID&#96; int unsigned NOT NULL` |
| 3 | `product_offer_ID` | `int unsigned` | No | `—` | índice; FK; fk_order_item_offer → tbd_users_offer_products(product_offer_ID); idx_order_items_offer (product_offer_ID) | — | `&#96;product_offer_ID&#96; int unsigned NOT NULL` |
| 4 | `product_name` | `varchar(250)` | No | `—` | — | — | `&#96;product_name&#96; varchar(250) NOT NULL` |
| 5 | `quantity` | `int unsigned` | No | `—` | — | — | `&#96;quantity&#96; int unsigned NOT NULL` |
| 6 | `unit_price` | `decimal(12,2)` | No | `—` | — | — | `&#96;unit_price&#96; decimal(12,2) NOT NULL` |
| 7 | `subtotal` | `decimal(14,2)` | Sí | `—` | — | — | `&#96;subtotal&#96; decimal(14,2) GENERATED ALWAYS AS ((&#96;quantity&#96; * &#96;unit_price&#96;)) STORED` |
| 8 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `idx_order_items_seller_order` (INDEX): `seller_order_ID`. DDL: `KEY &#96;idx_order_items_seller_order&#96; (&#96;seller_order_ID&#96;)`
- `idx_order_items_offer` (INDEX): `product_offer_ID`. DDL: `KEY &#96;idx_order_items_offer&#96; (&#96;product_offer_ID&#96;)`

## Claves foráneas

- `fk_order_item_offer`: (product_offer_ID) → `tbd_users_offer_products(product_offer_ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_order_item_offer&#96; FOREIGN KEY (&#96;product_offer_ID&#96;) REFERENCES &#96;tbd_users_offer_products&#96; (&#96;product_offer_ID&#96;)`
- `fk_order_item_seller_order`: (seller_order_ID) → `tb_seller_orders(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_order_item_seller_order&#96; FOREIGN KEY (&#96;seller_order_ID&#96;) REFERENCES &#96;tb_seller_orders&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- `CONSTRAINT &#96;chk_order_item_price&#96; CHECK ((&#96;unit_price&#96; >= 0))`
- `CONSTRAINT &#96;chk_order_item_quantity&#96; CHECK ((&#96;quantity&#96; > 0))`

## Definición SQL de la tabla

```sql
CREATE TABLE `tbd_order_items` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `seller_order_ID` int unsigned NOT NULL,
  `product_offer_ID` int unsigned NOT NULL,
  `product_name` varchar(250) NOT NULL,
  `quantity` int unsigned NOT NULL,
  `unit_price` decimal(12,2) NOT NULL,
  `subtotal` decimal(14,2) GENERATED ALWAYS AS ((`quantity` * `unit_price`)) STORED,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_order_items_seller_order` (`seller_order_ID`),
  KEY `idx_order_items_offer` (`product_offer_ID`),
  CONSTRAINT `fk_order_item_offer` FOREIGN KEY (`product_offer_ID`) REFERENCES `tbd_users_offer_products` (`product_offer_ID`),
  CONSTRAINT `fk_order_item_seller_order` FOREIGN KEY (`seller_order_ID`) REFERENCES `tb_seller_orders` (`ID`),
  CONSTRAINT `chk_order_item_price` CHECK ((`unit_price` >= 0)),
  CONSTRAINT `chk_order_item_quantity` CHECK ((`quantity` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
