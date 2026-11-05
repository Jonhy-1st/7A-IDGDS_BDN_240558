-- ============================================================================
-- CONSULTAS DE VERIFICACION - RESPALDO TRANSFORMADO
-- Archivo: Practica 03/backups/240558_Respaldo_com_responsables.sql
-- Base: db_test (MySQL 8.0)
--
-- Ejecutar como root sobre la base recien importada:
--   mysql -h 127.0.0.1 -P 3306 -u root -p < consultas_verificacion_transformado.sql
--
-- Cada consulta devuelve los valores actuales y, cuando aplica, el valor
-- esperado contra el respaldo original 240558_Respaldo_com.sql.
--
-- NOTA: los MD5 de tb_logs de este archivo son del estado PREVIO a la
-- normalizacion de db_user (2026-11-04). Para el estado final usar
-- consultas_verificacion_db_user.sql.
-- ============================================================================

USE `db_test`;
SET SESSION group_concat_max_len = 200000000;

-- ============================================================================
-- 1. CHEQUES DE CONTENIDO ORIGINAL (subconjunto sin cambios)
--    Los MD5 deben coincidir con el respaldo original.
-- ============================================================================

-- 1.1 Usuarios originales (IDs 1-10222). Esperado: 10222 filas,
--     MD5 132f2a396a8548ff1ffb9af6c81d3732
SELECT
  'tb_users' AS tabla,
  COUNT(*) AS filas_actuales,
  10222 AS filas_esperadas,
  MD5(GROUP_CONCAT(MD5(CONCAT_WS('|',IFNULL(HEX(CAST(`ID` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`email` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`nick` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`password` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`creation_date` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`last_update` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`last_login` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`status`+0 AS BINARY)),'<NULL>'))) ORDER BY `ID` SEPARATOR '')) AS md5_actual,
  '132f2a396a8548ff1ffb9af6c81d3732' AS md5_esperado
FROM `tb_users` WHERE `ID` <= 10222;

-- 1.2 Productos (todos originales). Esperado: 15000 filas,
--     MD5 3e6901c46a7f237902d5406a823e7835
SELECT
  'tb_products' AS tabla,
  COUNT(*) AS filas_actuales,
  15000 AS filas_esperadas,
  MD5(GROUP_CONCAT(MD5(CONCAT_WS('|',IFNULL(HEX(CAST(`ID` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`SKU` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`name` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`description` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`current_price` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`current_stock` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`status`+0 AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`creation_date` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`last_update` AS BINARY)),'<NULL>'))) ORDER BY `ID` SEPARATOR '')) AS md5_actual,
  '3e6901c46a7f237902d5406a823e7835' AS md5_esperado
FROM `tb_products`;

-- 1.3 Logs historicos originales (IDs 1-35569). Esperado: 35543 filas,
--     MD5 9b70a1c0e2bc7cafdf7c809f0cfe3afe
SELECT
  'tb_logs' AS tabla,
  COUNT(*) AS filas_actuales,
  35543 AS filas_esperadas,
  MD5(GROUP_CONCAT(MD5(CONCAT_WS('|',IFNULL(HEX(CAST(`ID` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`table_name` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`table_operation` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`operation` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`db_user` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`operation_description` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`operation_date` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`operation_status`+0 AS BINARY)),'<NULL>'))) ORDER BY `ID` SEPARATOR '')) AS md5_actual,
  '9b70a1c0e2bc7cafdf7c809f0cfe3afe' AS md5_esperado
FROM `tb_logs` WHERE `ID` <= 35569;

-- 1.4 Categorias. Esperado: 100 filas, MD5 676d9f7f8e98d27b3a2af50014d4f7f0
SELECT
  'tbc_categories' AS tabla,
  COUNT(*) AS filas_actuales,
  100 AS filas_esperadas,
  MD5(GROUP_CONCAT(MD5(CONCAT_WS('|',IFNULL(HEX(CAST(`ID` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`name` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`description` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`sup_id_category` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`status`+0 AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`creation_date` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`last_update` AS BINARY)),'<NULL>'))) ORDER BY `ID` SEPARATOR '')) AS md5_actual,
  '676d9f7f8e98d27b3a2af50014d4f7f0' AS md5_esperado
FROM `tbc_categories`;

