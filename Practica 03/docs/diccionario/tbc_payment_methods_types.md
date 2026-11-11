<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbc_payment_methods_types`

Fuente: `respaldo_compra_usuarios.sql`, líneas 2088–2097. SHA-256: `20eff15c9d28e69975c07c1fb29d265dd8527cefb43781d630567aca1c39e279`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 6.
- Filas encontradas en sentencias INSERT de este respaldo: 1.
- Claves primarias / índices: 2.
- Claves foráneas: 0.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `ID` | `int unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `code` | `varchar(30)` | No | `—` | UK; code_UNIQUE (code) | — | `&#96;code&#96; varchar(30) NOT NULL` |
| 3 | `description` | `text` | No | `—` | — | — | `&#96;description&#96; text NOT NULL` |
| 4 | `status` | `bit(1)` | No | `b` | — | — | `&#96;status&#96; bit(1) NOT NULL DEFAULT b'1'` |
| 5 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 6 | `last_update` | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `code_UNIQUE` (UNIQUE, UNIQUE): `code`. DDL: `UNIQUE KEY &#96;code_UNIQUE&#96; (&#96;code&#96;)`

## Claves foráneas

- No se encontraron claves foráneas en el DDL.

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tbc_payment_methods_types` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(30) NOT NULL,
  `description` text NOT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `code_UNIQUE` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
