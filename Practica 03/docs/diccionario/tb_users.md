<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_users`

Fuente: `respaldo_casos_compra_final.sql`, líneas 1784–1797. SHA-256: `99067eeb933614e493903c946b5c6f1faf8e214d9c69bc7ae5fa3180809e8010`.
## Para qué sirve

Contiene las cuentas de acceso de la plataforma: correo, alias, contraseña protegida con hash, estado y rol de plataforma. Los datos personales complementarios se guardan en tb_people.

Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 9.
- Filas encontradas en sentencias INSERT de este respaldo: 10025.
- Claves primarias / índices: 3.
- Claves foráneas: 0.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=16413 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Para qué sirve | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|---|:---:|---|---|---|---|
| 1 | `ID` | Identificador único del registro. | `int` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int NOT NULL AUTO_INCREMENT` |
| 2 | `email` | Correo usado para identificar o contactar la cuenta. | `varchar(80)` | No | `—` | UK; email (email) | — | `&#96;email&#96; varchar(80) NOT NULL` |
| 3 | `nick` | Nombre corto o alias de la cuenta. | `varchar(100)` | No | `—` | UK; nickname (nick) | — | `&#96;nick&#96; varchar(100) NOT NULL` |
| 4 | `password` | Contraseña almacenada; debe estar protegida mediante hash. | `varchar(255)` | No | `—` | — | — | `&#96;password&#96; varchar(255) NOT NULL` |
| 5 | `creation_date` | Fecha y hora de creación del registro. | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 6 | `last_update` | Fecha y hora de la última modificación. | `datetime` | Sí | `CURRENT_TIMESTAMP` | — | — | `&#96;last_update&#96; datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP` |
| 7 | `last_login` | Fecha y hora del último inicio de sesión. | `datetime` | Sí | `NULL` | — | — | `&#96;last_login&#96; datetime DEFAULT NULL` |
| 8 | `status` | Indica si el registro está habilitado o activo. | `bit(1)` | No | `b` | — | — | `&#96;status&#96; bit(1) NOT NULL DEFAULT b'1'` |
| 9 | `platform_role` | Rol de la persona dentro de la plataforma. | `enum('common_user','buyer')` | No | `'common_user'` | — | — | `&#96;platform_role&#96; enum('common_user','buyer') NOT NULL DEFAULT 'common_user'` |

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
  `platform_role` enum('common_user','buyer') NOT NULL DEFAULT 'common_user',
  PRIMARY KEY (`ID`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `nickname` (`nick`)
) ENGINE=InnoDB AUTO_INCREMENT=16413 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