-- 1.5 Metodos de pago. Esperado: 5 filas, MD5 5b4c83a67e759d8037d7322e535d1125
SELECT
  'tb_payment_methods' AS tabla,
  COUNT(*) AS filas_actuales,
  5 AS filas_esperadas,
  MD5(GROUP_CONCAT(MD5(CONCAT_WS('|',IFNULL(HEX(CAST(`ID` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`code` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`name` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`status`+0 AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`creation_date` AS BINARY)),'<NULL>'))) ORDER BY `ID` SEPARATOR '')) AS md5_actual,
  '5b4c83a67e759d8037d7322e535d1125' AS md5_esperado
FROM `tb_payment_methods`;

-- 1.6 Personas. Esperado: 2 filas, MD5 24088fcc2288dc4bea63218ed76afd29
SELECT
  'tb_people' AS tabla,
  COUNT(*) AS filas_actuales,
  2 AS filas_esperadas,
  MD5(GROUP_CONCAT(MD5(CONCAT_WS('|',IFNULL(HEX(CAST(`person_ID` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`user_ID` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`courtesy_title` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`given_names` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`family_names` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`birth_date` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`gender_ID` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`country_code` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`phone` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`status`+0 AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`creation_date` AS BINARY)),'<NULL>'),IFNULL(HEX(CAST(`last_update` AS BINARY)),'<NULL>'))) ORDER BY `person_ID` SEPARATOR '')) AS md5_actual,
  '24088fcc2288dc4bea63218ed76afd29' AS md5_esperado
FROM `tb_people`;

-- ============================================================================
-- 2. RESUMEN DE FILAS (original vs transformado)
-- ============================================================================
SELECT 'tb_users (total)'            AS entidad, COUNT(*) AS filas, 10229 AS esperado FROM `tb_users`
UNION ALL SELECT 'tb_users (originales)',      COUNT(*), 10222 FROM `tb_users` WHERE `ID` <= 10222
UNION ALL SELECT 'tb_users (proxy)',            COUNT(*), 7     FROM `tb_users` WHERE `ID` BETWEEN 10223 AND 10229
UNION ALL SELECT 'tb_products',                COUNT(*), 15000 FROM `tb_products`
UNION ALL SELECT 'tb_logs (total)',            COUNT(*), 50543 FROM `tb_logs`
UNION ALL SELECT 'tb_logs (historicos)',       COUNT(*), 35543 FROM `tb_logs` WHERE `ID` <= 35569
UNION ALL SELECT 'tb_logs (reasignaciones)',   COUNT(*), 15000 FROM `tb_logs` WHERE `ID` BETWEEN 35570 AND 50569
UNION ALL SELECT 'tbd_products_users_providers', COUNT(*), 15000 FROM `tbd_products_users_providers`
UNION ALL SELECT 'tb_user_identity_mapping',   COUNT(*), 7     FROM `tb_user_identity_mapping`
UNION ALL SELECT 'tb_product_responsibility_mapping', COUNT(*), 15000 FROM `tb_product_responsibility_mapping`;

-- 2.1 Tablas originales que deben permanecer vacías (esperado 0 en todas)
SELECT 'tb_buyer_orders'           AS tabla, COUNT(*) AS filas, 0 AS esperado FROM `tb_buyer_orders`
UNION ALL SELECT 'tb_carts',                    COUNT(*), 0 FROM `tb_carts`
UNION ALL SELECT 'tb_order_cancellations',      COUNT(*), 0 FROM `tb_order_cancellations`
UNION ALL SELECT 'tb_payment_transaction',      COUNT(*), 0 FROM `tb_payment_transaction`
UNION ALL SELECT 'tb_payments',                 COUNT(*), 0 FROM `tb_payments`
UNION ALL SELECT 'tb_refunds',                  COUNT(*), 0 FROM `tb_refunds`
UNION ALL SELECT 'tb_returns',                  COUNT(*), 0 FROM `tb_returns`
UNION ALL SELECT 'tb_shipments',                COUNT(*), 0 FROM `tb_shipments`
UNION ALL SELECT 'tb_user_addresses',           COUNT(*), 0 FROM `tb_user_addresses`
UNION ALL SELECT 'tbc_payment_methods_types',   COUNT(*), 0 FROM `tbc_payment_methods_types`
UNION ALL SELECT 'tbd_address_components',      COUNT(*), 0 FROM `tbd_address_components`
UNION ALL SELECT 'tbd_cancellation_items',      COUNT(*), 0 FROM `tbd_cancellation_items`
UNION ALL SELECT 'tbd_cart_items',              COUNT(*), 0 FROM `tbd_cart_items`
UNION ALL SELECT 'tbd_order_items',             COUNT(*), 0 FROM `tbd_order_items`
UNION ALL SELECT 'tbd_products_categories',     COUNT(*), 0 FROM `tbd_products_categories`
UNION ALL SELECT 'tbd_return_items',            COUNT(*), 0 FROM `tbd_return_items`
UNION ALL SELECT 'tbd_user_payment_methods',    COUNT(*), 0 FROM `tbd_user_payment_methods`
UNION ALL SELECT 'tbd_users_wishlist_products', COUNT(*), 0 FROM `tbd_users_wishlist_products`;

