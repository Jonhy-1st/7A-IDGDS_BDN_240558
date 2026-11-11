<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbd_user_payment_methods`

Fuente: `respaldo_compra_usuarios.sql`, líneas 3195–3213. SHA-256: `20eff15c9d28e69975c07c1fb29d265dd8527cefb43781d630567aca1c39e279`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 11.
- Filas encontradas en sentencias INSERT de este respaldo: 2.
- Claves primarias / índices: 4.
- Claves foráneas: 2.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `ID` | `bigint unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; bigint unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `user_ID` | `int` | No | `—` | índice; FK; tbd_user_payment_methods_ibfk_1 → tb_users(ID); user_ID (user_ID) | — | `&#96;user_ID&#96; int NOT NULL` |
| 3 | `payment_method_type_ID` | `int unsigned` | No | `—` | índice; FK; tbd_user_payment_methods_ibfk_2 → tbc_payment_methods_types(ID); payment_method_type_ID (payment_method_type_ID) | — | `&#96;payment_method_type_ID&#96; int unsigned NOT NULL` |
| 4 | `provider` | `varchar(60)` | No | `—` | UK; uk_provider_method (provider, provider_method_ref) | — | `&#96;provider&#96; varchar(60) NOT NULL` |
| 5 | `provider_method_ref` | `varchar(255)` | No | `—` | UK; uk_provider_method (provider, provider_method_ref) | — | `&#96;provider_method_ref&#96; varchar(255) NOT NULL` |
| 6 | `label` | `varchar(100)` | Sí | `NULL` | — | — | `&#96;label&#96; varchar(100) DEFAULT NULL` |
| 7 | `last_four` | `char(4)` | Sí | `NULL` | — | — | `&#96;last_four&#96; char(4) DEFAULT NULL` |
| 8 | `is_default` | `tinyint(1)` | No | `'0'` | — | — | `&#96;is_default&#96; tinyint(1) NOT NULL DEFAULT '0'` |
| 9 | `status` | `bit(1)` | No | `b` | — | — | `&#96;status&#96; bit(1) NOT NULL DEFAULT b'1'` |
| 10 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 11 | `last_update` | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `uk_provider_method` (UNIQUE, UNIQUE): `provider, provider_method_ref`. DDL: `UNIQUE KEY &#96;uk_provider_method&#96; (&#96;provider&#96;,&#96;provider_method_ref&#96;)`
- `user_ID` (INDEX): `user_ID`. DDL: `KEY &#96;user_ID&#96; (&#96;user_ID&#96;)`
- `payment_method_type_ID` (INDEX): `payment_method_type_ID`. DDL: `KEY &#96;payment_method_type_ID&#96; (&#96;payment_method_type_ID&#96;)`

## Claves foráneas

- `tbd_user_payment_methods_ibfk_1`: (user_ID) → `tb_users(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;tbd_user_payment_methods_ibfk_1&#96; FOREIGN KEY (&#96;user_ID&#96;) REFERENCES &#96;tb_users&#96; (&#96;ID&#96;)`
- `tbd_user_payment_methods_ibfk_2`: (payment_method_type_ID) → `tbc_payment_methods_types(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;tbd_user_payment_methods_ibfk_2&#96; FOREIGN KEY (&#96;payment_method_type_ID&#96;) REFERENCES &#96;tbc_payment_methods_types&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tbd_user_payment_methods` (
  `ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` int NOT NULL,
  `payment_method_type_ID` int unsigned NOT NULL,
  `provider` varchar(60) NOT NULL,
  `provider_method_ref` varchar(255) NOT NULL,
  `label` varchar(100) DEFAULT NULL,
  `last_four` char(4) DEFAULT NULL,
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_provider_method` (`provider`,`provider_method_ref`),
  KEY `user_ID` (`user_ID`),
  KEY `payment_method_type_ID` (`payment_method_type_ID`),
  CONSTRAINT `tbd_user_payment_methods_ibfk_1` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`),
  CONSTRAINT `tbd_user_payment_methods_ibfk_2` FOREIGN KEY (`payment_method_type_ID`) REFERENCES `tbc_payment_methods_types` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
