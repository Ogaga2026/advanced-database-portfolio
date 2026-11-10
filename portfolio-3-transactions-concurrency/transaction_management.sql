-- ============================================================
-- Portfolio 3: Transactions and Concurrency
-- transaction_manager.sql
-- ============================================================

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
    v_product_warehouse_id INT;
BEGIN
    -- Validate quantity
    IF p_quantity <= 0 THEN
        RAISE EXCEPTION 'Quantity must be positive';
    END IF;

    -- Check if customer exists
    SELECT customer_id INTO v_customer_exists
    FROM customers
    WHERE customer_id = p_customer_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Customer % not found', p_customer_id;
    END IF;

    -- Check if warehouse exists
    SELECT warehouse_id INTO v_warehouse_exists
    FROM warehouses
    WHERE warehouse_id = p_warehouse_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Warehouse % not found', p_warehouse_id;
    END IF;

    -- Lock product row and get stock, price, warehouse
    SELECT stock_quantity, price, warehouse_id INTO v_stock, v_price, v_product_warehouse_id
    FROM products
    WHERE product_id = p_product_id
    FOR UPDATE;

    -- Check if product exists
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Product % not found', p_product_id;
    END IF;

    -- Check warehouse matches product's warehouse
    IF v_product_warehouse_id <> p_warehouse_id THEN
        RAISE EXCEPTION 'Warehouse mismatch for product %: product is in warehouse %, requested warehouse %', p_product_id, v_product_warehouse_id, p_warehouse_id;
    END IF;

    -- Check if enough stock
    IF v_stock < p_quantity THEN
        RAISE EXCEPTION 'Insufficient stock for product %. Requested: %, Available: %', p_product_id, p_quantity, v_stock;
    END IF;

    -- Calculate total
    v_total := v_price * p_quantity;

    -- Create order
    INSERT INTO orders (customer_id, warehouse_id, total_amount, status)
    VALUES (p_customer_id, p_warehouse_id, v_total, 'completed')
    RETURNING order_id INTO v_order_id;

    -- Create order item
    INSERT INTO order_items (order_id, product_id, quantity, unit_price)
    VALUES (v_order_id, p_product_id, p_quantity, v_price);

    -- Create payment
    INSERT INTO payments (order_id, amount, status)
    VALUES (v_order_id, v_total, 'completed');

    -- Update stock
    UPDATE products
    SET stock_quantity = stock_quantity - p_quantity
    WHERE product_id = p_product_id;

    RETURN v_order_id;

EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
$$ LANGUAGE plpgsql;

-- ============================================================
-- Example Tests (Validation)
-- ============================================================

-- SELECT place_order(1, 1, 2, 1); -- success, returns order_id
-- SELECT place_order(1, 1, 999, 1); -- fails: Insufficient stock
-- SELECT place_order(999, 1, 1, 1); -- fails: Customer 999 not found
-- SELECT place_order(1, 1, 1, 999); -- fails: Warehouse 999 not found
-- SELECT place_order(1, 1, 1, 2); -- fails: Warehouse mismatch for product 1: product is in warehouse 1, requested warehouse 2

-- Reset sequences to MAX(id) so re-run no go cause duplicate key
SELECT setval('customers_customer_id_seq', COALESCE((SELECT MAX(customer_id) FROM customers), 1));
SELECT setval('products_product_id_seq', COALESCE((SELECT MAX(product_id) FROM products), 1));
SELECT setval('orders_order_id_seq', COALESCE((SELECT MAX(order_id) FROM orders), 1));
SELECT setval('order_items_order_item_id_seq', COALESCE((SELECT MAX(order_item_id) FROM order_items), 1));
SELECT setval('payments_payment_id_seq', COALESCE((SELECT MAX(payment_id) FROM payments), 1));
SELECT setval('warehouses_warehouse_id_seq', COALESCE((SELECT MAX(warehouse_id) FROM warehouses), 1));