-- ============================================================================
-- 3. INTEGRIDAD REFERENCIAL
-- ============================================================================

-- 3.1 Productos sin responsable (esperado 0)
SELECT 'productos_sin_responsable' AS chequeo, COUNT(*) AS actual, 0 AS esperado
FROM `tb_products` p
LEFT JOIN `tbd_products_users_providers` o ON o.`product_ID` = p.`ID`
WHERE o.`product_ID` IS NULL;

-- 3.2 Productos con mas de un responsable (esperado 0)
SELECT 'productos_con_multiples_responsables' AS chequeo, COUNT(*) AS actual, 0 AS esperado
FROM (
  SELECT `product_ID` FROM `tbd_products_users_providers`
  GROUP BY `product_ID` HAVING COUNT(*) > 1
) x;

-- 3.3 Responsables huerfanos de usuario o producto (esperado 0 y 0)
SELECT
  SUM(u.`ID` IS NULL) AS usuario_huerfano,
  SUM(p.`ID` IS NULL) AS producto_huerfano,
  0 AS esperado
FROM `tbd_products_users_providers` o
LEFT JOIN `tb_users` u    ON u.`ID` = o.`user_ID`
LEFT JOIN `tb_products` p ON p.`ID` = o.`product_ID`;

-- 3.4 Mapeo de responsabilidad: referencias huerfanas (esperado 0 en cada columna)
SELECT
  SUM(p.`ID` IS NULL)  AS producto_huerfano,
  SUM(u.`ID` IS NULL)  AS owner_huerfano,
  SUM(lo.`ID` IS NULL) AS log_origen_huerfano,
  SUM(ln.`ID` IS NULL) AS log_nuevo_huerfano,
  0 AS esperado
FROM `tb_product_responsibility_mapping` m
LEFT JOIN `tb_products` p ON p.`ID` = m.`product_ID`
LEFT JOIN `tb_users` u    ON u.`ID` = m.`new_owner_user_ID`
LEFT JOIN `tb_logs` lo    ON lo.`ID` = m.`original_creation_log_ID`
LEFT JOIN `tb_logs` ln    ON ln.`ID` = m.`reassignment_log_ID`;

-- 3.5 Mapeo de identidad: proxy huerfano (esperado 0)
SELECT 'identity_proxy_huerfano' AS chequeo, COUNT(*) AS actual, 0 AS esperado
FROM `tb_user_identity_mapping` i
LEFT JOIN `tb_users` u ON u.`ID` = i.`proxy_user_ID`
WHERE u.`ID` IS NULL;

-- 3.6 Todos los productos estan en el mapeo (esperado 0)
SELECT 'productos_no_mapeados' AS chequeo, COUNT(*) AS actual, 0 AS esperado
FROM `tb_products` p
LEFT JOIN `tb_product_responsibility_mapping` m ON m.`product_ID` = p.`ID`
WHERE m.`product_ID` IS NULL;

-- 3.7 Consistencia responsable asignado vs mapeo (esperado 0 y 0)
SELECT
  SUM(o.`user_ID` <> m.`new_owner_user_ID`)       AS owner_distinto,
  SUM(o.`type_ownership` <> m.`new_type_ownership`) AS tipo_distinto,
  0 AS esperado
