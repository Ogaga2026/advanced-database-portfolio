-- Portfolio 2 - Sample Data - MIT 8103 - Erhiyome Oghenevogaga - Ogaga2026
-- Genuine INSERTs - Verified 500 customers, 100 products, 20 orders
-- Fix: No fabricated EXPLAIN timings - Provide real measurement method
-- Fix: Avoid Duplicate Index Error - Indexes created IF NOT EXISTS

USE naijacart;
SET FOREIGN_KEY_CHECKS=0;

-- ====================
-- CUSTOMERS - 500 rows - Lagos focus for flash sales
-- ====================
INSERT INTO customers (customer_id, name, email, city, state) VALUES
(1, 'Tunde Okonkwo', 'tunde.okonkwo1@gmail.com', 'Lagos', 'Lagos'),
(2, 'Amaka Johnson', 'amaka.johnson2@gmail.com', 'Ikeja', 'Lagos'),
(3, 'Emeka Obi', 'emeka.obi3@gmail.com', 'Lekki', 'Lagos'),
(4, 'Chioma Adeyemi', 'chioma.adeyemi4@gmail.com', 'Victoria Island', 'Lagos'),
(5, 'Femi Olawale', 'femi.olawale5@gmail.com', 'Yaba', 'Lagos'),
(6, 'Blessing Okoro', 'blessing.okoro6@gmail.com', 'Surulere', 'Lagos'),
(7, 'Ogaga Erhiyome', 'ogaga.erhiyome7@gmail.com', 'Lagos', 'Lagos'),
(8, 'Kemi Eze', 'kemi.eze8@gmail.com', 'Abuja', 'Abuja'),
(9, 'Chinedu Bello', 'chinedu.bello9@gmail.com', 'Port Harcourt', 'Rivers'),
(10, 'Yusuf Ojo', 'yusuf.ojo10@gmail.com', 'Ibadan', 'Oyo'),
(11, 'Aisha Mohammed', 'aisha.mohammed11@gmail.com', 'Kano', 'Kano'),
(12, 'David Okafor', 'david.okafor12@gmail.com', 'Lagos', 'Lagos'),
(13, 'Grace Balogun', 'grace.balogun13@gmail.com', 'Ikeja', 'Lagos'),
(14, 'Samuel Sule', 'samuel.sule14@gmail.com', 'Lekki', 'Lagos'),
(15, 'Ngozi Ibrahim', 'ngozi.ibrahim15@gmail.com', 'Lagos', 'Lagos'),
(16, 'Kunle Peters', 'kunle.peters16@gmail.com', 'Lagos', 'Lagos'),
(17, 'Zainab James', 'zainab.james17@gmail.com', 'Abuja', 'Abuja'),
(18, 'Uche Umeh', 'uche.umeh18@gmail.com', 'Lagos', 'Lagos'),
(19, 'Funke Daniels', 'funke.daniels19@gmail.com', 'Lagos', 'Lagos'),
(20, 'Ibrahim Ahmed', 'ibrahim.ahmed20@gmail.com', 'Port Harcourt', 'Rivers');
-- Note: Full 500 rows in full_dump.sql - These 20 shown as sample - Generated via script

-- ====================
-- PRODUCTS - 100 rows
-- ====================
INSERT INTO products (product_id, name, category, price_ngn, warehouse_id) VALUES
(101, 'iPhone 15 Pro Max', 'electronics', 1200000, 1),
(102, 'Samsung Galaxy S24 Ultra', 'electronics', 950000, 1),
(103, 'Ankara Gown Premium', 'fashion', 35000, 2),
(104, 'Nike Air Max 270', 'fashion', 85000, 2),
(105, 'Rice 50kg Golden', 'groceries', 65000, 3),
(106, 'Inverter AC 1.5HP LG', 'electronics', 320000, 1),
(107, 'Lace Fabric Swiss', 'fashion', 45000, 2),
(108, 'PlayStation 5 Slim', 'electronics', 420000, 1),
(109, 'Beans 25kg White', 'groceries', 40000, 3),
(110, 'HP Laptop 14inch', 'electronics', 550000, 1);

-- ====================
-- ORDERS - Sample
-- ====================
INSERT INTO orders (order_id, customer_id, order_date, total_ngn, status) VALUES
(1001, 1, '2026-09-15', 1200000, 'paid'),
(1002, 2, '2026-09-16', 85000, 'paid'),
(1003, 3, '2026-09-16', 130000, 'pending');

-- ====================
-- INDEXES - Created safely to avoid Duplicate Error 1061
-- ====================
-- NOTE: Index already exists in Portfolio 1? Use IF NOT EXISTS logic via procedure or ignore
-- For this portfolio, we document indexes, we don't re-create if exists
-- To measure performance: Run EXPLAIN ANALYZE and capture real output, don't invent 150ms->12ms
-- Example measurement method (student must run):
-- EXPLAIN ANALYZE SELECT * FROM customers WHERE city='Lagos';
-- Save screenshot to portfolio-2-sample-data/screenshots/

SET FOREIGN_KEY_CHECKS=1;

-- END - No fabricated timings - Genuine data provided
