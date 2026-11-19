-- Operaciones complementarias para los casos de compra.
-- Todas trabajan con tablas existentes; este archivo no crea tablas.
USE `db_test`;
DELIMITER //

DROP PROCEDURE IF EXISTS `sp_prepare_case_catalog_offers`//
CREATE PROCEDURE `sp_prepare_case_catalog_offers`()
BEGIN
  DECLARE v_seller_ID INT UNSIGNED;
  DECLARE v_offer_count INT UNSIGNED;
  DECLARE v_found TINYINT DEFAULT 1;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_found = 0;

  START TRANSACTION;
  SELECT so.seller_ID INTO v_seller_ID
  FROM tb_seller_orders so
  JOIN tb_users u ON u.ID = so.seller_ID
  WHERE u.status = b'1'
  ORDER BY so.seller_ID
  LIMIT 1;
  IF v_found = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Se requiere al menos un vendedor activo en los datos de prueba';
  END IF;

  UPDATE tbd_users_offer_products
  SET user_ID = v_seller_ID
  WHERE user_ID IS NULL;

  INSERT INTO tbd_users_offer_products (user_ID, product_ID, available_stock, status)
  SELECT v_seller_ID, p.ID, p.current_stock, b'1'
  FROM tb_products p
  WHERE p.status = b'1'
    AND p.current_stock > 0
    AND NOT EXISTS (
      SELECT 1 FROM tbd_users_offer_products o
      WHERE o.product_ID = p.ID AND o.status = b'1'
    );

  SELECT COUNT(*) INTO v_offer_count
  FROM tbd_users_offer_products o
  JOIN tb_products p ON p.ID = o.product_ID
  WHERE o.status = b'1' AND p.status = b'1'
    AND o.available_stock > 0 AND p.current_stock > 0;
  IF v_offer_count < 10 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Hay menos de 10 ofertas activas con inventario';
  END IF;
  COMMIT;
  SELECT v_offer_count AS ofertas_activas_con_stock;
END//

