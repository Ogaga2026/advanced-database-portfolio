## Evidence - BEFORE Index

File: before-index.txt
- Seq Scan on orders
- Execution Time: 0.179 ms
- Rows: 1000

## Evidence - AFTER Index

File: after-index.txt
- Bitmap Index Scan using idx_orders_warehouse_id on orders
- Bitmap Heap Scan on orders
- Execution Time: 0.221 ms
- Rows: 1000

## What This Proves

The plan changed from Seq Scan -> Bitmap Index Scan. That is the proof the index is used.

Time did not drop because all 1000 test rows have warehouse_id = 1, so Postgres still has to fetch all 1000 rows. The improvement is in the plan, not the time for this test data.# Portfolio 2 - Query Optimisation Report

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
