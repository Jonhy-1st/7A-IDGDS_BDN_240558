<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbd_users_offer_products`

Fuente: `respaldo_casos_compra_final.sql`, líneas 3311–3324. SHA-256: `52a7d987f2e3f92a75f419de00c360508cf3b3d385ec3f70bcf65815f435a783`.
## Para qué sirve

Representa la oferta de un producto hecha por un vendedor: quién lo vende, qué producto ofrece, cuántas unidades tiene y si la oferta está activa. Los carritos y pedidos apuntan a esta oferta.

Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 8.
- Filas encontradas en sentencias INSERT de este respaldo: 5.
- Claves primarias / índices: 3.
- Claves foráneas: 1.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Para qué sirve | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|---|:---:|---|---|---|---|
| 1 | `product_offer_ID` | Identificador de la oferta del producto hecha por un vendedor. | `int unsigned` | No | `—` | PK; PRIMARY (product_offer_ID) | — | `&#96;product_offer_ID&#96; int unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `user_ID` | Identificador de la cuenta relacionada. | `int unsigned` | Sí | `NULL` | índice; fk_user_1 (user_ID) | — | `&#96;user_ID&#96; int unsigned DEFAULT NULL` |
| 3 | `product_ID` | Identificador del producto del catálogo. product_ID enlaza con tb_products.ID. | `int unsigned` | No | `—` | índice; FK; fk_product_2 → tb_products(ID); fk_product_2 (product_ID) | — | `&#96;product_ID&#96; int unsigned NOT NULL` |
| 4 | `available_stock` | Existencia asignada a la oferta del vendedor. | `int` | No | `'1'` | — | — | `&#96;available_stock&#96; int NOT NULL DEFAULT '1'` |
| 5 | `status` | Indica si el registro está habilitado o activo. | `bit(1)` | No | `b` | — | — | `&#96;status&#96; bit(1) NOT NULL DEFAULT b'1'` |
| 6 | `creation_date` | Fecha y hora de creación del registro. | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 7 | `available_date` | Fecha desde la que la oferta está disponible. | `datetime` | Sí | `NULL` | — | — | `&#96;available_date&#96; datetime DEFAULT NULL` |
| 8 | `last_update` | Fecha y hora de la última modificación. | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `product_offer_ID`. DDL: `PRIMARY KEY (&#96;product_offer_ID&#96;)`
- `fk_user_1` (INDEX): `user_ID`. DDL: `KEY &#96;fk_user_1&#96; (&#96;user_ID&#96;)`
- `fk_product_2` (INDEX): `product_ID`. DDL: `KEY &#96;fk_product_2&#96; (&#96;product_ID&#96;)`

## Claves foráneas

- `fk_product_2`: (product_ID) → `tb_products(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_product_2&#96; FOREIGN KEY (&#96;product_ID&#96;) REFERENCES &#96;tb_products&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tbd_users_offer_products` (
  `product_offer_ID` int unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` int unsigned DEFAULT NULL,
  `product_ID` int unsigned NOT NULL,
  `available_stock` int NOT NULL DEFAULT '1',
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `available_date` datetime DEFAULT NULL,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`product_offer_ID`),
  KEY `fk_user_1` (`user_ID`),
  KEY `fk_product_2` (`product_ID`),
  CONSTRAINT `fk_product_2` FOREIGN KEY (`product_ID`) REFERENCES `tb_products` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
