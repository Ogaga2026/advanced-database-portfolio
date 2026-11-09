# Normalisation - NaijaCart - 6 Tables in 3NF

Database has 6 tables only: warehouses, customers, products, orders, order_items, payments.
No Vendors, no Categories table. Matches er-diagram.jpg and relational-schema.sql exactly.

## 1NF - No repeating groups

Each column holds one atomic value.
Example: customers.phone holds one phone number, not a list. order_items holds one product per row.
No repeating groups, no multi-valued columns.

## 2NF - No partial dependency

All tables use single-column surrogate PK, so no partial dependency is possible.
- warehouses(warehouse_id), customers(customer_id), products(product_id), orders(order_id), order_items(order_item_id), payments(payment_id)
- order_items uses order_item_id as PK, NOT composite (order_id, product_id). So quantity and unit_price depend on full PK.

## 3NF - No transitive dependency

- customers: city, state depend on customer_id only, not on email. No transitive dependency.
- products: category, price, stock_quantity depend on product_id only. warehouse_id is a FK to warehouses. Category is stored as text, there is no separate Categories table.
- orders: total_amount depends on order_id only. customer_id and warehouse_id are FKs. No PKs, warehouse_id is in orders to show which warehouse fulfilled the order.
- order_items: quantity, unit_price depend on order_item_id only.
- payments: amount, payment_method, status depend on payment_id only. order_id is a FK to orders.

Conclusion: All 6 tables are in 3NF. No transitive dependency remains.
