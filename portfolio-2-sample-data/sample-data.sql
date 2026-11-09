-- NaijaCart - Portfolio 2 - Sample Data
-- Matches Portfolio 1 schema

-- Warehouses
INSERT INTO warehouses (warehouse_id, name, city, state, capacity) VALUES
(1, 'Lagos Main', 'Ikeja', 'Lagos', 10000),
(2, 'Abuja Hub', 'Abuja', 'FCT', 8000),
(3, 'Port Harcourt Hub', 'Port Harcourt', 'Rivers', 6000)
ON CONFLICT (warehouse_id) DO NOTHING;

-- Customers
INSERT INTO customers (customer_id, full_name, email, phone, city, state) VALUES
(1, 'Tunde Okonkwo', 'tunde.okonkwo@gmail.com', '08030000001', 'Ikeja', 'Lagos'),
(2, 'Amaka Johnson', 'amaka.johnson@gmail.com', '08030000002', 'Lekki', 'Lagos'),
(3, 'Emeka Obi', 'emeka.obi@gmail.com', '08030000003', 'Ikeja', 'Lagos'),
(4, 'Chioma Adeyemi', 'chioma.adeyemi@gmail.com', '08030000004', 'Surulere', 'Lagos'),
(5, 'Femi Olawale', 'femi.olawale@gmail.com', '08030000005', 'Victoria Island', 'Lagos'),
(6, 'Blessing Okoro', 'blessing.okoro@gmail.com', '08030000006', 'Yaba', 'Lagos'),
(7, 'Chinedu Eze', 'chinedu.eze@gmail.com', '08030000007', 'Surulere', 'Lagos'),
(8, 'Yusuf Bello', 'yusuf.bello@gmail.com', '08030000008', 'Abuja', 'FCT'),
(9, 'Aisha Mohammed', 'aisha.mohammed@gmail.com', '08030000009', 'Kano', 'Kano'),
(10, 'David Okafor', 'david.okafor@gmail.com', '08030000010', 'Ikeja', 'Lagos'),
(11, 'Grace Balogun', 'grace.balogun@gmail.com', '08030000011', 'Ikeja', 'Lagos'),
(12, 'Samuel Kole', 'samuel.kole@gmail.com', '08030000012', 'Ibadan', 'Oyo'),
(13, 'Ngozi Ibe', 'ngozi.ibe@gmail.com', '08030000013', 'Lekki', 'Lagos'),
(14, 'Kunle Peters', 'kunle.peters@gmail.com', '08030000014', 'Ikeja', 'Lagos'),
(15, 'Fatima Ahmed', 'fatima.ahmed@gmail.com', '08030000015', 'Abuja', 'FCT'),
(16, 'Oluwaseun Ade', 'oluwaseun.ade@gmail.com', '08030000016', 'Ikeja', 'Lagos'),
(17, 'Chiamaka Nwosu', 'chiamaka.nwosu@gmail.com', '08030000017', 'Lekki', 'Lagos'),
(18, 'Ibrahim Musa', 'ibrahim.musa@gmail.com', '08030000018', 'Kano', 'Kano'),
(19, 'Funke Alabi', 'funke.alabi@gmail.com', '08030000019', 'Surulere', 'Lagos'),
(20, 'Emmanuel James', 'emmanuel.james@gmail.com', '08030000020', 'Port Harcourt', 'Rivers')
ON CONFLICT (customer_id) DO NOTHING;

-- Products
INSERT INTO products (product_id, name, category, price, stock_quantity, warehouse_id) VALUES
(1, 'Ankara Fabric', 'Fashion', 15000.00, 100, 1),
(2, 'Laptop Stand', 'Electronics', 25000.00, 50, 1),
(3, 'Wireless Mouse', 'Electronics', 12000.00, 200, 1),
(4, 'Bag of Rice 50kg', 'Groceries', 85000.00, 80, 2),
(5, 'Palm Oil 5L', 'Groceries', 18000.00, 120, 2),
(6, 'Sneakers', 'Fashion', 35000.00, 60, 1),
(7, 'Phone Charger', 'Electronics', 8000.00, 300, 3),
(8, 'Yam Tuber', 'Groceries', 5000.00, 150, 3),
(9, 'Wrist Watch', 'Fashion', 45000.00, 40, 1),
(10, 'Bluetooth Speaker', 'Electronics', 30000.00, 70, 1)
ON CONFLICT (product_id) DO NOTHING;

-- Orders
INSERT INTO orders (order_id, customer_id, warehouse_id, status, total_amount) VALUES
(1, 1, 1, 'completed', 27000.00),
(2, 2, 1, 'completed', 35000.00),
(3, 3, 1, 'pending', 12000.00),
(4, 4, 2, 'completed', 85000.00),
(5, 5, 1, 'shipped', 15000.00),
(6, 1, 1, 'completed', 45000.00),
(7, 7, 3, 'completed', 8000.00),
(8, 8, 2, 'pending', 18000.00),
(9, 2, 1, 'completed', 30000.00),
(10, 10, 1, 'completed', 25000.00)
ON CONFLICT (order_id) DO NOTHING;

-- Order Items
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1, 15000.00),
(2, 1, 3, 1, 12000.00),
(3, 2, 6, 1, 35000.00),
(4, 3, 3, 1, 12000.00),
(5, 4, 4, 1, 85000.00),
(6, 5, 1, 1, 15000.00),
(7, 6, 9, 1, 45000.00),
(8, 7, 7, 1, 8000.00),
(9, 8, 5, 1, 18000.00),
(10, 9, 10, 1, 30000.00),
(11, 10, 2, 1, 25000.00)
ON CONFLICT (order_item_id) DO NOTHING;

-- Payments
INSERT INTO payments (payment_id, order_id, amount, payment_method, status) VALUES
(1, 1, 27000.00, 'card', 'completed'),
(2, 2, 35000.00, 'transfer', 'completed'),
(3, 3, 12000.00, 'card', 'pending'),
(4, 4, 85000.00, 'transfer', 'completed'),
(5, 5, 15000.00, 'card', 'completed'),
(6, 6, 45000.00, 'transfer', 'completed'),
(7, 7, 8000.00, 'cash', 'completed'),
(8, 8, 18000.00, 'card', 'pending'),
(9, 9, 30000.00, 'transfer', 'completed'),
(10, 10, 25000.00, 'card', 'completed')
ON CONFLICT (payment_id) DO NOTHING;

-- Indexes for Portfolio 2 optimization
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_orders_warehouse_id ON orders(warehouse_id);
CREATE INDEX IF NOT EXISTS idx_products_warehouse_id ON products(warehouse_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_payments_order_id ON payments(order_id);
CREATE INDEX IF NOT EXISTS idx_customers_email ON customers(email);
