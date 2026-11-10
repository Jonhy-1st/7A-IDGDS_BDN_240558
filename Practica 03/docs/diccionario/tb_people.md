<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_people`

Fuente: `240558_Respaldo_com_responsables_dbuser.sql`, líneas 574–590. SHA-256: `8242d2e7a82f3e2b2c326fda9989c7d676d061933ad43ad2e750a057d0e7a766`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 12.
- Filas encontradas en sentencias INSERT de este respaldo: 2.
- Claves primarias / índices: 2.
- Claves foráneas: 1.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `person_ID` | `bigint unsigned` | No | `—` | PK; PRIMARY (person_ID) | — | `&#96;person_ID&#96; bigint unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `user_ID` | `int` | No | `—` | UK; FK; fk_persons_user → tb_users(ID); uk_persons_user (user_ID) | — | `&#96;user_ID&#96; int NOT NULL` |
| 3 | `courtesy_title` | `varchar(50)` | Sí | `NULL` | — | — | `&#96;courtesy_title&#96; varchar(50) DEFAULT NULL` |
| 4 | `given_names` | `varchar(150)` | No | `—` | — | — | `&#96;given_names&#96; varchar(150) NOT NULL` |
| 5 | `family_names` | `varchar(150)` | Sí | `NULL` | — | — | `&#96;family_names&#96; varchar(150) DEFAULT NULL` |
| 6 | `birth_date` | `date` | Sí | `NULL` | — | — | `&#96;birth_date&#96; date DEFAULT NULL` |
| 7 | `gender_ID` | `tinyint unsigned` | Sí | `NULL` | — | — | `&#96;gender_ID&#96; tinyint unsigned DEFAULT NULL` |
| 8 | `country_code` | `char(2)` | Sí | `NULL` | — | — | `&#96;country_code&#96; char(2) DEFAULT NULL` |
| 9 | `phone` | `varchar(25)` | Sí | `NULL` | — | — | `&#96;phone&#96; varchar(25) DEFAULT NULL` |
| 10 | `status` | `bit(1)` | No | `b` | — | — | `&#96;status&#96; bit(1) NOT NULL DEFAULT b'1'` |
| 11 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 12 | `last_update` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;last_update&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `person_ID`. DDL: `PRIMARY KEY (&#96;person_ID&#96;)`
- `uk_persons_user` (UNIQUE, UNIQUE): `user_ID`. DDL: `UNIQUE KEY &#96;uk_persons_user&#96; (&#96;user_ID&#96;)`

## Claves foráneas

- `fk_persons_user`: (user_ID) → `tb_users(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_persons_user&#96; FOREIGN KEY (&#96;user_ID&#96;) REFERENCES &#96;tb_users&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_people` (
  `person_ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` int NOT NULL,
  `courtesy_title` varchar(50) DEFAULT NULL,
  `given_names` varchar(150) NOT NULL,
  `family_names` varchar(150) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `gender_ID` tinyint unsigned DEFAULT NULL,
  `country_code` char(2) DEFAULT NULL,
  `phone` varchar(25) DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`person_ID`),
  UNIQUE KEY `uk_persons_user` (`user_ID`),
  CONSTRAINT `fk_persons_user` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