FROM `tb_product_responsibility_mapping` m
JOIN `tbd_products_users_providers` o ON o.`product_ID` = m.`product_ID`;

-- 3.8 Nota: las 5 FK que apuntan a `tb_orders` no pueden validarse porque esa
-- tabla no existe en el respaldo original (inconsistencia heredada):
--   fk_seller_orders_order, fk_cancellation_order, fk_payment_order,
--   fk_return_order, fk_order_item_order

-- ============================================================================
-- 4. LOGS DE REASIGNACION
-- ============================================================================

-- 4.1 Rango y cantidad (esperado 35570-50569, 15000)
SELECT
  MIN(`ID`) AS min_id,
  MAX(`ID`) AS max_id,
  COUNT(*)  AS filas,
  COUNT(DISTINCT `ID`) AS ids_distintos
FROM `tb_logs` WHERE `ID` BETWEEN 35570 AND 50569;

-- 4.2 Un log de reasignacion por producto (esperado 15000 distintos y 0 sin log)
SELECT
  COUNT(DISTINCT CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(`operation_description`,'Producto ID: ',-1),';',1) AS UNSIGNED)) AS productos_distintos,
  SUM(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(`operation_description`,'Producto ID: ',-1),';',1) AS UNSIGNED) NOT BETWEEN 1 AND 15000) AS fuera_de_rango
FROM `tb_logs` WHERE `ID` BETWEEN 35570 AND 50569;

-- 4.3 Todos los logs nuevos los genero la cuenta de migracion (esperado 15000)
SELECT 'logs_actor_jonhy_neri' AS chequeo, COUNT(*) AS actual, 15000 AS esperado
FROM `tb_logs`
WHERE `ID` BETWEEN 35570 AND 50569
  AND `db_user` = 'jonhy.neri@%'
  AND `table_name` = 'tbd_products_users_providers'
  AND `table_operation` = 'INSERT'
  AND `operation` = 'Create'
  AND `operation_date` = '2026-11-04 00:00:00'
  AND `operation_status` = b'1';

-- 4.4 La descripcion contiene el ID y el usuario del mapeo (esperado 0)
SELECT 'logs_nuevos_inconsistentes_con_mapeo' AS chequeo, COUNT(*) AS actual, 0 AS esperado
FROM `tb_logs` l
JOIN `tb_product_responsibility_mapping` m ON m.`reassignment_log_ID` = l.`ID`
WHERE CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(l.`operation_description`,'Producto ID: ',-1),';',1) AS UNSIGNED) <> m.`product_ID`
   OR CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(l.`operation_description`,'Usuario ID: ',-1),';',1) AS UNSIGNED) <> m.`new_owner_user_ID`;

-- 4.5 La descripcion contiene el nombre exacto del producto (esperado 0)
SELECT 'logs_sin_nombre_exacto' AS chequeo, COUNT(*) AS actual, 0 AS esperado
FROM `tb_logs` l
JOIN `tb_product_responsibility_mapping` m ON m.`reassignment_log_ID` = l.`ID`
JOIN `tb_products` p ON p.`ID` = m.`product_ID`
WHERE l.`operation_description` NOT LIKE CONCAT('%nombre=', p.`name`, '%');

-- 4.6 No hay solapamiento de IDs entre logs historicos y nuevos (esperado 0)
SELECT 'solapamiento_ids_log' AS chequeo, COUNT(*) AS actual, 0 AS esperado
FROM `tb_logs` a JOIN `tb_logs` b ON a.`ID` = b.`ID`
WHERE a.`ID` <= 35569 AND b.`ID` >= 35570;

-- 4.7 AUTO_INCREMENT de tb_logs (esperado 50570)
SELECT AUTO_INCREMENT AS auto_increment_logs, 50570 AS esperado
FROM information_schema.tables
WHERE table_schema = 'db_test' AND table_name = 'tb_logs';

-- ============================================================================
-- 5. USUARIOS PROXY Y MAPEO DE IDENTIDAD
-- ============================================================================

-- 5.1 Proxy: 7 filas, inactivos, sin login, patron de correo/nick
SELECT
  COUNT(*) AS total,
  SUM(`status` = b'0')         AS inactivos,
  SUM(`last_login` IS NULL)    AS sin_login,
  SUM(`email` LIKE 'proxy+%@remote.invalid') AS correos_proxy,
  SUM(`nick` LIKE 'remote\_%') AS nicks_proxy,
  7 AS esperado