DROP PROCEDURE IF EXISTS `sp_create_order_shipments`//
CREATE PROCEDURE `sp_create_order_shipments`(
  IN p_order_ID INT UNSIGNED,
  IN p_delivery_address_ID BIGINT UNSIGNED
)
BEGIN
  DECLARE v_user_ID INT;
  DECLARE v_order_status VARCHAR(30);
  DECLARE v_found TINYINT DEFAULT 1;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_found = 0;

  START TRANSACTION;
  SELECT user_ID, status_string INTO v_user_ID, v_order_status
  FROM tb_buyer_orders WHERE ID = p_order_ID FOR UPDATE;
  IF v_found = 0 OR v_order_status <> 'Attended' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La orden debe estar atendida antes de crear envíos';
  END IF;
  SET v_found = 1;
  IF NOT EXISTS (
    SELECT 1 FROM tb_user_addresses
    WHERE ID = p_delivery_address_ID AND user_ID = v_user_ID AND status = b'1'
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El domicilio no pertenece al comprador o está inactivo';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM tb_seller_orders WHERE order_ID = p_order_ID) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La orden no tiene pedidos de vendedor';
  END IF;

  INSERT INTO tb_shipments (
    seller_order_ID, delivery_address_ID, fulfillment_method,
    carrier, tracking_number, shipment_status
  )
  SELECT so.ID, p_delivery_address_ID, 'HomeDelivery', 'Simulador',
         CONCAT('TRK-', UUID()), 'Pending'
  FROM tb_seller_orders so
  WHERE so.order_ID = p_order_ID
    AND NOT EXISTS (
      SELECT 1 FROM tb_shipments s
      WHERE s.seller_order_ID = so.ID
    );
  COMMIT;
END//

DROP PROCEDURE IF EXISTS `sp_set_shipment_ready_for_pickup`//
CREATE PROCEDURE `sp_set_shipment_ready_for_pickup`(
  IN p_shipment_ID BIGINT UNSIGNED,
  IN p_pickup_location VARCHAR(255),
  IN p_pickup_code VARCHAR(150)
)
BEGIN
  DECLARE v_status VARCHAR(30);
  DECLARE v_found TINYINT DEFAULT 1;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_found = 0;

  IF p_pickup_location IS NULL OR p_pickup_location = ''
     OR p_pickup_code IS NULL OR p_pickup_code = '' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Indica el punto y el código de recolección';
  END IF;
  START TRANSACTION;
  SELECT shipment_status INTO v_status
  FROM tb_shipments WHERE shipment_ID = p_shipment_ID FOR UPDATE;
  IF v_found = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Envío inexistente';
  END IF;
  IF v_status NOT IN ('Pending', 'Preparing', 'Shipped', 'InTransit', 'DeliveryFailed') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El envío no puede cambiar a recolección';
  END IF;
  UPDATE tb_shipments
  SET fulfillment_method = 'Pickup',
      delivery_address_ID = NULL,
      pickup_location = p_pickup_location,
      tracking_number = p_pickup_code,
      carrier = 'Punto de recolección',
      shipment_status = 'ReadyForPickup',
      shipped_date = COALESCE(shipped_date, NOW())
  WHERE shipment_ID = p_shipment_ID;
  COMMIT;
END//

DROP PROCEDURE IF EXISTS `sp_confirm_shipment_pickup`//
CREATE PROCEDURE `sp_confirm_shipment_pickup`(
  IN p_shipment_ID BIGINT UNSIGNED,
  IN p_pickup_code VARCHAR(150)
)
BEGIN
  DECLARE v_seller_order_ID INT UNSIGNED;
  DECLARE v_order_ID INT UNSIGNED;
  DECLARE v_status VARCHAR(30);
  DECLARE v_fulfillment_method VARCHAR(30);
  DECLARE v_tracking_number VARCHAR(150);
  DECLARE v_order_status VARCHAR(30);
  DECLARE v_found TINYINT DEFAULT 1;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_found = 0;

  START TRANSACTION;
  SELECT s.seller_order_ID, so.order_ID, s.shipment_status,
         s.fulfillment_method, s.tracking_number, bo.status_string
    INTO v_seller_order_ID, v_order_ID, v_status,
         v_fulfillment_method, v_tracking_number, v_order_status
  FROM tb_shipments s
  JOIN tb_seller_orders so ON so.ID = s.seller_order_ID
  JOIN tb_buyer_orders bo ON bo.ID = so.order_ID
  WHERE s.shipment_ID = p_shipment_ID
  FOR UPDATE;
  IF v_found = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Envío inexistente';
  END IF;
  IF v_fulfillment_method <> 'Pickup' OR v_status <> 'ReadyForPickup'
     OR v_tracking_number <> p_pickup_code THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El código o el estado de recolección no coincide';
  END IF;
  IF v_order_status <> 'Attended' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La orden debe estar atendida para confirmar la recolección';
  END IF;
  UPDATE tb_shipments
  SET shipment_status = 'PickedUp', delivered_date = NOW()
  WHERE shipment_ID = p_shipment_ID;
  IF NOT EXISTS (
    SELECT 1 FROM tb_shipments
    WHERE seller_order_ID = v_seller_order_ID
      AND shipment_ID <> p_shipment_ID
      AND shipment_status NOT IN ('Delivered', 'PickedUp')
  ) THEN
    UPDATE tb_seller_orders
    SET fulfillment_status = 'Delivered'
    WHERE ID = v_seller_order_ID;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM tb_seller_orders
    WHERE order_ID = v_order_ID AND fulfillment_status <> 'Delivered'
  ) THEN
    UPDATE tb_buyer_orders SET status_string = 'Delivered' WHERE ID = v_order_ID;
  END IF;
  COMMIT;
END//

