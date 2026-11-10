# Portfolio 2 - Query Optimisation Report

## Problem
The query was doing a Seq Scan on orders
when filtering by warehouse_id.

## Query Tested
```sql
SELECT * FROM orders WHERE warehouse_id = 1;
```

## Created Index
```sql
CREATE INDEX idx_orders_warehouse_id ON orders(warehouse_id);
```

## Evidence - AFTER Index
File: after-index.txt
- Index Scan using idx_orders_warehouse_id on orders
- Execution Time: 0.120 ms (single run, 3-row test dataset)

## Limitation - Read This
This is ONE run on a tiny 3-order dataset. Timing will vary.
We do NOT claim 0.850ms to 0.120ms is a guaranteed 85% improvement.
The only proof is the plan change: Seq Scan -> Index Scan.

## How To Reproduce
```sql
EXPLAIN ANALYZE SELECT * FROM orders WHERE warehouse_id = 1;
```
