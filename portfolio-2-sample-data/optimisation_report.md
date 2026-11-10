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

Time did not drop because all 1000 test rows have warehouse_id = 1, so Postgres still has to fetch all 1000 rows. The improvement is in the plan, not the time for this test data.