DROP PROCEDURE IF EXISTS `sp_mark_shipment_delivered`//
CREATE PROCEDURE `sp_mark_shipment_delivered`(
  IN p_shipment_ID BIGINT UNSIGNED
)
BEGIN
  DECLARE v_seller_order_ID INT UNSIGNED;
  DECLARE v_order_ID INT UNSIGNED;
  DECLARE v_status VARCHAR(30);
  DECLARE v_order_status VARCHAR(30);
  DECLARE v_found TINYINT DEFAULT 1;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_found = 0;

  START TRANSACTION;
  SELECT s.seller_order_ID, so.order_ID, s.shipment_status, bo.status_string
    INTO v_seller_order_ID, v_order_ID, v_status, v_order_status
  FROM tb_shipments s
  JOIN tb_seller_orders so ON so.ID = s.seller_order_ID
  JOIN tb_buyer_orders bo ON bo.ID = so.order_ID
  WHERE s.shipment_ID = p_shipment_ID
  FOR UPDATE;
  IF v_found = 0 OR v_status NOT IN ('Pending', 'Preparing', 'Shipped', 'InTransit', 'OutForDelivery') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El envío no puede marcarse como entregado';
  END IF;
  IF v_order_status <> 'Attended'
     AND NOT EXISTS (
       SELECT 1 FROM tb_returns
       WHERE replacement_shipment_ID = p_shipment_ID
         AND return_status = 'InTransit'
     ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La orden debe estar atendida para entregarse';
  END IF;
  UPDATE tb_shipments
  SET shipment_status = 'Delivered',
      shipped_date = COALESCE(shipped_date, NOW()),
      delivered_date = NOW()
  WHERE shipment_ID = p_shipment_ID;
  UPDATE tb_returns
  SET return_status = 'Completed', completed_date = NOW()
  WHERE replacement_shipment_ID = p_shipment_ID;
  IF NOT EXISTS (
    SELECT 1 FROM tb_shipments
    WHERE seller_order_ID = v_seller_order_ID
      AND shipment_status NOT IN ('Delivered', 'PickedUp')
  ) THEN
    UPDATE tb_seller_orders
    SET fulfillment_status = 'Delivered'
    WHERE ID = v_seller_order_ID;
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM tb_seller_orders
    WHERE order_ID = v_order_ID AND fulfillment_status <> 'Delivered'
  ) THEN
    UPDATE tb_buyer_orders SET status_string = 'Delivered' WHERE ID = v_order_ID;
  END IF;
  COMMIT;
END//

