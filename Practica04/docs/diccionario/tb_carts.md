<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_carts`

Fuente: `Respaldo_240558_final.sql`, líneas 220–231. SHA-256: `8b5679bd4606df2a2f9e6f461eeaac2ee6b93f0101e36ef72d645c0f0a5e7df1`.
## Para qué sirve

Guarda los carritos de cada persona antes de confirmar una compra. El estado distingue el carrito activo, convertido o abandonado; la columna calculada permite varios carritos históricos y limita a uno activo por usuario. Los productos están en tbd_cart_items.

Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 6.
- Filas encontradas en sentencias INSERT de este respaldo: 8.
- Claves primarias / índices: 3.
- Claves foráneas: 1.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Para qué sirve | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|---|:---:|---|---|---|---|
| 1 | `ID` | Identificador único del registro. | `int unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `user_ID` | Identificador de la cuenta relacionada. user_ID enlaza con tb_users.ID. | `int` | No | `—` | índice; FK; fk_cart_user → tb_users(ID); idx_carts_user (user_ID) | — | `&#96;user_ID&#96; int NOT NULL` |
| 3 | `status` | Indica si el registro está habilitado o activo. | `enum('Active','Converted','Abandoned')` | No | `'Active'` | — | — | `&#96;status&#96; enum('Active','Converted','Abandoned') NOT NULL DEFAULT 'Active'` |
| 4 | `active_user_ID` | Identificador calculado del usuario mientras el carrito está activo; queda vacío para carritos cerrados. | `int` | Sí | `—` | UK; uk_cart_active_user (active_user_ID) | — | `&#96;active_user_ID&#96; int GENERATED ALWAYS AS ((case when (&#96;status&#96; = _utf8mb4'Active') then &#96;user_ID&#96; else NULL end)) STORED` |
| 5 | `creation_date` | Fecha y hora de creación del registro. | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 6 | `last_update` | Fecha y hora de la última modificación. | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `uk_cart_active_user` (UNIQUE, UNIQUE): `active_user_ID`. DDL: `UNIQUE KEY &#96;uk_cart_active_user&#96; (&#96;active_user_ID&#96;)`
- `idx_carts_user` (INDEX): `user_ID`. DDL: `KEY &#96;idx_carts_user&#96; (&#96;user_ID&#96;)`

## Claves foráneas

- `fk_cart_user`: (user_ID) → `tb_users(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_cart_user&#96; FOREIGN KEY (&#96;user_ID&#96;) REFERENCES &#96;tb_users&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_carts` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` int NOT NULL,
  `status` enum('Active','Converted','Abandoned') NOT NULL DEFAULT 'Active',
  `active_user_ID` int GENERATED ALWAYS AS ((case when (`status` = _utf8mb4'Active') then `user_ID` else NULL end)) STORED,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_cart_active_user` (`active_user_ID`),
  KEY `idx_carts_user` (`user_ID`),
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
