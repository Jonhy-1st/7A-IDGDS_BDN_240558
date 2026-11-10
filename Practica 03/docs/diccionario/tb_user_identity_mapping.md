<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_user_identity_mapping`

Fuente: `240558_Respaldo_com_responsables_dbuser.sql`, líneas 1196–1210. SHA-256: `8242d2e7a82f3e2b2c326fda9989c7d676d061933ad43ad2e750a057d0e7a766`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 9.
- Filas encontradas en sentencias INSERT de este respaldo: 7.
- Claves primarias / índices: 3.
- Claves foráneas: 1.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `mapping_ID` | `int` | No | `—` | PK; PRIMARY (mapping_ID) | — | `&#96;mapping_ID&#96; int NOT NULL AUTO_INCREMENT` |
| 2 | `proxy_user_ID` | `int` | No | `—` | UK; FK; fk_identity_proxy_user → tb_users(ID); uq_identity_proxy_user (proxy_user_ID) | — | `&#96;proxy_user_ID&#96; int NOT NULL` |
| 3 | `remote_login` | `varchar(80)` | No | `—` | UK; uq_identity_remote_login (remote_login) | — | `&#96;remote_login&#96; varchar(80) NOT NULL` |
| 4 | `remote_host` | `varchar(60)` | No | `—` | — | — | `&#96;remote_host&#96; varchar(60) NOT NULL` |
| 5 | `remote_role` | `varchar(40)` | No | `—` | — | — | `&#96;remote_role&#96; varchar(40) NOT NULL` |
| 6 | `proxy_email` | `varchar(80)` | No | `—` | — | — | `&#96;proxy_email&#96; varchar(80) NOT NULL` |
| 7 | `proxy_nick` | `varchar(100)` | No | `—` | — | — | `&#96;proxy_nick&#96; varchar(100) NOT NULL` |
| 8 | `can_login` | `tinyint(1)` | No | `'0'` | — | — | `&#96;can_login&#96; tinyint(1) NOT NULL DEFAULT '0'` |
| 9 | `notes` | `varchar(255)` | Sí | `NULL` | — | — | `&#96;notes&#96; varchar(255) DEFAULT NULL` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `mapping_ID`. DDL: `PRIMARY KEY (&#96;mapping_ID&#96;)`
- `uq_identity_proxy_user` (UNIQUE, UNIQUE): `proxy_user_ID`. DDL: `UNIQUE KEY &#96;uq_identity_proxy_user&#96; (&#96;proxy_user_ID&#96;)`
- `uq_identity_remote_login` (UNIQUE, UNIQUE): `remote_login`. DDL: `UNIQUE KEY &#96;uq_identity_remote_login&#96; (&#96;remote_login&#96;)`

## Claves foráneas

- `fk_identity_proxy_user`: (proxy_user_ID) → `tb_users(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_identity_proxy_user&#96; FOREIGN KEY (&#96;proxy_user_ID&#96;) REFERENCES &#96;tb_users&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_user_identity_mapping` (
  `mapping_ID` int NOT NULL AUTO_INCREMENT,
  `proxy_user_ID` int NOT NULL,
  `remote_login` varchar(80) NOT NULL,
  `remote_host` varchar(60) NOT NULL,
  `remote_role` varchar(40) NOT NULL,
  `proxy_email` varchar(80) NOT NULL,
  `proxy_nick` varchar(100) NOT NULL,
  `can_login` tinyint(1) NOT NULL DEFAULT '0',
  `notes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`mapping_ID`),
  UNIQUE KEY `uq_identity_proxy_user` (`proxy_user_ID`),
  UNIQUE KEY `uq_identity_remote_login` (`remote_login`),
  CONSTRAINT `fk_identity_proxy_user` FOREIGN KEY (`proxy_user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
