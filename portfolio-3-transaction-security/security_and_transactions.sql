-- Portfolio 3: Transactions and Security

-- A. TRANSACTIONS

-- Example 1: Successful purchase transaction
START TRANSACTION;

UPDATE books SET stock_quantity = stock_quantity - 1 
WHERE book_id = 1;

INSERT INTO sales (book_id, quantity, sale_date) 
VALUES (1, 1, NOW());

COMMIT;

-- Example 2: Transaction with ROLLBACK on error
START TRANSACTION;

UPDATE books SET stock_quantity = stock_quantity - 5 
WHERE book_id = 2;

-- Check if stock is negative, if yes rollback
-- This would be done in application logic
-- ROLLBACK; -- Uncomment to undo

COMMIT;

-- Example 3: Setting Isolation Level
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- B. SECURITY

-- 1. Create users with different roles
CREATE USER 'book_admin'@'localhost' IDENTIFIED BY 'AdminPass123';
CREATE USER 'book_staff'@'localhost' IDENTIFIED BY 'StaffPass123';
CREATE USER 'book_reader'@'localhost' IDENTIFIED BY 'ReaderPass123';

-- 2. Grant privileges

-- Admin has full access
GRANT ALL PRIVILEGES ON bookstore.* TO 'book_admin'@'localhost';

-- Staff can read and update but not delete
GRANT SELECT, INSERT, UPDATE ON bookstore.* TO 'book_staff'@'localhost';

-- Reader can only read
GRANT SELECT ON bookstore.* TO 'book_reader'@'localhost';

-- 3. Revoke example
-- REVOKE DELETE ON bookstore.* FROM 'book_staff'@'localhost';

-- 4. Show grants
SHOW GRANTS FOR 'book_staff'@'localhost';

-- C. BACKUP AND RECOVERY (commands for documentation)

-- Backup command (to be run in terminal):
-- mysqldump -u root -p bookstore > bookstore_backup.sql

-- Restore command:
-- mysql -u root -p bookstore < bookstore_backup.sql

FLUSH PRIVILEGES;
