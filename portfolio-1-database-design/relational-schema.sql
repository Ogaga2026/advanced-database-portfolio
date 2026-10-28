CREATE DATABASE NaijaCart;
USE NaijaCart;

-- Publishers/ Vendors
CREATE TABLE Vendors (
 vendor_id INT PRIMARY KEY AUTO_INCREMENT,
 business_name VARCHAR(100) NOT NULL,
 email VARCHAR(100) UNIQUE,
 rating DECIMAL(2,1)
);

CREATE TABLE Categories (
 category_id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(50) NOT NULL UNIQUE,
 parent_id INT NULL
);

CREATE TABLE Customers (
 customer_id INT PRIMARY KEY AUTO_INCREMENT,
 full_name VARCHAR(100) NOT NULL,
 email VARCHAR(100) UNIQUE NOT NULL,
 city VARCHAR(50),
 created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Products (
 product_id INT PRIMARY KEY AUTO_INCREMENT,
 name VARCHAR(150) NOT NULL,
 sku VARCHAR(20) UNIQUE NOT NULL,
 category_id INT,
 vendor_id INT,
 price DECIMAL(10,2) CHECK (price > 0),
 stock_qty INT DEFAULT 0 CHECK (stock_qty >=0),
 FOREIGN KEY (category_id) REFERENCES Categories(category_id),
 FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id)
);

CREATE TABLE Orders (
 order_id INT PRIMARY KEY AUTO_INCREMENT,
 customer_id INT NOT NULL,
 order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
 status ENUM('PENDING','PAID','SHIPPED','DELIVERED','CANCELLED') DEFAULT 'PENDING',
 total_amount DECIMAL(10,2),
 FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
 order_id INT,
 product_id INT,
 quantity INT CHECK (quantity > 0),
 unit_price DECIMAL(10,2),
 PRIMARY KEY (order_id, product_id),
 FOREIGN KEY (order_id) REFERENCES Orders(order_id),
 FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Payments (
 payment_id INT PRIMARY KEY AUTO_INCREMENT,
 order_id INT UNIQUE NOT NULL,
 amount DECIMAL(10,2) NOT NULL,
 method ENUM('CARD','TRANSFER','PAYSTACK','COD'),
 status ENUM('SUCCESS','FAILED','PENDING') DEFAULT 'PENDING',
 FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Shipments (
 shipment_id INT PRIMARY KEY AUTO_INCREMENT,
 order_id INT UNIQUE NOT NULL,
 rider_name VARCHAR(100),
 tracking_no VARCHAR(50) UNIQUE,
 status VARCHAR(50),
 FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);
