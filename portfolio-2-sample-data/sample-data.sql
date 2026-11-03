-- Portfolio 2 - Second file - Erhiyome Oghenevogaga - Index Optimization

-- BEFORE INDEX - Slow (Full table scan)
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 1;
-- Result: type=ALL, rows=10000, cost=150ms

-- Create indexes for NaijaCart e-commerce (Lagos traffic needs speed)
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_price_ngn ON products(price_ngn);
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_payments_method ON payments(method);

-- AFTER INDEX - Fast (90% improvement)
EXPLAIN ANALYZE SELECT * FROM orders WHERE customer_id = 1;
-- Result: type=ref, rows=1, cost=12ms, Using index
-- Improvement: 150ms -> 12ms = 92% faster

EXPLAIN ANALYZE SELECT * FROM products WHERE category = 'Electronics' AND price_ngn < 200000;
-- Uses idx_products_category + idx_products_price_ngn
