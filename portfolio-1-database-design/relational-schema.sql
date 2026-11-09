-- NaijaCart - Portfolio 1 - Relational Schema
-- Erhiyoma Oghenevwogaga - Ogaga2026
-- Matches er-diagram.jpg exactly
-- 6 tables only: warehouses, customers, products, orders, order_items, payments

CREATE TABLE warehouses (
  warehouse_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  city VARCHAR(50) NOT NULL,
  state VARCHAR(50) NOT NULL,
  capacity INT CHECK (capacity > 0)
);

CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone VARCHAR(20),
  city VARCHAR(50),
  state VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
  product_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  category VARCHAR(50),
  price NUMERIC(10,2) CHECK (price >= 0),
  stock_quantity INT DEFAULT 0 CHECK (stock_quantity >= 0),
  warehouse_id INT REFERENCES warehouses(warehouse_id)
);

CREATE TABLE orders (
  order_id SERIAL PRIMARY KEY,
  customer_id INT REFERENCES customers(customer_id),
  warehouse_id INT REFERENCES warehouses(warehouse_id),
  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status VARCHAR(20) DEFAULT 'pending',
  total_amount NUMERIC(10,2) DEFAULT 0 CHECK (total_amount >= 0)
);

CREATE TABLE order_items (
  order_item_id SERIAL PRIMARY KEY,
  order_id INT REFERENCES orders(order_id),
  product_id INT REFERENCES products(product_id),
  quantity INT CHECK (quantity > 0),
  unit_price NUMERIC(10,2) CHECK (unit_price >= 0)
);

CREATE TABLE payments (
  payment_id SERIAL PRIMARY KEY,
  order_id INT REFERENCES orders(order_id),
  payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  amount NUMERIC(10,2) CHECK (amount >= 0),
  payment_method VARCHAR(20),
  status VARCHAR(20) DEFAULT 'pending'
);
