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
    v_customer_exists INT;
    v_warehouse_exists INT;
BEGIN
    -- 1. INPUT VALIDATION - reject bad input before any lock / insert
    IF p_customer_id IS NULL THEN
        RAISE EXCEPTION 'customer_id cannot be NULL';
    END IF;
    IF p_product_id IS NULL THEN
        RAISE EXCEPTION 'product_id cannot be NULL';
    END IF;
    IF p_warehouse_id IS NULL THEN
        RAISE EXCEPTION 'warehouse_id cannot be NULL';
    END IF;
    IF p_quantity IS NULL OR p_quantity <= 0 THEN
        RAISE EXCEPTION 'Quantity must be greater than 0. Got: %', p_quantity;
    END IF;

    -- 2. Check customer exists
    SELECT COUNT(*) INTO v_customer_exists FROM customers WHERE customer_id = p_customer_id;
    IF v_customer_exists = 0 THEN
        RAISE EXCEPTION 'Customer % not found', p_customer_id;
    END IF;

    -- 3. Check warehouse exists
    SELECT COUNT(*) INTO v_warehouse_exists FROM warehouses WHERE warehouse_id = p_warehouse_id;
    IF v_warehouse_exists = 0 THEN
        RAISE EXCEPTION 'Warehouse % not found', p_warehouse_id;
    END IF;

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
-- If stock is not enough, it will fail and NOT create order, NOT reduce stock.

-- Example Test (concurrent)
-- Open 2 terminals at same time and run:
-- Session 1: SELECT place_order(1, 1, 10, 1); -- will lock product 1
-- Session 2: SELECT place_order(2, 1, 10, 1); -- will wait, then fail if stock < 20

-- Example Test (validation)
-- SELECT place_order(1, 1, 0, 1);  -- fails: Quantity must be greater than 0
-- SELECT place_order(1, 1, -5, 1); -- fails: Quantity must be greater than 0
-- SELECT place_order(999, 1, 1, 1); -- fails: Customer 999 not found
-- SELECT place_order(1, 1, 1, 999); -- fails: Warehouse 999 not found

-- Reset sequences for clean re-run (use after TRUNCATE in testing only)
-- SELECT setval('customers_customer_id_seq', 1, false);
-- SELECT setval('products_product_id_seq', 1, false);
-- SELECT setval('orders_order_id_seq', 1, false);
-- SELECT setval('order_items_order_item_id_seq', 1, false);
-- SELECT setval('payments_payment_id_seq', 1, false);
-- SELECT setval('warehouses_warehouse_id_seq', 1, false);
