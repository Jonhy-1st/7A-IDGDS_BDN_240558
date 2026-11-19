# Diccionario técnico de `db_test`

Fuente: respaldo SQL [Respaldo_Practica4.sql](../backups/Respaldo_Practica4.sql).
Huella SHA-256 del archivo: `ed941c888be8bd17d759acbcec9824ba173ad4094795d47012b7cc702bdf3880`.
- Este respaldo es una copia derivada del dump guardado; conserva sus datos y materializa los cambios de esquema, pero no es una extracción nueva de un servidor en vivo.
Esta ficha resume exclusivamente declaraciones y sentencias encontradas en ese respaldo. No documenta reglas funcionales que no estén expresadas en el DDL.

## Resumen del archivo

- Base indicada por el dump: `db_test`.
- Tablas: 27; columnas: 234; claves foráneas declaradas: 34.
- Filas en sentencias `INSERT` del dump: 123820. Este conteo no representa el estado actual de una instancia.
- Objetos nombrados en el archivo: 36 vistas, 85 triggers, 21 procedimientos y 2 funciones.
- Referencias FK con tabla destino también declarada: 34; con tabla destino ausente en el respaldo: 0.

## Tablas y filas `INSERT`

| Tabla | Columnas | Filas encontradas en INSERT | Índices | FKs |
|---|---:|---:|---:|---:|
| [`tb_buyer_orders`](diccionario/tb_buyer_orders.md) | 9 | 8 | 2 | 1 |
| [`tb_carts`](diccionario/tb_carts.md) | 6 | 8 | 3 | 1 |
| [`tb_logs`](diccionario/tb_logs.md) | 9 | 63970 | 1 | 0 |
| [`tb_order_cancellations`](diccionario/tb_order_cancellations.md) | 11 | 1 | 6 | 3 |
| [`tb_payment_transactions`](diccionario/tb_payment_transactions.md) | 7 | 36 | 3 | 1 |
| [`tb_payments`](diccionario/tb_payments.md) | 15 | 13 | 5 | 2 |
| [`tb_people`](diccionario/tb_people.md) | 12 | 10025 | 2 | 1 |
| [`tb_products`](diccionario/tb_products.md) | 9 | 15007 | 2 | 0 |
| [`tb_refunds`](diccionario/tb_refunds.md) | 13 | 1 | 6 | 3 |
| [`tb_returns`](diccionario/tb_returns.md) | 14 | 1 | 6 | 3 |
| [`tb_seller_orders`](diccionario/tb_seller_orders.md) | 8 | 8 | 3 | 2 |
| [`tb_shipments`](diccionario/tb_shipments.md) | 14 | 7 | 4 | 2 |
| [`tb_user_addresses`](diccionario/tb_user_addresses.md) | 12 | 7 | 2 | 1 |
| [`tb_users`](diccionario/tb_users.md) | 9 | 10025 | 3 | 0 |
| [`tbc_categories`](diccionario/tbc_categories.md) | 7 | 100 | 3 | 1 |
| [`tbc_payment_methods_types`](diccionario/tbc_payment_methods_types.md) | 6 | 5 | 2 | 0 |
| [`tbc_payment_methods_types_res`](diccionario/tbc_payment_methods_types_res.md) | 4 | 0 | 1 | 0 |
| [`tbd_address_components`](diccionario/tbd_address_components.md) | 8 | 12 | 3 | 2 |
| [`tbd_cancellation_items`](diccionario/tbd_cancellation_items.md) | 5 | 1 | 1 | 0 |
| [`tbd_cart_items`](diccionario/tbd_cart_items.md) | 5 | 33 | 2 | 2 |
| [`tbd_order_items`](diccionario/tbd_order_items.md) | 9 | 33 | 3 | 2 |
| [`tbd_orders`](diccionario/tbd_orders.md) | 9 | 0 | 1 | 0 |
| [`tbd_products_categories`](diccionario/tbd_products_categories.md) | 5 | 9544 | 2 | 2 |
| [`tbd_return_items`](diccionario/tbd_return_items.md) | 5 | 1 | 1 | 0 |
| [`tbd_user_payment_methods`](diccionario/tbd_user_payment_methods.md) | 12 | 7 | 4 | 2 |
| [`tbd_users_offer_products`](diccionario/tbd_users_offer_products.md) | 8 | 14967 | 3 | 1 |
| [`tbd_wishlist_products`](diccionario/tbd_wishlist_products.md) | 3 | 0 | 2 | 2 |

## Para qué sirve cada tabla

