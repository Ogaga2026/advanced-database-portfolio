# Portfolio 2 - Query Optimisation Report

NaijaCart - Erhiyoma Oghenevwogaga - Ogaga2026

## Problem
Query SELECT * FROM orders WHERE warehouse_id = 1 was slow. It was doing a full table scan (Seq Scan).

## Evidence - BEFORE Index
File: before_index.txt
- Seq Scan on orders
- Execution Time: 0.850 ms (single run, 3-row test dataset)

## Fix
Created index:
CREATE INDEX idx_orders_warehouse_id ON orders(warehouse_id);

## Evidence - AFTER Index
File: after_index.txt
- Index Scan using idx_orders_warehouse_id on orders
- Execution Time: 0.120 ms (single run, 3-row test dataset)

## Limitation - Read This
This is ONE run on a tiny 3-order dataset. Timing will vary on every run.
We do NOT claim 0.850ms to 0.120ms is a guaranteed 85% improvement.
The real proof is the plan change: Seq Scan -> Index Scan.
With a larger dataset, the index benefit should be tested again with EXPLAIN ANALYZE run 3 times and averaged.

## How To Reproduce
EXPLAIN ANALYZE SELECT * FROM orders WHERE warehouse_id = 1;
