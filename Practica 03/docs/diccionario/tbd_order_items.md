<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbd_order_items`

Fuente: `240558_Respaldo_com_responsables_dbuser.sql`, líneas 1721–1733. SHA-256: `8242d2e7a82f3e2b2c326fda9989c7d676d061933ad43ad2e750a057d0e7a766`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 6.
- Filas encontradas en sentencias INSERT de este respaldo: 0.
- Claves primarias / índices: 2.
- Claves foráneas: 1.
- Restricciones CHECK: 2.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `order_ID` | `int unsigned` | No | `—` | PK; FK; fk_order_item_order → tb_orders(ID); PRIMARY (order_ID, product_offer_ID) | — | `&#96;order_ID&#96; int unsigned NOT NULL` |
| 2 | `product_offer_ID` | `int unsigned` | No | `—` | PK; índice; PRIMARY (order_ID, product_offer_ID); fk_order_item_offer (product_offer_ID) | — | `&#96;product_offer_ID&#96; int unsigned NOT NULL` |
| 3 | `quantity` | `int unsigned` | No | `'1'` | — | — | `&#96;quantity&#96; int unsigned NOT NULL DEFAULT '1'` |
| 4 | `unit_price` | `decimal(12,2)` | No | `—` | — | — | `&#96;unit_price&#96; decimal(12,2) NOT NULL` |
| 5 | `line_total` | `decimal(12,2)` | Sí | `—` | — | — | `&#96;line_total&#96; decimal(12,2) GENERATED ALWAYS AS ((&#96;quantity&#96; * &#96;unit_price&#96;)) STORED` |
| 6 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `order_ID, product_offer_ID`. DDL: `PRIMARY KEY (&#96;order_ID&#96;,&#96;product_offer_ID&#96;)`
- `fk_order_item_offer` (INDEX): `product_offer_ID`. DDL: `KEY &#96;fk_order_item_offer&#96; (&#96;product_offer_ID&#96;)`

## Claves foráneas

- `fk_order_item_order`: (order_ID) → `tb_orders(ID)`; ON DELETE CASCADE; ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_order_item_order&#96; FOREIGN KEY (&#96;order_ID&#96;) REFERENCES &#96;tb_orders&#96; (&#96;ID&#96;) ON DELETE CASCADE`

## Restricciones CHECK

- `CONSTRAINT &#96;chk_order_item_price&#96; CHECK ((&#96;unit_price&#96; >= 0))`
- `CONSTRAINT &#96;chk_order_item_quantity&#96; CHECK ((&#96;quantity&#96; > 0))`

## Definición SQL de la tabla

```sql
CREATE TABLE `tbd_order_items` (
  `order_ID` int unsigned NOT NULL,
  `product_offer_ID` int unsigned NOT NULL,
  `quantity` int unsigned NOT NULL DEFAULT '1',
  `unit_price` decimal(12,2) NOT NULL,
  `line_total` decimal(12,2) GENERATED ALWAYS AS ((`quantity` * `unit_price`)) STORED,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_ID`,`product_offer_ID`),
  KEY `fk_order_item_offer` (`product_offer_ID`),
  CONSTRAINT `fk_order_item_order` FOREIGN KEY (`order_ID`) REFERENCES `tb_orders` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `chk_order_item_price` CHECK ((`unit_price` >= 0)),
  CONSTRAINT `chk_order_item_quantity` CHECK ((`quantity` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
