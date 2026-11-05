-- ============================================================================
-- CONSULTAS DE VERIFICACION - ACTUALIZACION DE tb_logs.db_user
-- Archivo respaldo: Practica 03/backups/240558_Respaldo_com_responsables_dbuser.sql
-- Base: db_test (MySQL 8.0.45)
--
-- Ejecutar sobre la base importada:
--   mysql -h 127.0.0.1 -P 3306 -u <admin> -p < consultas_verificacion_db_user.sql
-- ============================================================================

USE `db_test`;
SET SESSION group_concat_max_len = 200000000;

-- ============================================================================
-- 1. VALORES DISTINTOS DE db_user
--    Esperado: solo las 7 cuentas del script (6 con actividad + uriel sin logs).
-- ============================================================================
SELECT db_user, COUNT(*) AS registros, MIN(ID) AS min_id, MAX(ID) AS max_id
FROM `tb_logs`
GROUP BY db_user
ORDER BY registros DESC;

-- 1.1 Total de logs (debe seguir siendo 50,543)
SELECT COUNT(*) AS total_logs, COUNT(DISTINCT ID) AS ids_distintos,
       MIN(ID) AS min_id, MAX(ID) AS max_id
FROM `tb_logs`;

-- 1.2 Registros fuera del conjunto del script (esperado: 0)
SELECT COUNT(*) AS registros_fuera_del_script
FROM `tb_logs`
WHERE db_user NOT IN (
  'jonhy.neri@%','marco.ramirez@%','luis.cazarez@%','saul.barrios@%',
  'aylin.esteban@%','pablo.reyes@%','uriel.valenzuela@%'
);

-- 1.3 Referencias a los usuarios originales que debian sustituirse en db_user
--     (esperado: 0 en todas)
SELECT
  SUM(db_user = 'root@localhost')          AS root_localhost,
  SUM(db_user = 'luis.cazarez@PC-05')      AS luis_pc05,
  SUM(db_user = 'natalia.carrasco@PC-02')  AS natalia_pc02,
  SUM(db_user = 'aylin.luna@localhost')    AS aylin_luna,
  SUM(db_user = 'yazmin.esquivel@PC-03')   AS yazmin_pc03,
  SUM(db_user = 'app_web@PC-13')           AS app_web
FROM `tb_logs`;

-- 1.4 Distribucion por tabla/operacion para revisar coherencia de roles
SELECT db_user, table_name, operation, COUNT(*) AS registros
FROM `tb_logs`
GROUP BY db_user, table_name, operation
ORDER BY db_user, registros DESC;

-- ============================================================================
-- 2. INVARIANTES DE CONTENIDO
-- ============================================================================

-- 2.1 Campos distintos de db_user: no deben haber cambiado.
--     Esperado: 50,543 filas y MD5 456b766584ea8e55fced9e7760f8ec7f
SELECT
  COUNT(*) AS filas,
  MD5(GROUP_CONCAT(MD5(CONCAT_WS('|',
    IFNULL(HEX(CAST(ID AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(table_name AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(table_operation AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(operation AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(operation_description AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(operation_date AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(operation_status+0 AS BINARY)),'<NULL>')
  )) ORDER BY ID SEPARATOR '')) AS md5_sin_dbuser,
  '456b766584ea8e55fced9e7760f8ec7f' AS md5_esperado
FROM `tb_logs`;

-- 2.2 Logs completos ya normalizados.
--     Esperado: MD5 8f727defba9822b28024295a542982b2
SELECT
  COUNT(*) AS filas,
  MD5(GROUP_CONCAT(MD5(CONCAT_WS('|',
    IFNULL(HEX(CAST(ID AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(table_name AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(table_operation AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(operation AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(db_user AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(operation_description AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(operation_date AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(operation_status+0 AS BINARY)),'<NULL>')
  )) ORDER BY ID SEPARATOR '')) AS md5_completo,
  '8f727defba9822b28024295a542982b2' AS md5_esperado
FROM `tb_logs`;

-- 2.3 Productos intactos. Esperado: 15,000 filas y
--     MD5 3e6901c46a7f237902d5406a823e7835
SELECT
  COUNT(*) AS productos, MIN(ID) AS min_id, MAX(ID) AS max_id,
  MD5(GROUP_CONCAT(MD5(CONCAT_WS('|',
    IFNULL(HEX(CAST(ID AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(SKU AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(name AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(description AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(current_price AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(current_stock AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(status+0 AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(creation_date AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(last_update AS BINARY)),'<NULL>')
  )) ORDER BY ID SEPARATOR '')) AS md5_productos,
  '3e6901c46a7f237902d5406a823e7835' AS md5_esperado
FROM `tb_products`;

-- 2.4 Usuarios (10,229 = 10,222 originales + 7 proxy).
--     Esperado: MD5 bdbdfc79a950f9e63ec2c5feb89eebf9
SELECT
  COUNT(*) AS usuarios,
  MD5(GROUP_CONCAT(MD5(CONCAT_WS('|',
    IFNULL(HEX(CAST(ID AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(email AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(nick AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(password AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(creation_date AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(last_update AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(last_login AS BINARY)),'<NULL>'),
    IFNULL(HEX(CAST(status+0 AS BINARY)),'<NULL>')
  )) ORDER BY ID SEPARATOR '')) AS md5_usuarios,
  'bdbdfc79a950f9e63ec2c5feb89eebf9' AS md5_esperado
FROM `tb_users`;

-- 2.5 Relaciones conservadas (esperado: 15,000 y 15,000)
SELECT 'tbd_products_users_providers' AS tabla, COUNT(*) AS filas FROM `tbd_products_users_providers`
UNION ALL
SELECT 'tb_product_responsibility_mapping', COUNT(*) FROM `tb_product_responsibility_mapping`;

-- 2.6 Triggers y rutinas del respaldo (esperado: 72 y 8)
SELECT 'triggers' AS objeto, COUNT(*) AS total
FROM information_schema.triggers WHERE TRIGGER_SCHEMA = 'db_test'
UNION ALL
SELECT 'rutinas', COUNT(*)
FROM information_schema.routines WHERE ROUTINE_SCHEMA = 'db_test';

-- ============================================================================
-- 3. REGISTROS PENDIENTES
--    Si no se pudo determinar una correspondencia, esta consulta los lista.
--    Resultado esperado: 0 filas.
-- ============================================================================
SELECT ID, table_name, operation, db_user, operation_date
FROM `tb_logs`
WHERE db_user NOT IN (
  'jonhy.neri@%','marco.ramirez@%','luis.cazarez@%','saul.barrios@%',
  'aylin.esteban@%','pablo.reyes@%','uriel.valenzuela@%'
);
