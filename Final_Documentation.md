# NaijaCart - Final Documentation
**Erhiyoma Oghenevwogaga - Ogaga2026**
**GitHub: https://github.com/Ogaga2026/ac**

## 1. LMS Summary

### What NaijaCart Is
NaijaCart is a small e-commerce database for Nigeria. Warehouses in Lagos and Abuja, customers, products like Laptop Stand (25000), and orders.

### Portfolio 1 - Design
PostgreSQL tables: warehouses, customers, products, orders.
Warehouses: warehouse_id, name, city, state, capacity.
Products: product_id, name, price.

### Portfolio 2 - Query Optimisation
Query: orders by warehouse_id.
First EXPLAIN: Seq Scan. Then CREATE INDEX idx_orders_warehouse_id. Second EXPLAIN: Index Scan, faster.
DROP INDEX IF EXISTS was run first so index did not exist before first run.
Evidence: portfolio-2-query-optimisation/EXPLAIN_results.txt

### Portfolio 3 - Transactions
Two overlapping transactions. Session A locks row, Session B WAITS, then proceeds after COMMIT. No lost update.
Evidence: portfolio-3-transactions-concurrency/test_results.txt

### Portfolio 4 - MongoDB
Collections: products, customers, orders, order_items. Matches nosql_implementation.js.
Laptop Stand = 25000 in both databases.
Evidence: portfolio-4-nosql-mongodb/mongo_results.txt

### Portfolio 5 - Distributed - PROPOSED
Replica set proposal in distributed_implementation.js. NOT tested. Aims to reduce data loss, does NOT guarantee 100% no-data-loss.

### What I Learned
Column names must match schema. Index placement matters. Evidence must be terminal output, not descriptions.

## 2. Real Folders Only
- portfolio-1-database-design/
- portfolio-2-query-optimisation/
- portfolio-3-transactions-concurrency/
- portfolio-4-nosql-mongodb/
- portfolio-5-distributed-cloud/

## 3. Isolation Levels
READ COMMITTED was used. Locking behaviour is shown in test_results.txt. No separate isolation test claimed beyond this.

## 4. AI-Use Declaration
AI (Meta AI) was used for guidance and drafting. All SQL, JavaScript and final decisions were reviewed and edited by me, Erhiyoma Oghenevwogaga.
