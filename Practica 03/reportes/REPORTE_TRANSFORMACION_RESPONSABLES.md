# Reporte de transformación de responsables

**Práctica 03 · Base `db_test` · MySQL 8**

Fecha de generación: 2026-11-04

> **Actualización posterior (2026-11-04):** este reporte describe la
> transformación de responsables. Después se normalizó `tb_logs.db_user` a las
> cuentas del script remoto; el estado final y sus verificaciones están en
> `REPORTE_ACTUALIZACION_DB_USER.md`. Los MD5 de logs de este documento
> corresponden al estado **previo** a esa normalización.

---

## 1. Resumen ejecutivo

Se generó un segundo respaldo SQL completo e independiente a partir de
`240558_Respaldo_com.sql`. El respaldo original **no fue modificado**. El nuevo
archivo conserva todas las filas, relaciones y objetos del original y agrega la
reasignación de responsabilidad de los 15,000 productos a las cuentas remotas.

| Concepto | Resultado |
|---|---|
| Respaldo original | `Practica 03/backups/240558_Respaldo_com.sql` (10,410,955 bytes) |
| Respaldo transformado | `Practica 03/backups/240558_Respaldo_com_responsables.sql` (19,869,731 bytes) |
| Importación de prueba | MySQL 8.0.45, instalación limpia, `exit=0`, sin errores SQL |
| Segunda importación | `exit=0` (el archivo es reimportable) |
| Filas originales modificadas | **0** |
| Filas originales eliminadas | **0** |
| Productos | 15,000 (idénticos al original) |
| Usuarios | 10,229 = 10,222 originales + 7 proxy |
| Logs | 50,543 = 35,543 históricos + 15,000 reasignaciones |

**SHA-256**

| Archivo | SHA-256 |
|---|---|
| `240558_Respaldo_com.sql` | `196ce17f770fa3c0dc2d1bc4120bb4ca5c8ec79905e98766b49f4250f67186da` |
| `240558_Respaldo_com_responsables.sql` | `5e9fb16e569f289a896de5984d7969c7e196bdae9765a65e5708d2c19d58541d` |

El archivo transformado es **reversible byte a byte**: si se eliminan sus cinco
bloques `TRANSFORM_*`, el texto resultante es exactamente el respaldo original.
Esta comprobación la realiza el generador en cada ejecución y también se verificó
de forma independiente.

---

## 2. Archivos entregados

| Archivo | Contenido |
|---|---|
| `Practica 03/backups/240558_Respaldo_com_responsables.sql` | Respaldo SQL transformado, listo para importar en MySQL 8 |
| `Practica 03/reportes/correspondencias_responsables.csv` | Detalle de las 15,000 reasignaciones (11 columnas, UTF-8 con BOM) |
| `Practica 03/queries/consultas_verificacion_transformado.sql` | Consultas de verificación con valores esperados |
| `Practica 03/reportes/REPORTE_TRANSFORMACION_RESPONSABLES.md` | Este reporte |
| `Practica 03/scripts/generate_transformed_backup.py` | Generador reproducible y verificación de reversibilidad |

---

## 3. Correspondencia aplicada

> **Supuesto importante:** no se recibió una tabla de correspondencias explícita.
> La única evidencia disponible en el respaldo era el actor que creó cada
> producto en `tb_logs`. Por eso la correspondencia se derivó como
> **creador original del producto → cuenta remota responsable**. Si la
> correspondencia real es distinta, el respaldo debe regenerarse (ver sección 9).

| Creador original (`tb_logs.db_user`) | Productos | Nuevo responsable | Tipo | Usuario proxy |
|---|---:|---|---|---|
| `root@localhost` | 2 | `jonhy.neri` | `Owner` | 10223 |
| `luis.cazarez@PC-05` | 10,005 | `saul.barrios` | `Seller` | 10226 |
| `natalia.carrasco@PC-02` | 4,993 | `aylin.esteban` | `Seller` | 10227 |
| **Total** | **15,000** | | | |

Cada producto tiene exactamente un log de creación (`operation = 'Create'`,
`table_name = 'tb_products'`), sin duplicados ni productos sin log. Esa relación
1:1 permitió asignar los 15,000 productos sin ambigüedad.

Las cuentas `marco.ramirez`, `luis.cazarez`, `pablo.reyes` y
`uriel.valenzuela` no reciben productos: su rol no los hace responsables de
catálogo en esta correspondencia.

