# Preparación de los casos de compra

La migración [`preparar_esquema_casos_compra.sql`](../scripts/preparar_esquema_casos_compra.sql)
trabaja exclusivamente con las tablas ya existentes. No crea tablas. Está
dirigida al esquema `db_test` que selecciona actualmente el respaldo de compra.
Debe aplicarse una sola vez sobre una copia de pruebas; el script no se ejecutó
contra una instancia.

## Cambios previstos

- `tb_buyer_orders`: estados `PartiallyPaid` y `PaymentFailed` para no confundir
  una cuota rechazada o un pago parcial con una orden completamente pagada.
- `tb_payments`: número y total de cuotas por pago. Los campos son opcionales
  para conservar compatibilidad con pagos únicos y filas existentes.
- `tb_shipments`: estados `ReadyForPickup` y `PickedUp`.
- `tb_returns`: vínculo opcional a un envío de reemplazo en `tb_shipments`.
- `tbd_user_payment_methods`: saldo opcional para simular un cupón. La bandera
  `status` permite habilitar/deshabilitar ese instrumento; un cupón cancelado
  debe restaurarse mediante el flujo operativo de la aplicación.
- `tbc_payment_methods_types`: agrega los tipos simulados de tarjeta de crédito,
  billetera Spin y cupón, reactivándolos si ya existían.
- `sp_register_test_payment_attempt`: registra intentos exitosos o rechazados,
  cuotas, saldo pagado acumulado y consumo simulado de cupón de forma
  transaccional e idempotente.

## Reglas para ejecutar los casos

1. Registrar cada cuota/intentona como una fila de `tb_payments` y sus eventos
   en `tb_payment_transactions`. Solo marcar la orden `Payed` cuando el total
   de pagos capturados cubra `tb_buyer_orders.total_cost`; si aún falta saldo,
   usar `PartiallyPaid`. La razón del rechazo se registra en `remarks`.
2. Verificar stock disponible tanto en `tbd_users_offer_products` como en
   `tb_products` antes de capturar el pago. El descuento de existencias debe
   ocurrir una sola vez, dentro de una transacción, cuando se acepta la orden.
3. Para un cupón, asociar el instrumento `GIFT_COUPON_SIM`, guardar el saldo en
   `available_balance`, y registrar el pago como `Other`. Si falta stock, no
   capturar el pago y mantener/reactivar el instrumento.
4. En recolección, guardar en `tb_shipments` el estado `ReadyForPickup` y luego
   `PickedUp`; el código de recolección puede registrarse en `tracking_number`.
5. Para reenvío, crear otro registro en `tb_shipments` para la misma orden de
   vendedor y guardar su ID en `tb_returns.replacement_shipment_ID`.
6. Usar `sp_register_new_user` para el alta, y probar con cuentas de aplicación
   separadas. No conceder el rol `buyer` a una conexión compartida por todos
   los clientes: los roles MySQL pertenecen a la cuenta de conexión, no a cada
   fila de `tb_users`.

## Reglas de negocio que aún deben corregirse en los casos

- En el caso 2 no se debe marcar la orden atendida/entregada si la sexta cuota
  rechazada deja un saldo pendiente, salvo que se defina explícitamente una
  política de crédito que permita entregar con deuda. La base puede registrar
  ambos resultados, pero esa decisión corresponde al flujo del negocio.
- En los casos 3 y 4 hay que elegir un único medio efectivo de cobro: Spin o
  efectivo en el caso 3; SPEI o efectivo en el caso 4. El medio registrado en
  `tb_payments.payment_method` debe coincidir con el cobro simulado.
- El reembolso ya puede vincularse con `tb_order_cancellations` o `tb_returns`
  mediante `tb_refunds`. Para cancelación parcial, registrar el ítem/cantidad
  en `tbd_cancellation_items` y calcular el reembolso desde el precio congelado
  en `tbd_order_items`.

La migración prepara campos y estados, pero no concede privilegios ni ejecuta
compras. Antes de aplicarla hay que confirmar que `db_test` es la instancia de
pruebas correcta y respaldarla. Aún se deben integrar las validaciones de stock,
cancelación, reembolso y entrega en los procedimientos operativos existentes;
después se verifican los cinco flujos con datos aislados.
