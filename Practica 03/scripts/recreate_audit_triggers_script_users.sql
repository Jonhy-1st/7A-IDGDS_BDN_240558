-- ============================================================================
-- RECREACION DE LOS 72 TRIGGERS DE AUDITORIA
-- Base: db_test (MySQL 8.0.45, 127.0.0.1:3306)
-- Ejecutado: 2026-11-04
--
-- Todos los triggers que escriben en tb_logs calculan db_user con:
--   CASE SUBSTRING_INDEX(USER(),'@',1)
--     WHEN '<cuenta del script>' THEN '<cuenta>@%' ... ELSE 'jonhy.neri@%' END
-- Asi, cualquier sesion (incluida root o una cuenta heredada) produce un
-- db_user valido del script. Se conserva DEFINER=root@localhost.
--
-- Incluye la correccion de los 3 triggers de tbd_products_users_providers,
-- que insertaban columnas inexistentes (product_id, user_id, action, details).
-- ============================================================================

SET NAMES utf8mb4;
USE `db_test`;
DELIMITER $$

DROP TRIGGER IF EXISTS `trg_after_delete_products_users_providers`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_after_delete_products_users_providers` AFTER DELETE ON `tbd_products_users_providers` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
  VALUES ('tbd_products_users_providers', 'DELETE', 'Delete',
    (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END),
    CONCAT('DELETE en tbd_products_users_providers; product_ID=', OLD.product_ID, ', user_ID=', OLD.user_ID, ', type_ownership=', OLD.type_ownership, ', status=', OLD.status, ', available_date=', IFNULL(DATE_FORMAT(OLD.available_date,'%Y-%m-%d %H:%i:%s'),'NULL')),
    b'1');
END$$

DROP TRIGGER IF EXISTS `trg_after_insert_products_users_providers`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_after_insert_products_users_providers` AFTER INSERT ON `tbd_products_users_providers` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
  VALUES ('tbd_products_users_providers', 'INSERT', 'Create',
    (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END),
    CONCAT('INSERT en tbd_products_users_providers; product_ID=', NEW.product_ID, ', user_ID=', NEW.user_ID, ', type_ownership=', NEW.type_ownership, ', status=', NEW.status, ', available_date=', IFNULL(DATE_FORMAT(NEW.available_date,'%Y-%m-%d %H:%i:%s'),'NULL')),
    b'1');
END$$

DROP TRIGGER IF EXISTS `trg_after_update_products_users_providers`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_after_update_products_users_providers` AFTER UPDATE ON `tbd_products_users_providers` FOR EACH ROW
BEGIN
  INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
  VALUES ('tbd_products_users_providers', 'UPDATE', 'Update',
    (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END),
    CONCAT('UPDATE en tbd_products_users_providers; product_ID=', NEW.product_ID, ', user_ID=', NEW.user_ID, ', type_ownership_old=', OLD.type_ownership, ', type_ownership_new=', NEW.type_ownership, ', status_old=', OLD.status, ', status_new=', NEW.status, ', available_date_old=', IFNULL(DATE_FORMAT(OLD.available_date,'%Y-%m-%d %H:%i:%s'),'NULL'), ', available_date_new=', IFNULL(DATE_FORMAT(NEW.available_date,'%Y-%m-%d %H:%i:%s'),'NULL')),
    b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_buyer_orders_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_buyer_orders_delete` AFTER DELETE ON `tb_buyer_orders` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_buyer_orders', 'DELETE', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('DELETE en tb_buyer_orders; clave=', OLD.ID), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_buyer_orders_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_buyer_orders_insert` AFTER INSERT ON `tb_buyer_orders` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_buyer_orders', 'INSERT', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('INSERT en tb_buyer_orders; clave=', NEW.ID), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_buyer_orders_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_buyer_orders_update` AFTER UPDATE ON `tb_buyer_orders` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_buyer_orders', 'UPDATE', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('UPDATE en tb_buyer_orders; clave=', NEW.ID), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_carts_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_carts_delete` AFTER DELETE ON `tb_carts` FOR EACH ROW
