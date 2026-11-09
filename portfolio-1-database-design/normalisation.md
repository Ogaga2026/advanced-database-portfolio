# Normalisation - NaijaCart - 6 Tables in 3NF

Database has 6 tables only: warehouses, customers, products, orders, order_items, payments. No Vendors, no Categories table, no Shipments table.

## 1NF - No repeating groups
Each column holds one value. Example: customers.phone holds one phone number, not list. order_items holds one product per row, not many products in one row.

## 2NF - No partial dependency
All tables use single-column surrogate PK, so no partial dependency:
- warehouses(warehouse_id), customers(customer_id), products(product_id), orders(order_id), order_items(order_item_id), payments(payment_id)
- order_items uses order_item_id PK, NOT composite (order_id, product_id). So quantity and unit_price depend on full PK.

## 3NF - No transitive dependency
- customers: city, state depend on customer_id only, not on email. email is unique but not used as FK.
- products: category, price, stock_quantity depend on product_id only. warehouse_id is FK to warehouses. Category is stored as text in products because there is no separate Categories table.
- orders: total_amount depends on order_id only. customer_id and warehouse_id are FKs. warehouse_id in orders is the fulfilment warehouse for that order, which can differ from products.warehouse_id.
- payments: amount, payment_method depend on payment_id only, not on order_id. order_id is FK.
- No Vendors table, so no vendor dependency. No Shipments table, so delivery is tracked via orders.warehouse_id and orders.status.

## Why 3NF fits NaijaCart
Keeps money correct. If we store customer name inside orders, and customer changes name, we go get two names for same person. By keeping name only in customers, and using customer_id FK in orders, update happens in one place.
