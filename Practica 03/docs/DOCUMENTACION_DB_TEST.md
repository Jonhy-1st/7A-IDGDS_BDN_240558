# Diccionario técnico de `db_test`

Fuente: respaldo SQL [240558_Respaldo_com_responsables_dbuser.sql](../backups/240558_Respaldo_com_responsables_dbuser.sql).
Huella SHA-256 del archivo: `8242d2e7a82f3e2b2c326fda9989c7d676d061933ad43ad2e750a057d0e7a766`.
Esta ficha resume exclusivamente declaraciones y sentencias encontradas en ese respaldo. No documenta reglas funcionales que no estén expresadas en el DDL.

## Resumen del archivo

- Base indicada por el dump: `db_test`.
- Tablas: 27; columnas: 213; claves foráneas declaradas: 28.
- Filas en sentencias `INSERT` del dump: 105886. Este conteo no representa el estado actual de una instancia.
- Objetos nombrados en el archivo: 23 vistas, 72 triggers, 6 procedimientos y 2 funciones.
- Referencias FK con tabla destino también declarada: 23; con tabla destino ausente en el respaldo: 5.

## Tablas y filas `INSERT`

| Tabla | Columnas | Filas encontradas en INSERT | Índices | FKs |
|---|---:|---:|---:|---:|
| [`tb_buyer_orders`](diccionario/tb_buyer_orders.md) | 10 | 0 | 4 | 2 |
| [`tb_carts`](diccionario/tb_carts.md) | 4 | 0 | 2 | 1 |
| [`tb_logs`](diccionario/tb_logs.md) | 8 | 50543 | 3 | 0 |
| [`tb_order_cancellations`](diccionario/tb_order_cancellations.md) | 11 | 0 | 6 | 4 |
| [`tb_payment_methods`](diccionario/tb_payment_methods.md) | 5 | 5 | 2 | 0 |
| [`tb_payment_transaction`](diccionario/tb_payment_transaction.md) | 6 | 0 | 1 | 0 |
| [`tb_payments`](diccionario/tb_payments.md) | 12 | 0 | 6 | 2 |
| [`tb_people`](diccionario/tb_people.md) | 12 | 2 | 2 | 1 |
| [`tb_product_responsibility_mapping`](diccionario/tb_product_responsibility_mapping.md) | 11 | 15000 | 5 | 4 |
| [`tb_products`](diccionario/tb_products.md) | 9 | 15000 | 2 | 0 |
| [`tb_refunds`](diccionario/tb_refunds.md) | 13 | 0 | 6 | 3 |
| [`tb_returns`](diccionario/tb_returns.md) | 13 | 0 | 5 | 3 |
| [`tb_shipments`](diccionario/tb_shipments.md) | 11 | 0 | 3 | 1 |
| [`tb_user_addresses`](diccionario/tb_user_addresses.md) | 8 | 0 | 1 | 0 |
| [`tb_user_identity_mapping`](diccionario/tb_user_identity_mapping.md) | 9 | 7 | 3 | 1 |
| [`tb_users`](diccionario/tb_users.md) | 8 | 10229 | 3 | 0 |
| [`tbc_categories`](diccionario/tbc_categories.md) | 7 | 100 | 3 | 1 |
| [`tbc_payment_methods_types`](diccionario/tbc_payment_methods_types.md) | 4 | 0 | 1 | 0 |
| [`tbd_address_components`](diccionario/tbd_address_components.md) | 4 | 0 | 1 | 0 |
| [`tbd_cancellation_items`](diccionario/tbd_cancellation_items.md) | 5 | 0 | 1 | 0 |
| [`tbd_cart_items`](diccionario/tbd_cart_items.md) | 5 | 0 | 1 | 0 |
| [`tbd_order_items`](diccionario/tbd_order_items.md) | 6 | 0 | 2 | 1 |
| [`tbd_products_categories`](diccionario/tbd_products_categories.md) | 5 | 0 | 2 | 2 |
| [`tbd_products_users_providers`](diccionario/tbd_products_users_providers.md) | 7 | 15000 | 2 | 2 |
| [`tbd_return_items`](diccionario/tbd_return_items.md) | 10 | 0 | 4 | 0 |
| [`tbd_user_payment_methods`](diccionario/tbd_user_payment_methods.md) | 5 | 0 | 1 | 0 |
| [`tbd_users_wishlist_products`](diccionario/tbd_users_wishlist_products.md) | 5 | 0 | 1 | 0 |

## Objetos referenciados por el DDL

### Vistas

- `vw_total_products_by_category`
- `vw_trazabilidad_actividad_usuarios`
- `vw_trazabilidad_carritos`
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
- `vw_trazabilidad_people`
- `vw_trazabilidad_productos`
- `vw_trazabilidad_productos_categorias`
- `vw_trazabilidad_proveedores`
- `vw_trazabilidad_proveedores_productos`
- `vw_trazabilidad_resenas`
- `vw_trazabilidad_roles`
- `vw_trazabilidad_usuarios`
- `vw_trazabilidad_vendedores`

### Triggers

