# NaijaCart - Final Documentation
Erhiyoma Oghenevwogaga - Ogaga2026

## What NaijaCart Is
NaijaCart is a small e-commerce database for Nigeria. Warehouses in Lagos and Abuja, customers, products like Laptop Stand (25000) and Wireless Mouse (12000), orders.

## Portfolio 1 - Design
PostgreSQL tables: warehouses, customers, products, orders, order_items, payments. Warehouses: warehouse_id, name, city, state, capacity. Products: product_id, name, category, price, stock_quantity, warehouse_id.

## Portfolio 2 - Query Optimisation
Query: orders by warehouse_id. First EXPLAIN: Seq Scan. Then CREATE INDEX idx_orders_warehouse_id. Second EXPLAIN: Index Scan, faster. DROP INDEX IF EXISTS was run first so index did not exist before first run. Evidence: portfolio-2-sample-data/EXPLAIN_results.txt

## Portfolio 3 - Transactions
Two overlapping transactions. Session A locks row, Session B WAITS, then proceeds after COMMIT. No lost update. Evidence: portfolio-3-transactions/concurrency/test_results.txt

## Portfolio 4 - MongoDB
Collections: warehouses, customers, products, orders, order_items, payments. Matches nosql_implementation.js. Laptop Stand = 25000 in both databases. Evidence: portfolio-4-nosql/mongo_results.txt

## Portfolio 5 - Distributed - PROPOSED
Replica set proposal in distributed_implementation.js. NOT tested. Aims to reduce data loss, does NOT guarantee 100% no data loss.

## What I Learned
1. Design first: I learned to design 6 tables with proper keys before writing any code. This stopped confusion later.
2. Transactions protect business: In Portfolio 3, I used place_order() with FOR UPDATE row-level locking to stop lost updates.
3. Consistency matters: Prices MUST match in BOTH systems. Example: Laptop Stand = 25000 in PostgreSQL AND 25000 in MongoDB. If you see 35000 anywhere, na mistake.

## How To Run
docker-compose up -d PostgreSQL: localhost:5432 MongoDB: localhost:27017

## Consistency Rule
Prices MUST match in BOTH systems. Example: Laptop Stand = 25000 in PostgreSQL AND 25000 in MongoDB.
