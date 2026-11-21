# Guía sencilla para ejecutar y comprobar los casos

## Preparación, una sola vez

1. Haz una copia de seguridad de la base de pruebas.
2. Conéctate a `db_test` como superadmin.
3. Ejecuta `scripts/preparar_esquema_casos_compra.sql` una sola vez.
4. Ejecuta `scripts/operaciones_casos_compra.sql` para instalar las operaciones.
5. Ejecuta `CALL sp_prepare_case_catalog_offers();`. El resultado debe mostrar
   por lo menos 10 ofertas activas con existencia. Esta operación usa productos
   que ya existen y no crea tablas ni productos nuevos.
6. Ejecuta `scripts/crear_vistas_trazabilidad_casos.sql` para instalar las
   vistas que se consultan en la evidencia de `Trazabilidades/image.png`.

La migración está escrita para el esquema del respaldo de la práctica. No la
ejecutes sobre una base que ya tenga esos cambios aplicados: los `ALTER TABLE`
son migraciones de una sola ejecución.

## Consultar la trazabilidad

Después de ejecutar los casos y crear las vistas, ejecuta
`queries/trazabilidad_casos_compra.sql` en Workbench. El archivo consulta las
cinco trazabilidades y el resumen:

```sql
SELECT * FROM vw_practica04_caso_1 ORDER BY fecha_evento;
SELECT * FROM vw_practica04_caso_2 ORDER BY fecha_evento;
SELECT * FROM vw_practica04_caso_3 ORDER BY fecha_evento;
SELECT * FROM vw_practica04_caso_4 ORDER BY fecha_evento;
SELECT * FROM vw_practica04_caso_5 ORDER BY fecha_evento;
SELECT * FROM vw_practica04_resumen;
```

Las vistas están mapeadas a los pedidos `3`, `4` y `5` (reenvío del caso 2),
`6`, `7` y `8`, que son los IDs de la ejecución documentada. Si se restauró o
repitió la base y se generaron otros IDs, actualiza esos valores en el script de
vistas antes de ejecutarlo. La bitácora original no incluye un campo `caso_ID`;
por eso las vistas relacionan eventos con pedidos mediante los IDs presentes
en los detalles y las relaciones de pago, vendedor y envío. Los eventos sin una
referencia al pedido (por ejemplo, una cuenta creada sin `user_ID` en su
descripción) no se pueden atribuir con certeza a un caso.

## Para cobrar un pedido

Guarda el ID de la orden en `@pedido` y el ID del instrumento de pago en
`@instrumento`. Esta llamada representa un cobro aprobado de una sola exhibición:

```sql
SET @pago = NULL;
CALL sp_register_test_payment_attempt(
  @pedido, @instrumento, 100.00, 'Card', NULL, NULL,
  1, 'Pago autorizado para prueba', 'CASO-UNICO-001', @pago
);
CALL sp_pr04_attend_order(@pedido);
```

Usa el total real del pedido en lugar de `100.00`. `p_authorized=1` significa
aprobado; `p_authorized=0` registra un rechazo. Para efectivo usa `Cash`, para
SPEI usa `SPEI`, y para un cupón usa `Other` junto con un instrumento del tipo
`GIFT_COUPON_SIM`. La clave debe ser diferente en cada intento.

Tarjeta, Spin y SPEI deben vincularse a un instrumento del usuario. Guarda un
token ficticio y solo los últimos cuatro dígitos en
`tbd_user_payment_methods`; no registres los 16 dígitos completos.

## Cómo representar cada resultado

- **Caso 1:** termina el pago completo, atiende la orden y usa
  `sp_pr04_deliver_order(pedido, domicilio)`. Debe quedar `Delivered` y con el
  pago cubriendo el total.
- **Caso 2:** registra cinco cuotas aprobadas con número 1 a 5 de 6. Registra
  la sexta con `p_authorized=0` y detalle `Límite excedido de crédito`. Debe
  quedar `PartiallyPaid`, con saldo y sin envío. No se debe entregar una orden
  con deuda sin una política de crédito. Para probar reclamo y reenvío crea una
  segunda orden completamente pagada; registra el daño en `tb_returns`, pon la
  devolución en `Inspected` y llama a `sp_create_replacement_shipment`.
- Al recibir el reemplazo del caso 2, llama a `sp_mark_shipment_delivered`
  con el ID del envío nuevo; la devolución queda `Completed`.
- **Caso 3:** paga con `Card` y el instrumento `DIGITAL_WALLET_SIM` de Spin.
  Registra el renglón cancelado en `tbd_cancellation_items`, vincúlalo a una
  solicitud de `tb_order_cancellations` y llama a
  `sp_complete_partial_cancellation`. El procedimiento ajusta existencias,
  total de la orden y reembolso. `tbd_order_items.cancelled_quantity` conserva
  las unidades canceladas y el subtotal se recalcula automáticamente.
- **Caso 4:** después de atender la orden crea el envío con
  `sp_create_order_shipments(pedido, domicilio)`. Llama a
  `sp_set_shipment_ready_for_pickup(envío, 'Sucursal de prueba', 'PICK-001')`
  y cuando se recoja llama a `sp_confirm_shipment_pickup(envío, 'PICK-001')`.
  El estado final del envío debe ser `PickedUp`.
- **Caso 5:** usa un producto con existencia menor que la cantidad solicitada y
  un cupón con saldo suficiente. Al intentar el pago total, el procedimiento
  registra el intento fallido, cancela la orden y no consume el cupón.

## Comprobación en tres pasos

1. Abre `queries/verificacion_casos_compra.sql`. Ya contiene los IDs de la
   ejecución real actual (`3` a `8`). Si restauras otra copia o repites los
   casos, sustitúyelos; `@caso2_reenvio` lleva el pedido pagado del reclamo.
2. Ejecuta el archivo como superadmin.
3. Revisa los resultados:

   - Compra normal: orden `Delivered`, pagos cobrados por el total, usuario con
     `platform_role = 'buyer'` y envío entregado.
   - Última cuota rechazada: orden `PartiallyPaid`, un evento `Failed` y saldo
     pendiente.
   - Cancelación: `cancelled_quantity` y total actualizados, subtotal vigente y
     reembolso `Completed`.
   - Recolección: método `Pickup` y envío `PickedUp`.
   - Falta de inventario: orden `Canceled`, pago `Failed` y cupón activo con el
     mismo saldo.

`platform_role` guarda el rol de la persona en `tb_users` y cambia a `buyer`
cuando sus pagos cubren el total. Los roles MySQL `buyer` y
`user_not_registered` pertenecen a la cuenta de conexión; no pueden cambiar por
cliente si todos usan `AppWeb` o `AppMobile`. Por eso se conserva el rol de la
persona en su fila, mientras el superadmin realiza estas pruebas.