BEGIN INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status) VALUES ('tb_carts', 'DELETE', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('DELETE en tb_carts; clave=', OLD.ID), b'1'); END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_carts_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_carts_insert` AFTER INSERT ON `tb_carts` FOR EACH ROW
BEGIN INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status) VALUES ('tb_carts', 'INSERT', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('INSERT en tb_carts; clave=', NEW.ID), b'1'); END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_carts_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_carts_update` AFTER UPDATE ON `tb_carts` FOR EACH ROW
BEGIN INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status) VALUES ('tb_carts', 'UPDATE', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('UPDATE en tb_carts; clave=', NEW.ID), b'1'); END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_order_cancellations_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_order_cancellations_delete` AFTER DELETE ON `tb_order_cancellations` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_order_cancellations', 'DELETE', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('DELETE en tb_order_cancellations; order_ID=', OLD.order_ID), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_order_cancellations_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_order_cancellations_insert` AFTER INSERT ON `tb_order_cancellations` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_order_cancellations', 'INSERT', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('INSERT en tb_order_cancellations; order_ID=', NEW.order_ID), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_order_cancellations_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_order_cancellations_update` AFTER UPDATE ON `tb_order_cancellations` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_order_cancellations', 'UPDATE', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('UPDATE en tb_order_cancellations; order_ID=', NEW.order_ID), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_payment_methods_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_payment_methods_delete` AFTER DELETE ON `tb_payment_methods` FOR EACH ROW
BEGIN INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status) VALUES ('tb_payment_methods', 'DELETE', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('DELETE en tb_payment_methods; clave=', OLD.ID), b'1'); END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_payment_methods_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_payment_methods_insert` AFTER INSERT ON `tb_payment_methods` FOR EACH ROW
BEGIN INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status) VALUES ('tb_payment_methods', 'INSERT', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('INSERT en tb_payment_methods; clave=', NEW.ID), b'1'); END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_payment_methods_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_payment_methods_update` AFTER UPDATE ON `tb_payment_methods` FOR EACH ROW
BEGIN INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status) VALUES ('tb_payment_methods', 'UPDATE', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('UPDATE en tb_payment_methods; clave=', NEW.ID), b'1'); END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_payment_transaction_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_payment_transaction_delete` AFTER DELETE ON `tb_payment_transaction` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_payment_transaction', 'DELETE', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('DELETE en tb_payment_transaction; payment_ID=', OLD.payment_ID), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_payment_transaction_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_payment_transaction_insert` AFTER INSERT ON `tb_payment_transaction` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_payment_transaction', 'INSERT', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('INSERT en tb_payment_transaction; payment_ID=', NEW.payment_ID), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_payment_transaction_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_payment_transaction_update` AFTER UPDATE ON `tb_payment_transaction` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_payment_transaction', 'UPDATE', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('UPDATE en tb_payment_transaction; payment_ID=', NEW.payment_ID), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_payments_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_payments_delete` AFTER DELETE ON `tb_payments` FOR EACH ROW
BEGIN INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status) VALUES ('tb_payments', 'DELETE', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('DELETE en tb_payments; clave=', OLD.ID), b'1'); END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_payments_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_payments_insert` AFTER INSERT ON `tb_payments` FOR EACH ROW
BEGIN INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status) VALUES ('tb_payments', 'INSERT', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('INSERT en tb_payments; clave=', NEW.ID), b'1'); END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_payments_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_payments_update` AFTER UPDATE ON `tb_payments` FOR EACH ROW
BEGIN INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status) VALUES ('tb_payments', 'UPDATE', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('UPDATE en tb_payments; clave=', NEW.ID), b'1'); END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_refunds_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_refunds_delete` AFTER DELETE ON `tb_refunds` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_refunds', 'DELETE', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('DELETE en tb_refunds; clave=', OLD.refund_ID), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_refunds_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_refunds_insert` AFTER INSERT ON `tb_refunds` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_refunds', 'INSERT', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('INSERT en tb_refunds; clave=', NEW.refund_ID), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_refunds_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_refunds_update` AFTER UPDATE ON `tb_refunds` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_refunds', 'UPDATE', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('UPDATE en tb_refunds; clave=', NEW.refund_ID), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_returns_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_returns_delete` AFTER DELETE ON `tb_returns` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_returns', 'DELETE', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('DELETE en tb_returns; clave=', OLD.return_ID), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_returns_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_returns_insert` AFTER INSERT ON `tb_returns` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_returns', 'INSERT', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('INSERT en tb_returns; clave=', NEW.return_ID), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_returns_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_returns_update` AFTER UPDATE ON `tb_returns` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_returns', 'UPDATE', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('UPDATE en tb_returns; clave=', NEW.return_ID), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_shipments_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_shipments_delete` AFTER DELETE ON `tb_shipments` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_shipments', 'DELETE', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('DELETE en tb_shipments; clave=', OLD.shipment_ID), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_shipments_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_shipments_insert` AFTER INSERT ON `tb_shipments` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_shipments', 'INSERT', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('INSERT en tb_shipments; clave=', NEW.shipment_ID), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_shipments_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_shipments_update` AFTER UPDATE ON `tb_shipments` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_shipments', 'UPDATE', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('UPDATE en tb_shipments; clave=', NEW.shipment_ID), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_user_addresses_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_user_addresses_delete` AFTER DELETE ON `tb_user_addresses` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_user_addresses', 'DELETE', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('DELETE en tb_user_addresses; id=', OLD.id, ', user_id=', OLD.user_id), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_user_addresses_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_user_addresses_insert` AFTER INSERT ON `tb_user_addresses` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_user_addresses', 'INSERT', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('INSERT en tb_user_addresses; id=', NEW.id, ', user_id=', NEW.user_id), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tb_user_addresses_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tb_user_addresses_update` AFTER UPDATE ON `tb_user_addresses` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tb_user_addresses', 'UPDATE', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('UPDATE en tb_user_addresses; id=', NEW.id, ', user_id=', NEW.user_id), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tbc_payment_methods_types_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbc_payment_methods_types_delete` AFTER DELETE ON `tbc_payment_methods_types` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tbc_payment_methods_types', 'DELETE', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('DELETE en tbc_payment_methods_types; id=', OLD.id, ', name=', OLD.name), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tbc_payment_methods_types_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbc_payment_methods_types_insert` AFTER INSERT ON `tbc_payment_methods_types` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tbc_payment_methods_types', 'INSERT', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('INSERT en tbc_payment_methods_types; id=', NEW.id, ', name=', NEW.name), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tbc_payment_methods_types_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbc_payment_methods_types_update` AFTER UPDATE ON `tbc_payment_methods_types` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tbc_payment_methods_types', 'UPDATE', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('UPDATE en tbc_payment_methods_types; id=', NEW.id, ', name=', NEW.name), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_address_components_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_address_components_delete` AFTER DELETE ON `tbd_address_components` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tbd_address_components', 'DELETE', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('DELETE en tbd_address_components; id=', OLD.id, ', user_address_id=', OLD.user_address_id), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_address_components_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_address_components_insert` AFTER INSERT ON `tbd_address_components` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tbd_address_components', 'INSERT', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('INSERT en tbd_address_components; id=', NEW.id, ', user_address_id=', NEW.user_address_id), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_address_components_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_address_components_update` AFTER UPDATE ON `tbd_address_components` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tbd_address_components', 'UPDATE', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('UPDATE en tbd_address_components; id=', NEW.id, ', user_address_id=', NEW.user_address_id), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_cancellation_items_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_cancellation_items_delete` AFTER DELETE ON `tbd_cancellation_items` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tbd_cancellation_items', 'DELETE', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('DELETE en tbd_cancellation_items; id=', OLD.id, ', cancellation_id=', OLD.cancellation_id), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_cancellation_items_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_cancellation_items_insert` AFTER INSERT ON `tbd_cancellation_items` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tbd_cancellation_items', 'INSERT', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('INSERT en tbd_cancellation_items; id=', NEW.id, ', cancellation_id=', NEW.cancellation_id), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_cancellation_items_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_cancellation_items_update` AFTER UPDATE ON `tbd_cancellation_items` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tbd_cancellation_items', 'UPDATE', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('UPDATE en tbd_cancellation_items; id=', NEW.id, ', cancellation_id=', NEW.cancellation_id), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_cart_items_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_cart_items_delete` AFTER DELETE ON `tbd_cart_items` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tbd_cart_items', 'DELETE', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('DELETE en tbd_cart_items; id=', OLD.id, ', cart_id=', OLD.cart_id, ', product_id=', OLD.product_id), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_cart_items_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_cart_items_insert` AFTER INSERT ON `tbd_cart_items` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tbd_cart_items', 'INSERT', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('INSERT en tbd_cart_items; id=', NEW.id, ', cart_id=', NEW.cart_id, ', product_id=', NEW.product_id), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_cart_items_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_cart_items_update` AFTER UPDATE ON `tbd_cart_items` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tbd_cart_items', 'UPDATE', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('UPDATE en tbd_cart_items; id=', NEW.id, ', cart_id=', NEW.cart_id, ', product_id=', NEW.product_id), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_order_items_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_order_items_delete` AFTER DELETE ON `tbd_order_items` FOR EACH ROW
BEGIN INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status) VALUES ('tbd_order_items', 'DELETE', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('DELETE en tbd_order_items; clave=', CONCAT(OLD.order_ID, '/', OLD.product_offer_ID)), b'1'); END$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_order_items_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_order_items_insert` AFTER INSERT ON `tbd_order_items` FOR EACH ROW
BEGIN INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status) VALUES ('tbd_order_items', 'INSERT', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('INSERT en tbd_order_items; clave=', CONCAT(NEW.order_ID, '/', NEW.product_offer_ID)), b'1'); END$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_order_items_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_order_items_update` AFTER UPDATE ON `tbd_order_items` FOR EACH ROW
BEGIN INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status) VALUES ('tbd_order_items', 'UPDATE', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('UPDATE en tbd_order_items; clave=', CONCAT(NEW.order_ID, '/', NEW.product_offer_ID)), b'1'); END$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_return_items_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_return_items_delete` AFTER DELETE ON `tbd_return_items` FOR EACH ROW
INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
VALUES ('tbd_return_items', 'DELETE', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('DELETE en tbd_return_items; ID=', OLD.ID, ', return_ID=', OLD.return_ID), b'1')$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_return_items_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_return_items_insert` AFTER INSERT ON `tbd_return_items` FOR EACH ROW
INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
VALUES ('tbd_return_items', 'INSERT', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('INSERT en tbd_return_items; ID=', NEW.ID, ', return_ID=', NEW.return_ID), b'1')$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_return_items_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_return_items_update` AFTER UPDATE ON `tbd_return_items` FOR EACH ROW
INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
VALUES ('tbd_return_items', 'UPDATE', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('UPDATE en tbd_return_items; ID=', NEW.ID, ', return_ID=', NEW.return_ID), b'1')$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_user_payment_methods_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_user_payment_methods_delete` AFTER DELETE ON `tbd_user_payment_methods` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tbd_user_payment_methods', 'DELETE', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('DELETE en tbd_user_payment_methods; id=', OLD.id, ', user_id=', OLD.user_id), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_user_payment_methods_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_user_payment_methods_insert` AFTER INSERT ON `tbd_user_payment_methods` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tbd_user_payment_methods', 'INSERT', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('INSERT en tbd_user_payment_methods; id=', NEW.id, ', user_id=', NEW.user_id), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_user_payment_methods_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_user_payment_methods_update` AFTER UPDATE ON `tbd_user_payment_methods` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status)
    VALUES ('tbd_user_payment_methods', 'UPDATE', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('UPDATE en tbd_user_payment_methods; id=', NEW.id, ', user_id=', NEW.user_id), b'1');
