# Final Documentation - NaijaCart - Advanced Database Portfolio
MIT 8103 - Erhiyoma Oghenevwogaga - Ogaga2026

## Case Study
NaijaCart na Nigerian online shopping platform for Lagos Flash Sales. E dey handle high concurrent users during Black Friday.

Postgres for money (orders, payments, inventory). MongoDB for catalog (products with different attributes, behaviour tracking).

## Portfolio 1 - Schema Design
File: `portfolio-1-database-design/relational-schema.sql`
ER Diagram: `portfolio-1-database-design/er-diagram.jpg`

6 tables only, all in 3NF:
- warehouses(warehouse_id PK, name, city, state, capacity)
- customers(customer_id PK, full_name, email, phone, city, state, created_at)
- products(product_id PK, name, category, price, stock_quantity, warehouse_id FK)
- orders(order_id PK, customer_id FK, warehouse_id FK, order_date, status, total_amount)
- order_items(order_item_id PK, order_id FK, product_id FK, quantity, unit_price)
- payments(payment_id PK, order_id FK, payment_date, amount, payment_method, status)

Key points:
- order_items uses single PK order_item_id, NOT composite (order_id, product_id)
- orders.warehouse_id is the fulfilment warehouse for that order. It can differ from products.warehouse_id.
- No Vendors, Categories, or Shipments tables. Category is stored as text in products.

## Portfolio 2 - Sample Data & Optimisation
File: `portfolio-2-sample-data-optimization/`

Sample data loaded for all 6 tables. Indexes added on columns used in WHERE and JOIN: orders(customer_id), orders(warehouse_id), order_items(order_id), order_items(product_id), payments(order_id), products(warehouse_id).

Optimisation approach: Use EXPLAIN ANALYZE to compare before and after index. Report actual plan output saved in portfolio-2 file, not assumed timings. Warehouse sales query uses orders.warehouse_id (fulfilment warehouse), not products.warehouse_id, to avoid misstating sales when fulfilment warehouse differs from product warehouse.

## Portfolio 3 - Transactions & Concurrency
File: `portfolio-3-transactions-concurrency/`

Example: Two customers try to buy last Ankara at same time.
Solution: `BEGIN; SELECT stock_quantity FROM products WHERE product_id = 1 FOR UPDATE; UPDATE products SET stock_quantity = stock_quantity - 1 WHERE product_id = 1; INSERT INTO orders...; INSERT INTO order_items...; COMMIT;`
FOR UPDATE locks the product row until COMMIT, so second customer waits and sees updated stock. Prevents overselling.
Isolation levels tested: READ COMMITTED vs REPEATABLE READ. Deadlock example included where two transactions lock products in opposite order.

## Portfolio 4 - NoSQL Implementation
File: `portfolio-4-nosql-implementation/`

MongoDB collections mirror the 6 relational tables but with flexible schema. Products collection uses embedded attributes: `{ name, category, price, attributes: { sizes, colours } }` - for Postgres this would need separate table.
Prices kept consistent with Postgres sample data. Example: Laptop Stand is same price in both systems. No duplicate price for same product.
Aggregation: Total sales per category is grouped by products.category via $lookup from order_items to products, then $group by category. It does NOT group by order status, and it does NOT double-count orders with many items - it sums quantity * unit_price per line item.

## Portfolio 5 - Distributed & Cloud
File: `portfolio-5-distributed-cloud/`

Proposed architecture, NOT tested with 3-node replica set in this repo:
- Docker Compose in this repo runs 1 MongoDB instance (mongo:6) for development. It does NOT run 3 replica members.
- Proposed production: Replica Set naijacartRS - Lagos Primary, Abuja Secondary, Port Harcourt Hidden Backup. Lagos down -> Abuja takes over.
- Proposed sharding: `sh.shardCollection("naijacart.products", { category: 1, warehouse_id: 1 })`
- CAP: Orders = Consistency with writeConcern { w: "majority" }, Catalog = Availability with readPreference secondaryPreferred.
- This section is design proposal. Full 3-node replica + sharding infrastructure is not configured in docker-compose.yml in this repo.

## How To Run
```bash
docker-compose up -d
# Postgres on 5432, MongoDB on 27017
# Postgres auto-loads portfolio-1-database-design/relational-schema.sql
