<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_user_addresses`

Fuente: `respaldo_compra_usuarios.sql`, líneas 1678–1697. SHA-256: `20eff15c9d28e69975c07c1fb29d265dd8527cefb43781d630567aca1c39e279`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 12.
- Filas encontradas en sentencias INSERT de este respaldo: 2.
- Claves primarias / índices: 2.
- Claves foráneas: 1.
- Restricciones CHECK: 3.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `ID` | `bigint unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; bigint unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `user_ID` | `int` | No | `—` | índice; FK; fk_addresses_users → tb_users(ID); idx_user_addresses (user_ID) | — | `&#96;user_ID&#96; int NOT NULL` |
| 3 | `address_label` | `varchar(100)` | No | `—` | — | — | `&#96;address_label&#96; varchar(100) NOT NULL` |
| 4 | `recipient_name` | `varchar(150)` | Sí | `NULL` | — | — | `&#96;recipient_name&#96; varchar(150) DEFAULT NULL` |
| 5 | `recipient_phone` | `varchar(25)` | Sí | `NULL` | — | — | `&#96;recipient_phone&#96; varchar(25) DEFAULT NULL` |
| 6 | `delivery_instructions` | `varchar(500)` | Sí | `NULL` | — | — | `&#96;delivery_instructions&#96; varchar(500) DEFAULT NULL` |
| 7 | `latitude` | `decimal(10,7)` | Sí | `NULL` | — | — | `&#96;latitude&#96; decimal(10,7) DEFAULT NULL` |
| 8 | `longitude` | `decimal(10,7)` | Sí | `NULL` | — | — | `&#96;longitude&#96; decimal(10,7) DEFAULT NULL` |
| 9 | `is_default` | `tinyint(1)` | No | `'0'` | — | — | `&#96;is_default&#96; tinyint(1) NOT NULL DEFAULT '0'` |
| 10 | `status` | `bit(1)` | No | `b` | — | — | `&#96;status&#96; bit(1) NOT NULL DEFAULT b'1'` |
| 11 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 12 | `last_update` | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `idx_user_addresses` (INDEX): `user_ID`. DDL: `KEY &#96;idx_user_addresses&#96; (&#96;user_ID&#96;)`

## Claves foráneas

- `fk_addresses_users`: (user_ID) → `tb_users(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_addresses_users&#96; FOREIGN KEY (&#96;user_ID&#96;) REFERENCES &#96;tb_users&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- `CONSTRAINT &#96;chk_coordinates&#96; CHECK ((((&#96;latitude&#96; is null) and (&#96;longitude&#96; is null)) or ((&#96;latitude&#96; is not null) and (&#96;longitude&#96; is not null))))`
- `CONSTRAINT &#96;chk_latitude&#96; CHECK ((&#96;latitude&#96; between -(90) and 90))`
- `CONSTRAINT &#96;chk_longitude&#96; CHECK ((&#96;longitude&#96; between -(180) and 180))`

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_user_addresses` (
  `ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` int NOT NULL,
  `address_label` varchar(100) NOT NULL,
  `recipient_name` varchar(150) DEFAULT NULL,
  `recipient_phone` varchar(25) DEFAULT NULL,
  `delivery_instructions` varchar(500) DEFAULT NULL,
  `latitude` decimal(10,7) DEFAULT NULL,
  `longitude` decimal(10,7) DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  KEY `idx_user_addresses` (`user_ID`),
  CONSTRAINT `fk_addresses_users` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`),
  CONSTRAINT `chk_coordinates` CHECK ((((`latitude` is null) and (`longitude` is null)) or ((`latitude` is not null) and (`longitude` is not null)))),
  CONSTRAINT `chk_latitude` CHECK ((`latitude` between -(90) and 90)),
  CONSTRAINT `chk_longitude` CHECK ((`longitude` between -(180) and 180))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