---

## 4. Cambios realizados

### 4.1 Usuarios proxy en `tb_users`

Se agregaron 7 filas (IDs `10223`–`10229`), una por cuenta remota. Son cuentas
**sintéticas, inactivas y sin login**, usadas solo para que las relaciones de
responsabilidad tengan una FK válida dentro de `db_test`.

| ID | `nick` | `email` | Rol remoto | `status` | `last_login` |
|---:|---|---|---|---|---|
| 10223 | `remote_jonhy.neri` | `proxy+jonhy.neri@remote.invalid` | superadmin | 0 | NULL |
| 10224 | `remote_marco.ramirez` | `proxy+marco.ramirez@remote.invalid` | admin | 0 | NULL |
| 10225 | `remote_luis.cazarez` | `proxy+luis.cazarez@remote.invalid` | support | 0 | NULL |
| 10226 | `remote_saul.barrios` | `proxy+saul.barrios@remote.invalid` | seller | 0 | NULL |
| 10227 | `remote_aylin.esteban` | `proxy+aylin.esteban@remote.invalid` | seller | 0 | NULL |
| 10228 | `remote_pablo.reyes` | `proxy+pablo.reyes@remote.invalid` | sin rol | 0 | NULL |
| 10229 | `remote_uriel.valenzuela` | `proxy+uriel.valenzuela@remote.invalid` | sin rol | 0 | NULL |

Contraseña de todas: `!SYNTHETIC-PROXY-NO-LOGIN!` (placeholder; no debe usarse
para autenticarse). `AUTO_INCREMENT` de `tb_users` queda en `10230`.

### 4.2 Relaciones producto–responsable

Se insertaron 15,000 filas en `tbd_products_users_providers`
(la tabla estaba vacía en el original):

| Responsable | `type_ownership` | Productos |
|---|---|---:|
| 10226 `saul.barrios` | `Seller` | 10,005 |
| 10227 `aylin.esteban` | `Seller` | 4,993 |
| 10223 `jonhy.neri` | `Owner` | 2 |
| **Total** | | **15,000** |

- `status = b'1'` (activo).
- `available_date` = fecha del log de creación original del producto.
- `creation_date` y `last_update` = `2026-11-04 00:00:00` (fecha de la migración).
- Un solo responsable por producto; sin productos sin responsable.

### 4.3 Logs de reasignación

Se agregaron 15,000 filas en `tb_logs`, IDs `35570`–`50569`:

| Campo | Valor |
|---|---|
| `table_name` | `tbd_products_users_providers` |
| `table_operation` | `INSERT` |
| `operation` | `Create` |
| `db_user` | `jonhy.neri@%` (superadmin que ejecuta la migración) |
| `operation_date` | `2026-11-04 00:00:00` |
| `operation_status` | `b'1'` |

Cada descripción documenta producto, SKU, nombre, responsable original, nuevo
responsable, tipo de propiedad y el `ID` del log de creación original. Ejemplo:

```
Reasignacion de responsable. Producto ID: 1; Usuario ID: 10227;
SKU=P00001; nombre=Gillette Mach3 presentación familiar;
responsable original=natalia.carrasco@PC-02; nuevo responsable=aylin.esteban;
tipo_ownership=Seller; log_origen=46.
```

Los 35,543 logs históricos (IDs 1–35569) no se tocaron: sus checksums coinciden
exactamente con el respaldo original. `AUTO_INCREMENT` de `tb_logs` queda en
`50570`.

### 4.4 Tablas de mapeo

Se crearon dos tablas nuevas al final del respaldo:

- `tb_user_identity_mapping` (7 filas): relación entre cada usuario proxy y su
  cuenta/rol remoto. `can_login = 0`.
- `tb_product_responsibility_mapping` (15,000 filas): auditoría completa de cada
  reasignación, con FK a producto, usuario responsable, log original y log nuevo.

Estas tablas son metadatos de la transformación; no alteran el modelo original.
El CSV `correspondencias_responsables.csv` contiene la misma información que
`tb_product_responsibility_mapping`.

### 4.5 Cuentas, roles y privilegios remotos

Se incluyó la sección activa del script
`Practica 03/scripts/remote_users_privileges_creation.sql` (script 1):

- 7 cuentas `usuario@'%'` con sus contraseñas.
- 7 roles: `superadmin`, `admin`, `seller`, `buyer`, `common_user`,
  `user_not_registered`, `support`.
