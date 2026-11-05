# Reporte de actualización de `tb_logs.db_user`

**Práctica 03 · Base `db_test` · MySQL 8.0.45 · `127.0.0.1:3306`**

Fecha de ejecución: 2026-11-04

---

## 1. Resumen ejecutivo

Se actualizó directamente la base `db_test` para que `tb_logs.db_user` use
**exclusivamente** las cuentas definidas en
`Practica 03/scripts/remote_users_privileges_creation.sql`. Los `UPDATE` se
ejecutaron en una sola transacción y los 72 triggers de auditoría se recrearon
para que los logs nuevos también usen esas cuentas.

| Concepto | Resultado |
|---|---|
| Registros de `tb_logs` actualizados | **35,543** |
| Registros de `tb_logs` antes / después | 50,543 / **50,543** |
| IDs distintos antes / después | 50,543 / **50,543** |
| Valores de `db_user` fuera del script | **0** |
| Referencias a usuarios originales en `db_user` | **0** |
| Productos antes / después | 15,000 / **15,000** |
| Triggers recreados | **72** (incluye 3 triggers roto que se corrigieron) |
| Rutinas conservadas | **8** |
| Respaldo actualizado | `Practica 03/backups/240558_Respaldo_com_responsables_dbuser.sql` |

**SHA-256 del respaldo actualizado:**
`2dbdf3d092ef49a3ab97f68ab8df92bceaee390900e2c3456f4e0241801bdd97`

El respaldo original `240558_Respaldo_com.sql` **no fue modificado**
(SHA-256 `196ce17f770fa3c0dc2d1bc4120bb4ca5c8ec79905e98766b49f4250f67186da`).

---

## 2. Correspondencia aplicada

> **Supuesto:** no se proporcionó una tabla de correspondencias explícita. La
> asignación se derivó combinando el nombre de la cuenta, el tipo de operación
> histórica y los privilegios/roles del script. Se priorizó la **coherencia de
> rol** sobre la coincidencia literal de nombres.

| `db_user` original | Operaciones originales | Cuenta del script | Rol / privilegio | Justificación |
|---|---|---:|---|---|
| `root@localhost` | 10,222 (10,219 usuarios, 2 productos, 1 persona) | `jonhy.neri@%` | `superadmin`, `ALL ON *.*` | Única cuenta global capaz de crear usuarios y personas en cualquier esquema. |
| `aylin.luna@localhost` | 10,215 (10,213 usuarios, 1 categoría, 1 actualización) | `marco.ramirez@%` | `admin`, `ALL ON db_test.*` | Actividad administrativa sobre usuarios y catálogo de `db_test`. |
| `luis.cazarez@PC-05` | 10,005 (creación de productos) | `saul.barrios@%` | `seller` | Seller con `INSERT` en `tb_products`; coincide con la reasignación ya registrada. |
| `natalia.carrasco@PC-02` | 4,994 (4,993 productos, 1 usuario) | `aylin.esteban@%` | `seller` | Seller con `INSERT` en `tb_products`; coincide con la reasignación ya registrada. |
| `yazmin.esquivel@PC-03` | 105 (categorías y actualizaciones de usuarios) | `luis.cazarez@%` | `support` | Support tiene `SELECT/INSERT/UPDATE` sobre `tb_users` y `tbc_categories`. |
| `app_web@PC-13` | 2 (1 usuario, 1 persona) | `pablo.reyes@%` | DML sobre `db_test.*` | Cuenta de aplicación con `SELECT/INSERT/UPDATE/DELETE` en todo `db_test`. |
| `jonhy.neri@%` | 15,000 (reasignaciones) | `jonhy.neri@%` | `superadmin` | Ya era una cuenta del script; no se modificó. |

Notas:

- `uriel.valenzuela@%` no recibe registros porque ninguna actividad original es
  compatible con su cuenta `USAGE` (sin privilegios). No se inventó actividad.
- `aylin.luna@localhost` **no** se asignó a `aylin.esteban` aunque comparta
  nombre: `aylin.esteban` es `seller` y no puede crear usuarios, mientras que
  `aylin.luna` realizó 10,213 creaciones en `tb_users`.
- `luis.cazarez@PC-05` **no** se asignó a `luis.cazarez` (support) porque ese
  usuario no puede insertar en `tb_products`.
- El único log de `tb_users` atribuido a `natalia.carrasco@PC-02` se conserva con
  `aylin.esteban@%` para no fragmentar una misma identidad original entre dos
  cuentas; es 1 registro de 4,994.
- El detalle de productos ya reasignados sigue en
  `Practica 03/reportes/correspondencias_responsables.csv`.

---

## 3. Ejecución de los `UPDATE`