- **[tb_buyer_orders](diccionario/tb_buyer_orders.md):** Guarda el pedido general que hace una persona: quién compra, cuántos artículos incluye, cuánto cuesta y en qué etapa está. Se relaciona con usuarios, pedidos por vendedor, pagos y cancelaciones.
- **[tb_carts](diccionario/tb_carts.md):** Guarda los carritos de cada persona antes de confirmar una compra. El estado distingue el carrito activo, convertido o abandonado; la columna calculada permite varios carritos históricos y limita a uno activo por usuario. Los productos están en tbd_cart_items.
- **[tb_logs](diccionario/tb_logs.md):** Conserva la bitácora de acciones hechas sobre la base, como altas, cambios y bajas. Guarda la tabla afectada, la cuenta de conexión, la fecha y una descripción para poder rastrear operaciones.
- **[tb_order_cancellations](diccionario/tb_order_cancellations.md):** Registra una solicitud para cancelar uno o más artículos de un pedido, quién la solicitó, el motivo y si fue solicitada, aprobada, rechazada o completada. Los artículos se detallan en tbd_cancellation_items.
- **[tb_payment_transactions](diccionario/tb_payment_transactions.md):** Guarda cada evento de un cobro o devolución, por ejemplo creación, autorización, captura, rechazo o reembolso. Cada evento pertenece a un registro de tb_payments.
- **[tb_payments](diccionario/tb_payments.md):** Representa un cobro, intento de cobro o cuota de un pedido. Guarda el importe, medio, estado, fechas y referencia al instrumento del cliente; sus eventos se registran en tb_payment_transactions.
- **[tb_people](diccionario/tb_people.md):** Guarda los datos personales de una cuenta, como nombre, apellidos, nacimiento, país y teléfono. Se relaciona con tb_users, que contiene las credenciales de acceso.
- **[tb_products](diccionario/tb_products.md):** Es el catálogo general de productos. Guarda nombre, SKU, precio, existencia general y estado de publicación; las ofertas concretas de vendedores están en tbd_users_offer_products.
- **[tb_refunds](diccionario/tb_refunds.md):** Registra el dinero que se devuelve por una cancelación o una devolución de producto. Indica el pago de origen, el motivo, el importe y el estado del reembolso.
- **[tb_returns](diccionario/tb_returns.md):** Registra la reclamación de un producto entregado, su motivo, cantidad, revisión y resolución. Puede vincular un envío de reemplazo en tb_shipments.
- **[tb_seller_orders](diccionario/tb_seller_orders.md):** Divide un pedido general en las partes que prepara cada vendedor. Guarda el vendedor, subtotal, costo de envío y estado de preparación o entrega.
- **[tb_shipments](diccionario/tb_shipments.md):** Sigue el envío asociado a una parte del pedido de un vendedor: destino, paquetería, guía y estado. También permite indicar entrega en domicilio o recolección en un punto.
- **[tb_user_addresses](diccionario/tb_user_addresses.md):** Guarda los domicilios de entrega de cada cuenta, con etiqueta, destinatario, teléfono e instrucciones. Los envíos apuntan aquí cuando se entregan en domicilio.
- **[tb_users](diccionario/tb_users.md):** Contiene las cuentas de acceso de la plataforma: correo, alias, contraseña protegida con hash, estado y rol de plataforma. Los datos personales complementarios se guardan en tb_people.
- **[tbc_categories](diccionario/tbc_categories.md):** Es el catálogo de categorías que organiza los productos, como ropa o accesorios. La relación entre cada producto y sus categorías está en tbd_products_categories.
- **[tbc_payment_methods_types](diccionario/tbc_payment_methods_types.md):** Es el catálogo de tipos de instrumentos que una persona puede guardar, como tarjetas, cuenta SPEI, billetera digital o cupón simulados. Los instrumentos individuales están en tbd_user_payment_methods.
- **[tbc_payment_methods_types_res](diccionario/tbc_payment_methods_types_res.md):** Es un catálogo auxiliar de tipos de medio de pago utilizado por el esquema anterior. Sus nombres y descripciones son referencias de catálogo; el modelo actual de instrumentos usa tbc_payment_methods_types.
- **[tbd_address_components](diccionario/tbd_address_components.md):** Divide un domicilio en partes estructuradas, como componentes geográficos o administrativos. Se relaciona con tb_user_addresses y permite anidar una parte dentro de otra mediante su referencia a sí misma.
- **[tbd_cancellation_items](diccionario/tbd_cancellation_items.md):** Detalla qué renglones y cantidades se solicitan cancelar dentro de una solicitud de tb_order_cancellations. Permite calcular el ajuste y el reembolso usando el precio guardado en tbd_order_items.
- **[tbd_cart_items](diccionario/tbd_cart_items.md):** Contiene los productos y cantidades que una persona agrega al carrito. Cada renglón relaciona un carrito con una oferta de vendedor.
- **[tbd_order_items](diccionario/tbd_order_items.md):** Guarda los artículos confirmados dentro de un pedido de vendedor, con el nombre y precio que tenían al comprarse. Conserva la cantidad original y registra aparte las unidades canceladas; el subtotal muestra solo las unidades vigentes.
- **[tbd_orders](diccionario/tbd_orders.md):** Conserva una estructura de pedido anterior o auxiliar con clave, cantidades, total y estado. En este respaldo no tiene claves foráneas declaradas que la conecten al flujo actual de compra.
- **[tbd_products_categories](diccionario/tbd_products_categories.md):** Asocia productos del catálogo con sus categorías. Es una relación de muchos a muchos entre tb_products y tbc_categories.
- **[tbd_return_items](diccionario/tbd_return_items.md):** Detalla los renglones y cantidades que forman parte de una reclamación o devolución, junto con notas sobre la condición recibida. Se complementa con tb_returns y tbd_order_items.
- **[tbd_user_payment_methods](diccionario/tbd_user_payment_methods.md):** Guarda instrumentos de pago simulados de cada persona, como tarjeta o cupón: tipo, proveedor, referencia, últimos cuatro dígitos y saldo opcional. Los pagos los referencian sin guardar el número completo de la tarjeta.
- **[tbd_users_offer_products](diccionario/tbd_users_offer_products.md):** Representa la oferta de un producto hecha por un vendedor: quién lo vende, qué producto ofrece, cuántas unidades tiene y si la oferta está activa. Los carritos y pedidos apuntan a esta oferta.
- **[tbd_wishlist_products](diccionario/tbd_wishlist_products.md):** Relaciona los productos que una persona desea guardar para después. Vincula la cuenta con el producto y evita confundir la lista de deseos con el carrito de compra.

