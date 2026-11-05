-- ============================================================================
-- ACTUALIZACION DE tb_logs.db_user A LAS CUENTAS DEL SCRIPT REMOTO
-- Base: db_test (MySQL 8.0.45, 127.0.0.1:3306)
-- Ejecutado: 2026-11-04
--
-- Fuente de usuarios: Practica 03/scripts/remote_users_privileges_creation.sql
-- Este script se ejecuto realmente sobre la base (transaccion unica).
-- Solo modifica db_user; no toca ID, table_name, table_operation, operation,
-- operation_description, operation_date ni operation_status.
-- ============================================================================

-- Normalizacion de tb_logs.db_user a las cuentas del script remoto.
-- Se ejecuta en una sola transaccion sobre db_test (MySQL 8, puerto 3306).
START TRANSACTION;

UPDATE db_test.tb_logs SET db_user = 'jonhy.neri@%'      WHERE db_user = 'root@localhost';
SELECT 'root@localhost -> jonhy.neri@%' AS mapped, ROW_COUNT() AS affected;

UPDATE db_test.tb_logs SET db_user = 'saul.barrios@%'    WHERE db_user = 'luis.cazarez@PC-05';
SELECT 'luis.cazarez@PC-05 -> saul.barrios@%' AS mapped, ROW_COUNT() AS affected;

UPDATE db_test.tb_logs SET db_user = 'aylin.esteban@%'   WHERE db_user = 'natalia.carrasco@PC-02';
SELECT 'natalia.carrasco@PC-02 -> aylin.esteban@%' AS mapped, ROW_COUNT() AS affected;

UPDATE db_test.tb_logs SET db_user = 'marco.ramirez@%'   WHERE db_user = 'aylin.luna@localhost';
SELECT 'aylin.luna@localhost -> marco.ramirez@%' AS mapped, ROW_COUNT() AS affected;

UPDATE db_test.tb_logs SET db_user = 'luis.cazarez@%'    WHERE db_user = 'yazmin.esquivel@PC-03';
SELECT 'yazmin.esquivel@PC-03 -> luis.cazarez@%' AS mapped, ROW_COUNT() AS affected;

UPDATE db_test.tb_logs SET db_user = 'pablo.reyes@%'     WHERE db_user = 'app_web@PC-13';
SELECT 'app_web@PC-13 -> pablo.reyes@%' AS mapped, ROW_COUNT() AS affected;

COMMIT;

SELECT db_user, COUNT(*) AS n FROM db_test.tb_logs GROUP BY db_user ORDER BY n DESC;
SELECT COUNT(*) AS total_logs FROM db_test.tb_logs;