END$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_users_wishlist_products_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_users_wishlist_products_delete` AFTER DELETE ON `tbd_users_wishlist_products` FOR EACH ROW
BEGIN INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status) VALUES ('tbd_users_wishlist_products', 'DELETE', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('DELETE en tbd_users_wishlist_products; clave=', CONCAT(OLD.user_id, '/', OLD.product_id)), b'1'); END$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_users_wishlist_products_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_users_wishlist_products_insert` AFTER INSERT ON `tbd_users_wishlist_products` FOR EACH ROW
BEGIN INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status) VALUES ('tbd_users_wishlist_products', 'INSERT', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('INSERT en tbd_users_wishlist_products; clave=', CONCAT(NEW.user_id, '/', NEW.product_id)), b'1'); END$$

DROP TRIGGER IF EXISTS `trg_audit_tbd_users_wishlist_products_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_audit_tbd_users_wishlist_products_update` AFTER UPDATE ON `tbd_users_wishlist_products` FOR EACH ROW
BEGIN INSERT INTO tb_logs (table_name, table_operation, operation, db_user, operation_description, operation_status) VALUES ('tbd_users_wishlist_products', 'UPDATE', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('UPDATE en tbd_users_wishlist_products; clave=', CONCAT(NEW.user_id, '/', NEW.product_id)), b'1'); END$$

