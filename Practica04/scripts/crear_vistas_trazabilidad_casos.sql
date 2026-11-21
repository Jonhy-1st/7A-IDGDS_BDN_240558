-- Vistas de lectura para reproducir las consultas de Trazabilidades/image.png.
-- Requiere db_test y MySQL 8.x. No modifica datos ni crea tablas.
-- Los IDs de pedido corresponden a la ejecución documentada en
-- queries/verificacion_casos_compra.sql (3, 4, 5, 6, 7 y 8).
-- Si se restauró otra ejecución, actualizar el filtro de pedido de cada vista.

USE `db_test`;

CREATE OR REPLACE VIEW `vw_practica04_trazabilidad_base` AS
SELECT
  l.ID AS `log_ID`,
  COALESCE(
    direct_order.ID,
    payment_order.ID,
    transaction_order.ID,
    seller_order.order_ID,
    item_order.ID,
    shipment_order.ID,
    return_row.order_ID,
    cancellation_row.order_ID,
    cancellation_item_order.ID,
    refund_order.ID,
    cart_item_order.ID,
    people_order.ID,
    address_order.ID,
    address_component_order.ID,
    user_order.ID
  ) AS `pedido_ID`,
  CASE
    WHEN l.table_name = 'tb_buyer_orders' THEN 'Compra'
    WHEN l.table_name IN ('tb_carts', 'tbd_cart_items') THEN 'Carrito'
    WHEN l.table_name IN ('tb_users', 'tb_people', 'tb_user_addresses', 'tbd_address_components') THEN 'Registro'
    ELSE 'Compra'
  END AS `fase`,
  SUBSTRING_INDEX(l.db_user, '@', 1) AS `usuario_ejecutor`,
  l.db_user AS `conexion_bd`,
  l.operation_date AS `fecha_evento`,
  l.table_name AS `tabla_modificada`,
  l.table_operation AS `operacion`,
  COALESCE(l.operation_description, l.description) AS `detalle_evento`,
  IF(COALESCE(l.operation_status, b'1') = b'1', 'Evento registrado', 'Operación fallida') AS `resultado`
FROM tb_logs AS l
LEFT JOIN tb_buyer_orders AS direct_order
  ON l.table_name = 'tb_buyer_orders'
 AND direct_order.ID = CAST(REGEXP_SUBSTR(
       REGEXP_SUBSTR(COALESCE(l.description, ''), 'ID=[0-9]+'), '[0-9]+'
     ) AS UNSIGNED)
LEFT JOIN tb_payments AS payment_row
  ON l.table_name = 'tb_payments'
 AND payment_row.ID = CAST(REGEXP_SUBSTR(
       REGEXP_SUBSTR(COALESCE(l.description, ''), 'ID=[0-9]+'), '[0-9]+'
     ) AS UNSIGNED)
LEFT JOIN tb_buyer_orders AS payment_order ON payment_order.ID = payment_row.order_ID
LEFT JOIN tb_payment_transactions AS transaction_row
  ON l.table_name = 'tb_payment_transactions'
 AND transaction_row.ID = CAST(REGEXP_SUBSTR(
       REGEXP_SUBSTR(COALESCE(l.description, ''), 'ID=[0-9]+'), '[0-9]+'
     ) AS UNSIGNED)
LEFT JOIN tb_payments AS transaction_payment ON transaction_payment.ID = transaction_row.payment_ID
LEFT JOIN tb_buyer_orders AS transaction_order ON transaction_order.ID = transaction_payment.order_ID
LEFT JOIN tb_seller_orders AS seller_order
  ON l.table_name = 'tb_seller_orders'
 AND seller_order.ID = CAST(REGEXP_SUBSTR(
       REGEXP_SUBSTR(COALESCE(l.description, ''), 'ID=[0-9]+'), '[0-9]+'
     ) AS UNSIGNED)
LEFT JOIN tbd_order_items AS order_item
  ON l.table_name = 'tbd_order_items'
 AND order_item.ID = CAST(REGEXP_SUBSTR(
       REGEXP_SUBSTR(COALESCE(l.description, ''), 'ID=[0-9]+'), '[0-9]+'
     ) AS UNSIGNED)
