<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_users`

Fuente: `respaldo_compra_usuarios.sql`, líneas 1771–1783. SHA-256: `20eff15c9d28e69975c07c1fb29d265dd8527cefb43781d630567aca1c39e279`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 8.
- Filas encontradas en sentencias INSERT de este respaldo: 10024.
- Claves primarias / índices: 3.
- Claves foráneas: 0.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=16412 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `ID` | `int` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int NOT NULL AUTO_INCREMENT` |
| 2 | `email` | `varchar(80)` | No | `—` | UK; email (email) | — | `&#96;email&#96; varchar(80) NOT NULL` |
| 3 | `nick` | `varchar(100)` | No | `—` | UK; nickname (nick) | — | `&#96;nick&#96; varchar(100) NOT NULL` |
| 4 | `password` | `varchar(255)` | No | `—` | — | — | `&#96;password&#96; varchar(255) NOT NULL` |
| 5 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 6 | `last_update` | `datetime` | Sí | `CURRENT_TIMESTAMP` | — | — | `&#96;last_update&#96; datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP` |
| 7 | `last_login` | `datetime` | Sí | `NULL` | — | — | `&#96;last_login&#96; datetime DEFAULT NULL` |
| 8 | `status` | `bit(1)` | No | `b` | — | — | `&#96;status&#96; bit(1) NOT NULL DEFAULT b'1'` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `email` (UNIQUE, UNIQUE): `email`. DDL: `UNIQUE KEY &#96;email&#96; (&#96;email&#96;)`
- `nickname` (UNIQUE, UNIQUE): `nick`. DDL: `UNIQUE KEY &#96;nickname&#96; (&#96;nick&#96;)`

## Claves foráneas

- No se encontraron claves foráneas en el DDL.

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_users` (
  `ID` int NOT NULL AUTO_INCREMENT,
  `email` varchar(80) NOT NULL,
  `nick` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_login` datetime DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `nickname` (`nick`)
) ENGINE=InnoDB AUTO_INCREMENT=16412 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