DROP TRIGGER IF EXISTS `trg_people_after_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_people_after_delete` AFTER DELETE ON `tb_people` FOR EACH ROW
BEGIN
    INSERT INTO `tb_logs` (
        `table_name`,
        `operation`,
        `db_user`,
        `operation_description`,
        `operation_status`
    ) VALUES (
        'tb_people',
        'Delete',
        (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END),
        CONCAT('Registro eliminado. ID=', OLD.person_ID, ', user_ID=', OLD.user_ID),
        1
    );
END$$

DROP TRIGGER IF EXISTS `trg_people_after_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_people_after_insert` AFTER INSERT ON `tb_people` FOR EACH ROW
BEGIN
    INSERT INTO `tb_logs` (
        `table_name`,
        `operation`,
        `db_user`,
        `operation_description`,
        `operation_status`
    ) VALUES (
        'tb_people',
        'Create',
        (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END),
        CONCAT('Registro creado. ID=', NEW.person_ID, ', user_ID=', NEW.user_ID),
        1
    );
END$$

DROP TRIGGER IF EXISTS `trg_people_after_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_people_after_update` AFTER UPDATE ON `tb_people` FOR EACH ROW
BEGIN
    INSERT INTO `tb_logs` (
        `table_name`,
        `operation`,
        `db_user`,
        `operation_description`,
        `operation_status`
    ) VALUES (
        'tb_people',
        'Update',
        (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END),
        CONCAT('Registro actualizado. ID=', NEW.person_ID, ', user_ID=', NEW.user_ID),
        1
    );