LEFT JOIN tb_seller_orders AS item_seller_order ON item_seller_order.ID = order_item.seller_order_ID
LEFT JOIN tb_buyer_orders AS item_order ON item_order.ID = item_seller_order.order_ID
LEFT JOIN tb_shipments AS shipment_row
  ON l.table_name = 'tb_shipments'
 AND shipment_row.shipment_ID = CAST(REGEXP_SUBSTR(
       REGEXP_SUBSTR(COALESCE(l.description, ''), 'ID=[0-9]+'), '[0-9]+'
     ) AS UNSIGNED)
LEFT JOIN tb_seller_orders AS shipment_seller_order
  ON shipment_seller_order.ID = shipment_row.seller_order_ID
LEFT JOIN tb_buyer_orders AS shipment_order ON shipment_order.ID = shipment_seller_order.order_ID
LEFT JOIN tb_returns AS return_row
  ON l.table_name = 'tb_returns'
 AND return_row.return_ID = CAST(REGEXP_SUBSTR(
       REGEXP_SUBSTR(COALESCE(l.description, ''), 'ID=[0-9]+'), '[0-9]+'
     ) AS UNSIGNED)
LEFT JOIN tb_order_cancellations AS cancellation_row
  ON l.table_name = 'tb_order_cancellations'
 AND cancellation_row.cancellation_ID = CAST(REGEXP_SUBSTR(
       REGEXP_SUBSTR(COALESCE(l.description, ''), 'ID=[0-9]+'), '[0-9]+'
     ) AS UNSIGNED)
LEFT JOIN tbd_cancellation_items AS cancellation_item
  ON l.table_name = 'tbd_cancellation_items'
 AND cancellation_item.id = CAST(REGEXP_SUBSTR(
       REGEXP_SUBSTR(COALESCE(l.description, ''), 'id=[0-9]+'), '[0-9]+'
     ) AS UNSIGNED)
LEFT JOIN tb_order_cancellations AS cancellation_item_parent
  ON cancellation_item_parent.cancellation_ID = cancellation_item.cancellation_id
LEFT JOIN tb_buyer_orders AS cancellation_item_order
  ON cancellation_item_order.ID = cancellation_item_parent.order_ID
LEFT JOIN tb_refunds AS refund_row
  ON l.table_name = 'tb_refunds'
 AND refund_row.refund_ID = CAST(REGEXP_SUBSTR(
       REGEXP_SUBSTR(COALESCE(l.description, ''), 'ID=[0-9]+'), '[0-9]+'
     ) AS UNSIGNED)
LEFT JOIN tb_payments AS refund_payment ON refund_payment.ID = refund_row.payment_ID
LEFT JOIN tb_buyer_orders AS refund_order ON refund_order.ID = refund_payment.order_ID
LEFT JOIN tbd_cart_items AS cart_item_row
  ON l.table_name = 'tbd_cart_items'
 AND cart_item_row.cart_ID = CAST(REGEXP_SUBSTR(
       REGEXP_SUBSTR(COALESCE(l.description, ''), 'cart_ID=[0-9]+'), '[0-9]+'
     ) AS UNSIGNED)
LEFT JOIN tb_carts AS cart_row ON cart_row.ID = cart_item_row.cart_ID
LEFT JOIN tb_buyer_orders AS cart_item_order ON cart_item_order.user_ID = cart_row.user_ID
LEFT JOIN tb_people AS people_row
  ON l.table_name = 'tb_people'
 AND people_row.person_ID = CAST(REGEXP_SUBSTR(
       REGEXP_SUBSTR(COALESCE(l.description, ''), 'ID=[0-9]+'), '[0-9]+'
     ) AS UNSIGNED)
LEFT JOIN tb_buyer_orders AS people_order ON people_order.user_ID = people_row.user_ID
LEFT JOIN tb_user_addresses AS address_row
  ON l.table_name = 'tb_user_addresses'
 AND address_row.ID = CAST(REGEXP_SUBSTR(
       REGEXP_SUBSTR(COALESCE(l.description, ''), 'ID=[0-9]+'), '[0-9]+'
     ) AS UNSIGNED)
LEFT JOIN tb_buyer_orders AS address_order ON address_order.user_ID = address_row.user_ID
LEFT JOIN tbd_address_components AS address_component
  ON l.table_name = 'tbd_address_components'
 AND address_component.ID = CAST(REGEXP_SUBSTR(
       REGEXP_SUBSTR(COALESCE(l.description, ''), 'ID=[0-9]+'), '[0-9]+'
     ) AS UNSIGNED)
LEFT JOIN tb_user_addresses AS component_address ON component_address.ID = address_component.address_ID
LEFT JOIN tb_buyer_orders AS address_component_order
  ON address_component_order.user_ID = component_address.user_ID
