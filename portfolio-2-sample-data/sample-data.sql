-- Portfolio 2 - Sample Data & Optimisation - NaijaCart
-- Erhiyoma Oghenevwogaga - Ogaga2026
-- 6 tables only: warehouses, customers, products, orders, order_items, payments

-- ========== SAMPLE DATA (consistent prices) ==========
-- Prices must match Portfolio 4 MongoDB. Laptop Stand = 25000 in BOTH systems.

INSERT INTO warehouses (warehouse_id, name, city, state, capacity) VALUES
(1, 'Lagos Main', 'Lagos', 'Lagos', 10000),
(2, 'Abuja Hub', 'Abuja', 'FCT', 5000);

INSERT INTO customers (customer_id, full_name, email, phone, city, state, created_at) VALUES
(1, 'Erhiyoma Oghenevwogaga', 'erhiyoma@test.com', '08030000000', 'Lagos', 'Lagos', '2026-01-01'),
(2, 'Ada Okoro', 'ada@test.com', '08030000001', 'Abuja', 'FCT', '2026-01-02');

INSERT INTO products (product_id, name, category, price, stock_quantity, warehouse_id) VALUES
(1, 'Ankara Fabric', 'Fashion', 25000, 10, 1),
(2, 'Laptop Stand', 'Electronics', 25000, 10, 1),
(3, 'Sneakers', 'Fashion', 45000, 5, 2);

INSERT INTO orders (order_id, customer_id, warehouse_id, order_date, status, total_amount) VALUES
(1, 1, 2, '2026-11-09', 'completed', 25000),
(2, 2, 1, '2026-11-09', 'completed', 45000);

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 1, 2, 1, 25000),
(2, 2, 3, 1, 45000);

INSERT INTO payments (payment_id, order_id, payment_date, amount, payment_method, status) VALUES
(1, 1, '2026-11-09', 25000, 'Transfer', 'success'),
(2, 2, '2026-11-09', 45000, 'Card', 'success');

-- ========== INDEXES ==========
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_warehouse ON orders(warehouse_id);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_payments_order ON payments(order_id);
CREATE INDEX idx_products_warehouse ON products(warehouse_id);

-- ========== OPTIMISATION EVIDENCE - NOT COMMENTED OUT ==========
-- Run these 2 queries in Postgres and paste the real output below.
-- Do NOT claim 250ms to 18ms without running it.

-- BEFORE INDEX (drop index, run EXPLAIN ANALYZE, then re-create index):
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 1;

-- AFTER INDEX (with idx_orders_customer):
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 1;

-- Saved execution plan example (paste your REAL output here, replace this):
-- Seq Scan on orders (cost=0.00..15.00 rows=1) - BEFORE index
-- Index Scan using idx_orders_customer on orders (cost=0.00..8.00 rows=1) - AFTER index
-- Result: Index Scan is used, no Seq Scan. Actual timing depends on your machine, report what Postgres shows.

-- ========== WAREHOUSE SALES - CORRECT VERSION ==========
-- MUST use orders.warehouse_id (fulfilment warehouse)
-- MUST NOT use products.warehouse_id - that would misstate sales
-- Example: Order 1 product is in Lagos warehouse (products.warehouse_id=1)
-- but order was fulfilled from Abuja (orders.warehouse_id=2).
-- Correct sales must credit Abuja, not Lagos.

SELECT w.name AS warehouse_name, SUM(o.total_amount) AS total_sales
FROM orders o
JOIN warehouses w ON o.warehouse_id = w.warehouse_id
GROUP BY w.name;

-- WRONG VERSION - DO NOT USE:
-- SELECT w.name, SUM(o.total_amount) FROM orders o
-- JOIN order_items oi ON o.order_id = oi.order_id
-- JOIN products p ON oi.product_id = p.product_id
-- JOIN warehouses w ON p.warehouse_id = w.warehouse_id
-- GROUP BY w.name;
-- This is wrong because it credits product warehouse, not fulfilment warehouse.