END$$

DROP TRIGGER IF EXISTS `trg_tb_products_after_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_tb_products_after_delete` AFTER DELETE ON `tb_products` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, operation, db_user, operation_description, operation_date, operation_status, table_operation)
    VALUES ('tb_products', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('Producto eliminado ID: ', OLD.ID, ' - Nombre: ', OLD.name), NOW(), b'1', 'DELETE');
END$$

DROP TRIGGER IF EXISTS `trg_tb_products_after_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_tb_products_after_insert` AFTER INSERT ON `tb_products` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, operation, db_user, operation_description, operation_date, operation_status, table_operation)
    VALUES ('tb_products', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('Producto creado ID: ', NEW.ID, ' - Nombre: ', NEW.name), NOW(), b'1', 'INSERT');
END$$

DROP TRIGGER IF EXISTS `trg_tb_products_after_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_tb_products_after_update` AFTER UPDATE ON `tb_products` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, operation, db_user, operation_description, operation_date, operation_status, table_operation)
    VALUES ('tb_products', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('Producto actualizado ID: ', NEW.ID, ' - Nombre: ', NEW.name), NOW(), b'1', 'UPDATE');
END$$

DROP TRIGGER IF EXISTS `trg_tb_users_after_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_tb_users_after_delete` AFTER DELETE ON `tb_users` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, operation, db_user, operation_description, operation_date, operation_status, table_operation)
    VALUES ('tb_users', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('Usuario eliminado ID: ', OLD.ID, ' - Nick: ', OLD.nick), NOW(), b'1', 'DELETE');
END$$

DROP TRIGGER IF EXISTS `trg_tb_users_after_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_tb_users_after_insert` AFTER INSERT ON `tb_users` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, operation, db_user, operation_description, operation_date, operation_status, table_operation)
    VALUES ('tb_users', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('Usuario creado ID: ', NEW.ID, ' - Nick: ', NEW.nick), NOW(), b'1', 'INSERT');