- `trg_audit_tb_buyer_orders_insert`
- `trg_audit_tb_buyer_orders_update`
- `trg_audit_tb_buyer_orders_delete`
- `trg_audit_tb_carts_insert`
- `trg_audit_tb_carts_update`
- `trg_audit_tb_carts_delete`
- `trg_audit_tb_order_cancellations_insert`
- `trg_audit_tb_order_cancellations_update`
- `trg_audit_tb_order_cancellations_delete`
- `trg_audit_tb_payment_methods_insert`
- `trg_audit_tb_payment_methods_update`
- `trg_audit_tb_payment_methods_delete`
- `trg_audit_tb_payment_transaction_insert`
- `trg_audit_tb_payment_transaction_update`
- `trg_audit_tb_payment_transaction_delete`
- `trg_audit_tb_payments_insert`
- `trg_audit_tb_payments_update`
- `trg_audit_tb_payments_delete`
- `trg_people_after_insert`
- `trg_people_after_update`
- `trg_people_after_delete`
- `trg_tb_products_after_insert`
- `trg_tb_products_after_update`
- `trg_tb_products_after_delete`
- `trg_audit_tb_refunds_insert`
- `trg_audit_tb_refunds_update`
- `trg_audit_tb_refunds_delete`
- `trg_audit_tb_returns_insert`
- `trg_audit_tb_returns_update`
- `trg_audit_tb_returns_delete`
- `trg_audit_tb_shipments_insert`
- `trg_audit_tb_shipments_update`
- `trg_audit_tb_shipments_delete`
- `trg_audit_tb_user_addresses_insert`
- `trg_audit_tb_user_addresses_update`
- `trg_audit_tb_user_addresses_delete`
- `trg_tb_users_after_insert`
- `trg_tb_users_after_update`
- `trg_tb_users_after_delete`
- `trg_tbc_categories_after_insert`
- `trg_tbc_categories_after_update`
- `trg_tbc_categories_after_delete`
- `trg_audit_tbc_payment_methods_types_insert`
- `trg_audit_tbc_payment_methods_types_update`
- `trg_audit_tbc_payment_methods_types_delete`
- `trg_audit_tbd_address_components_insert`
- `trg_audit_tbd_address_components_update`
- `trg_audit_tbd_address_components_delete`
- `trg_audit_tbd_cancellation_items_insert`
- `trg_audit_tbd_cancellation_items_update`
- `trg_audit_tbd_cancellation_items_delete`
- `trg_audit_tbd_cart_items_insert`
- `trg_audit_tbd_cart_items_update`
- `trg_audit_tbd_cart_items_delete`
- `trg_audit_tbd_order_items_insert`
- `trg_audit_tbd_order_items_update`
- `trg_audit_tbd_order_items_delete`
- `trg_tbd_prod_cat_after_insert`
- `trg_tbd_prod_cat_after_update`
- `trg_tbd_prod_cat_after_delete`
- `trg_after_insert_products_users_providers`
- `trg_after_update_products_users_providers`
- `trg_after_delete_products_users_providers`
- `trg_audit_tbd_return_items_insert`
- `trg_audit_tbd_return_items_update`
- `trg_audit_tbd_return_items_delete`
- `trg_audit_tbd_user_payment_methods_insert`
- `trg_audit_tbd_user_payment_methods_update`
- `trg_audit_tbd_user_payment_methods_delete`
- `trg_audit_tbd_users_wishlist_products_insert`
- `trg_audit_tbd_users_wishlist_products_update`
- `trg_audit_tbd_users_wishlist_products_delete`

### Procedimientos y funciones

- Procedimiento: `sp_generate_users_batch`
- Procedimiento: `sp_insert_single_user`
- Procedimiento: `sp_register_new_user`
- Procedimiento: `sp_restore_product`
- Procedimiento: `sp_soft_delete_product`
- Procedimiento: `sp_soft_delete_user`
- Función: `fn_generate_birthdate_by_age`
- Función: `fn_generate_random_email`

## Claves foráneas cuyo destino no está declarado

- `tb_buyer_orders.fk_seller_orders_order`: (order_ID) → `tb_orders(ID)`; ON DELETE RESTRICT; ON UPDATE CASCADE.
- `tb_order_cancellations.fk_cancellation_order`: (order_ID) → `tb_orders(ID)`; ON DELETE RESTRICT; ON UPDATE (no especificado en DDL).
- `tb_payments.fk_payment_order`: (order_ID) → `tb_orders(ID)`; ON DELETE (no especificado en DDL); ON UPDATE (no especificado en DDL).
- `tb_returns.fk_return_order`: (order_ID) → `tb_orders(ID)`; ON DELETE RESTRICT; ON UPDATE (no especificado en DDL).
- `tbd_order_items.fk_order_item_order`: (order_ID) → `tb_orders(ID)`; ON DELETE CASCADE; ON UPDATE (no especificado en DDL).

Las relaciones con destinos ausentes se conservan como declaraciones del SQL; este documento no agrega entidades implícitas para resolverlas.

## Archivos asociados

- [CSV por campo](../diccionario/campos.csv)
- [Explorador HTML](../diccionario/diccionario.html)
- Fichas individuales en `diccionario/`, una por tabla.
- El explorador permite cargar otro `.sql` local. Esa selección actualiza la interfaz en el navegador y no envía el archivo a un servidor.
