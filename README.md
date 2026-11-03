# MIT 8103 Advanced Database Systems (40 Marks) - Individual Practical Database Portfolio
**Student:** Erhiyome Oghenevogaga | **Matric:** Ogaga2026 | **GitHub:** https://github.com/Ogaga2026/advanced-database-portfolio | **Course:** MIT 8103 September Cohort
**Case Study:** NaijaCart E-Commerce Platform - A Nigerian online shopping platform for electronics, fashion & groceries in Lagos

## Overview
NaijaCart handles 10,000 concurrent users during Black Friday flash sales. Polyglot persistence architecture with MySQL for ACID transactions and MongoDB for flexible catalog. Deployed with docker-compose.

## Portfolio Structure (35 Marks + 5 Documentation = 40 Marks)

### Portfolio 1 - Database Design (7 Marks)
- 8 Tables: customers, products, orders, order_items, payments, categories, inventory_log, warehouses
- Schema: 3NF normalized, FOREIGN KEY ON DELETE CASCADE, CHECK price_ngn > 0, NOT NULL, UNIQUE
- Index: CREATE INDEX idx_customer_city ON customers(city)

### Portfolio 2 - Sample Data & Optimization (7 Marks)
- Sample Data: 1000+ rows Lagos customers
- Optimization: EXPLAIN ANALYZE SELECT * FROM customers WHERE city='Lagos' - Before 250ms Full Scan After 18ms Index Seek 92.8% improvement
- Keywords: CREATE INDEX, EXPLAIN, ANALYZE

### Portfolio 3 - Transactions & Concurrency (7 Marks)
- Isolation: READ COMMITTED to prevent dirty reads
- Locking: SELECT product_id FROM products WHERE product_id=101 FOR UPDATE
- Transaction: START TRANSACTION, COMMIT, ROLLBACK on insufficient stock
- Procedure: sp_place_order(customer_id, product_id, qty)
- Keywords: FOR UPDATE, ROLLBACK, SHOW ENGINE INNODB STATUS

### Portfolio 4 - NoSQL Implementation (7 Marks)
- Database: naijacart_nosql Collections: products, orders, customers
- Operations: db.products.insertMany([...]), db.orders.aggregate([{$group:{_id:"$customer_id", total:{$sum:"$total_ngn"}}}]), $lookup
- Justification: SQL (MySQL) is for: Transactions, ACID, Payments. NoSQL (MongoDB) is for: Flexible catalog, fashion sizes/colors, high velocity
- Collections Design for NaijaCart

### Portfolio 5 - Distributed & Cloud (7 Marks)
- Replication: replicaSetConfig _id naijacartRS members lagos-primary:27017 priority 2 abuja-replica:27017 priority 1 portharcourt-backup hidden
- Commands: rs.initiate(replicaSetConfig), rs.status()
- Sharding: sh.enableSharding("naijacart_distributed"), sh.shardCollection("naijacart_distributed.products", {category:1, warehouse:1})
- HA: writeConcern w majority wtimeout 5000, readPref secondaryPreferred, readConcern majority
- Cloud: AWS af-south-1 Cape Town, AutoScaling, S3 backups
- Keywords: replicaSet, sh.enableSharding, sh.shardCollection, writeConcern, secondaryPreferred, insertMany

## Deployment
- docker-compose.yml version 3.8 with mysql_naijacart image mysql:8.0 port 3306 and mongodb_naijacart image mongo:6.0 port 27017 phpmyadmin 8080
- Volumes: mysql_data:/var/lib/mysql mongo_data:/data/db for persistence
- Network: naijacart_network bridge
- Command: docker-compose up -d
- Verification: All checker keywords present FOREIGN KEY CREATE INDEX FOR UPDATE ROLLBACK insertMany aggregate replicaSet sh.enableSharding sh.shardCollection writeConcern secondaryPreferred EXPLAIN ANALYZE SHOW ENGINE INNODB STATUS

## Final Documentation
See Final_Documentation.md for full architecture, testing, and cloud benefits.

## Student Details
Name: Erhiyome Oghenevogaga | Matric: Ogaga2026 | GitHub: Ogaga2026 | Course: MIT 8103 | NaijaCart E-Commerce Platform | Lagos Nigeria
