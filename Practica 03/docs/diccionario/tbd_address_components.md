<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbd_address_components`

Fuente: `respaldo_compra_usuarios.sql`, líneas 2316–2330. SHA-256: `20eff15c9d28e69975c07c1fb29d265dd8527cefb43781d630567aca1c39e279`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 8.
- Filas encontradas en sentencias INSERT de este respaldo: 12.
- Claves primarias / índices: 3.
- Claves foráneas: 2.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `ID` | `bigint unsigned` | No | `—` | PK; UK; PRIMARY (ID); uk_address_component (address_ID, ID) | — | `&#96;ID&#96; bigint unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `address_ID` | `bigint unsigned` | No | `—` | UK; índice; FK; fk_component_address → tb_user_addresses(ID); fk_component_parent → tbd_address_components(address_ID, ID); uk_address_component (address_ID, ID); idx_address_parent (address_ID, address_sup_ID) | — | `&#96;address_ID&#96; bigint unsigned NOT NULL` |
| 3 | `value` | `varchar(255)` | No | `—` | — | — | `&#96;value&#96; varchar(255) NOT NULL` |
| 4 | `component_type` | `varchar(50)` | No | `—` | — | — | `&#96;component_type&#96; varchar(50) NOT NULL` |
| 5 | `status` | `bit(1)` | No | `b` | — | — | `&#96;status&#96; bit(1) NOT NULL DEFAULT b'1'` |
| 6 | `address_sup_ID` | `bigint unsigned` | Sí | `NULL` | índice; FK; fk_component_parent → tbd_address_components(address_ID, ID); idx_address_parent (address_ID, address_sup_ID) | — | `&#96;address_sup_ID&#96; bigint unsigned DEFAULT NULL` |
| 7 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 8 | `last_update` | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `uk_address_component` (UNIQUE, UNIQUE): `address_ID, ID`. DDL: `UNIQUE KEY &#96;uk_address_component&#96; (&#96;address_ID&#96;,&#96;ID&#96;)`
- `idx_address_parent` (INDEX): `address_ID, address_sup_ID`. DDL: `KEY &#96;idx_address_parent&#96; (&#96;address_ID&#96;,&#96;address_sup_ID&#96;)`

## Claves foráneas

- `fk_component_address`: (address_ID) → `tb_user_addresses(ID)`; ON DELETE RESTRICT; ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_component_address&#96; FOREIGN KEY (&#96;address_ID&#96;) REFERENCES &#96;tb_user_addresses&#96; (&#96;ID&#96;) ON DELETE RESTRICT`
- `fk_component_parent`: (address_ID, address_sup_ID) → `tbd_address_components(address_ID, ID)`; ON DELETE RESTRICT; ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_component_parent&#96; FOREIGN KEY (&#96;address_ID&#96;, &#96;address_sup_ID&#96;) REFERENCES &#96;tbd_address_components&#96; (&#96;address_ID&#96;, &#96;ID&#96;) ON DELETE RESTRICT`

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tbd_address_components` (
  `ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `address_ID` bigint unsigned NOT NULL,
  `value` varchar(255) NOT NULL,
  `component_type` varchar(50) NOT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `address_sup_ID` bigint unsigned DEFAULT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_address_component` (`address_ID`,`ID`),
  KEY `idx_address_parent` (`address_ID`,`address_sup_ID`),
  CONSTRAINT `fk_component_address` FOREIGN KEY (`address_ID`) REFERENCES `tb_user_addresses` (`ID`) ON DELETE RESTRICT,
  CONSTRAINT `fk_component_parent` FOREIGN KEY (`address_ID`, `address_sup_ID`) REFERENCES `tbd_address_components` (`address_ID`, `ID`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
