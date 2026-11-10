<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_product_responsibility_mapping`

Fuente: `240558_Respaldo_com_responsables_dbuser.sql`, líneas 697–718. SHA-256: `8242d2e7a82f3e2b2c326fda9989c7d676d061933ad43ad2e750a057d0e7a766`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 11.
- Filas encontradas en sentencias INSERT de este respaldo: 15000.
- Claves primarias / índices: 5.
- Claves foráneas: 4.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `product_ID` | `int unsigned` | No | `—` | PK; FK; fk_responsibility_product → tb_products(ID); PRIMARY (product_ID) | — | `&#96;product_ID&#96; int unsigned NOT NULL` |
| 2 | `SKU` | `varchar(50)` | No | `—` | — | — | `&#96;SKU&#96; varchar(50) NOT NULL` |
| 3 | `product_name` | `varchar(255)` | No | `—` | — | — | `&#96;product_name&#96; varchar(255) NOT NULL` |
| 4 | `original_creator_db_user` | `varchar(80)` | No | `—` | índice; idx_responsibility_creator (original_creator_db_user) | — | `&#96;original_creator_db_user&#96; varchar(80) NOT NULL` |
| 5 | `original_creation_log_ID` | `int` | No | `—` | índice; FK; fk_responsibility_original_log → tb_logs(ID); fk_responsibility_original_log (original_creation_log_ID) | — | `&#96;original_creation_log_ID&#96; int NOT NULL` |
| 6 | `original_creation_date` | `datetime` | No | `—` | — | — | `&#96;original_creation_date&#96; datetime NOT NULL` |
| 7 | `new_owner_user_ID` | `int` | No | `—` | índice; FK; fk_responsibility_owner → tb_users(ID); idx_responsibility_owner (new_owner_user_ID) | — | `&#96;new_owner_user_ID&#96; int NOT NULL` |
| 8 | `new_owner_db_user` | `varchar(80)` | No | `—` | — | — | `&#96;new_owner_db_user&#96; varchar(80) NOT NULL` |
| 9 | `new_type_ownership` | `enum('Owner','Seller','Distributor')` | No | `—` | — | — | `&#96;new_type_ownership&#96; enum('Owner','Seller','Distributor') NOT NULL` |
| 10 | `reassignment_log_ID` | `int` | No | `—` | UK; FK; fk_responsibility_new_log → tb_logs(ID); uq_responsibility_log (reassignment_log_ID) | — | `&#96;reassignment_log_ID&#96; int NOT NULL` |
| 11 | `reassigned_at` | `datetime` | No | `—` | — | — | `&#96;reassigned_at&#96; datetime NOT NULL` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `product_ID`. DDL: `PRIMARY KEY (&#96;product_ID&#96;)`
- `uq_responsibility_log` (UNIQUE, UNIQUE): `reassignment_log_ID`. DDL: `UNIQUE KEY &#96;uq_responsibility_log&#96; (&#96;reassignment_log_ID&#96;)`
- `idx_responsibility_creator` (INDEX): `original_creator_db_user`. DDL: `KEY &#96;idx_responsibility_creator&#96; (&#96;original_creator_db_user&#96;)`
- `idx_responsibility_owner` (INDEX): `new_owner_user_ID`. DDL: `KEY &#96;idx_responsibility_owner&#96; (&#96;new_owner_user_ID&#96;)`
- `fk_responsibility_original_log` (INDEX): `original_creation_log_ID`. DDL: `KEY &#96;fk_responsibility_original_log&#96; (&#96;original_creation_log_ID&#96;)`

## Claves foráneas

- `fk_responsibility_new_log`: (reassignment_log_ID) → `tb_logs(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_responsibility_new_log&#96; FOREIGN KEY (&#96;reassignment_log_ID&#96;) REFERENCES &#96;tb_logs&#96; (&#96;ID&#96;)`
- `fk_responsibility_original_log`: (original_creation_log_ID) → `tb_logs(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_responsibility_original_log&#96; FOREIGN KEY (&#96;original_creation_log_ID&#96;) REFERENCES &#96;tb_logs&#96; (&#96;ID&#96;)`
- `fk_responsibility_owner`: (new_owner_user_ID) → `tb_users(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_responsibility_owner&#96; FOREIGN KEY (&#96;new_owner_user_ID&#96;) REFERENCES &#96;tb_users&#96; (&#96;ID&#96;)`
- `fk_responsibility_product`: (product_ID) → `tb_products(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_responsibility_product&#96; FOREIGN KEY (&#96;product_ID&#96;) REFERENCES &#96;tb_products&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_product_responsibility_mapping` (
  `product_ID` int unsigned NOT NULL,
  `SKU` varchar(50) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `original_creator_db_user` varchar(80) NOT NULL,
  `original_creation_log_ID` int NOT NULL,
  `original_creation_date` datetime NOT NULL,
  `new_owner_user_ID` int NOT NULL,
  `new_owner_db_user` varchar(80) NOT NULL,
  `new_type_ownership` enum('Owner','Seller','Distributor') NOT NULL,
  `reassignment_log_ID` int NOT NULL,
  `reassigned_at` datetime NOT NULL,
  PRIMARY KEY (`product_ID`),
  UNIQUE KEY `uq_responsibility_log` (`reassignment_log_ID`),
  KEY `idx_responsibility_creator` (`original_creator_db_user`),
  KEY `idx_responsibility_owner` (`new_owner_user_ID`),
  KEY `fk_responsibility_original_log` (`original_creation_log_ID`),
  CONSTRAINT `fk_responsibility_new_log` FOREIGN KEY (`reassignment_log_ID`) REFERENCES `tb_logs` (`ID`),
  CONSTRAINT `fk_responsibility_original_log` FOREIGN KEY (`original_creation_log_ID`) REFERENCES `tb_logs` (`ID`),
  CONSTRAINT `fk_responsibility_owner` FOREIGN KEY (`new_owner_user_ID`) REFERENCES `tb_users` (`ID`),
  CONSTRAINT `fk_responsibility_product` FOREIGN KEY (`product_ID`) REFERENCES `tb_products` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