## Objetos referenciados por el DDL

### Vistas

- `vw_total_products_by_category`
- `vw_trazabilidad_actividad_usuarios`
- `vw_trazabilidad_buyer_orders`
- `vw_trazabilidad_carritos`
- `vw_trazabilidad_carts`
- `vw_trazabilidad_carts_items`
- `vw_trazabilidad_categorias`
- `vw_trazabilidad_consolidado_general`
- `vw_trazabilidad_cupones`
- `vw_trazabilidad_direcciones`
- `vw_trazabilidad_envios`
- `vw_trazabilidad_historial_productos`
- `vw_trazabilidad_inventario`
- `vw_trazabilidad_lista_deseos`
- `vw_trazabilidad_lista_deseos_estado`
- `vw_trazabilidad_logs`
- `vw_trazabilidad_ordenes_compradores`
- `vw_trazabilidad_order_items`
- `vw_trazabilidad_payment_methods_types`
- `vw_trazabilidad_payment_transactions`
- `vw_trazabilidad_payments`
- `vw_trazabilidad_people`
- `vw_trazabilidad_productos`
- `vw_trazabilidad_productos_categorias`
- `vw_trazabilidad_proveedores`
- `vw_trazabilidad_proveedores_productos`
- `vw_trazabilidad_resenas`
- `vw_trazabilidad_resumen_pedidos`
- `vw_trazabilidad_roles`
- `vw_trazabilidad_seller_orders`
- `vw_trazabilidad_tb_payment_methods`
- `vw_trazabilidad_tb_payment_transaction`
- `vw_trazabilidad_users_offer_products`
- `vw_trazabilidad_usuarios`
- `vw_trazabilidad_vendedores`
- `vw_trazabilidad_wishlist_products`

### Triggers

