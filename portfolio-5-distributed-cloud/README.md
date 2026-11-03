# Portfolio 5: Distributed and Cloud Database - NaijaCart

## Objective
To ensure high availability, scalability, and fault tolerance for NaijaCart E-commerce during high traffic (e.g., Black Friday in Nigeria).

## 1. Replication Strategy
- **Type:** Primary-Secondary (Master-Slave)
- **Primary:** Lagos (lagos-primary.naijacart.com) - Handles all WRITES
- **Secondary 1:** Abuja (read replica) - Handles READS for product browsing
- **Secondary 2:** Port Harcourt (hidden backup) - For disaster recovery
- **Benefit:** If Lagos server fails, Abuja automatically becomes Primary. Zero downtime for customers.

## 2. Sharding Strategy
- **Why Shard?** NaijaCart has >5 million orders, single server cannot handle.
- **Collection: Orders** - Shard key: `{customer_id: 1, order_id: 1}`
    - Reason: Keep all orders of one customer on same shard = faster customer order history
- **Collection: Products** - Shard key: `{category: 1, product_id: 1}`
    - Reason: Distribute Electronics, Fashion, Food categories across shards
- **Shards:** 3 shards across Nigeria regions

## 3. CAP Theorem - Consistency Model
- **Product Catalog (Views, Reviews):** AP System - Availability + Partition Tolerance, Eventual Consistency. Write concern w:1 for fast updates.
- **Orders & Payments:** CP System - Consistency + Partition Tolerance, Strong Consistency. Write concern w:majority, j:true to ensure money is never lost.

## 4. Cloud Deployment (AWS Example)
- **Primary Database:** RDS PostgreSQL Multi-AZ (for ACID transactions)
- **NoSQL:** MongoDB Atlas Cluster on AWS af-south-1 (Cape Town, closest to Nigeria)
- **Cache:** ElastiCache Redis for Shopping Cart (fast in-memory)
- **Failover:** Auto-failover tested with rs.status() and isMaster()

## Conclusion
This distributed design allows NaijaCart to scale horizontally, handle server failures, and serve customers from different regions with low latency.