- Privilegios y `SET DEFAULT ROLE` para `jonhy.neri`, `marco.ramirez`,
  `luis.cazarez`, `saul.barrios` y `aylin.esteban`.
- `pablo.reyes` recibe `SELECT, INSERT, UPDATE, DELETE ON db_test.*`.
- `uriel.valenzuela` no recibe privilegios.

---

## 5. Lo que no cambió

- **15,000 productos**: checksum idéntico al original.
- **10,222 usuarios originales**: checksum idéntico al original.
- **35,543 logs históricos**: checksum idéntico al original.
- **100 categorías**, **5 métodos de pago** y **2 personas**: checksums idénticos.
- Las 18 tablas originales que no se usaron siguen vacías. La tabla
  `tbd_products_users_providers`, que también estaba vacía en el original,
  ahora contiene las 15,000 relaciones de responsabilidad.
- Los 25 objetos de tabla, 23 vistas, 72 triggers, 6 procedimientos y 2 funciones
  originales se conservan. Solo se agregaron 2 tablas y 5 FK.
- No se modificó ni eliminó ninguna fila original.
- No se remapeó `tb_people`: el alcance solicitado es la responsabilidad de
  productos, no la relación persona–usuario.

---

## 6. Validaciones ejecutadas

Todas las validaciones se ejecutaron sobre una importación limpia del archivo
transformado en MySQL 8.0.45 (se eliminaron previamente la base, los 7 usuarios
y los 7 roles para simular otra instalación).

### 6.1 Checksums contra el respaldo original

Convención: `MD5(GROUP_CONCAT(MD5(CONCAT_WS('|', HEX(CAST(col AS BINARY)), ...)) ORDER BY PK))`.
El uso de `BINARY`/`HEX` evita que el resultado dependa del charset del cliente.

| Tabla / subconjunto | Filas | MD5 actual | MD5 esperado | Estado |
|---|---:|---|---|---|
| `tb_users` (ID ≤ 10222) | 10,222 | `132f2a396a8548ff1ffb9af6c81d3732` | `132f2a396a8548ff1ffb9af6c81d3732` | OK |
| `tb_products` (todos) | 15,000 | `3e6901c46a7f237902d5406a823e7835` | `3e6901c46a7f237902d5406a823e7835` | OK |
| `tb_logs` (ID ≤ 35569) | 35,543 | `9b70a1c0e2bc7cafdf7c809f0cfe3afe` | `9b70a1c0e2bc7cafdf7c809f0cfe3afe` | OK |
| `tbc_categories` | 100 | `676d9f7f8e98d27b3a2af50014d4f7f0` | `676d9f7f8e98d27b3a2af50014d4f7f0` | OK |
| `tb_payment_methods` | 5 | `5b4c83a67e759d8037d7322e535d1125` | `5b4c83a67e759d8037d7322e535d1125` | OK |
| `tb_people` | 2 | `24088fcc2288dc4bea63218ed76afd29` | `24088fcc2288dc4bea63218ed76afd29` | OK |

### 6.2 Conteos

| Entidad | Actual | Esperado | Estado |
|---|---:|---:|---|
| `tb_users` total | 10,229 | 10,229 | OK |
| `tb_users` originales | 10,222 | 10,222 | OK |
| `tb_users` proxy | 7 | 7 | OK |
| `tb_products` | 15,000 | 15,000 | OK |
| `tb_logs` total | 50,543 | 50,543 | OK |
| `tb_logs` históricos | 35,543 | 35,543 | OK |
| `tb_logs` reasignaciones | 15,000 | 15,000 | OK |
| `tbd_products_users_providers` | 15,000 | 15,000 | OK |
| `tb_user_identity_mapping` | 7 | 7 | OK |
| `tb_product_responsibility_mapping` | 15,000 | 15,000 | OK |

### 6.3 Integridad y consistencia

