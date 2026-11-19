<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbd_user_payment_methods`

Fuente: `respaldo_casos_compra_final.sql`, líneas 3216–3237. SHA-256: `52a7d987f2e3f92a75f419de00c360508cf3b3d385ec3f70bcf65815f435a783`.
## Para qué sirve

Guarda instrumentos de pago simulados de cada persona, como tarjeta o cupón: tipo, proveedor, referencia, últimos cuatro dígitos y saldo opcional. Los pagos los referencian sin guardar el número completo de la tarjeta.

Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 12.
- Filas encontradas en sentencias INSERT de este respaldo: 2.
- Claves primarias / índices: 4.
- Claves foráneas: 2.
- Restricciones CHECK: 1.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Para qué sirve | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|---|:---:|---|---|---|---|
| 1 | `ID` | Identificador único del registro. | `bigint unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; bigint unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `user_ID` | Identificador de la cuenta relacionada. user_ID enlaza con tb_users.ID. | `int` | No | `—` | índice; FK; tbd_user_payment_methods_ibfk_1 → tb_users(ID); user_ID (user_ID) | — | `&#96;user_ID&#96; int NOT NULL` |
| 3 | `payment_method_type_ID` | Identificador del tipo de instrumento de pago. payment_method_type_ID enlaza con tbc_payment_methods_types.ID. | `int unsigned` | No | `—` | índice; FK; tbd_user_payment_methods_ibfk_2 → tbc_payment_methods_types(ID); payment_method_type_ID (payment_method_type_ID) | — | `&#96;payment_method_type_ID&#96; int unsigned NOT NULL` |
| 4 | `provider` | Proveedor del instrumento o del procesamiento de pago. | `varchar(60)` | No | `—` | UK; uk_provider_method (provider, provider_method_ref) | — | `&#96;provider&#96; varchar(60) NOT NULL` |
| 5 | `provider_method_ref` | Referencia del instrumento en el proveedor de pago. | `varchar(255)` | No | `—` | UK; uk_provider_method (provider, provider_method_ref) | — | `&#96;provider_method_ref&#96; varchar(255) NOT NULL` |
| 6 | `label` | Nombre elegido para reconocer el instrumento de pago. | `varchar(100)` | Sí | `NULL` | — | — | `&#96;label&#96; varchar(100) DEFAULT NULL` |
| 7 | `last_four` | Últimos cuatro dígitos visibles del instrumento; no contiene el número completo. | `char(4)` | Sí | `NULL` | — | — | `&#96;last_four&#96; char(4) DEFAULT NULL` |
| 8 | `available_balance` | Saldo disponible del instrumento; se usa, por ejemplo, para un cupón simulado. | `decimal(12,2)` | Sí | `NULL` | — | — | `&#96;available_balance&#96; decimal(12,2) DEFAULT NULL` |
| 9 | `is_default` | Indica si este es el domicilio o instrumento predeterminado. | `tinyint(1)` | No | `'0'` | — | — | `&#96;is_default&#96; tinyint(1) NOT NULL DEFAULT '0'` |
| 10 | `status` | Indica si el registro está habilitado o activo. | `bit(1)` | No | `b` | — | — | `&#96;status&#96; bit(1) NOT NULL DEFAULT b'1'` |
| 11 | `creation_date` | Fecha y hora de creación del registro. | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 12 | `last_update` | Fecha y hora de la última modificación. | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `uk_provider_method` (UNIQUE, UNIQUE): `provider, provider_method_ref`. DDL: `UNIQUE KEY &#96;uk_provider_method&#96; (&#96;provider&#96;,&#96;provider_method_ref&#96;)`
- `user_ID` (INDEX): `user_ID`. DDL: `KEY &#96;user_ID&#96; (&#96;user_ID&#96;)`
- `payment_method_type_ID` (INDEX): `payment_method_type_ID`. DDL: `KEY &#96;payment_method_type_ID&#96; (&#96;payment_method_type_ID&#96;)`

## Claves foráneas

- `tbd_user_payment_methods_ibfk_1`: (user_ID) → `tb_users(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;tbd_user_payment_methods_ibfk_1&#96; FOREIGN KEY (&#96;user_ID&#96;) REFERENCES &#96;tb_users&#96; (&#96;ID&#96;)`
- `tbd_user_payment_methods_ibfk_2`: (payment_method_type_ID) → `tbc_payment_methods_types(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;tbd_user_payment_methods_ibfk_2&#96; FOREIGN KEY (&#96;payment_method_type_ID&#96;) REFERENCES &#96;tbc_payment_methods_types&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- `CONSTRAINT &#96;chk_user_payment_method_balance&#96; CHECK ((&#96;available_balance&#96; is null) or (&#96;available_balance&#96; >= 0))`

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
  `available_balance` decimal(12,2) DEFAULT NULL,
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
,
  CONSTRAINT `chk_user_payment_method_balance` CHECK ((`available_balance` is null) or (`available_balance` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