FROM `tb_users` WHERE `ID` BETWEEN 10223 AND 10229;

-- 5.2 Detalle de proxies
SELECT `ID`, `email`, `nick`, `status`+0 AS status, `last_login`
FROM `tb_users` WHERE `ID` BETWEEN 10223 AND 10229 ORDER BY `ID`;

-- 5.3 Mapeo identidad -> roles remotos
SELECT `mapping_ID`, `proxy_user_ID`, `remote_login`, `remote_host`, `remote_role`, `can_login`
FROM `tb_user_identity_mapping` ORDER BY `mapping_ID`;

-- 5.4 AUTO_INCREMENT de tb_users (esperado 10230)
SELECT AUTO_INCREMENT AS auto_increment_users, 10230 AS esperado
FROM information_schema.tables
WHERE table_schema = 'db_test' AND table_name = 'tb_users';

-- ============================================================================
-- 6. DISTRIBUCION DE RESPONSABILIDADES
-- ============================================================================
SELECT
  m.`original_creator_db_user` AS creador_original,
  m.`new_owner_db_user`        AS nuevo_responsable,
  m.`new_type_ownership`       AS tipo,
  COUNT(*)                     AS productos
FROM `tb_product_responsibility_mapping` m
GROUP BY m.`original_creator_db_user`, m.`new_owner_db_user`, m.`new_type_ownership`
ORDER BY productos DESC;

SELECT
  u.`ID` AS user_id,
  u.`nick`,
  o.`type_ownership`,
  COUNT(*) AS productos
FROM `tbd_products_users_providers` o
JOIN `tb_users` u ON u.`ID` = o.`user_ID`
GROUP BY u.`ID`, u.`nick`, o.`type_ownership`
ORDER BY productos DESC;

-- ============================================================================
-- 7. INVENTARIO DE OBJETOS
--    Esperado: 27 tablas (25 originales + 2 de mapeo), 23 vistas,
--    72 triggers, 6 procedimientos, 2 funciones, 28 FK (23 + 5 nuevas).
-- ============================================================================
SELECT 'tablas_base' AS objeto, COUNT(*) AS cantidad, 27 AS esperado
FROM information_schema.tables WHERE table_schema='db_test' AND table_type='BASE TABLE'
UNION ALL SELECT 'vistas', COUNT(*), 23
FROM information_schema.views WHERE table_schema='db_test'
UNION ALL SELECT 'triggers', COUNT(*), 72
FROM information_schema.triggers WHERE trigger_schema='db_test'
UNION ALL SELECT 'procedimientos', COUNT(*), 6
FROM information_schema.routines WHERE routine_schema='db_test' AND routine_type='PROCEDURE'
UNION ALL SELECT 'funciones', COUNT(*), 2
FROM information_schema.routines WHERE routine_schema='db_test' AND routine_type='FUNCTION'
UNION ALL SELECT 'foreign_keys', COUNT(*), 28
FROM information_schema.table_constraints WHERE table_schema='db_test' AND constraint_type='FOREIGN KEY';

-- 7.1 Tablas de mapeo presentes
SELECT `table_name`, `table_rows`
FROM information_schema.tables
WHERE table_schema='db_test'
  AND table_name IN ('tb_user_identity_mapping','tb_product_responsibility_mapping');

-- ============================================================================
-- 8. CUENTAS, ROLES Y PRIVILEGIOS (requiere privilegios sobre mysql.*)
-- ============================================================================

-- 8.1 Cuentas remotas (esperado 7)
SELECT `user`, `host`, `account_locked`
FROM `mysql`.`user`
WHERE `user` IN ('jonhy.neri','marco.ramirez','luis.cazarez','saul.barrios',
                 'aylin.esteban','pablo.reyes','uriel.valenzuela')
ORDER BY `user`;

-- 8.2 Roles (esperado 7)
SELECT `user`, `host`, `account_locked`
FROM `mysql`.`user`
WHERE `user` IN ('superadmin','admin','seller','buyer','common_user',
                 'user_not_registered','support')
ORDER BY `user`;

