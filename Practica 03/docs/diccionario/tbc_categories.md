<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbc_categories`

Fuente: `respaldo_compra_usuarios.sql`, líneas 1931–1943. SHA-256: `20eff15c9d28e69975c07c1fb29d265dd8527cefb43781d630567aca1c39e279`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 7.
- Filas encontradas en sentencias INSERT de este respaldo: 100.
- Claves primarias / índices: 3.
- Claves foráneas: 1.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `ID` | `int unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `name` | `varchar(120)` | No | `—` | UK; name (name) | — | `&#96;name&#96; varchar(120) NOT NULL` |
| 3 | `description` | `text` | Sí | `—` | — | — | `&#96;description&#96; text` |
| 4 | `sup_id_category` | `int unsigned` | Sí | `NULL` | índice; FK; fk_superior_category → tbc_categories(ID); fk_superior_category (sup_id_category) | — | `&#96;sup_id_category&#96; int unsigned DEFAULT NULL` |
| 5 | `status` | `bit(1)` | No | `b` | — | — | `&#96;status&#96; bit(1) NOT NULL DEFAULT b'1'` |
| 6 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 7 | `last_update` | `datetime` | No | `—` | — | — | `&#96;last_update&#96; datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `name` (UNIQUE, UNIQUE): `name`. DDL: `UNIQUE KEY &#96;name&#96; (&#96;name&#96;)`
- `fk_superior_category` (INDEX): `sup_id_category`. DDL: `KEY &#96;fk_superior_category&#96; (&#96;sup_id_category&#96;)`

## Claves foráneas

- `fk_superior_category`: (sup_id_category) → `tbc_categories(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_superior_category&#96; FOREIGN KEY (&#96;sup_id_category&#96;) REFERENCES &#96;tbc_categories&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tbc_categories` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(120) NOT NULL,
  `description` text,
  `sup_id_category` int unsigned DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `name` (`name`),
  KEY `fk_superior_category` (`sup_id_category`),
  CONSTRAINT `fk_superior_category` FOREIGN KEY (`sup_id_category`) REFERENCES `tbc_categories` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
