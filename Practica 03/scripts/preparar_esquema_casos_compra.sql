-- Preparación del esquema para los casos de compra de Práctica 03.
-- Requiere MySQL 8.x y selecciona explícitamente db_test.
-- No crea tablas; amplía columnas/ENUM de tablas existentes.
-- Ejecutar una sola vez sobre una copia de pruebas y respaldar antes.

USE `db_test`;

-- Permite representar cuotas pendientes y pagos parciales sin marcar la orden
-- como pagada antes de cubrir su total.
ALTER TABLE `tb_buyer_orders`
  MODIFY COLUMN `status_string` ENUM(
    'Registered', 'Wishlist', 'Payed', 'Canceled', 'Delivered',
    'Devolved', 'Attended', 'Sended', 'PartiallyPaid', 'PaymentFailed'
  ) NOT NULL DEFAULT 'Registered';

-- Cada fila de tb_payments representa un intento/cuota. Los campos nuevos
-- quedan NULL para los pagos existentes y los pagos de una sola exhibición.
ALTER TABLE `tb_payments`
  ADD COLUMN `installment_number` SMALLINT UNSIGNED DEFAULT NULL
    AFTER `amount`,
  ADD COLUMN `installment_count` SMALLINT UNSIGNED DEFAULT NULL
    AFTER `installment_number`,
  ADD CONSTRAINT `chk_payment_installment_pair` CHECK (
    (`installment_number` IS NULL AND `installment_count` IS NULL)
    OR
    (`installment_number` IS NOT NULL AND `installment_count` IS NOT NULL
      AND `installment_number` > 0 AND `installment_count` > 0
      AND `installment_number` <= `installment_count`)
  );

-- El estado de envío puede expresar entrega en punto de recolección.
ALTER TABLE `tb_shipments`
  MODIFY COLUMN `shipment_status` ENUM(
    'Pending', 'Preparing', 'Shipped', 'InTransit', 'OutForDelivery',
    'Delivered', 'DeliveryFailed', 'Lost', 'Returned',
    'ReadyForPickup', 'PickedUp'
  ) NOT NULL DEFAULT 'Pending';

-- Se vincula el reenvío con la devolución en las mismas tablas existentes.
ALTER TABLE `tb_returns`
  ADD COLUMN `replacement_shipment_ID` BIGINT UNSIGNED DEFAULT NULL
    AFTER `inspection_notes`,
  ADD KEY `idx_returns_replacement_shipment` (`replacement_shipment_ID`),
  ADD CONSTRAINT `fk_returns_replacement_shipment`
    FOREIGN KEY (`replacement_shipment_ID`)
    REFERENCES `tb_shipments` (`shipment_ID`)
    ON DELETE RESTRICT;

-- available_balance se usa solo para medios simulados con saldo, por ejemplo
-- un cupón. Para tarjetas/cuentas simuladas debe permanecer NULL.
ALTER TABLE `tbd_user_payment_methods`
  ADD COLUMN `available_balance` DECIMAL(12,2) DEFAULT NULL
    AFTER `last_four`,
  ADD CONSTRAINT `chk_user_payment_method_balance`
    CHECK (`available_balance` IS NULL OR `available_balance` >= 0);

-- Tipos de instrumento guardado; el método efectivo de cobro sigue registrado
-- en tb_payments.payment_method. No almacenar números completos de tarjeta.
INSERT INTO `tbc_payment_methods_types` (`code`, `description`, `status`)
VALUES
  ('CREDIT_CARD_SIM', 'Tarjeta de crédito simulada para pruebas', b'1'),
  ('DIGITAL_WALLET_SIM', 'Billetera digital simulada (Spin) para pruebas', b'1'),
  ('GIFT_COUPON_SIM', 'Cupón de regalo simulado con saldo', b'1')
ON DUPLICATE KEY UPDATE
  `description` = VALUES(`description`),
  `status` = b'1';

-- Los métodos de cobro admitidos ya se representan en tb_payments:
-- Card, SPEI, Transfer, Cash y Other. Para cupones usar Other y asociar el
-- instrumento GIFT_COUPON_SIM; registrar resultado/motivo en
-- tb_payment_transactions. El caso de falta de stock debe fallar antes de
-- capturar el pago y dejar disponible el instrumento/cupón.