| Chequeo | Resultado |
|---|---|
| Productos sin responsable | 0 |
| Productos con más de un responsable | 0 |
| Responsables con usuario/producto huérfano | 0 / 0 |
| Mapeo con producto/owner/log original/log nuevo huérfano | 0 / 0 / 0 / 0 |
| Mapeo de identidad con proxy huérfano | 0 |
| Productos fuera del mapeo | 0 |
| Diferencia owner asignado vs mapeo | 0 |
| Diferencia tipo de propiedad vs mapeo | 0 |
| Logs nuevos sin producto válido | 0 |
| Logs nuevos con ID de producto/usuario distinto al mapeo | 0 / 0 |
| Logs nuevos sin el nombre exacto del producto | 0 |
| Solapamiento de IDs entre logs históricos y nuevos | 0 |
| IDs de log duplicados | 0 |
| Correos/nick duplicados en `tb_users` | 0 / 0 |
| Filas huérfanas en las 23 FK verificables | 0 |

### 6.4 Objetos de base de datos

| Objeto | Original | Transformado | Esperado |
|---|---:|---:|---:|
| Tablas base | 25 | 27 | 27 (25 + 2) |
| Vistas | 23 | 23 | 23 |
| Triggers | 72 | 72 | 72 |
| Procedimientos | 6 | 6 | 6 |
| Funciones | 2 | 2 | 2 |
| Foreign keys | 23 | 28 | 28 (23 + 5) |

### 6.5 Importación

- Instalación limpia (sin `db_test`, sin usuarios remotos y sin roles):
  `exit=0`, sin errores SQL. Solo aparece la advertencia normal de contraseña
  en la línea de comandos.
- Segunda importación sobre la misma instalación: `exit=0`; no se duplicaron
  datos (los conteos se mantienen).
- `AUTO_INCREMENT`: `tb_users = 10230`, `tb_logs = 50570`.
- Todas las cuentas y roles se crearon; `SHOW GRANTS` confirma los privilegios.

### 6.6 Vistas

Se ejecutaron las vistas livianas. Todas responden:

| Vista | Filas |
|---|---:|
| `vw_trazabilidad_productos` | 15,000 |
| `vw_trazabilidad_proveedores_productos` | 15,000 |
| `vw_trazabilidad_usuarios` | 10,229 |
| `vw_trazabilidad_logs` | 50,543 |
| `vw_trazabilidad_consolidado_general` | 50,543 |
| `vw_trazabilidad_historial_productos` | 15,000 |
| `vw_total_products_by_category` | 100 |

`vw_trazabilidad_proveedores` no se ejecutó por la limitación descrita en la
advertencia 3.

### 6.7 Reversibilidad

El archivo transformado contiene 5 bloques marcados:

| Bloque | Bytes |
|---|---:|
| `TRANSFORM_HEADER` | 1,261 |
| `TRANSFORM_INSERT_LOGS` | 5,259,017 |
| `TRANSFORM_INSERT_PROXIES` | 1,182 |
| `TRANSFORM_INSERT_OWNERS` | 1,508,613 |
| `TRANSFORM_FOOTER` | 2,688,703 |

Al eliminarlos, el resultado es **byte a byte igual** al original
(`reversible byte a byte: True`). El original no contiene ningún marcador
`TRANSFORM_*`.

---

## 7. Advertencias e inconsistencias

### 7.1 La correspondencia es un supuesto, no un dato recibido — **alta**

No se proporcionó la tabla de correspondencias. Se usó
“creador del producto → cuenta remota”. Los productos de `root` quedaron como
`Owner` de `jonhy.neri`; los de los dos vendedores se asignaron a los dos
vendedores remotos. Si la correspondencia real difiere, los responsables
asignados no serán los esperados. Regenerar con la sección 9.

### 7.2 Usuarios proxy sintéticos — **media**

El respaldo ahora tiene 10,229 usuarios, no 10,222. Cualquier consulta o reporte
que espere exactamente 10,222 debe filtrar `ID <= 10222`. Los 7 proxies:

- No son personas reales ni están vinculados a `tb_people`.
- Tienen `status = b'0'` y `last_login = NULL`.
- Su contraseña es un placeholder conocido; si la aplicación permitiera login
  con usuarios inactivos, sería un riesgo. Cambiarla o eliminarlos si no se
  necesitan.

### 7.3 `vw_trazabilidad_proveedores` es lenta y duplica filas — **media**

La definición original hace:

```sql
LEFT JOIN tb_logs l
  ON l.table_name = 'tbd_products_users_providers'
 AND l.operation_description LIKE CONCAT('%Producto ID: ', pup.product_ID, '%')
 AND l.operation_description LIKE CONCAT('%Usuario ID: ', pup.user_ID, '%')
```

