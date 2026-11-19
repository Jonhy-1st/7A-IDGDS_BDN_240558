<!-- generado por generar_diccionario_interactivo.js -->
# Tabla `tb_products`

Fuente: `Respaldo_Practica4.sql`, líneas 1052–1064. SHA-256: `ed941c888be8bd17d759acbcec9824ba173ad4094795d47012b7cc702bdf3880`.
## Para qué sirve

Es el catálogo general de productos. Guarda nombre, SKU, precio, existencia general y estado de publicación; las ofertas concretas de vendedores están en tbd_users_offer_products.

Los datos siguientes transcriben propiedades visibles en el DDL del respaldo; no asignan semántica funcional no declarada.

## Resumen DDL

- Columnas: 9.
- Filas encontradas en sentencias INSERT de este respaldo: 15007.
- Claves primarias / índices: 2.
- Claves foráneas: 0.
- Restricciones CHECK: 0.
- Opciones de tabla tal como aparecen junto al DDL: `ENGINE=InnoDB AUTO_INCREMENT=21399 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci`.

## Columnas

| # | Columna | Para qué sirve | Tipo SQL | Nulo | Predeterminado | Claves | Comentario DDL | Definición SQL |
|---:|---|---|---|:---:|---|---|---|---|
| 1 | `ID` | Identificador único del registro. | `int unsigned` | No | `—` | PK; PRIMARY (ID) | — | `&#96;ID&#96; int unsigned NOT NULL AUTO_INCREMENT` |
| 2 | `SKU` | Código de inventario que identifica el producto. | `varchar(50)` | No | `—` | UK; SKU (SKU) | — | `&#96;SKU&#96; varchar(50) NOT NULL` |
| 3 | `name` | Nombre del elemento; puede ser un producto, categoría o tipo de pago según la tabla. | `varchar(250)` | No | `—` | — | — | `&#96;name&#96; varchar(250) NOT NULL` |
| 4 | `description` | Texto que explica el elemento del catálogo o registro. | `text` | Sí | `—` | — | — | `&#96;description&#96; text` |
| 5 | `current_price` | Precio vigente del producto en el catálogo. | `decimal(10,2)` | No | `'0.00'` | — | — | `&#96;current_price&#96; decimal(10,2) NOT NULL DEFAULT '0.00'` |
| 6 | `current_stock` | Existencia general disponible del producto. | `int unsigned` | No | `'0'` | — | — | `&#96;current_stock&#96; int unsigned NOT NULL DEFAULT '0'` |
| 7 | `status` | Indica si el registro está habilitado o activo. | `bit(1)` | Sí | `b` | — | — | `&#96;status&#96; bit(1) DEFAULT b'1'` |
| 8 | `creation_date` | Fecha y hora de creación del registro. | `datetime` | No | `CURRENT_TIMESTAMP` | — | — | `&#96;creation_date&#96; datetime NOT NULL DEFAULT CURRENT_TIMESTAMP` |
| 9 | `last_update` | Fecha y hora de la última modificación. | `datetime` | No | `—` | — | — | `&#96;last_update&#96; datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP` |

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
  `last_update` datetime NOT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `SKU` (`SKU`)
) ENGINE=InnoDB AUTO_INCREMENT=21399 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```
