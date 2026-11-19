# Preparación de los casos de compra

La migración [`preparar_esquema_casos_compra.sql`](../scripts/preparar_esquema_casos_compra.sql)
trabaja exclusivamente con las tablas ya existentes. No crea tablas. Está
dirigida al esquema `db_test` que selecciona actualmente el respaldo de compra.
La migración y los cinco flujos se ejecutaron en la instancia local real
`db_test` (MySQL en 127.0.0.1:40558), manteniendo las 27 tablas existentes.
Los registros de prueba quedan en esa base para que se puedan revisar con las
consultas de verificación. Se usó la cuenta MySQL superusuario local para aplicar
el esquema y ejecutar los procedimientos; los compradores son filas de `tb_users`.

Después de la migración, ejecutar [`operaciones_casos_compra.sql`](../scripts/operaciones_casos_compra.sql)
para crear los procedimientos de recolección, cancelación con reembolso y
reenvío por producto dañado. Las consultas de
[`verificacion_casos_compra.sql`](../queries/verificacion_casos_compra.sql)
permiten revisar los resultados usando los ID de pedidos creados.

## Preparar el catálogo de ofertas

Después de instalar los procedimientos, ejecutar `CALL sp_prepare_case_catalog_offers();`.
La operación utiliza el vendedor que ya aparece en los pedidos de prueba y
crea ofertas para productos activos con existencia, reutilizando las tablas
`tb_products` y `tbd_users_offer_products`. No agrega productos ni tablas.

## Cambios previstos

- `tb_buyer_orders`: estados `PartiallyPaid` y `PaymentFailed` para no confundir
  una cuota rechazada o un pago parcial con una orden completamente pagada.
- `tb_payments`: número y total de cuotas por pago. Los campos son opcionales
  para conservar compatibilidad con pagos únicos y filas existentes.
- `tb_shipments`: estados `ReadyForPickup` y `PickedUp`.
- `tb_shipments`: método de entrega y ubicación de recolección.
- `tb_carts`: permite más de un carrito histórico por usuario para que los
  siguientes casos puedan comprar después de convertir el carrito anterior.
- `tb_returns`: vínculo opcional a un envío de reemplazo en `tb_shipments`.
- `tbd_user_payment_methods`: saldo opcional para simular un cupón. La bandera
  `status` permite habilitar/deshabilitar ese instrumento; un cupón cancelado
  debe restaurarse mediante el flujo operativo de la aplicación.
- `tbc_payment_methods_types`: agrega los tipos simulados de tarjeta de crédito,
  billetera Spin y cupón, reactivándolos si ya existían.
- `sp_register_test_payment_attempt`: registra intentos exitosos o rechazados,
  cuotas, saldo pagado acumulado y consumo simulado de cupón de forma
  transaccional e idempotente. Antes del cobro final valida el inventario; si
  no alcanza, cancela la orden y deja el cupón sin consumir.
- `operaciones_casos_compra.sql`: agrega procedimientos para marcar un envío
  listo para recoger, confirmar la recolección, completar una cancelación
  parcial con su reembolso y crear un envío de reemplazo para una devolución.

## Reglas para ejecutar los casos

1. Registrar cada cuota/intento con `sp_register_test_payment_attempt`; el
   procedimiento crea la fila de `tb_payments` y sus eventos
   en `tb_payment_transactions`. Solo marcar la orden `Payed` cuando el total
   de pagos capturados cubra `tb_buyer_orders.total_cost`; si aún falta saldo,
   usar `PartiallyPaid`. La razón del rechazo se registra en `remarks`.
2. El pago final valida stock activo en `tbd_users_offer_products` y
   `tb_products`. Después de cubrir el total, llamar a
   `sp_pr04_attend_order` para descontar inventario y preparar la orden.
3. Para un cupón, asociar el instrumento `GIFT_COUPON_SIM`, guardar el saldo en
   `available_balance`, y registrar el pago como `Other`. Si falta stock, no
   capturar el pago y mantener/reactivar el instrumento.
4. En recolección, usar `sp_set_shipment_ready_for_pickup` con la ubicación y
   código; al recoger, usar `sp_confirm_shipment_pickup` con ese código.
5. Crear los envíos pendientes con `sp_create_order_shipments` cuando se use
   recolección o se necesite un estado de envío intermedio.
6. Para un reenvío, registrar la devolución como `Authorized`, `Received` o
   `Inspected` y llamar a `sp_create_replacement_shipment`; el procedimiento
   crea el envío y lo vincula en `tb_returns.replacement_shipment_ID`.
7. Usar `sp_register_new_user` para el alta, y probar con cuentas de aplicación
   separadas. No conceder el rol `buyer` a una conexión compartida por todos
   los clientes: los roles MySQL pertenecen a la cuenta de conexión, no a cada
   fila de `tb_users`.

## Ajustes para que los casos sean consistentes

- En el caso 2, cinco cuotas pagadas y una rechazada dejan saldo pendiente. La
  orden queda `PartiallyPaid`; no se atiende ni se envía hasta liquidar el
  saldo. Si el objetivo es probar devolución y reenvío, primero usa una orden
  liquidada y registra el rechazo en otra orden, o define un crédito autorizado.
- En el caso 3 usa Spin como medio de pago y devuelve el dinero al mismo pago.
- En el caso 4 usa SPEI como medio de pago; la entrega en el punto se registra
  por separado con el método `Pickup`.
- Para cancelación parcial, guardar el detalle en `tbd_cancellation_items` y
  llamar a `sp_complete_partial_cancellation`. El procedimiento ajusta total,
  cantidades de inventario, pago y reembolso en una transacción.

Los scripts no conceden privilegios ni ejecutan compras. Antes de aplicarlos,
confirma que `db_test` es la instancia de pruebas correcta y respáldala. Las
cuentas de conexión MySQL y los usuarios de la plataforma son identidades
distintas. La columna `tb_users.platform_role` conserva el rol de cada persona
y el procedimiento de pago la cambia a `buyer` al cubrir el pedido. El rol de
conexión MySQL permanece asociado a `AppWeb` o `AppMobile`; el superadmin
ejecuta las pruebas con esas cuentas de plataforma identificadas por `user_ID`.

## Comprobación sencilla

1. Crea una orden de prueba por caso y guarda su ID.
2. Escribe los cinco ID en `@caso1` a `@caso5` al inicio de
   `verificacion_casos_compra.sql`.
3. Ejecuta el archivo. Revisa que la compra normal figure `Delivered`, la
   orden parcial tenga saldo pendiente, la cancelación tenga un reembolso
   completado, la recolección muestre `PickedUp`, y la orden sin stock figure
   `Canceled` con el cupón activo y su saldo intacto.