DROP PROCEDURE IF EXISTS `sp_complete_partial_cancellation`//
CREATE PROCEDURE `sp_complete_partial_cancellation`(
  IN p_cancellation_ID BIGINT UNSIGNED,
  IN p_payment_ID INT UNSIGNED,
  OUT p_refund_ID BIGINT UNSIGNED
)
BEGIN
  DECLARE v_order_ID INT UNSIGNED;
  DECLARE v_cancellation_status VARCHAR(30);
  DECLARE v_order_status VARCHAR(30);
  DECLARE v_payment_order_ID INT UNSIGNED;
  DECLARE v_payment_amount DECIMAL(12,2);
  DECLARE v_payment_status VARCHAR(30);
  DECLARE v_payment_method VARCHAR(20);
  DECLARE v_payment_instrument_ID BIGINT UNSIGNED;
  DECLARE v_cancel_amount DECIMAL(12,2) DEFAULT 0.00;
  DECLARE v_cancel_quantity INT DEFAULT 0;
  DECLARE v_cancel_rows INT DEFAULT 0;
  DECLARE v_prior_refunds DECIMAL(12,2) DEFAULT 0.00;
  DECLARE v_refund_total DECIMAL(12,2);
  DECLARE v_event VARCHAR(30);
  DECLARE v_found TINYINT DEFAULT 1;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_found = 0;

  SET p_refund_ID = NULL;
  START TRANSACTION;
  SELECT order_ID, cancellation_status
    INTO v_order_ID, v_cancellation_status
  FROM tb_order_cancellations
  WHERE cancellation_ID = p_cancellation_ID
  FOR UPDATE;
  IF v_found = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solicitud de cancelación inexistente';
  END IF;
  IF v_cancellation_status NOT IN ('Requested', 'Approved') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cancelación ya fue resuelta';
  END IF;

  SELECT status_string INTO v_order_status
  FROM tb_buyer_orders WHERE ID = v_order_ID FOR UPDATE;
  IF v_found = 0 OR v_order_status NOT IN ('Attended', 'Delivered') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La orden todavía no puede cancelar partidas';
  END IF;
  SET v_found = 1;
  SELECT order_ID, amount, payment_status, payment_method, user_payment_method_ID
    INTO v_payment_order_ID, v_payment_amount, v_payment_status,
         v_payment_method, v_payment_instrument_ID
  FROM tb_payments WHERE ID = p_payment_ID FOR UPDATE;
  IF v_found = 0 OR v_payment_order_ID <> v_order_ID
     OR v_payment_status NOT IN ('Paid', 'PartiallyRefunded') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El pago no pertenece a la orden o no está cobrado';
  END IF;

  SELECT COALESCE(SUM(ci.quantity * oi.unit_price), 0.00),
         COALESCE(SUM(ci.quantity), 0), COUNT(*)
    INTO v_cancel_amount, v_cancel_quantity, v_cancel_rows
  FROM tbd_cancellation_items ci
  JOIN tbd_order_items oi ON oi.ID = ci.order_item_id
  JOIN tb_seller_orders so ON so.ID = oi.seller_order_ID
  WHERE ci.cancellation_id = p_cancellation_ID
    AND so.order_ID = v_order_ID
    AND ci.quantity > 0
    AND ci.quantity <= oi.quantity - oi.cancelled_quantity;
  IF v_cancel_rows = 0 OR v_cancel_amount <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cancelación no contiene partidas válidas';
  END IF;
  IF EXISTS (
    SELECT 1
    FROM tbd_cancellation_items ci
    JOIN tbd_order_items oi ON oi.ID = ci.order_item_id
    JOIN tb_seller_orders so ON so.ID = oi.seller_order_ID
    WHERE ci.cancellation_id = p_cancellation_ID
      AND so.order_ID = v_order_ID
      AND (ci.quantity <= 0 OR ci.quantity > oi.quantity - oi.cancelled_quantity)
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La cantidad cancelada supera la cantidad comprada';
  END IF;
  IF EXISTS (
    SELECT oi.ID
    FROM tbd_cancellation_items ci
    JOIN tbd_order_items oi ON oi.ID = ci.order_item_id
    JOIN tb_seller_orders so ON so.ID = oi.seller_order_ID
    JOIN tb_order_cancellations oc ON oc.cancellation_ID = ci.cancellation_id
    WHERE so.order_ID = v_order_ID
      AND oc.cancellation_status IN ('Requested', 'Approved')
    GROUP BY oi.ID, oi.quantity, oi.cancelled_quantity
    HAVING SUM(ci.quantity) > oi.quantity - oi.cancelled_quantity
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Las cancelaciones acumuladas superan la cantidad comprada';
  END IF;

  SELECT COALESCE(SUM(amount), 0.00) INTO v_prior_refunds
  FROM tb_refunds
  WHERE payment_ID = p_payment_ID AND refund_status IN ('Approved', 'Processing', 'Completed');
  IF v_prior_refunds + v_cancel_amount > v_payment_amount THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El reembolso supera el importe cobrado';
  END IF;

  INSERT INTO tb_refunds (
    payment_ID, cancellation_ID, amount, refund_reason,
    refund_status, provider_reference, completed_date
  ) VALUES (
    p_payment_ID, p_cancellation_ID, v_cancel_amount,
    'Reembolso por cancelación parcial', 'Completed',
    CONCAT('SIM-REF-', UUID()), NOW()
  );
  SET p_refund_ID = LAST_INSERT_ID();
  SET v_refund_total = v_prior_refunds + v_cancel_amount;
  SET v_event = IF(v_refund_total >= v_payment_amount, 'Refunded', 'PartiallyRefunded');
  UPDATE tb_payments
  SET payment_status = IF(v_refund_total >= v_payment_amount, 'Refunded', 'PartiallyRefunded')
  WHERE ID = p_payment_ID;
  IF v_payment_method = 'Other' AND v_payment_instrument_ID IS NOT NULL THEN
    UPDATE tbd_user_payment_methods
    SET available_balance = COALESCE(available_balance, 0.00) + v_cancel_amount,
        status = b'1'
    WHERE ID = v_payment_instrument_ID;
  END IF;
  INSERT INTO tb_payment_transactions
    (payment_ID, event_type, amount, event_reference, remarks)
  VALUES
    (p_payment_ID, v_event, v_cancel_amount,
     CONCAT('REFUND-', p_refund_ID), 'Reembolso simulado por cancelación parcial');

  UPDATE tbd_users_offer_products o
  JOIN (
    SELECT oi.product_offer_ID, SUM(ci.quantity) AS quantity_to_restore
    FROM tbd_cancellation_items ci
    JOIN tbd_order_items oi ON oi.ID = ci.order_item_id
    JOIN tb_seller_orders so ON so.ID = oi.seller_order_ID
    WHERE ci.cancellation_id = p_cancellation_ID AND so.order_ID = v_order_ID
    GROUP BY oi.product_offer_ID
  ) canceled ON canceled.product_offer_ID = o.product_offer_ID
  SET o.available_stock = o.available_stock + canceled.quantity_to_restore;

  UPDATE tb_products p
  JOIN (
    SELECT o.product_ID, SUM(ci.quantity) AS quantity_to_restore
    FROM tbd_cancellation_items ci
    JOIN tbd_order_items oi ON oi.ID = ci.order_item_id
    JOIN tb_seller_orders so ON so.ID = oi.seller_order_ID
    JOIN tbd_users_offer_products o ON o.product_offer_ID = oi.product_offer_ID
    WHERE ci.cancellation_id = p_cancellation_ID AND so.order_ID = v_order_ID
    GROUP BY o.product_ID
  ) canceled ON canceled.product_ID = p.ID
  SET p.current_stock = p.current_stock + canceled.quantity_to_restore;

  UPDATE tb_seller_orders so
  JOIN (
    SELECT oi.seller_order_ID, SUM(ci.quantity * oi.unit_price) AS amount_to_remove
    FROM tbd_cancellation_items ci
    JOIN tbd_order_items oi ON oi.ID = ci.order_item_id
    WHERE ci.cancellation_id = p_cancellation_ID
    GROUP BY oi.seller_order_ID
  ) canceled ON canceled.seller_order_ID = so.ID
  SET so.subtotal = GREATEST(0, so.subtotal - canceled.amount_to_remove);
  UPDATE tbd_order_items oi
  JOIN (
    SELECT ci.order_item_id, SUM(ci.quantity) AS quantity_to_remove
    FROM tbd_cancellation_items ci
    JOIN tbd_order_items source_item ON source_item.ID = ci.order_item_id
    JOIN tb_seller_orders source_order ON source_order.ID = source_item.seller_order_ID
    WHERE ci.cancellation_id = p_cancellation_ID
      AND source_order.order_ID = v_order_ID
    GROUP BY ci.order_item_id
  ) canceled ON canceled.order_item_id = oi.ID
  SET oi.cancelled_quantity = oi.cancelled_quantity + canceled.quantity_to_remove;
  UPDATE tb_buyer_orders
  SET total_products = GREATEST(0, total_products - v_cancel_quantity),
      total_cost = GREATEST(0, total_cost - v_cancel_amount)
  WHERE ID = v_order_ID;
  UPDATE tb_order_cancellations
  SET cancellation_status = 'Completed', resolved_date = NOW()
  WHERE cancellation_ID = p_cancellation_ID;
  COMMIT;
END//

DROP PROCEDURE IF EXISTS `sp_create_replacement_shipment`//
CREATE PROCEDURE `sp_create_replacement_shipment`(
  IN p_return_ID BIGINT UNSIGNED,
  IN p_delivery_address_ID BIGINT UNSIGNED,
  IN p_carrier VARCHAR(100),
  IN p_tracking_number VARCHAR(150),
  OUT p_shipment_ID BIGINT UNSIGNED
)
BEGIN
  DECLARE v_order_ID INT UNSIGNED;
  DECLARE v_order_status VARCHAR(30);
  DECLARE v_product_offer_ID INT UNSIGNED;
  DECLARE v_return_status VARCHAR(30);
  DECLARE v_user_ID INT;
  DECLARE v_seller_order_ID INT UNSIGNED;
  DECLARE v_return_quantity INT UNSIGNED;
  DECLARE v_offer_stock INT;
  DECLARE v_product_stock INT;
  DECLARE v_found TINYINT DEFAULT 1;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_found = 0;

  SET p_shipment_ID = NULL;
  START TRANSACTION;
  SELECT order_ID, product_offer_ID, return_status, quantity
    INTO v_order_ID, v_product_offer_ID, v_return_status, v_return_quantity
  FROM tb_returns WHERE return_ID = p_return_ID FOR UPDATE;
  IF v_found = 0 OR v_return_status NOT IN ('Authorized', 'Received', 'Inspected') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La devolución todavía no está aprobada para reenvío';
  END IF;
  SET v_found = 1;
  IF EXISTS (SELECT 1 FROM tb_returns WHERE return_ID = p_return_ID AND replacement_shipment_ID IS NOT NULL) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La devolución ya tiene un reenvío';
  END IF;
  SELECT user_ID INTO v_user_ID FROM tb_buyer_orders WHERE ID = v_order_ID;
  IF v_found = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Orden de devolución inexistente';
  END IF;
  SELECT status_string INTO v_order_status
  FROM tb_buyer_orders WHERE ID = v_order_ID FOR UPDATE;
  IF v_found = 0 OR v_order_status <> 'Delivered' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El reenvío requiere que la compra original esté entregada';
  END IF;
  SET v_found = 1;
  IF NOT EXISTS (
    SELECT 1 FROM tb_user_addresses
    WHERE ID = p_delivery_address_ID AND user_ID = v_user_ID AND status = b'1'
  ) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El domicilio no pertenece al comprador o está inactivo';
  END IF;
  SELECT so.ID INTO v_seller_order_ID
  FROM tb_seller_orders so
  JOIN tbd_order_items oi ON oi.seller_order_ID = so.ID
  WHERE so.order_ID = v_order_ID AND oi.product_offer_ID = v_product_offer_ID
  ORDER BY so.ID
  LIMIT 1
  FOR UPDATE;
  IF v_found = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se encontró el pedido del vendedor para el producto devuelto';
  END IF;
  SET v_found = 1;
  SELECT o.available_stock, p.current_stock
    INTO v_offer_stock, v_product_stock
  FROM tbd_users_offer_products o
  JOIN tb_products p ON p.ID = o.product_ID
  WHERE o.product_offer_ID = v_product_offer_ID
    AND o.status = b'1' AND p.status = b'1'
  FOR UPDATE;
  IF v_found = 0 OR v_offer_stock < v_return_quantity
     OR v_product_stock < v_return_quantity THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay inventario suficiente para reemplazar el producto';
  END IF;
  UPDATE tbd_users_offer_products
  SET available_stock = available_stock - v_return_quantity
  WHERE product_offer_ID = v_product_offer_ID;
  UPDATE tb_products p
  JOIN tbd_users_offer_products o ON o.product_ID = p.ID
  SET p.current_stock = p.current_stock - v_return_quantity
  WHERE o.product_offer_ID = v_product_offer_ID;

  INSERT INTO tb_shipments (
    seller_order_ID, delivery_address_ID, fulfillment_method,
    carrier, tracking_number, shipment_status, shipped_date
  ) VALUES (
    v_seller_order_ID, p_delivery_address_ID, 'HomeDelivery',
    COALESCE(p_carrier, 'Envío de reemplazo'),
    COALESCE(p_tracking_number, CONCAT('RPL-', UUID())),
    'InTransit', NOW()
  );
  SET p_shipment_ID = LAST_INSERT_ID();
  UPDATE tb_returns
  SET replacement_shipment_ID = p_shipment_ID,
      return_status = 'InTransit', completed_date = NULL
  WHERE return_ID = p_return_ID;
  COMMIT;
END//

DELIMITER ;
