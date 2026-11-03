-- NaijaCart E-commerce - Relational Schema
-- MIT 8103 - Erhiyome Oghenevogaga - Ogaga2026
-- Consistent across all 5 portfolios

DROP DATABASE IF EXISTS naijacart;
CREATE DATABASE naijacart CHARACTER SET utf8mb4;
USE naijacart;

CREATE TABLE warehouses (
  warehouse_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  city VARCHAR(50) NOT NULL,
  state VARCHAR(50) NOT NULL,
  capacity INT
);

CREATE TABLE customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20) NOT NULL,
  city VARCHAR(50),
  state VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  sku VARCHAR(30) UNIQUE NOT NULL,
  name VARCHAR(150) NOT NULL,
  category VARCHAR(50) NOT NULL,
  price_ngn DECIMAL(10,2) NOT NULL CHECK (price_ngn > 0),
  stock_quantity INT DEFAULT 0,
  warehouse_id INT,
  FOREIGN KEY (warehouse_id) REFERENCES warehouses(warehouse_id)
);

CREATE TABLE orders (
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status ENUM('pending','paid','shipped','delivered','cancelled') DEFAULT 'pending',
  total_ngn DECIMAL(12,2) NOT NULL,
  delivery_fee DECIMAL(8,2) DEFAULT 1500,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
  order_item_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL CHECK (quantity > 0),
  unit_price_ngn DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
  payment_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  method ENUM('paystack','flutterwave','bank_transfer','ussd') NOT NULL,
  amount_ngn DECIMAL(12,2) NOT NULL,
  status ENUM('pending','success','failed') DEFAULT 'pending',
  paid_at TIMESTAMP NULL,
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE inventory_log (
  log_id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT NOT NULL,
  change_qty INT NOT NULL,
  reason VARCHAR(100),
  logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE delivery (
  delivery_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT NOT NULL,
  rider_name VARCHAR(100),
  dispatch_city VARCHAR(50),
  delivery_status ENUM('dispatched','in_transit','delivered') DEFAULT 'dispatched',
  FOREIGN KEY (order_id) REFERENCES orders(order_id)
);