Al no haber índice posible para `LIKE '%...%'`, el motor compara 15,000 filas de
propiedad contra ~50,000 logs. En la prueba superó los 45 segundos y no terminó.
Además, el patrón no delimita el número: el producto `1` coincide también con
`Producto ID: 10`, `100`, `1000`, etc. Con los datos actuales la vista
devolvería aproximadamente **28,116 filas** en lugar de 15,000; 493 productos
tienen más de una coincidencia (el producto 1 devuelve 1,111 filas).

Esto es una **limitación heredada de la vista original**, no un cambio de la
migración. Para consultar la responsabilidad real use
`tbd_products_users_providers` o `tb_product_responsibility_mapping`, no esa
vista. Si se desea corregir, habría que reescribir la vista con una extracción
exacta del ID (por ejemplo, `SUBSTRING_INDEX`) o agregar columnas de
producto/usuario a `tb_logs`.

### 7.4 Triggers rotos en `tbd_products_users_providers` — **alta para escrituras futuras**

Los tres triggers `trg_after_insert_products_users_providers`,
`trg_after_update_products_users_providers` y
`trg_after_delete_products_users_providers` insertan en `tb_logs` las columnas
`product_id`, `user_id`, `action` y `details`, que **no existen** en `tb_logs`
(sus columnas son `ID`, `table_name`, `table_operation`, `operation`, `db_user`,
`operation_description`, `operation_date`, `operation_status`).

Por eso las 15,000 filas de propiedad se insertaron **antes** de crear los
triggers (el dump crea los triggers al final). Cualquier `INSERT`, `UPDATE` o
`DELETE` futuro sobre esa tabla fallará con `ERROR 1054 (42S22): Unknown column`.
Los triggers se conservaron tal como estaban para no alterar el esquema original.

### 7.5 Falta la tabla `tb_orders` — **alta para operaciones de pedidos**

El respaldo original referencia `tb_orders` desde 5 FK:

- `tb_buyer_orders.fk_seller_orders_order`
- `tb_order_cancellations.fk_cancellation_order`
- `tb_payments.fk_payment_order`
- `tb_returns.fk_return_order`
- `tbd_order_items.fk_order_item_order`

La tabla no existe. Las FK se conservan (MySQL las permite porque el dump
desactiva `FOREIGN_KEY_CHECKS` durante la creación), pero cualquier operación
que inserte en esas tablas fallará con `ERROR 1452`. Es una inconsistencia
heredada.

### 7.6 Procedimientos defectuosos — **media**

- `sp_insert_single_user` inserta en columnas inexistentes
  (`nickname`, `country`, `birthdate`) y usa `status` como texto
  (`'Active'`/`'Inactive'`) cuando la columna es `bit(1)`.
- `sp_generate_users_batch` depende de `sp_insert_single_user` y de estructuras
  no presentes (entre ellas `tb_cancellations`).

Se conservaron sin cambios, como el resto del esquema original.

### 7.7 El rol `seller` no puede gestionar la tabla de responsables — **media**

El script de privilegios solo otorga a `seller`:

```sql
GRANT SELECT, INSERT, UPDATE ON db_test.tb_products TO 'seller';
GRANT SELECT, INSERT ON db_test.tbc_categories TO 'seller';
```

No hay privilegios sobre `tbd_products_users_providers`. Las 15,000 asignaciones
las insertó la migración, no los vendedores. Si `saul.barrios` o
`aylin.esteban` deben modificar responsables desde la aplicación, hace falta un
`GRANT` adicional (no incluido para no alterar los privilegios aprobados):

```sql
GRANT SELECT, INSERT, UPDATE, DELETE
  ON db_test.tbd_products_users_providers TO 'seller';
```

### 7.8 Contraseñas en texto plano — **alta (seguridad)**

El archivo contiene las contraseñas de las 7 cuentas remotas, igual que el
script original. Debe tratarse como un archivo sensible, importarse solo en un
entorno controlado y cambiarse las contraseñas después de la importación.
Requiere un usuario con `CREATE USER`, `GRANT`, `CREATE ROLE` y `SET_USER_ID`
(por eso se importó como `root`).

### 7.9 Nombre de base fijo y `CREATE DATABASE` — **media**

El dump contiene `CREATE DATABASE IF NOT EXISTS db_test` y `USE db_test`. Si se
importa en una instalación que ya tenga una base `db_test`, las tablas de esa
base se eliminan y se recrean (el dump hace `DROP TABLE IF EXISTS` por tabla).
**Hacer respaldo antes de importar.** Si se desea otro nombre, hay que
reemplazar `db_test` en el archivo y ajustar las referencias de privilegios.