-- 8.3 Roles asignados
SELECT `FROM_USER` AS rol, `TO_USER` AS cuenta
FROM `mysql`.`role_edges`
WHERE `TO_USER` IN ('jonhy.neri','marco.ramirez','luis.cazarez',
                    'saul.barrios','aylin.esteban')
ORDER BY `TO_USER`;

-- 8.4 Roles por defecto
SELECT `USER`, `HOST`, `DEFAULT_ROLE_USER`
FROM `mysql`.`default_roles`
WHERE `USER` IN ('jonhy.neri','marco.ramirez','luis.cazarez',
                 'saul.barrios','aylin.esteban')
ORDER BY `USER`;

-- ============================================================================
-- 9. VISTAS
--    Se listan las 23 vistas. NO se ejecuta vw_trazabilidad_proveedores:
--    su definicion original usa LIKE '%...%' sin indice y, con 15,000 filas
--    de propiedad, tarda minutos y devuelve filas duplicadas por prefijos
--    (p. ej. el producto 1 coincide con "Producto ID: 10"). Es una
--    limitacion heredada del respaldo original, no un cambio de esta
--    migracion. Para comprobarla use:
--      EXPLAIN SELECT * FROM vw_trazabilidad_proveedores;
-- ============================================================================
SELECT `table_name` AS vista
FROM information_schema.views
WHERE `table_schema` = 'db_test'
ORDER BY `table_name`;

-- 9.1 Conteos de las vistas livianas
SELECT 'vw_trazabilidad_productos' AS vista, COUNT(*) AS filas FROM `vw_trazabilidad_productos`
UNION ALL SELECT 'vw_trazabilidad_proveedores_productos', COUNT(*) FROM `vw_trazabilidad_proveedores_productos`
UNION ALL SELECT 'vw_trazabilidad_usuarios', COUNT(*) FROM `vw_trazabilidad_usuarios`
UNION ALL SELECT 'vw_trazabilidad_logs', COUNT(*) FROM `vw_trazabilidad_logs`
UNION ALL SELECT 'vw_trazabilidad_consolidado_general', COUNT(*) FROM `vw_trazabilidad_consolidado_general`
UNION ALL SELECT 'vw_trazabilidad_historial_productos', COUNT(*) FROM `vw_trazabilidad_historial_productos`
UNION ALL SELECT 'vw_total_products_by_category', COUNT(*) FROM `vw_total_products_by_category`;

-- ============================================================================
-- 10. CHEQUEO FINAL RESUMIDO
--     Todas las columnas "estado" deben valer OK.
-- ============================================================================
SELECT 'productos_sin_responsable' AS chequeo,
       IF(COUNT(*) = 0, 'OK', 'FALLA') AS estado
FROM `tb_products` p
LEFT JOIN `tbd_products_users_providers` o ON o.`product_ID` = p.`ID`
WHERE o.`product_ID` IS NULL
UNION ALL
SELECT 'multiples_responsables',
       IF(COUNT(*) = 0, 'OK', 'FALLA')
FROM (SELECT `product_ID` FROM `tbd_products_users_providers`
      GROUP BY `product_ID` HAVING COUNT(*) > 1) x
UNION ALL
SELECT 'logs_nuevos_completos',
       IF(COUNT(*) = 15000, 'OK', 'FALLA')
FROM `tb_logs` WHERE `ID` BETWEEN 35570 AND 50569
UNION ALL
SELECT 'logs_historicos_intactos',
       IF(COUNT(*) = 35543, 'OK', 'FALLA')
FROM `tb_logs` WHERE `ID` <= 35569
UNION ALL
SELECT 'productos_intactos',
       IF(COUNT(*) = 15000, 'OK', 'FALLA')
FROM `tb_products`
UNION ALL
SELECT 'usuarios_originales_intactos',
       IF(COUNT(*) = 10222, 'OK', 'FALLA')
FROM `tb_users` WHERE `ID` <= 10222
UNION ALL
SELECT 'mapeo_responsabilidad_completo',
       IF(COUNT(*) = 15000, 'OK', 'FALLA')
FROM `tb_product_responsibility_mapping`
UNION ALL
SELECT 'mapeo_identidad_completo',
       IF(COUNT(*) = 7, 'OK', 'FALLA')
FROM `tb_user_identity_mapping`;
