<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbd_products_users_providers`

Fuente: `240558_Respaldo_com_responsables_dbuser.sql`, líneas 1880–1892. SHA-256: `8242d2e7a82f3e2b2c326fda9989c7d676d061933ad43ad2e750a057d0e7a766`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 7.
- Filas encontradas en sentencias INSERT de este respaldo: 15000.
- Claves primarias / índices: 2.
- Claves foráneas: 2.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `user_ID` | `int` | No | `—` | PK; FK; fk_user1 → tb_users(ID); PRIMARY (user_ID, product_ID) | — | `&#96;user_ID&#96; int NOT NULL` |
| 2 | `product_ID` | `int unsigned` | No | `—` | PK; índice; FK; fk_products2 → tb_products(ID); PRIMARY (user_ID, product_ID); fk_products2 (product_ID) | — | `&#96;product_ID&#96; int unsigned NOT NULL` |
| 3 | `type_ownership` | `enum('Owner','Seller','Distributor')` | Sí | `NULL` | — | — | `&#96;type_ownership&#96; enum('Owner','Seller','Distributor') DEFAULT NULL` |
| 4 | `status` | `bit(1)` | No | `b` | — | — | `&#96;status&#96; bit(1) NOT NULL DEFAULT b'1'` |
| 5 | `available_date` | `datetime` | No | `—` | — | — | `&#96;available_date&#96; datetime NOT NULL` |
| 6 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 7 | `last_update` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;last_update&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `user_ID, product_ID`. DDL: `PRIMARY KEY (&#96;user_ID&#96;,&#96;product_ID&#96;)`
- `fk_products2` (INDEX): `product_ID`. DDL: `KEY &#96;fk_products2&#96; (&#96;product_ID&#96;)`

## Claves foráneas

- `fk_products2`: (product_ID) → `tb_products(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_products2&#96; FOREIGN KEY (&#96;product_ID&#96;) REFERENCES &#96;tb_products&#96; (&#96;ID&#96;)`
- `fk_user1`: (user_ID) → `tb_users(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_user1&#96; FOREIGN KEY (&#96;user_ID&#96;) REFERENCES &#96;tb_users&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tbd_products_users_providers` (
  `user_ID` int NOT NULL,
  `product_ID` int unsigned NOT NULL,
  `type_ownership` enum('Owner','Seller','Distributor') DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `available_date` datetime NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_ID`,`product_ID`),
  KEY `fk_products2` (`product_ID`),
  CONSTRAINT `fk_products2` FOREIGN KEY (`product_ID`) REFERENCES `tb_products` (`ID`),
  CONSTRAINT `fk_user1` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
