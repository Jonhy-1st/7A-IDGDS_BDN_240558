<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_products`

Fuente: `240558_Respaldo_com_responsables_dbuser.sql`, líneas 740–752. SHA-256: `8242d2e7a82f3e2b2c326fda9989c7d676d061933ad43ad2e750a057d0e7a766`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 9.
- Filas encontradas en sentencias INSERT de este respaldo: 15000.
- Claves primarias / índices: 2.
- Claves foráneas: 0.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=15001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `ID` | `int unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `SKU` | `varchar(50)` | No | `—` | UK; SKU (SKU) | — | `&#96;SKU&#96; varchar(50) NOT NULL` |
| 3 | `name` | `varchar(250)` | No | `—` | — | — | `&#96;name&#96; varchar(250) NOT NULL` |
| 4 | `description` | `text` | Sí | `—` | — | — | `&#96;description&#96; text` |
| 5 | `current_price` | `decimal(10,2)` | No | `'0.00'` | — | — | `&#96;current_price&#96; decimal(10,2) NOT NULL DEFAULT '0.00'` |
| 6 | `current_stock` | `int unsigned` | No | `'0'` | — | — | `&#96;current_stock&#96; int unsigned NOT NULL DEFAULT '0'` |
| 7 | `status` | `bit(1)` | Sí | `b` | — | — | `&#96;status&#96; bit(1) DEFAULT b'1'` |
| 8 | `creation_date` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 9 | `last_update` | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;last_update&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `SKU` (UNIQUE, UNIQUE): `SKU`. DDL: `UNIQUE KEY &#96;SKU&#96; (&#96;SKU&#96;)`

## Claves foráneas

- No se encontraron claves foráneas en el DDL.

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_products` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `SKU` varchar(50) NOT NULL,
  `name` varchar(250) NOT NULL,
  `description` text,
  `current_price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `current_stock` int unsigned NOT NULL DEFAULT '0',
  `status` bit(1) DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `SKU` (`SKU`)
) ENGINE=InnoDB AUTO_INCREMENT=15001 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