LEFT JOIN tb_buyer_orders AS user_order
  ON COALESCE(
       CAST(REGEXP_SUBSTR(
         REGEXP_SUBSTR(COALESCE(l.description, ''), 'user_ID=[0-9]+'), '[0-9]+'
       ) AS UNSIGNED),
       IF(l.table_name = 'tb_users', CAST(REGEXP_SUBSTR(
         REGEXP_SUBSTR(COALESCE(l.description, ''), 'ID=[0-9]+'), '[0-9]+'
       ) AS UNSIGNED), NULL)
     ) = user_order.user_ID
 AND l.table_name IN ('tb_users', 'tb_people', 'tb_user_addresses', 'tbd_address_components',
                      'tb_carts', 'tbd_cart_items');

-- Caso 1: compra exitosa, pedido 3.
CREATE OR REPLACE VIEW `vw_practica04_caso_1` AS
SELECT 'Caso 1 - Compra exitosa' AS `caso`, `fase`, `usuario_ejecutor`, `conexion_bd`,
       `fecha_evento`, `tabla_modificada`, `operacion`, `detalle_evento`, `resultado`
FROM vw_practica04_trazabilidad_base
WHERE `pedido_ID` = 3;

-- Caso 2: cuotas/reclamo; pedido original 4 y pedido de reenvío documentado 5.
CREATE OR REPLACE VIEW `vw_practica04_caso_2` AS
SELECT 'Caso 2 - Pago y reenvío' AS `caso`, `fase`, `usuario_ejecutor`, `conexion_bd`,
       `fecha_evento`, `tabla_modificada`, `operacion`, `detalle_evento`, `resultado`
FROM vw_practica04_trazabilidad_base
WHERE `pedido_ID` IN (4, 5);

-- Caso 3: cancelación parcial y reembolso, pedido 6.
CREATE OR REPLACE VIEW `vw_practica04_caso_3` AS
SELECT 'Caso 3 - Cancelación parcial' AS `caso`, `fase`, `usuario_ejecutor`, `conexion_bd`,
       `fecha_evento`, `tabla_modificada`, `operacion`, `detalle_evento`, `resultado`
FROM vw_practica04_trazabilidad_base
WHERE `pedido_ID` = 6;

-- Caso 4: recolección en punto, pedido 7.
CREATE OR REPLACE VIEW `vw_practica04_caso_4` AS
SELECT 'Caso 4 - Recolección' AS `caso`, `fase`, `usuario_ejecutor`, `conexion_bd`,
       `fecha_evento`, `tabla_modificada`, `operacion`, `detalle_evento`, `resultado`
FROM vw_practica04_trazabilidad_base
WHERE `pedido_ID` = 7;

-- Caso 5: inventario insuficiente y cupón no consumido, pedido 8.
CREATE OR REPLACE VIEW `vw_practica04_caso_5` AS
SELECT 'Caso 5 - Falta de inventario' AS `caso`, `fase`, `usuario_ejecutor`, `conexion_bd`,
       `fecha_evento`, `tabla_modificada`, `operacion`, `detalle_evento`, `resultado`
FROM vw_practica04_trazabilidad_base
WHERE `pedido_ID` = 8;

CREATE OR REPLACE VIEW `vw_practica04_resumen` AS
SELECT `caso`, COUNT(*) AS `eventos`, MIN(`fecha_evento`) AS `inicio`,
       MAX(`fecha_evento`) AS `fin`
FROM (
  SELECT * FROM vw_practica04_caso_1
  UNION ALL SELECT * FROM vw_practica04_caso_2
  UNION ALL SELECT * FROM vw_practica04_caso_3
  UNION ALL SELECT * FROM vw_practica04_caso_4
  UNION ALL SELECT * FROM vw_practica04_caso_5
) AS eventos
GROUP BY `caso`;

-- Consultas como las de la captura (ejecutar cada SELECT por separado):
-- SELECT * FROM vw_practica04_caso_1 ORDER BY fecha_evento;
-- SELECT * FROM vw_practica04_caso_2 ORDER BY fecha_evento;
-- SELECT * FROM vw_practica04_caso_3 ORDER BY fecha_evento;
-- SELECT * FROM vw_practica04_caso_4 ORDER BY fecha_evento;
-- SELECT * FROM vw_practica04_caso_5 ORDER BY fecha_evento;
-- SELECT * FROM vw_practica04_resumen;