END$$

DROP TRIGGER IF EXISTS `trg_tb_users_after_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_tb_users_after_update` AFTER UPDATE ON `tb_users` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, operation, db_user, operation_description, operation_date, operation_status, table_operation)
    VALUES ('tb_users', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('Usuario actualizado ID: ', NEW.ID, ' - Nick: ', NEW.nick), NOW(), b'1', 'UPDATE');
END$$

DROP TRIGGER IF EXISTS `trg_tbc_categories_after_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_tbc_categories_after_delete` AFTER DELETE ON `tbc_categories` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, operation, db_user, operation_description, operation_date, operation_status, table_operation)
    VALUES ('tbc_categories', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('Categor├¡a eliminada ID: ', OLD.ID, ' - Nombre: ', OLD.name), NOW(), b'1', 'DELETE');
END$$

DROP TRIGGER IF EXISTS `trg_tbc_categories_after_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_tbc_categories_after_insert` AFTER INSERT ON `tbc_categories` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, operation, db_user, operation_description, operation_date, operation_status, table_operation)
    VALUES ('tbc_categories', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('Categor├¡a creada ID: ', NEW.ID, ' - Nombre: ', NEW.name), NOW(), b'1', 'INSERT');
END$$

DROP TRIGGER IF EXISTS `trg_tbc_categories_after_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_tbc_categories_after_update` AFTER UPDATE ON `tbc_categories` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, operation, db_user, operation_description, operation_date, operation_status, table_operation)
    VALUES ('tbc_categories', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('Categor├¡a actualizada ID: ', NEW.ID, ' - Nombre: ', NEW.name), NOW(), b'1', 'UPDATE');
END$$

DROP TRIGGER IF EXISTS `trg_tbd_prod_cat_after_delete`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_tbd_prod_cat_after_delete` AFTER DELETE ON `tbd_products_categories` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, operation, db_user, operation_description, operation_date, operation_status, table_operation)
    VALUES ('tbd_products_categories', 'Delete', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('Relaci├│n eliminada - Producto ID: ', OLD.product_ID, ' | Categor├¡a ID: ', OLD.category_ID), NOW(), b'1', 'DELETE');
END$$

DROP TRIGGER IF EXISTS `trg_tbd_prod_cat_after_insert`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_tbd_prod_cat_after_insert` AFTER INSERT ON `tbd_products_categories` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, operation, db_user, operation_description, operation_date, operation_status, table_operation)
    VALUES ('tbd_products_categories', 'Create', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('Relaci├│n creada - Producto ID: ', NEW.product_ID, ' | Categor├¡a ID: ', NEW.category_ID), NOW(), b'1', 'INSERT');
END$$

DROP TRIGGER IF EXISTS `trg_tbd_prod_cat_after_update`$$
CREATE DEFINER='root'@'localhost' TRIGGER `trg_tbd_prod_cat_after_update` AFTER UPDATE ON `tbd_products_categories` FOR EACH ROW
BEGIN
    INSERT INTO tb_logs (table_name, operation, db_user, operation_description, operation_date, operation_status, table_operation)
    VALUES ('tbd_products_categories', 'Update', (CASE SUBSTRING_INDEX(USER(),'@',1) WHEN 'jonhy.neri' THEN 'jonhy.neri@%' WHEN 'marco.ramirez' THEN 'marco.ramirez@%' WHEN 'luis.cazarez' THEN 'luis.cazarez@%' WHEN 'saul.barrios' THEN 'saul.barrios@%' WHEN 'aylin.esteban' THEN 'aylin.esteban@%' WHEN 'pablo.reyes' THEN 'pablo.reyes@%' WHEN 'uriel.valenzuela' THEN 'uriel.valenzuela@%' ELSE 'jonhy.neri@%' END), CONCAT('Relaci├│n actualizada - Producto ID: ', NEW.product_ID, ' | Categor├¡a ID: ', NEW.category_ID), NOW(), b'1', 'UPDATE');
END$$

DELIMITER ;
