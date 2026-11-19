-- Verificacion de la carga de categorizacion de productos.
-- Ejecutar despues de cargar Practica 03/scripts/cargar_categorizacion_productos.sql.

USE `db_test`;

-- Todo producto debe tener al menos una categoria activa. Esperado: 0.
SELECT COUNT(*) AS `productos_sin_categoria_activa`
FROM `tb_products` p
LEFT JOIN `tbd_products_categories` pc
  ON pc.`product_ID` = p.`ID`
  AND pc.`status` = b'1'
WHERE pc.`product_ID` IS NULL;

-- Cobertura del catalogo. Esperado: 15000 productos y 15000 con categoria activa.
SELECT COUNT(*) AS `total_productos`,
       COUNT(DISTINCT CASE WHEN pc.`status` = b'1' THEN p.`ID` END) AS `productos_categorizados`
FROM `tb_products` p
LEFT JOIN `tbd_products_categories` pc ON pc.`product_ID` = p.`ID`;

-- Distribucion de asignaciones activas por categoria.
SELECT c.`ID`, c.`name`, COUNT(DISTINCT pc.`product_ID`) AS `productos`
FROM `tbc_categories` c
LEFT JOIN `tbd_products_categories` pc
  ON pc.`category_ID` = c.`ID`
  AND pc.`status` = b'1'
GROUP BY c.`ID`, c.`name`
HAVING COUNT(DISTINCT pc.`product_ID`) > 0
ORDER BY c.`ID`;

-- Referencias invalidas. Esperado: 0.
SELECT COUNT(*) AS `relaciones_huerfanas`
FROM `tbd_products_categories` pc
LEFT JOIN `tb_products` p ON p.`ID` = pc.`product_ID`
LEFT JOIN `tbc_categories` c ON c.`ID` = pc.`category_ID`
WHERE p.`ID` IS NULL OR c.`ID` IS NULL;
