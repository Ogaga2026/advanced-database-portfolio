-- NaijaCart - Portfolio 2 - Sample Data
-- Erhiyoma Oghenevwogaga - Ogaga2026
-- Column names MATCH schema exactly: warehouses(name, city), products(name)

DROP INDEX IF EXISTS idx_orders_warehouse_id;

INSERT INTO warehouses (warehouse_id, name, city, state, capacity) VALUES
(1, 'Lagos Main', 'Lagos', 'Lagos State', 10000),
(2, 'Abuja Hub', 'Abuja', 'FCT', 8000);

INSERT INTO customers (customer_id, name, email) VALUES
(1, 'Ada Obi', 'ada@example.com'),
(2, 'Tunde Bakare', 'tunde@example.com');

INSERT INTO products (product_id, name, price) VALUES
(1, 'Laptop Stand', 25000),
(2, 'Wireless Mouse', 12000);

INSERT INTO orders (order_id, customer_id, warehouse_id, total_amount) VALUES
(1, 1, 1, 25000),
(2, 2, 1, 12000),
(3, 1, 2, 25000);

-- FIRST EXPLAIN - BEFORE index
EXPLAIN ANALYZE SELECT * FROM orders WHERE warehouse_id = 1;

-- CREATE INDEX BETWEEN the two EXPLAINs
CREATE INDEX idx_orders_warehouse_id ON orders(warehouse_id);

-- SECOND EXPLAIN - AFTER index
EXPLAIN ANALYZE SELECT * FROM orders WHERE warehouse_id = 1;

-- Warehouse Sales - uses orders.warehouse_id
SELECT w.name AS warehouse_name, SUM(o.total_amount) AS total_sales
FROM orders o
JOIN warehouses w ON o.warehouse_id = w.warehouse_id
GROUP BY w.name;