Se ejecutó una única transacción sobre `db_test`:

| Sentencia | Filas afectadas |
|---|---:|
| `root@localhost` → `jonhy.neri@%` | 10,222 |
| `luis.cazarez@PC-05` → `saul.barrios@%` | 10,005 |
| `natalia.carrasco@PC-02` → `aylin.esteban@%` | 4,994 |
| `aylin.luna@localhost` → `marco.ramirez@%` | 10,215 |
| `yazmin.esquivel@PC-03` → `luis.cazarez@%` | 105 |
| `app_web@PC-13` → `pablo.reyes@%` | 2 |
| **Total** | **35,543** |

El script ejecutado se conserva en
`Practica 03/scripts/update_db_user_to_script_users.sql`.

Solo se modificó la columna `db_user`. Permanecen intactos `ID`, `table_name`,
`table_operation`, `operation`, `operation_description`, `operation_date` y
`operation_status`; además, no se eliminó ningún registro.

---

## 4. Triggers de auditoría

Los 72 triggers que escriben en `tb_logs` fueron recreados con la misma lógica
funcional, pero calculando `db_user` así:

```sql
CASE SUBSTRING_INDEX(USER(),'@',1)
  WHEN 'jonhy.neri'      THEN 'jonhy.neri@%'
  WHEN 'marco.ramirez'   THEN 'marco.ramirez@%'
  WHEN 'luis.cazarez'    THEN 'luis.cazarez@%'
  WHEN 'saul.barrios'    THEN 'saul.barrios@%'
  WHEN 'aylin.esteban'   THEN 'aylin.esteban@%'
  WHEN 'pablo.reyes'     THEN 'pablo.reyes@%'
  WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%'
  ELSE 'jonhy.neri@%'
END
```

Motivos:

- `USER()` devuelve la cuenta de la sesión que ejecuta la operación; se normaliza
  el host a `%` para que coincida con el formato del script (por ejemplo,
  `saul.barrios@localhost` → `saul.barrios@%`).
- Se usa `USER()` en lugar de `CURRENT_USER()` porque, dentro de un trigger con
  `DEFINER=root@localhost`, `CURRENT_USER()` devuelve el definer (`root`) y no
  el operador real.
- La cláusula `ELSE` garantiza que incluso una sesión `root` o una cuenta
  heredada escriba una cuenta válida del script.

Se corrigieron además los 3 triggers de `tbd_products_users_providers`
(`trg_after_insert_products_users_providers`,
`trg_after_update_products_users_providers`,
`trg_after_delete_products_users_providers`), que insertaban columnas
inexistentes en `tb_logs` (`product_id`, `user_id`, `action`, `details`) y
fallaban en cada operación. Ahora escriben `table_name`, `table_operation`,
`operation`, `db_user`, `operation_description`, `operation_date` y
`operation_status`.

Se conservó `DEFINER=root@localhost` en los 72 triggers, igual que en el
respaldo original. El SQL aplicado está en
`Practica 03/scripts/recreate_audit_triggers_script_users.sql`.

Pruebas realizadas (dentro de transacciones con `ROLLBACK`, sin dejar basura):

| Sesión | Operación | `db_user` generado |
|---|---|---|
| `pablo.reyes` | `INSERT` en `tbc_categories` | `pablo.reyes@%` |
| `pablo.reyes` | `INSERT` en `tbd_products_users_providers` | `pablo.reyes@%` |
| `jonhy.neri` | `INSERT` en `tbd_products_users_providers` | `jonhy.neri@%` |

Después de cada prueba, `tb_logs` volvió a 50,543 y las relaciones a 15,000.

---

## 5. Verificación final

Consultas completas en `Practica 03/queries/consultas_verificacion_db_user.sql`.

### 5.1 Valores distintos de `db_user`

| `db_user` | Registros |
|---|---:|
| `jonhy.neri@%` | 25,222 |
| `marco.ramirez@%` | 10,215 |
| `saul.barrios@%` | 10,005 |
| `aylin.esteban@%` | 4,994 |
| `luis.cazarez@%` | 105 |
| `pablo.reyes@%` | 2 |

`jonhy.neri@%` incluye 15,000 reasignaciones previas + 10,222 registros que antes
eran de `root@localhost`. No aparece `uriel.valenzuela@%` porque no tiene
actividad, pero sí está definido en el script.

### 5.2 Chequeos

