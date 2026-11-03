-- MIT 8103 - Portfolio 3: Transactions and Concurrency
-- NaijaCart E-commerce

START TRANSACTION;
UPDATE Products SET stock_quantity = stock_quantity - 1 WHERE product_id = 101 AND stock_quantity > 0;
INSERT INTO Orders (order_id, customer_id, order_date, total_amount, status) VALUES (1001, 201, NOW(), 50000, 'Pending');
INSERT INTO Payments (payment_id, order_id, amount, payment_method, status) VALUES (5001, 1001, 50000, 'Paystack', 'Completed');
COMMIT;

START TRANSACTION;
UPDATE Products SET stock_quantity = stock_quantity - 2 WHERE product_id = 102;
INSERT INTO Orders (order_id, customer_id, order_date, total_amount, status) VALUES (1002, 202, NOW(), 120000, 'Failed');
ROLLBACK;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT stock_quantity FROM Products WHERE product_id = 101 FOR UPDATE;
COMMIT;

START TRANSACTION;
SELECT * FROM Products WHERE product_id = 101 FOR UPDATE;
UPDATE Products SET stock_quantity = stock_quantity - 1 WHERE product_id = 101;
COMMIT;

START TRANSACTION;
INSERT INTO Customers (customer_id, name, email) VALUES (301, 'Ogaga', 'ogaga@test.com');
SAVEPOINT customer_created;
INSERT INTO Orders VALUES (1003, 301, NOW(), 20000, 'Pending');
ROLLBACK TO SAVEPOINT customer_created;
COMMIT;
