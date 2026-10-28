-- NaijaCart E-commerce Sample Data - Portfolio 2
-- 8 Tables with realistic Nigerian data

INSERT INTO Vendors (vendor_id, business_name, email, phone, address) VALUES
(1, 'Lagos Electronics Hub', 'contact@lagoselectronics.ng', '08012345678', 'Computer Village, Ikeja'),
(2, 'Ankara Fashion Store', 'info@ankarafashion.ng', '08087654321', 'Yaba, Lagos'),
(3, 'Naija Groceries', 'sales@naijagroceries.ng', '07011223344', 'Lekki Phase 1, Lagos');

INSERT INTO Categories (category_id, name, description) VALUES
(1, 'Electronics', 'Phones, laptops and accessories'),
(2, 'Fashion', 'Clothes, shoes and bags'),
(3, 'Groceries', 'Food items'),
(4, 'Home Appliances', 'Kitchen and home electronics');

INSERT INTO Customers (customer_id, full_name, email, phone, city, address) VALUES
(1, 'Chinedu Okoro', 'chinedu.okoro@gmail.com', '08030000001', 'Lagos', '12 Allen Avenue, Ikeja'),
(2, 'Aisha Bello', 'aisha.bello@yahoo.com', '08030000002', 'Abuja', '5 Garki Area, Abuja'),
(3, 'Emeka Nwosu', 'emeka.nwosu@gmail.com', '08030000003', 'Port Harcourt', '22 Aba Road, PH'),
(4, 'Fatima Yusuf', 'fatima.yusuf@gmail.com', '08030000004', 'Kano', '10 Zoo Road, Kano'),
(5, 'Tunde Ogunleye', 'tunde.ogunleye@gmail.com', '08030000005', 'Ibadan', '15 Bodija, Ibadan');

INSERT INTO Products (product_id, name, sku, category_id, vendor_id, price, stock_qty, description) VALUES
(1, 'iPhone 14 Pro', 'IPH14P-001', 1, 1, 850000.00, 25, 'Apple iPhone 14 Pro 128GB'),
(2, 'Samsung Galaxy S23', 'SAMS23-002', 1, 1, 650000.00, 30, 'Samsung flagship phone'),
(3, 'Ankara Gown', 'ANK-GOWN-003', 2, 2, 25000.00, 50, 'Designer Ankara gown'),
(4, 'Rice 50kg Bag', 'RICE-50KG-004', 3, 3, 45000.00, 100, 'Premium parboiled rice'),
(5, 'Microwave Oven', 'MICRO-005', 4, 1, 85000.00, 15, 'LG Microwave 20L');

INSERT INTO Orders (order_id, customer_id, order_date, status, total_amount, shipping_address) VALUES
(1, 1, '2025-09-10', 'Delivered', 875000.00, '12 Allen Avenue, Ikeja, Lagos'),
(2, 2, '2025-09-12', 'Shipped', 25000.00, '5 Garki Area, Abuja'),
(3, 1, '2025-09-15', 'Processing', 45000.00, '12 Allen Avenue, Ikeja, Lagos'),
(4, 3, '2025-09-18', 'Delivered', 735000.00, '22 Aba Road, PH'),
(5, 4, '2025-09-20', 'Cancelled', 85000.00, '10 Zoo Road, Kano');

INSERT INTO Order_Items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 850000.00),
(1, 3, 1, 25000.00),
(2, 3, 1, 25000.00),
(3, 4, 1, 45000.00),
(4, 2, 1, 650000.00),
(4, 3, 2, 25000.00),
(4, 5, 1, 85000.00),
(5, 5, 1, 85000.00);

INSERT INTO Payments (payment_id, order_id, payment_method, payment_date, amount, payment_status) VALUES
(1, 1, 'Bank Transfer', '2025-09-10', 875000.00, 'Completed'),
(2, 2, 'Pay on Delivery', '2025-09-12', 25000.00, 'Pending'),
(3, 3, 'Card', '2025-09-15', 45000.00, 'Completed'),
(4, 4, 'Bank Transfer', '2025-09-18', 735000.00, 'Completed'),
(5, 5, 'Card', '2025-09-20', 85000.00, 'Refunded');

INSERT INTO Shipments (shipment_id, order_id, rider_name, tracking_no, status, shipped_date, delivered_date) VALUES
(1, 1, 'Musa Ibrahim', 'TRK-LAG-001', 'Delivered', '2025-09-11', '2025-09-13'),
(2, 2, 'John Okeke', 'TRK-ABJ-002', 'In Transit', '2025-09-13', NULL),
(3, 3, 'Adeola Johnson', 'TRK-LAG-003', 'Processing', NULL, NULL),
(4, 4, 'Chika Obi', 'TRK-PH-004', 'Delivered', '2025-09-19', '2025-09-21'),
(5, 5, 'Bala Mohammed', 'TRK-KAN-005', 'Cancelled', NULL, NULL);