| Chequeo | Esperado | Obtenido |
|---|---:|---:|
| Total de logs | 50,543 | **50,543** |
| IDs distintos | 50,543 | **50,543** |
| `db_user` fuera del script | 0 | **0** |
| `root@localhost`, `luis.cazarez@PC-05`, `natalia.carrasco@PC-02`, `aylin.luna@localhost`, `yazmin.esquivel@PC-03`, `app_web@PC-13` en `db_user` | 0 | **0** |
| Productos | 15,000 | **15,000** |
| Relaciones producto-responsable | 15,000 | **15,000** |
| Filas de mapeo de responsabilidad | 15,000 | **15,000** |
| Triggers | 72 | **72** |
| Rutinas | 8 | **8** |

### 5.3 Integridad de los campos no modificados

| Conjunto | MD5 esperado | MD5 obtenido |
|---|---|---|
| `tb_logs` sin `db_user` (50,543 filas) | `456b766584ea8e55fced9e7760f8ec7f` | **coincide** |
| `tb_products` (15,000 filas) | `3e6901c46a7f237902d5406a823e7835` | **coincide** |
| `tb_users` (10,229 filas) | `bdbdfc79a950f9e63ec2c5feb89eebf9` | **coincide** |

También se compararon, antes y después, los archivos completos de
`tb_products`, `tb_users`, `tbd_products_users_providers`,
`tb_product_responsibility_mapping` y `tbc_categories`: **SHA-256 idéntico**.

---

## 6. Respaldo actualizado

| Concepto | Valor |
|---|---|
| Archivo | `Practica 03/backups/240558_Respaldo_com_responsables_dbuser.sql` |
| Tamaño | 19,554,921 bytes |
| SHA-256 | `2dbdf3d092ef49a3ab97f68ab8df92bceaee390900e2c3456f4e0241801bdd97` |
| Contenido | 27 tablas, datos, 72 triggers, 8 rutinas, cuentas/roles/privilegios |
| Importación de prueba | MySQL 8.0.45 en `127.0.0.1:3307`, `exit=0` |

La importación se hizo sobre una base limpia y se comparó contra la base viva:

| Conjunto | Resultado |
|---|---|
| `tb_logs` completo | SHA-256 idéntico |
| `tb_logs` sin `db_user` | SHA-256 idéntico |
| `tb_products`, `tb_users`, `tbd_products_users_providers`, `tb_product_responsibility_mapping`, `tbc_categories` | SHA-256 idéntico |
| Conteos | 10,229 / 15,000 / 50,543 / 15,000 / 15,000 |
| Triggers / rutinas | 72 / 8 |

---

## 7. Advertencias y observaciones

1. **Correspondencia asumida.** No se recibió una tabla oficial de
   correspondencias. La asignación de la sección 2 es la interpretación más
   coherente con roles y actividad. Si el profesor/equipo define otra
   correspondencia, basta reejecutar los `UPDATE` del script con el mapeo
   corregido; la estructura y los conteos no cambian.
2. **Trazabilidad histórica.** `operation_description` de los 15,000 logs de
   reasignación y la columna
   `tb_product_responsibility_mapping.original_creator_db_user` conservan, por
   diseño, los nombres de los actores originales. **No se modificaron** porque
   la instrucción prohíbe alterar `operation_description` y porque esa columna
   documenta el origen histórico. No son el campo `db_user`.
3. **Productos.** La base contiene **15,000** productos, no 10,000. No se
   modificó ninguno; se verificó por conteo, IDs y MD5.
4. **Credenciales y roles.** No se alteró ninguna contraseña, rol ni privilegio
   de las cuentas del script.
5. **Respaldo original.** `240558_Respaldo_com.sql` permanece byte a byte
   intacto; solo se creó un archivo nuevo.
6. **Contraseñas en texto plano.** El respaldo actualizado incluye el bloque de
   creación de cuentas del script, tal como el original. Debe manejarse en un
   entorno controlado.
7. **Respaldo previo a los cambios.**
   `Practica 03/backups/240558_Respaldo_pre_dbuser_20261104.sql` es una copia de
   seguridad tomada justo antes de los `UPDATE` (tablas y triggers; no incluye
   rutinas porque la cuenta usada entonces no tenía `SHOW_ROUTINE`).

---

## 8. Archivos entregados

| Archivo | Contenido |
|---|---|
| `Practica 03/backups/240558_Respaldo_com_responsables_dbuser.sql` | Respaldo actualizado, listo para importar |
| `Practica 03/queries/consultas_verificacion_db_user.sql` | Consultas de verificación con valores esperados |
| `Practica 03/scripts/update_db_user_to_script_users.sql` | `UPDATE` aplicados (transacción) |
| `Practica 03/scripts/recreate_audit_triggers_script_users.sql` | DDL de los 72 triggers recreados |
| `Practica 03/reportes/REPORTE_ACTUALIZACION_DB_USER.md` | Este reporte |
| `Practica 03/reportes/correspondencias_responsables.csv` | Detalle de las 15,000 reasignaciones |
