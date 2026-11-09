# Advanced Database Portfolio - NaijaCart E-commerce
MIT 8103 - Erhiyoma Oghenevwogaga - Ogaga2026

## Case Study: NaijaCart
NaijaCart na Nigerian online shopping platform for Lagos Flash Sales. E dey handle 10,000 concurrent users during Black Friday.

We use TWO databases because one cannot do everything:
- **Postgres:** For money - orders, payments, inventory. Must never lose data, must never oversell.
- **MongoDB:** For catalog - products with different attributes, behaviour tracking. Fast reads + scaling.

## Folder Structure
- `portfolio-1-database-design/` - Schema design, 8 tables, 3NF, constraints, indexes
- `portfolio-2-sample-data-optimization/` - Sample data, EXPLAIN ANALYZE, index optimization
- `portfolio-3-transactions-concurrency/` - Transactions, FOR UPDATE locking, isolation levels, deadlock
- `portfolio-4-nosql-implementation/` - MongoDB collections, flexible catalog, embedded orders
- `portfolio-5-distributed-cloud/` - Replica set, sharding, CAP Theorem, cloud deployment
- `Final_Documentation.md` - Full summary of all portfolios

## Key Decisions
- **Postgres for money:** ACID + `SELECT ... FOR UPDATE` to stop two customers buying last Ankara at same time
- **MongoDB for catalog:** `attributes: { sizes, colours }` - for Postgres this would need separate table
- **Distributed:** Replica Set `naijacartRS` - Lagos Primary, Abuja Secondary, Port Harcourt Hidden Backup. Lagos down -> Abuja takes over in <10s.
- **Sharding:** `sh.shardCollection("naijacart_distributed.products", { category: 1, warehouse_id: 1 })`
- **CAP:** Orders = Consistency with `writeConcern: { w: "majority" }`, Catalog = Availability with `readPref: "secondaryPreferred"`

## How To Run
```bash
docker-compose up -d
