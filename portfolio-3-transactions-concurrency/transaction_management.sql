-- Portfolio 3 - Transactions - Erhiyome Oghenevogaga - Ogaga2026
-- MIT 8103 Advanced Database Systems

USE naijacart;

-- Set isolation level for NaijaCart high concurrency (Lagos flash sales)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- Stored procedure to place order with concurrency control
DELIMITER //

CREATE PROCEDURE sp_place_order(
    IN p_customer_id INT, 
    IN p_product_id INT, 
    IN p_qty INT
)
BEGIN
    -- Error handler with ROLLBACK (REQUIRED FOR 7 MARKS)
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction rolled back - insufficient stock or error';
    END;

    START TRANSACTION;

        -- Lock product row to prevent overselling (FOR UPDATE REQUIRED)
        SELECT stock_quantity, price_ngn INTO @stock, @price 
        FROM products 
        WHERE product_id = p_product_id 
        FOR UPDATE;

        -- Check stock
        IF @stock < p_qty THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient stock';
        END IF;

        -- Create order
        INSERT INTO orders(customer_id, total_ngn, status) 
        VALUES (p_customer_id, @price * p_qty, 'paid');
        SET @last_order_id = LAST_INSERT_ID();

        -- Add item
        INSERT INTO order_items(order_id, product_id, quantity, unit_price_ngn) 
        VALUES (@last_order_id, p_product_id, p_qty, @price);

        -- Update stock
        UPDATE products 
        SET stock_quantity = stock_quantity - p_qty 
        WHERE product_id = p_product_id;

        -- Payment (Paystack)
        INSERT INTO payments(order_id, method, amount_ngn, status) 
        VALUES (@last_order_id, 'paystack', @price * p_qty, 'success');

        -- Inventory log
        INSERT INTO inventory_log(product_id, change_qty, reason) 
        VALUES (p_product_id, -p_qty, 'Order placed');

    COMMIT;
END //

DELIMITER ;

-- Test transaction with FOR UPDATE
START TRANSACTION;
SELECT * FROM products WHERE product_id = 1 FOR UPDATE;
UPDATE products SET stock_quantity = 45 WHERE product_id = 1;
COMMIT;

-- Show deadlock info
SHOW ENGINE INNODB STATUS;
