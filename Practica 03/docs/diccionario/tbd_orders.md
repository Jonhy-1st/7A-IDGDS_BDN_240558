<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tbd_orders`

Fuente: `respaldo_compra_usuarios.sql`, líneas 2808–2819. SHA-256: `20eff15c9d28e69975c07c1fb29d265dd8527cefb43781d630567aca1c39e279`.
Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 9.
- Filas encontradas en sentencias INSERT de este respaldo: 0.
- Claves primarias / índices: 1.
- Claves foráneas: 0.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|:---:|---|---|---|---|
| 1 | `ID` | `int unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `key` | `varchar(40)` | No | `—` | — | — | `&#96;key&#96; varchar(40) NOT NULL` |
| 3 | `total_products` | `int` | No | `—` | — | — | `&#96;total_products&#96; int NOT NULL` |
| 4 | `total_cost` | `decimal(10,3)` | No | `'0.000'` | — | — | `&#96;total_cost&#96; decimal(10,3) NOT NULL DEFAULT '0.000'` |
| 5 | `status_string` | `enum('Registered','Attend','Canceled','Whistlist','Payed','Delivered','Devolved','Sended')` | Sí | `NULL` | — | — | `&#96;status_string&#96; enum('Registered','Attend','Canceled','Whistlist','Payed','Delivered','Devolved','Sended') DEFAULT NULL` |
| 6 | `status` | `bit(1)` | No | `b` | — | — | `&#96;status&#96; bit(1) NOT NULL DEFAULT b'1'` |
| 7 | `creation_date` | `datetime` | Sí | `NULL` | — | — | `&#96;creation_date&#96; datetime DEFAULT NULL` |
| 8 | `last_update` | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL` |
| 9 | `User_ID` | `varchar(45)` | Sí | `NULL` | — | — | `&#96;User_ID&#96; varchar(45) DEFAULT NULL` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`

## Claves foráneas

- No se encontraron claves foráneas en el DDL.

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tbd_orders` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(40) NOT NULL,
  `total_products` int NOT NULL,
  `total_cost` decimal(10,3) NOT NULL DEFAULT '0.000',
  `status_string` enum('Registered','Attend','Canceled','Whistlist','Payed','Delivered','Devolved','Sended') DEFAULT NULL,
  `status` bit(1) NOT NULL DEFAULT b'1',
  `creation_date` datetime DEFAULT NULL,
  `last_update` datetime DEFAULT NULL,
  `User_ID` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
