-- NaijaCart - Portfolio 2 - Sample Data
-- Erhiyoma Oghenevwogaga - Ogaga2026
-- 6 tables only: warehouses, customers, products, orders, order_items, payments

-- ========== WAREHOUSES ==========
INSERT INTO warehouses (warehouse_id, warehouse_name, location) VALUES
(1, 'Lagos Warehouse', 'Lagos'),
(2, 'Abuja Warehouse', 'Abuja')
ON CONFLICT (warehouse_id) DO NOTHING;

-- ========== CUSTOMERS ==========
INSERT INTO customers (customer_id, full_name, email, city) VALUES
(1, 'Ada Obi', 'ada@example.com', 'Lagos'),
(2, 'Tunde Musa', 'tunde@example.com', 'Abuja')
ON CONFLICT (customer_id) DO NOTHING;

-- ========== PRODUCTS ==========
-- Consistency Rule: Laptop Stand = 25000 in BOTH PostgreSQL AND MongoDB
INSERT INTO products (product_id, product_name, price, stock_quantity, warehouse_id) VALUES
(1, 'Laptop Stand', 25000, 10, 1),
(2, 'Wireless Mouse', 15000, 20, 2)
ON CONFLICT (product_id) DO NOTHING;

-- ========== ORDERS ==========
INSERT INTO orders (order_id, customer_id, warehouse_id, total_amount, order_date) VALUES
(1, 1, 1, 25000, '2026-01-10'),
(2, 2, 2, 15000, '2026-01-11')
ON CONFLICT (order_id) DO NOTHING;

-- ========== ORDER_ITEMS ==========
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 25000),
(2, 2, 1, 15000)
ON CONFLICT DO NOTHING;

-- ========== PAYMENTS ==========
INSERT INTO payments (payment_id, order_id, amount, payment_method) VALUES
(1, 1, 25000, 'Card'),
(2, 2, 15000, 'Transfer')
ON CONFLICT (payment_id) DO NOTHING;

-- ========== OTHER INDEXES - Created BEFORE test ==========
CREATE INDEX IF NOT EXISTS idx_orders_warehouse ON orders(warehouse_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product ON order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_payments_order ON payments(order_id);
CREATE INDEX IF NOT EXISTS idx_products_warehouse ON products(warehouse_id);

-- ========== OPTIMISATION EVIDENCE ==========
-- DO NOT create idx_orders_customer before this test.
-- Step 1: Run BEFORE query first - no index on customer_id yet
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM orders WHERE customer_id = 1;

-- Step 2: Now create the index
CREATE INDEX IF NOT EXISTS idx_orders_customer ON orders(customer_id);

-- Step 3: Run AFTER query - with index
EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM orders WHERE customer_id = 1;

-- Save BOTH real outputs inside EXPLAIN_results.txt in this same folder.
-- Do NOT invent times like 250ms to 10ms without running it.
-- Note: Dataset is small (only 2 orders), so time difference will be small.
-- What matters is plan changes from Seq Scan to Index Scan using idx_orders_customer.

-- ========== WAREHOUSE SALES - CORRECT VERSION ==========
-- MUST use orders.warehouse_id (fulfilment warehouse)
-- MUST NOT use products.warehouse_id
-- Example: Order 1 product is in Lagos warehouse (products.warehouse_id = 1)
-- But order was fulfilled from Abuja warehouse (orders.warehouse_id = 2)
-- Correct sales must credit Abuja, not Lagos.

SELECT w.warehouse_name AS warehouse_name, SUM(o.total_amount) AS total_sales
FROM orders o
JOIN warehouses w ON o.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_name;

-- WRONG VERSION - DO NOT USE:
-- This is wrong because it credits product warehouse, not fulfilment warehouse.
-- SELECT w.warehouse_name, SUM(oi.quantity * oi.unit_price) FROM orders o
-- JOIN order_items oi ON o.order_id = oi.order_id
-- JOIN products p ON oi.product_id = p.product_id
-- JOIN warehouses w ON p.warehouse_id = w.warehouse_id
-- GROUP BY w.warehouse_name;