-- Registra un intento o una cuota simulada como pago y eventos de transacción.
-- p_authorized=0 registra el rechazo sin cambiar el total pagado.
-- p_idempotency_key debe ser único por intento.
DELIMITER //
DROP PROCEDURE IF EXISTS `sp_register_test_payment_attempt`//
CREATE PROCEDURE `sp_register_test_payment_attempt`(
  IN p_order_ID INT UNSIGNED,
  IN p_user_payment_method_ID BIGINT UNSIGNED,
  IN p_amount DECIMAL(12,2),
  IN p_payment_method VARCHAR(10),
  IN p_installment_number SMALLINT UNSIGNED,
  IN p_installment_count SMALLINT UNSIGNED,
  IN p_authorized TINYINT,
  IN p_result_detail VARCHAR(500),
  IN p_idempotency_key VARCHAR(100),
  OUT p_payment_ID INT UNSIGNED
)
payment_attempt: BEGIN
  DECLARE v_order_found TINYINT DEFAULT 1;
  DECLARE v_user_ID INT;
  DECLARE v_order_total DECIMAL(12,2);
  DECLARE v_order_status VARCHAR(30);
  DECLARE v_paid_total DECIMAL(12,2) DEFAULT 0.00;
  DECLARE v_method_user_ID INT;
  DECLARE v_method_type VARCHAR(30);
  DECLARE v_method_status BIT(1);
  DECLARE v_method_balance DECIMAL(12,2);
  DECLARE v_now_paid DECIMAL(12,2);
  DECLARE v_stock_shortage TINYINT DEFAULT 0;
  DECLARE v_new_payment_ID INT UNSIGNED;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_order_found = 0;

  SET p_payment_ID = NULL;
  IF p_amount IS NULL OR p_amount <= 0 OR p_authorized NOT IN (0, 1)
     OR p_payment_method NOT IN ('Card', 'SPEI', 'Transfer', 'Cash', 'Other')
     OR p_idempotency_key IS NULL OR p_idempotency_key = '' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Importe, método, resultado o clave de idempotencia inválidos';
  END IF;
  IF (p_installment_number IS NULL) <> (p_installment_count IS NULL)
     OR (p_installment_number IS NOT NULL AND
         (p_installment_number = 0 OR p_installment_count = 0 OR
          p_installment_number > p_installment_count)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Datos de cuota inválidos';
  END IF;

  START TRANSACTION;
  SELECT user_ID, ROUND(total_cost, 2), status_string
    INTO v_user_ID, v_order_total, v_order_status
  FROM tb_buyer_orders
  WHERE ID = p_order_ID
  FOR UPDATE;
  IF v_order_found = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Orden inexistente';
  END IF;
  IF v_order_status IN ('Canceled', 'Delivered', 'Devolved') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La orden ya no acepta pagos';
  END IF;

  SET v_order_found = 1;
  IF p_user_payment_method_ID IS NOT NULL THEN
    SELECT upm.user_ID, pmt.code, upm.status, upm.available_balance
      INTO v_method_user_ID, v_method_type, v_method_status, v_method_balance
    FROM tbd_user_payment_methods upm
    JOIN tbc_payment_methods_types pmt ON pmt.ID = upm.payment_method_type_ID
    WHERE upm.ID = p_user_payment_method_ID
    FOR UPDATE;
    IF v_order_found = 0 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Método de pago inexistente';
    END IF;
    IF v_method_user_ID <> v_user_ID OR v_method_status <> b'1' THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El instrumento no pertenece al comprador o está inactivo';
    END IF;
  END IF;

  IF p_payment_method = 'Other' AND
     (p_user_payment_method_ID IS NULL OR v_method_type <> 'GIFT_COUPON_SIM') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Other solo se usa para el cupón simulado';
  END IF;
  IF p_payment_method = 'Card' AND p_user_payment_method_ID IS NOT NULL AND
     v_method_type NOT IN ('DEBIT_CARD_SIM', 'CREDIT_CARD_SIM', 'DIGITAL_WALLET_SIM') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El instrumento no corresponde a un pago con tarjeta';
  END IF;

  SELECT COALESCE(SUM(amount), 0.00) INTO v_paid_total
  FROM tb_payments
  WHERE order_ID = p_order_ID AND payment_status IN ('Authorized', 'Paid');
  -- Valida el inventario antes del cobro que completa la orden. Si no alcanza,
  -- registra el intento fallido y deja disponible el cupón.
  IF p_authorized = 1 AND v_paid_total + p_amount >= v_order_total THEN
    SELECT EXISTS (
      SELECT 1
      FROM (
        SELECT o.product_offer_ID,
               SUM(oi.quantity) AS requested_qty,
               MAX(o.available_stock) AS offer_stock,
               MAX(p.current_stock) AS product_stock,
               MIN(o.status) AS offer_status,
               MIN(p.status) AS product_status
        FROM tbd_order_items oi
        JOIN tb_seller_orders so ON so.ID = oi.seller_order_ID
        JOIN tbd_users_offer_products o ON o.product_offer_ID = oi.product_offer_ID
        JOIN tb_products p ON p.ID = o.product_ID
        WHERE so.order_ID = p_order_ID
        GROUP BY o.product_offer_ID
      ) stock_check
      WHERE stock_check.offer_stock < stock_check.requested_qty
         OR stock_check.product_stock < stock_check.requested_qty
         OR stock_check.offer_status <> b'1'
         OR stock_check.product_status <> b'1'
    ) INTO v_stock_shortage;
  END IF;
  IF v_stock_shortage = 1 THEN
    INSERT INTO tb_payments (
      order_ID, user_payment_method_ID, amount, installment_number,
      installment_count, payment_method, idempotency_key, payment_status
    ) VALUES (
      p_order_ID, p_user_payment_method_ID, p_amount, p_installment_number,
      p_installment_count, p_payment_method, p_idempotency_key, 'Failed'
    );
    SET v_new_payment_ID = LAST_INSERT_ID();
    INSERT INTO tb_payment_transactions
      (payment_ID, event_type, amount, event_reference, remarks)
    VALUES
      (v_new_payment_ID, 'Created', p_amount,
       CONCAT('CREATED-', p_idempotency_key), 'Intento de cobro simulado');
    INSERT INTO tb_payment_transactions
      (payment_ID, event_type, amount, event_reference, remarks)
    VALUES
      (v_new_payment_ID, 'Failed', p_amount,
       CONCAT('FAIL-', p_idempotency_key),
       'Orden cancelada: inventario insuficiente; el cupón no se consumió');
    UPDATE tb_buyer_orders SET status_string = 'Canceled' WHERE ID = p_order_ID;
    UPDATE tb_seller_orders SET fulfillment_status = 'Canceled' WHERE order_ID = p_order_ID;
    SET p_payment_ID = v_new_payment_ID;
    COMMIT;
    LEAVE payment_attempt;
  END IF;
  IF p_authorized = 1 AND p_amount > v_order_total - v_paid_total THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El intento excede el saldo pendiente de la orden';
  END IF;
  IF p_authorized = 1 AND p_payment_method = 'Other' AND
     (v_method_balance IS NULL OR v_method_balance < p_amount) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Saldo insuficiente en el cupón';
  END IF;

  INSERT INTO tb_payments (
    order_ID, user_payment_method_ID, amount, installment_number,
    installment_count, payment_method, idempotency_key, payment_status
  ) VALUES (
    p_order_ID, p_user_payment_method_ID, p_amount, p_installment_number,
    p_installment_count, p_payment_method, p_idempotency_key, 'Pending'
  );
  SET v_new_payment_ID = LAST_INSERT_ID();
  INSERT INTO tb_payment_transactions
    (payment_ID, event_type, amount, event_reference, remarks)
  VALUES
    (v_new_payment_ID, 'Created', p_amount,
     CONCAT('CREATED-', p_idempotency_key), p_result_detail);

  IF p_authorized = 1 THEN
    INSERT INTO tb_payment_transactions
      (payment_ID, event_type, amount, event_reference, remarks)
    VALUES
      (v_new_payment_ID, 'Authorized', p_amount,
       CONCAT('AUTH-', p_idempotency_key), 'Autorización simulada');
    INSERT INTO tb_payment_transactions
      (payment_ID, event_type, amount, event_reference, remarks)
    VALUES
      (v_new_payment_ID, 'Captured', p_amount,
       CONCAT('CAP-', p_idempotency_key), 'Cobro simulado');
    UPDATE tb_payments
    SET payment_status = 'Paid', paid_date = NOW()
    WHERE ID = v_new_payment_ID;

    IF p_payment_method = 'Other' THEN
      SET v_now_paid = v_method_balance - p_amount;
      UPDATE tbd_user_payment_methods
      SET available_balance = v_now_paid,
          status = IF(v_now_paid = 0, b'0', b'1')
      WHERE ID = p_user_payment_method_ID;
    END IF;

    SET v_paid_total = v_paid_total + p_amount;
    UPDATE tb_buyer_orders
    SET status_string = IF(v_paid_total >= v_order_total, 'Payed', 'PartiallyPaid')
    WHERE ID = p_order_ID;
  ELSE
    INSERT INTO tb_payment_transactions
      (payment_ID, event_type, amount, event_reference, remarks)
    VALUES
      (v_new_payment_ID, 'Failed', p_amount,
       CONCAT('FAIL-', p_idempotency_key), p_result_detail);
    UPDATE tb_payments SET payment_status = 'Failed'
    WHERE ID = v_new_payment_ID;
    UPDATE tb_buyer_orders
    SET status_string = IF(v_paid_total > 0, 'PartiallyPaid', 'PaymentFailed')
    WHERE ID = p_order_ID;
  END IF;

  SET p_payment_ID = v_new_payment_ID;
  COMMIT;
END//
DELIMITER ;
