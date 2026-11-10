# Portfolio 2 - Query Optimisation Report

NaijaCart - Erhiyoma Oghenevwogaga - Ogaga2026

## Problem
Query `SELECT * FROM orders WHERE warehouse_id = 1` was slow. It was doing a full table scan (Seq Scan).

## Evidence - BEFORE Index
File: `before_index.txt`
- Seq Scan on orders
- Execution Time: 0.850 ms (single run, 3-row test dataset)

## Fix
Created index:

```sql
CREATE INDEX idx_orders_warehouse_id ON orders(warehouse_id);
