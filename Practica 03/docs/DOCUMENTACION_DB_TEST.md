# Diccionario técnico de `db_test_corregida`

Fuente: respaldo SQL [respaldo_compra_usuarios.sql](../backups/respaldo_compra_usuarios.sql).
Huella SHA-256 del archivo: `20eff15c9d28e69975c07c1fb29d265dd8527cefb43781d630567aca1c39e279`.
Esta ficha resume exclusivamente declaraciones y sentencias encontradas en ese respaldo. No documenta reglas funcionales que no estén expresadas en el DDL.

## Resumen del archivo

- Base indicada por el dump: `db_test_corregida`.
- Tablas: 27; columnas: 225; claves foráneas declaradas: 33.
- Filas en sentencias `INSERT` del dump: 93530. Este conteo no representa el estado actual de una instancia.
- Objetos nombrados en el archivo: 36 vistas, 85 triggers, 13 procedimientos y 2 funciones.
- Referencias FK con tabla destino también declarada: 33; con tabla destino ausente en el respaldo: 0.

## Tablas y filas `INSERT`

| Tabla | Columnas | Filas encontradas en INSERT | Índices | FKs |
|---|---:|---:|---:|---:|
| [`tb_buyer_orders`](diccionario/tb_buyer_orders.md) | 9 | 2 | 2 | 1 |
| [`tb_carts`](diccionario/tb_carts.md) | 5 | 2 | 2 | 1 |
| [`tb_logs`](diccionario/tb_logs.md) | 9 | 48775 | 1 | 0 |
| [`tb_order_cancellations`](diccionario/tb_order_cancellations.md) | 11 | 0 | 6 | 3 |
| [`tb_payment_transactions`](diccionario/tb_payment_transactions.md) | 7 | 4 | 3 | 1 |
| [`tb_payments`](diccionario/tb_payments.md) | 13 | 2 | 5 | 2 |
| [`tb_people`](diccionario/tb_people.md) | 12 | 10024 | 2 | 1 |
| [`tb_products`](diccionario/tb_products.md) | 9 | 15007 | 2 | 0 |
| [`tb_refunds`](diccionario/tb_refunds.md) | 13 | 0 | 6 | 3 |
| [`tb_returns`](diccionario/tb_returns.md) | 13 | 0 | 5 | 2 |
| [`tb_seller_orders`](diccionario/tb_seller_orders.md) | 8 | 2 | 3 | 2 |
| [`tb_shipments`](diccionario/tb_shipments.md) | 12 | 2 | 4 | 2 |
| [`tb_user_addresses`](diccionario/tb_user_addresses.md) | 12 | 2 | 2 | 1 |
| [`tb_users`](diccionario/tb_users.md) | 8 | 10024 | 3 | 0 |
| [`tbc_categories`](diccionario/tbc_categories.md) | 7 | 100 | 3 | 1 |
| [`tbc_payment_methods_types`](diccionario/tbc_payment_methods_types.md) | 6 | 1 | 2 | 0 |
| [`tbc_payment_methods_types_res`](diccionario/tbc_payment_methods_types_res.md) | 4 | 0 | 1 | 0 |
| [`tbd_address_components`](diccionario/tbd_address_components.md) | 8 | 12 | 3 | 2 |
| [`tbd_cancellation_items`](diccionario/tbd_cancellation_items.md) | 5 | 0 | 1 | 0 |
| [`tbd_cart_items`](diccionario/tbd_cart_items.md) | 5 | 10 | 2 | 2 |
| [`tbd_order_items`](diccionario/tbd_order_items.md) | 8 | 10 | 3 | 2 |
| [`tbd_orders`](diccionario/tbd_orders.md) | 9 | 0 | 1 | 0 |
| [`tbd_products_categories`](diccionario/tbd_products_categories.md) | 5 | 9544 | 2 | 2 |
| [`tbd_return_items`](diccionario/tbd_return_items.md) | 5 | 0 | 1 | 0 |
| [`tbd_user_payment_methods`](diccionario/tbd_user_payment_methods.md) | 11 | 2 | 4 | 2 |
| [`tbd_users_offer_products`](diccionario/tbd_users_offer_products.md) | 8 | 5 | 3 | 1 |
| [`tbd_wishlist_products`](diccionario/tbd_wishlist_products.md) | 3 | 0 | 2 | 2 |

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
- Procedimiento: `sp_deliver_order`
- Procedimiento: `sp_generate_users_batch`
- Procedimiento: `sp_insert_single_user`
- Procedimiento: `sp_pr04_attend_order`
- Procedimiento: `sp_pr04_deliver_order`
- Procedimiento: `sp_register_new_user`
- Procedimiento: `sp_restore_product`
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
