# NaijaCart - Advanced Database Portfolio
MIT 8103 - Erhiyoma Oghenevwogaga - Ogaga2026

NaijaCart na Nigerian online shopping platform for Lagos Flash Sales. E dey handle high concurrent users during Black Friday.

Postgres for money (orders, payments, inventory). MongoDB for catalog (products with different attributes).

## 6 Tables Only

The database has 6 tables, NOT 8.

- warehouses(warehouse_id PK, name, city, state, capacity)
- customers(customer_id PK, full_name, email, phone, city, state, created_at)
- products(product_id PK, name, category, price, stock_quantity, warehouse_id FK)
- orders(order_id PK, customer_id FK, warehouse_id FK, order_date, status, total_amount)
- order_items(order_item_id PK, order_id FK, product_id FK, quantity, unit_price)
- payments(payment_id PK, order_id FK, payment_date, amount, payment_method, status)

Key points:
- order_items uses single PK order_item_id, NOT composite (order_id, product_id)
- orders.warehouse_id is fulfilment warehouse. It can differ from products.warehouse_id.
- No Vendors, Categories, or Shipments tables. Category is stored as text in products.
- Laptop Stand price is 25000 in BOTH Postgres and MongoDB.

## Structure

- `portfolio-1-database-design/` - Schema design, 6 tables in 3NF
- `portfolio-2-sample-data-optimization/` - Sample data + indexes + EXPLAIN ANALYZE
- `portfolio-3-transactions-concurrency/` - FOR UPDATE, isolation levels
- `portfolio-4-nosql-implementation/` - MongoDB, 6 collections to match 6 tables
- `portfolio-5-distributed-cloud/` - PROPOSED architecture, not tested 3-node replica
- `Final_Documentation.md` - Full documentation
- `docker-compose.yml` - Postgres + MongoDB for development

## How To Run

```bash
docker-compose up -d
# Postgres on 5432, MongoDB on 27017
# Postgres auto-loads portfolio-1-database-design/relational-schema.sql
