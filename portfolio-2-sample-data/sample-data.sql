-- NaijaCart - Portfolio 2 - Sample Data - CORRECTED to match relational-schema.sql
-- Erhiyoma Oghenevwogaga - Ogaga2026

DROP INDEX IF EXISTS idx_orders_warehouse_id;

INSERT INTO warehouses (warehouse_id, name, city, state, capacity) VALUES
(1, 'Lagos Main', 'Lagos', 'Lagos State', 10000),
(2, 'Abuja Hub', 'Abuja', 'FCT', 8000);

INSERT INTO customers (customer_id, full_name, email, phone, city, state) VALUES
(1, 'Ada Obi', 'ada@example.com', '08030000001', 'Lagos', 'Lagos State'),
(2, 'Tunde Bakare', 'tunde@example.com', '08030000002', 'Abuja', 'FCT');

INSERT INTO products (product_id, name, category, price, stock_quantity, warehouse_id) VALUES
(1, 'Laptop Stand', 'Accessories', 25000, 50, 1),
(2, 'Wireless Mouse', 'Accessories', 12000, 100, 1);

INSERT INTO orders (order_id, customer_id, warehouse_id, status, total_amount) VALUES
(1, 1, 1, 'pending', 25000),
(2, 2, 1, 'pending', 12000),
(3, 1, 1, 'pending', 25000);

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1, 25000),
(2, 2, 2, 1, 12000),
(3, 3, 1, 1, 25000);

INSERT INTO payments (payment_id, order_id, amount, payment_method, status) VALUES
(1, 1, 25000, 'Card', 'pending'),
(2, 2, 12000, 'Transfer', 'pending'),
(3, 3, 25000, 'Card', 'pending');

-- FIRST EXPLAIN - BEFORE index
EXPLAIN ANALYZE SELECT * FROM orders WHERE warehouse_id = 1;

-- CREATE INDEX BETWEEN the two EXPLAINs
CREATE INDEX idx_orders_warehouse_id ON orders(warehouse_id);

-- SECOND EXPLAIN - AFTER index
EXPLAIN ANALYZE SELECT * FROM orders WHERE warehouse_id = 1;

-- Warehouse Sales - uses w.name NOT w.warehouse_name
SELECT w.name AS warehouse_name, SUM(o.total_amount) AS total_sales
FROM orders o
JOIN warehouses w ON o.warehouse_id = w.warehouse_id
GROUP BY w.name;

-- Synchronize sequences after explicit IDs
SELECT setval('warehouses_warehouse_id_seq', (SELECT MAX(warehouse_id) FROM warehouses));
SELECT setval('customers_customer_id_seq', (SELECT MAX(customer_id) FROM customers));
SELECT setval('products_product_id_seq', (SELECT MAX(product_id) FROM products));
SELECT setval('orders_order_id_seq', (SELECT MAX(order_id) FROM orders));
SELECT setval('order_items_order_item_id_seq', (SELECT MAX(order_item_id) FROM order_items));
SELECT setval('payments_payment_id_seq', (SELECT MAX(payment_id) FROM payments));