- `trg_validate_tb_buyer_orders_before_insert`
- `trg_buyer_orders_after_insert`
- `trg_buyer_orders_after_update`
- `trg_buyer_orders_after_delete`
- `trg_carts_after_insert`
- `trg_carts_after_update`
- `trg_carts_after_delete`
- `trg_audit_tb_order_cancellations_insert`
- `trg_audit_tb_order_cancellations_update`
- `trg_audit_tb_order_cancellations_delete`
- `trg_payment_transactions_after_insert`
- `trg_payment_transactions_after_update`
- `trg_payment_transactions_after_delete`
- `trg_payments_after_insert`
- `trg_payments_after_update`
- `trg_payments_after_delete`
- `trg_persons_insert`
- `trg_people_after_insert`
- `trg_persons_update`
- `trg_people_after_update`
- `trg_persons_delete`
- `trg_people_after_delete`
- `trg_validate_tb_products_before_insert`
- `trg_products_after_insert`
- `trg_products_after_update`
- `trg_products_after_delete`
- `trg_adapt_audit_refunds_insert`
- `trg_adapt_audit_refunds_update`
- `trg_adapt_audit_refunds_delete`
- `trg_adapt_audit_returns_insert`
- `trg_adapt_audit_returns_update`
- `trg_adapt_audit_returns_delete`
- `trg_seller_orders_after_insert`
- `trg_seller_orders_after_update`
- `trg_seller_orders_after_delete`
- `trg_adapt_audit_shipments_insert`
- `trg_adapt_audit_shipments_update`
- `trg_adapt_audit_shipments_delete`
- `trg_adapt_audit_user_addresses_insert`
- `trg_adapt_audit_user_addresses_update`
- `trg_adapt_audit_user_addresses_delete`
- `trg_validate_tb_users_before_insert`
- `trg_users_after_insert`
- `trg_users_after_update`
- `trg_users_after_delete`
- `trg_validate_tbc_categories_before_insert`
- `trg_tbc_categories_after_insert`
- `trg_tbc_categories_after_update`
- `trg_tbc_categories_after_delete`
- `trg_tbc_payment_methods_types_after_insert`
- `trg_tbc_payment_methods_types_after_update`
- `trg_tbc_payment_methods_types_after_delete`
- `trg_adapt_audit_payment_methods_types_res_insert`
- `trg_adapt_audit_payment_methods_types_res_update`
- `trg_adapt_audit_payment_methods_types_res_delete`
- `trg_adapt_audit_address_components_insert`
- `trg_adapt_audit_address_components_update`
- `trg_adapt_audit_address_components_delete`
- `trg_adapt_audit_cancellation_items_insert`
- `trg_adapt_audit_cancellation_items_update`
- `trg_adapt_audit_cancellation_items_delete`
- `trg_tbd_cart_items_after_insert`
- `trg_tbd_cart_items_after_update`
- `trg_tbd_cart_items_after_delete`
- `trg_tbd_order_items_after_insert`
- `trg_tbd_order_items_after_update`
- `trg_tbd_order_items_after_delete`
- `trg_tbd_orders_after_insert`
- `trg_tbd_orders_after_update`
- `trg_tbd_orders_after_delete`
- `trg_tbd_products_categories_after_insert`
- `trg_tbd_products_categories_after_update`
- `trg_tbd_products_categories_after_delete`
- `trg_adapt_audit_return_items_insert`
- `trg_adapt_audit_return_items_update`
- `trg_adapt_audit_return_items_delete`
- `trg_adapt_audit_user_payment_methods_insert`
- `trg_adapt_audit_user_payment_methods_update`
- `trg_adapt_audit_user_payment_methods_delete`
- `trg_tbd_users_offer_products_after_insert`
- `trg_tbd_users_offer_products_after_update`
- `trg_tbd_users_offer_products_after_delete`
- `trg_tbd_wishlist_products_after_insert`
- `trg_tbd_wishlist_products_after_update`
- `trg_tbd_wishlist_products_after_delete`

### Procedimientos y funciones

- Procedimiento: `sp_attend_order`
- Procedimiento: `sp_authorize_payment`
- Procedimiento: `sp_complete_partial_cancellation`
- Procedimiento: `sp_confirm_shipment_pickup`
- Procedimiento: `sp_create_order_shipments`
- Procedimiento: `sp_create_replacement_shipment`
- Procedimiento: `sp_deliver_order`
- Procedimiento: `sp_generate_users_batch`
- Procedimiento: `sp_insert_single_user`
- Procedimiento: `sp_mark_shipment_delivered`
- Procedimiento: `sp_pr04_attend_order`
- Procedimiento: `sp_pr04_deliver_order`
- Procedimiento: `sp_prepare_case_catalog_offers`
- Procedimiento: `sp_register_new_user`
- Procedimiento: `sp_register_test_payment_attempt`
- Procedimiento: `sp_restore_product`
- Procedimiento: `sp_set_shipment_ready_for_pickup`
- Procedimiento: `sp_soft_delete`
- Procedimiento: `sp_soft_delete_product`
- Procedimiento: `sp_soft_delete_user`
- Procedimiento: `sp_sync_people_from_users`
- Función: `fn_generate_birthdate_by_age`
- Función: `fn_generate_random_email`

## Claves foráneas cuyo destino no está declarado

- Ninguna.

Las relaciones con destinos ausentes se conservan como declaraciones del SQL; este documento no agrega entidades implícitas para resolverlas.

## Archivos asociados

- [CSV por campo](../diccionario/campos.csv)
- [Explorador HTML](../diccionario/diccionario.html)
- Fichas individuales en `diccionario/`, una por tabla.
- El explorador permite cargar otro `.sql` local. Esa selección actualiza la interfaz en el navegador y no envía el archivo a un servidor.
