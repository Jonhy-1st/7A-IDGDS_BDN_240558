-- Consultas de lectura para comprobar las órdenes de los cinco casos.
-- Sustituye los ceros por los ID de pedido creados en cada caso.
USE `db_test`;

-- IDs creados en la ejecución real de db_test el 2026-11-18.
SET @caso1 = 3;
SET @caso2 = 4;
SET @caso2_reenvio = 5;
SET @caso3 = 6;
SET @caso4 = 7;
SET @caso5 = 8;

-- 1. Resumen: estado, total y monto neto cobrado (resta reembolsos aplicados).
SELECT bo.ID AS pedido_ID,
       bo.status_string AS estado_pedido,
       u.platform_role AS rol_de_plataforma,
       bo.total_products AS productos,
       bo.total_cost AS total_pedido,
       COALESCE(pt.captured_amount, 0) - COALESCE(pt.refunded_amount, 0) AS pagado_neto,
       GREATEST(ROUND(bo.total_cost, 2) -
         (COALESCE(pt.captured_amount, 0) - COALESCE(pt.refunded_amount, 0)), 0) AS saldo_pendiente
FROM tb_buyer_orders bo
JOIN tb_users u ON u.ID = bo.user_ID
LEFT JOIN (
  SELECT p.order_ID,
         SUM(CASE WHEN p.payment_status IN ('Paid','Authorized','PartiallyRefunded','Refunded')
                  THEN p.amount ELSE 0 END) AS captured_amount,
         SUM(COALESCE(r.refunded_amount, 0)) AS refunded_amount
  FROM tb_payments p
  LEFT JOIN (
    SELECT payment_ID, SUM(amount) AS refunded_amount
    FROM tb_refunds
    WHERE refund_status IN ('Approved','Processing','Completed')
    GROUP BY payment_ID
  ) r ON r.payment_ID = p.ID
  GROUP BY p.order_ID
) pt ON pt.order_ID = bo.ID
WHERE bo.ID IN (@caso1, @caso2, @caso2_reenvio, @caso3, @caso4, @caso5)
  AND bo.ID <> 0
ORDER BY bo.ID;

-- 2. Pagos, cuotas y motivo de intentos rechazados.
SELECT p.order_ID, p.ID AS pago_ID, p.payment_method, p.amount,
       p.installment_number, p.installment_count, p.payment_status,
       t.event_type, t.remarks, t.creation_date
FROM tb_payments p
LEFT JOIN tb_payment_transactions t ON t.payment_ID = p.ID
WHERE p.order_ID IN (@caso1, @caso2, @caso2_reenvio, @caso3, @caso4, @caso5)
  AND p.order_ID <> 0
ORDER BY p.order_ID, p.installment_number, p.ID, t.ID;

-- 3. Envíos a domicilio y recolecciones.
SELECT bo.ID AS pedido_ID, so.ID AS pedido_vendedor_ID,
       s.shipment_ID, s.fulfillment_method, s.shipment_status,
       s.delivery_address_ID, s.pickup_location, s.tracking_number,
       s.shipped_date, s.delivered_date
FROM tb_buyer_orders bo
JOIN tb_seller_orders so ON so.order_ID = bo.ID
LEFT JOIN tb_shipments s ON s.seller_order_ID = so.ID
WHERE bo.ID IN (@caso1, @caso2, @caso2_reenvio, @caso3, @caso4, @caso5)
  AND bo.ID <> 0
ORDER BY bo.ID, s.shipment_ID;

-- 4. Cancelaciones, renglones afectados y reembolsos.
SELECT oc.order_ID, oc.cancellation_ID, oc.cancellation_status,
       ci.order_item_id, ci.quantity AS cantidad_cancelada,
       oi.product_name, oi.quantity AS cantidad_original,
       oi.cancelled_quantity AS cantidad_cancelada_acumulada,
       oi.subtotal AS subtotal_vigente, oi.unit_price,
       r.refund_ID, r.amount AS monto_reembolsado, r.refund_status
FROM tb_order_cancellations oc
LEFT JOIN tbd_cancellation_items ci ON ci.cancellation_id = oc.cancellation_ID
LEFT JOIN tbd_order_items oi ON oi.ID = ci.order_item_id
LEFT JOIN tb_refunds r ON r.cancellation_ID = oc.cancellation_ID
WHERE oc.order_ID IN (@caso2, @caso2_reenvio, @caso3)
ORDER BY oc.order_ID, oc.cancellation_ID, ci.id, r.refund_ID;

-- 5. Reclamaciones por producto dañado y envío de reemplazo.
SELECT r.order_ID, r.return_ID, r.return_reason, r.return_status,
       r.product_offer_ID, r.quantity, r.replacement_shipment_ID,
       s.shipment_status AS estado_reenvio, s.tracking_number AS guia_reenvio
FROM tb_returns r
LEFT JOIN tb_shipments s ON s.shipment_ID = r.replacement_shipment_ID
WHERE r.order_ID = @caso2_reenvio
ORDER BY r.return_ID;

-- 6. Pedido cancelado por inventario y cupón no consumido.
SELECT bo.ID AS pedido_ID, bo.status_string AS estado_pedido,
       p.ID AS pago_ID, p.payment_status,
       t.event_type, t.remarks,
       upm.ID AS instrumento_ID, pmt.code AS tipo_instrumento,
       upm.status AS instrumento_activo, upm.available_balance AS saldo_cupon
FROM tb_buyer_orders bo
LEFT JOIN tb_payments p ON p.order_ID = bo.ID
LEFT JOIN tb_payment_transactions t ON t.payment_ID = p.ID
LEFT JOIN tbd_user_payment_methods upm ON upm.ID = p.user_payment_method_ID
LEFT JOIN tbc_payment_methods_types pmt ON pmt.ID = upm.payment_method_type_ID
WHERE bo.ID = @caso5
ORDER BY p.ID, t.ID;

-- 7. Disponibilidad aproximada para elegir artículos de prueba.
SELECT COUNT(DISTINCT p.ID) AS productos_activos_con_stock
FROM tb_products p
JOIN tbd_users_offer_products o ON o.product_ID = p.ID
WHERE p.status = b'1' AND p.current_stock > 0
  AND o.status = b'1' AND o.available_stock > 0;
