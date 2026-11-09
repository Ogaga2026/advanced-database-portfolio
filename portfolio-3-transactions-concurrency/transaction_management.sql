-- Portfolio 3 - Transaction Management
-- NaijaCart - Postgres version
-- Matches Portfolio 1 schema

-- Set isolation level for high concurrency (avoid dirty reads)
-- In Postgres, default is READ COMMITTED, we keep it explicit per transaction

-- Stored function to place order with concurrency control
-- Uses row-level lock (FOR UPDATE) to prevent overselling when 2 users buy same product

CREATE OR REPLACE FUNCTION place_order(
    p_customer_id INT,
    p_product_id INT,
    p_quantity INT,
    p_warehouse_id INT
) RETURNS INT AS $$
DECLARE
    v_stock INT;
    v_price NUMERIC(10,2);
    v_total NUMERIC(10,2);
    v_order_id INT;
BEGIN
    -- Lock product row to prevent concurrent overselling
    SELECT stock_quantity, price INTO v_stock, v_price
    FROM products
    WHERE product_id = p_product_id
    FOR UPDATE;

    -- Check if product exists
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Product % not found', p_product_id;
    END IF;

    -- Check stock
    IF v_stock < p_quantity THEN
        RAISE EXCEPTION 'Insufficient stock for product %. Available: %, Requested: %', p_product_id, v_stock, p_quantity;
    END IF;

    v_total := v_price * p_quantity;

    -- Create order
    INSERT INTO orders (customer_id, warehouse_id, status, total_amount)
    VALUES (p_customer_id, p_warehouse_id, 'pending', v_total)
    RETURNING order_id INTO v_order_id;

    -- Create order item
    INSERT INTO order_items (order_id, product_id, quantity, unit_price)
    VALUES (v_order_id, p_product_id, p_quantity, v_price);

    -- Reduce stock
    UPDATE products
    SET stock_quantity = stock_quantity - p_quantity
    WHERE product_id = p_product_id;

    -- If we reach here, transaction succeeds
    RETURN v_order_id;

EXCEPTION WHEN OTHERS THEN
    -- Postgres auto-rolls back on exception in function
    RAISE EXCEPTION 'Transaction failed - rolled back: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;

-- How to use it:
-- SELECT place_order(1, 1, 2, 1);
-- This will create an order for customer 1, product 1, qty 2, warehouse 1
-- If stock is not enough, it will fail and NOT create order, NOT reduce stock

-- Example: Test concurrency
-- Open 2 sessions at same time and run:
-- Session 1: BEGIN; SELECT place_order(1, 1, 90, 1); -- will lock product 1
-- Session 2: BEGIN; SELECT place_order(2, 1, 90, 1); -- will WAIT until Session 1 commits/rolls back
-- Session 1: COMMIT;
-- Session 2 will then see updated stock and fail if not enough - no overselling

-- Example: Isolation levels in Postgres
-- BEGIN ISOLATION LEVEL READ COMMITTED;
-- SELECT * FROM products WHERE product_id = 1;
-- COMMIT;

-- BEGIN ISOLATION LEVEL REPEATABLE READ;
-- SELECT * FROM products WHERE product_id = 1;
-- COMMIT;

-- Deadlock explanation:
-- If Session A locks product 1 then tries product 2,
-- and Session B locks product 2 then tries product 1,
-- Postgres will detect deadlock and abort one transaction.
-- Solution: Always lock products in same order (ORDER BY product_id).
