<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_carts`

Fuente: `respaldo_compra_usuarios.sql`, líneas 228–237. SHA-256: `20eff15c9d28e69975c07c1fb29d265dd8527cefb43781d630567aca1c39e279`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 5.
- Filas encontradas en sentencias INSERT de este respaldo: 2.
- Claves primarias / índices: 2.
- Claves foráneas: 1.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `ID` | `int unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `user_ID` | `int` | No | `—` | UK; FK; fk_cart_user → tb_users(ID); uk_cart_user (user_ID) | — | `&#96;user_ID&#96; int NOT NULL` |
| 3 | `status` | `enum('Active','Converted','Abandoned')` | No | `'Active'` | — | — | `&#96;status&#96; enum('Active','Converted','Abandoned') NOT NULL DEFAULT 'Active'` |
| 4 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 5 | `last_update` | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `uk_cart_user` (UNIQUE, UNIQUE): `user_ID`. DDL: `UNIQUE KEY &#96;uk_cart_user&#96; (&#96;user_ID&#96;)`

## Claves foráneas

- `fk_cart_user`: (user_ID) → `tb_users(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_cart_user&#96; FOREIGN KEY (&#96;user_ID&#96;) REFERENCES &#96;tb_users&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_carts` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `user_ID` int NOT NULL,
  `status` enum('Active','Converted','Abandoned') NOT NULL DEFAULT 'Active',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uk_cart_user` (`user_ID`),
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
