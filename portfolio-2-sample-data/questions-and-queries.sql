-- NaijaCart - Portfolio 2 - Questions and Queries
-- Matches Portfolio 1 schema (Postgres)
-- Run sample-data.sql first, then run these queries

-- Q1: List all customers from Lagos
SELECT customer_id, full_name, email, city, state
FROM customers
WHERE city = 'Lagos';

-- Q2: Low stock products
SELECT product_id, name, category, stock_quantity, warehouse_id
FROM products
WHERE stock_quantity < 50
ORDER BY stock_quantity ASC;

-- Q3: Orders with customer names
SELECT o.order_id, c.full_name, o.status, o.total_amount, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_id;

-- Q4: Total sales per warehouse - CORRECT
-- Use orders.warehouse_id = fulfilment warehouse
-- NOT products.warehouse_id
SELECT
  o.warehouse_id,
  w.name AS warehouse_name,
  SUM(oi.quantity * oi.unit_price) AS total_sales
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN warehouses w ON w.warehouse_id = o.warehouse_id
GROUP BY o.warehouse_id, w.name
ORDER BY total_sales DESC;

-- Q5: Most popular product
SELECT p.name, SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- Q6: Customer spend - total
SELECT c.customer_id, c.full_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC;

-- Q7: Processing / Shipped orders
SELECT order_id, customer_id, warehouse_id, status, total_amount
FROM orders
WHERE status IN ('processing', 'shipped');

-- Q8: Payment method counts
SELECT payment_method, COUNT(*) AS payment_count
FROM payments
GROUP BY payment_method;

-- Q9: Optimization - Check plan for Q3
-- Run this in Postgres to see if index is used:
-- EXPLAIN ANALYZE SELECT o.order_id, c.full_name, o.status, o.total_amount
-- FROM orders o JOIN customers c ON o.customer_id = c.customer_id
-- WHERE o.customer_id = 1;

-- Q10: Optimization - Check plan for Q2
-- EXPLAIN ANALYZE SELECT product_id, name, stock_quantity
-- FROM products WHERE stock_quantity < 50;
