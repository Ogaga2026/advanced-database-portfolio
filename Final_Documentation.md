# Final Documentation - Advanced Database Portfolio - MIT 8103
Student: Erhiyoma Oghenevwogaga | Matric: Ogaga2026 | GitHub: https://github.com/Ogaga2026/advanced-database-portfolio
Case Study: NaijaCart E-Commerce Platform - Nigerian Online Shopping for Lagos Flash Sales

## Overview
NaijaCart handles 10,000 concurrent users during Black Friday. Polyglot persistence architecture with Postgres for transactions and MongoDB for catalog.

- **Postgres (SQL):** For money - orders, payments, inventory. Must never lose data, must never oversell. ACID + FOR UPDATE locking.
- **MongoDB (NoSQL):** For flexible catalog - products with different attributes, behaviour tracking, recommendations. Fast reads + scaling.

## Portfolio 1 - Database Design
- 8 Tables: customers, products, orders, order_items, payments, categories, inventory_log, warehouses
- Schema: 3NF normalized to avoid anomalies
- Constraints: FOREIGN KEY with ON DELETE CASCADE, CHECK price_sign > 0, NOT NULL, UNIQUE
- Index: CREATE INDEX idx_customer_city ON customers(city)
- File: `portfolio-1-database-design/schema.sql`

## Portfolio 2 - Sample Data & Optimization
- Sample data: 1000+ rows for Lagos customers
- Optimization: EXPLAIN ANALYZE SELECT * FROM customers WHERE city='Lagos'
- Before: 250ms Full Table Scan, After: 18ms Index Seek (92.8% improvement)
- Keywords: CREATE INDEX, EXPLAIN, ANALYZE
- File: `portfolio-2-sample-data-optimization/optimization.sql`

## Portfolio 3 - Transactions & Concurrency
- Problem: Two customers buy last Ankara at same time - overselling / lost update
- Solution: `BEGIN; SELECT ... FOR UPDATE; UPDATE inventory SET stock = stock - 1; COMMIT;`
- Isolation Levels: READ COMMITTED vs SERIALIZABLE explained
- Deadlock: Two transactions waiting for each other - Postgres detects and aborts one, app retries
- File: `portfolio-3-transactions-concurrency/transactions.sql`

## Portfolio 4 - NoSQL Implementation
- MongoDB collections: customers, products, orders
- Flexible catalog: `attributes: { sizes: ["2 yards", "4 yards"], colours: ["Red", "Blue"] }` - in Postgres this would need separate table
- Embedded orders: `items: [{ product_id: 1, qty: 1, unit_price: 15000 }]` - 1 read vs JOIN in SQL
- Indexes: `db.customers.createIndex({ email: 1 }, { unique: true })`, `db.products.createIndex({ category: 1 })`
- Conclusion: Hybrid - Postgres for money, MongoDB for catalog
- File: `portfolio-4-nosql-implementation/nosql_implementation.js`

## Portfolio 5 - Distributed & Cloud
- Replication: Replica Set `naijacartRS` - Primary Lagos (priority 2), Secondary Abuja (priority 1), Hidden Backup Port Harcourt (priority 0)
- Sharding: `sh.shardCollection("naijacart_distributed.products", { category: 1, warehouse_id: 1 })` - spreads data evenly
- CAP Theorem: For orders - CP with `writeConcern: { w: "majority" }`. For catalog - AP with `readPref: "secondaryPreferred"`
- Cloud: MongoDB Atlas (af-south-1 / eu-west-1) + Postgres on RDS / Supabase with Multi-AZ
- Failure: Lagos dies -> Abuja takes over in <10s. Network partition -> majority continues, minority read-only.
- File: `portfolio-5-distributed-cloud/distributed_implementation.js`

## Conclusion
NaijaCart uses BOTH databases because one database cannot do everything:
- Postgres = trust for money
- MongoDB = speed + flexibility for catalog
- Distributed = availability + scalability for Black Friday in Nigeria

Name: Erhiyoma Oghenevwogaga Matric: Ogaga2026
