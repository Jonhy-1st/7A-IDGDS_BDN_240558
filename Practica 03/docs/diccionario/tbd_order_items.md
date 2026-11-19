<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbd_order_items`

Fuente: `respaldo_casos_compra_final.sql`, líneas 2646–2664. SHA-256: `99067eeb933614e493903c946b5c6f1faf8e214d9c69bc7ae5fa3180809e8010`.
## Para qué sirve

Guarda los artículos confirmados dentro de un pedido de vendedor, con el nombre y precio que tenían al comprarse. Conserva la cantidad original y registra aparte las unidades canceladas; el subtotal muestra solo las unidades vigentes.

Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 9.
- Filas encontradas en sentencias INSERT de este respaldo: 33.
- Claves primarias / índices: 3.
- Claves foráneas: 2.
- Restricciones CHECK: 3.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Para qué sirve | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|---|:---:|---|---|---|---|
| 1 | `ID` | Identificador único del registro. | `int unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `seller_order_ID` | Identificador de la parte del pedido que prepara un vendedor. seller_order_ID enlaza con tb_seller_orders.ID. | `int unsigned` | No | `—` | índice; FK; fk_order_item_seller_order → tb_seller_orders(ID); idx_order_items_seller_order (seller_order_ID) | — | `&#96;seller_order_ID&#96; int unsigned NOT NULL` |
| 3 | `product_offer_ID` | Identificador de la oferta del producto hecha por un vendedor. product_offer_ID enlaza con tbd_users_offer_products.product_offer_ID. | `int unsigned` | No | `—` | índice; FK; fk_order_item_offer → tbd_users_offer_products(product_offer_ID); idx_order_items_offer (product_offer_ID) | — | `&#96;product_offer_ID&#96; int unsigned NOT NULL` |
| 4 | `product_name` | Nombre del producto guardado al momento de la compra. | `varchar(250)` | No | `—` | — | — | `&#96;product_name&#96; varchar(250) NOT NULL` |
| 5 | `quantity` | Número de unidades del artículo, reclamación o cancelación. | `int unsigned` | No | `—` | — | — | `&#96;quantity&#96; int unsigned NOT NULL` |
| 6 | `cancelled_quantity` | Cantidad de unidades canceladas del renglón; se conserva la cantidad originalmente comprada. | `int unsigned` | No | `'0'` | — | — | `&#96;cancelled_quantity&#96; int unsigned NOT NULL DEFAULT '0'` |
| 7 | `unit_price` | Precio de una unidad guardado en el pedido. | `decimal(12,2)` | No | `—` | — | — | `&#96;unit_price&#96; decimal(12,2) NOT NULL` |
| 8 | `subtotal` | Importe parcial de los artículos o del pedido del vendedor. | `decimal(14,2)` | Sí | `—` | — | — | `&#96;subtotal&#96; decimal(14,2) GENERATED ALWAYS AS (((&#96;quantity&#96; - &#96;cancelled_quantity&#96;) * &#96;unit_price&#96;)) STORED` |
| 9 | `creation_date` | Fecha y hora de creación del registro. | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `idx_order_items_seller_order` (INDEX): `seller_order_ID`. DDL: `KEY &#96;idx_order_items_seller_order&#96; (&#96;seller_order_ID&#96;)`
- `idx_order_items_offer` (INDEX): `product_offer_ID`. DDL: `KEY &#96;idx_order_items_offer&#96; (&#96;product_offer_ID&#96;)`

## Claves foráneas

- `fk_order_item_offer`: (product_offer_ID) → `tbd_users_offer_products(product_offer_ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_order_item_offer&#96; FOREIGN KEY (&#96;product_offer_ID&#96;) REFERENCES &#96;tbd_users_offer_products&#96; (&#96;product_offer_ID&#96;)`
- `fk_order_item_seller_order`: (seller_order_ID) → `tb_seller_orders(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_order_item_seller_order&#96; FOREIGN KEY (&#96;seller_order_ID&#96;) REFERENCES &#96;tb_seller_orders&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- `CONSTRAINT &#96;chk_order_item_cancelled_quantity&#96; CHECK ((&#96;cancelled_quantity&#96; <= &#96;quantity&#96;))`
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
  `cancelled_quantity` int unsigned NOT NULL DEFAULT '0',
  `unit_price` decimal(12,2) NOT NULL,
  `subtotal` decimal(14,2) GENERATED ALWAYS AS (((`quantity` - `cancelled_quantity`) * `unit_price`)) STORED,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_order_items_seller_order` (`seller_order_ID`),
  KEY `idx_order_items_offer` (`product_offer_ID`),
  CONSTRAINT `fk_order_item_offer` FOREIGN KEY (`product_offer_ID`) REFERENCES `tbd_users_offer_products` (`product_offer_ID`),
  CONSTRAINT `fk_order_item_seller_order` FOREIGN KEY (`seller_order_ID`) REFERENCES `tb_seller_orders` (`ID`),
  CONSTRAINT `chk_order_item_cancelled_quantity` CHECK ((`cancelled_quantity` <= `quantity`)),
  CONSTRAINT `chk_order_item_price` CHECK ((`unit_price` >= 0)),
  CONSTRAINT `chk_order_item_quantity` CHECK ((`quantity` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
