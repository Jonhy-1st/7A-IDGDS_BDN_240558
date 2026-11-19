<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_buyer_orders`

Fuente: `Respaldo_Practica4.sql`, líneas 27–40. SHA-256: `ed941c888be8bd17d759acbcec9824ba173ad4094795d47012b7cc702bdf3880`.
## Para qué sirve

Guarda el pedido general que hace una persona: quién compra, cuántos artículos incluye, cuánto cuesta y en qué etapa está. Se relaciona con usuarios, pedidos por vendedor, pagos y cancelaciones.

Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 9.
- Filas encontradas en sentencias INSERT de este respaldo: 8.
- Claves primarias / índices: 2.
- Claves foráneas: 1.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Para qué sirve | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|---|:---:|---|---|---|---|
| 1 | `ID` | Identificador único del registro. | `int unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `key` | Clave legible o de referencia del registro. | `varchar(40)` | No | `—` | — | — | `&#96;key&#96; varchar(40) NOT NULL` |
| 3 | `user_ID` | Identificador de la cuenta relacionada. user_ID enlaza con tb_users.ID. | `int` | No | `—` | índice; FK; fk_user_2 → tb_users(ID); fk_user_2_idx (user_ID) | — | `&#96;user_ID&#96; int NOT NULL` |
| 4 | `total_products` | Cantidad total de unidades incluidas en el pedido. | `int` | No | `—` | — | — | `&#96;total_products&#96; int NOT NULL` |
| 5 | `total_cost` | Importe total del pedido. | `decimal(10,3)` | No | `'0.000'` | — | — | `&#96;total_cost&#96; decimal(10,3) NOT NULL DEFAULT '0.000'` |
| 6 | `status_string` | Etapa general del pedido. | `enum('Registered','Wishlist','Payed','Canceled','Delivered','Devolved','Attended','Sended','PartiallyPaid','PaymentFailed')` | No | `'Registered'` | — | — | `&#96;status_string&#96; enum('Registered','Wishlist','Payed','Canceled','Delivered','Devolved','Attended','Sended','PartiallyPaid','PaymentFailed') NOT NULL DEFAULT 'Registered'` |
| 7 | `status` | Indica si el registro está habilitado o activo. | `bit(1)` | Sí | `b` | — | — | `&#96;status&#96; bit(1) DEFAULT b'1'` |
| 8 | `creation_date` | Fecha y hora de creación del registro. | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 9 | `last_update` | Fecha y hora de la última modificación. | `datetime` | Sí | `NULL` | — | — | `&#96;last_update&#96; datetime DEFAULT NULL` |

## Claves primarias e índices

- `PRIMARY` (PRIMARY, UNIQUE): `ID`. DDL: `PRIMARY KEY (&#96;ID&#96;)`
- `fk_user_2_idx` (INDEX): `user_ID`. DDL: `KEY &#96;fk_user_2_idx&#96; (&#96;user_ID&#96;)`

## Claves foráneas

- `fk_user_2`: (user_ID) → `tb_users(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL). DDL: `CONSTRAINT &#96;fk_user_2&#96; FOREIGN KEY (&#96;user_ID&#96;) REFERENCES &#96;tb_users&#96; (&#96;ID&#96;)`

## Restricciones CHECK

- No se encontraron restricciones CHECK separadas en el DDL.

## Definición SQL de la tabla

```sql
CREATE TABLE `tb_buyer_orders` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(40) NOT NULL,
  `user_ID` int NOT NULL,
  `total_products` int NOT NULL,
  `total_cost` decimal(10,3) NOT NULL DEFAULT '0.000',
  `status_string` enum('Registered','Wishlist','Payed','Canceled','Delivered','Devolved','Attended','Sended','PartiallyPaid','PaymentFailed') NOT NULL DEFAULT 'Registered',
  `status` bit(1) DEFAULT b'1',
  `creation_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `fk_user_2_idx` (`user_ID`),
  CONSTRAINT `fk_user_2` FOREIGN KEY (`user_ID`) REFERENCES `tb_users` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
