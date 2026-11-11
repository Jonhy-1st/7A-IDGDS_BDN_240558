# Normalización de usuarios en `respaldo_compra`

Se generó `backups/respaldo_compra_usuarios.sql` a partir de `backups/respaldo_compra.sql`. El respaldo original se conserva. En la copia solo se cambiaron los valores de `tb_logs.db_user`; las demás columnas y tablas se mantuvieron iguales.

## Mapeo aplicado

| Usuario de origen | Usuario del proyecto | Criterio |
|---|---|---|
| `root@localhost`, `jonhy.neri@192.168.1.79` | `jonhy.neri@%` | Superadmin / misma cuenta |
| `carlos.morales@192.168.1.79` | `luis.cazarez@%` | Sus registros crean usuarios; `support` tiene permisos acotados sobre `tb_users` |
| `angel.barrios@PC-06`, `angel.barrios@PC-Angel` | `saul.barrios@%` | Registros de categorías y relaciones producto-categoría; `seller` tiene esos permisos |
| `aylin.luna@10.10.60.7`, `aylin.luna@DESKTOP-978SUTP`, `aylin.luna@PC-Angel` | `aylin.esteban@%` | Predominan altas de productos; corresponde al rol `seller` y conserva el nombre Aylin |
| `luis.cazarez@localhost`, `luis.cazarez@host.docker.internal` | `luis.cazarez@%` | Misma cuenta de soporte; operaciones en usuarios/categorías |
| `saul.barrios@PC-06` | `saul.barrios@%` | Misma cuenta seller |
| `app_web@localhost` | `pablo.reyes@%` | Correspondencia establecida en la normalización anterior |
| `app_movil@localhost` | `uriel.valenzuela@%` | Segunda cuenta de usuario asociada a la aplicación móvil |

## Resultado

La tabla contiene 48,775 registros de log. Después del cambio quedan seis cuentas con actividad: Jonhy (20,079), Luis (10,002), Saul (9,645), Aylin (8,975), Pablo (72) y Uriel (2). Marco y el segundo seller no tenían alias de origen asignados en estos registros.

La operación se realizó sobre la columna `db_user` ubicada en el esquema de logs de este respaldo. No se modificaron los usuarios de otras tablas ni las descripciones almacenadas en los logs.