### 7.10 Fechas cero en productos — **baja**

`tb_products.creation_date` tiene 4,988 filas con `0000-00-00 00:00:00` en el
original. Se conservaron tal cual; el modo `NO_ZERO_DATE` del dump no las
rechaza porque el import las recrea con la misma configuración. No afectan la
reasignación (las fechas de disponibilidad se tomaron del log de creación, que
no tiene fechas cero).

### 7.11 Actor y fecha de los logs nuevos — **baja**

Los 15,000 logs nuevos usan `jonhy.neri@%` como actor y una fecha fija
(`2026-11-04 00:00:00`), porque la migración se ejecutó fuera de la aplicación.
No representan una sesión real de esa cuenta, sino la operación de migración.
Si se requiere trazabilidad real, regenerar con el usuario/fecha efectivos.

### 7.12 Las consultas de verificación originales tienen nombres incorrectos — **baja**

`Practica 03/queries/consultas_de_verificacion.sql` usa `db_users`,
`description` y `nickname`, pero el esquema real usa `db_test`,
`operation_description` y `nick`. El archivo
`consultas_verificacion_transformado.sql` ya usa los nombres correctos.

### 7.13 `tb_people` no se remapeó — **baja**

Las 2 personas siguen vinculadas a sus usuarios originales. La reasignación
solicitada es de responsabilidad de productos, no de personas. Si también se
esperaba remapear personas, es un trabajo adicional.

---

## 8. Cómo ejecutar las consultas de verificación

```bash
mysql -h 127.0.0.1 -P 3306 -u root -p \
      --default-character-set=utf8mb4 \
      < "Practica 03/queries/consultas_verificacion_transformado.sql"
```

El archivo hace `USE db_test`, fija `group_concat_max_len` y ejecuta:

1. Checksums de las 6 tablas originales contra los valores esperados.
2. Resumen de conteos.
3. Integridad referencial y consistencia del mapeo.
4. Validación de los 15,000 logs nuevos.
5. Validación de proxies y mapeo de identidad.
6. Distribución de responsabilidades.
7. Inventario de objetos.
8. Cuentas, roles y privilegios (`mysql.*`).
9. Listado y conteo de vistas.
10. Chequeo final resumido (todas las filas deben decir `OK`).

Resultado obtenido en la importación limpia: **todas las filas del chequeo final
en `OK`**.

---

## 9. Cómo regenerar con otra correspondencia

1. Editar `CREATOR_MAP` en
   `Practica 03/scripts/generate_transformed_backup.py`:

   ```python
   CREATOR_MAP = {
       "root@localhost": ("jonhy.neri", "Owner"),
       "luis.cazarez@PC-05": ("saul.barrios", "Seller"),
       "natalia.carrasco@PC-02": ("aylin.esteban", "Seller"),
   }
   ```

   Las claves son los `db_user` que aparecen en los logs de creación; los valores
   son `(login_remoto, type_ownership)`. Los logins deben existir en `PROXIES`.

2. Ejecutar:

   ```bash
   python "Practica 03/scripts/generate_transformed_backup.py"
   ```

3. Reimportar el nuevo SQL y volver a ejecutar
   `consultas_verificacion_transformado.sql`.

El generador valida que los 15,000 productos tengan exactamente un log de
creación, que el actor esté en `CREATOR_MAP` y que al quitar los bloques se
reproduzca el original byte a byte.

---

## 10. Conclusión

El respaldo transformado cumple los requisitos: conserva íntegramente el
original, mantiene productos, usuarios, roles, relaciones y logs históricos,
reasigna la responsabilidad de los 15,000 productos y registra cada reasignación
como una operación independiente. Se importó con éxito en una instalación limpia
de MySQL 8.0.45, es reimportable y todas las verificaciones de conteo, checksum
e integridad referencial pasan.

Las advertencias principales son: (a) la correspondencia aplicada es un supuesto
derivado del creador, no una tabla entregada; (b) los triggers de la tabla de
propiedad y las 5 FK hacia `tb_orders` siguen rotos, como en el original; y
(c) `vw_trazabilidad_proveedores` es inviable a esta escala por su `LIKE` con
comodín inicial. Ninguna de estas advertencias altera los datos ni las
relaciones del respaldo original.
