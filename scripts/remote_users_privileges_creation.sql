/* CREACION DE USUARIOS REMOTOS */

CREATE USER IF NOT EXISTS 'jonhy.neri'@'%' IDENTIFIED BY '240558'; -- superadmin
CREATE USER IF NOT EXISTS 'marco.ramirez'@'%' IDENTIFIED BY 'qwerty123'; -- admin 
CREATE USER IF NOT EXISTS 'luis.cazarez'@'%' IDENTIFIED BY '240343'; -- supp
CREATE USER IF NOT EXISTS 'saul.barrios'@'%' IDENTIFIED BY '240196'; -- seller 1
CREATE USER IF NOT EXISTS 'aylin.esteban'@'%' IDENTIFIED BY '240873'; -- seller 2
CREATE USER IF NOT EXISTS 'pablo.reyes'@'%' IDENTIFIED BY '240148'; -- usuario 1
CREATE USER IF NOT EXISTS 'uriel.valenzuela'@'%' IDENTIFIED BY '240485';-- usuario 2


/* ASIGNACION DE PRIVILEGIOS DEL SUPER USUARIO  - IMPORTANTE: SOLO USTEDES */
GRANT ALL PRIVILEGES ON *.* TO 'jonhy.neri'@'%' WITH GRANT OPTION;

GRANT SELECT, INSERT, UPDATE , DELETE ON db_test.* TO 'pablo.reyes'@'%';

/*CREACION DE ROLES PARA LOS USUARIOS DE LA PLATAFORMA DE ECOMMERCE */
CREATE ROLE IF NOT EXISTS 'superadmin';
CREATE ROLE IF NOT EXISTS 'admin';
CREATE ROLE IF NOT EXISTS 'seller';
CREATE ROLE IF NOT EXISTS 'buyer';
CREATE ROLE IF NOT EXISTS 'common_user';
CREATE ROLE IF NOT EXISTS 'user_not_registered';
CREATE ROLE IF NOT EXISTS 'support';

/* ASIGNACION DE PRIVILEGIOS A LOS ROLES DE LA PLATAFORMA DE ECOMMERCE */
GRANT ALL PRIVILEGES ON *.* TO 'superadmin';
-- ADMIN
GRANT ALL PRIVILEGES ON db_test.* TO 'admin';
-- SUPPORT
GRANT SELECT, INSERT, UPDATE ON db_test.tb_users TO 'support';
GRANT SELECT, INSERT, UPDATE ON db_test.tb_products TO 'support';
-- SELLER
GRANT SELECT, INSERT, UPDATE ON db_test.tb_products TO 'seller';

/* ASIGNAR EL ROL AL USUARIO*/
GRANT 'superadmin' TO 'jonhy.neri'@'%';
GRANT 'admin' TO 'marco.ramirez'@'%';
GRANT 'support' TO 'luis.cazarez'@'%';
GRANT 'seller' To 'saul.barrios'@'%';
GRANT 'seller' To 'aylin.esteban'@'%';

SET DEFAULT ROLE 'superadmin' TO 'jonhy.neri'@'%';
SET DEFAULT ROLE 'admin' TO 'marco.ramirez'@'%';
SET DEFAULT ROLE 'support' TO 'luis.cazarez'@'%';
SET DEFAULT ROLE 'seller' To 'saul.barrios'@'%';
SET DEFAULT ROLE 'seller' To 'aylin.esteban'@'%';

-- MENSAJE DE CONFIRMACION
SELECT "Los usuarios y privilegios han sido creados correctamente" AS mensaje;