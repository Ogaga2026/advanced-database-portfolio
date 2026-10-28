-- Q1: List all customers from Lagos
SELECT * FROM Customers WHERE city = 'Lagos';

-- Q2: Low stock products
SELECT name, sku, stock_qty FROM Products WHERE stock_qty < 20;

-- Q3: Orders with customer names
SELECT o.order_id, c.full_name, o.order_date, o.status, o.total_amount
FROM Orders o JOIN Customers c ON o.customer_id = c.customer_id;

-- Q4: Total sales per vendor
SELECT v.business_name, SUM(oi.quantity * oi.unit_price) AS total_sales
FROM Vendors v JOIN Products p ON v.vendor_id = p.vendor_id JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY v.business_name;

-- Q5: Most popular product
SELECT p.name, SUM(oi.quantity) AS total_quantity_sold FROM Products p JOIN Order_Items oi ON p.product_id = oi.product_id GROUP BY p.name ORDER BY total_quantity_sold DESC LIMIT 1;

-- Q6: Customers spent > 500k
SELECT c.full_name, SUM(o.total_amount) AS total_spent FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id GROUP BY c.full_name HAVING SUM(o.total_amount) > 500000;

-- Q7: Processing/Shipped orders
SELECT * FROM Orders WHERE status IN ('Processing', 'Shipped');

-- Q8: Payment method count
SELECT payment_method, COUNT(*) AS usage_count FROM Payments GROUP BY payment_method;

-- Q9: Products with category and vendor
SELECT p.name, c.name AS category, v.business_name AS vendor, p.price FROM Products p JOIN Categories c ON p.category_id = c.category_id JOIN Vendors v ON p.vendor_id = v.vendor_id;

-- Q10: Average order value
SELECT AVG(total_amount) AS average_order_value FROM Orders;

-- Q11: Shipments per rider
SELECT rider_name, COUNT(*) AS total_shipments FROM Shipments GROUP BY rider_name;

-- Q12: Delivery time
SELECT o.order_id, c.full_name, s.shipped_date, s.delivered_date, DATEDIFF(s.delivered_date, s.shipped_date) AS delivery_days FROM Orders o JOIN Customers c ON o.customer_id = c.customer_id JOIN Shipments s ON o.order_id = s.order_id WHERE s.status = 'Delivered';

-- Q13: Products never ordered
SELECT * FROM Products WHERE product_id NOT IN (SELECT product_id FROM Order_Items);

-- Q14: Top 3 customers by orders
SELECT c.full_name, COUNT(o.order_id) AS order_count FROM Customers c JOIN Orders o ON c.customer_id = o.customer_id GROUP BY c.full_name ORDER BY order_count DESC LIMIT 3;

-- Q15: Monthly sales
SELECT MONTH(order_date) AS month, SUM(total_amount) AS monthly_sales FROM Orders WHERE status != 'Cancelled' GROUP BY MONTH(order_date);
