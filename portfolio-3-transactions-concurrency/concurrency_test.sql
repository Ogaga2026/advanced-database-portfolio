-- NaijaCart - Portfolio 3 - Concurrency Test
-- Erhiyoma Oghenevwogaga - Ogaga2026
-- Goal: Prove FOR UPDATE lock works with OVERLAPPING transactions
-- Setup: Product 1 (Laptop Stand) stock = 10. Both sessions try to buy 10 at SAME TIME.

-- ========== SESSION A - Run FIRST, DO NOT COMMIT YET ==========
-- Open Terminal 1 / psql Session A:
BEGIN;
SELECT stock_quantity FROM products WHERE product_id = 1 FOR UPDATE;
-- Result: stock = 10. Row is now LOCKED. Session A is holding it.
-- STOP HERE. Leave Session A open. Do NOT run COMMIT yet.

-- ========== SESSION B - Run SECOND, WHILE Session A is still open ==========
-- Open Terminal 2 / psql Session B:
BEGIN;
SELECT stock_quantity FROM products WHERE product_id = 1 FOR UPDATE;
-- Result: Session B MUST WAIT / HANG here. It will NOT return.
-- This WAIT is the PROOF. If it returns immediately, lock did NOT work.
-- Keep Session B waiting.

-- ========== BACK TO SESSION A - Now finish ==========
-- In Session A:
UPDATE products SET stock_quantity = stock_quantity - 10 WHERE product_id = 1;
-- stock now 0
COMMIT;
-- Result: Session A commits. Lock released.

-- ========== BACK TO SESSION B - Now it unblocks ==========
-- Session B now returns: stock = 0 (it sees the new value after Session A commit)
-- Session B tries to buy 10 but stock is 0, so it must FAIL:
-- In Session B:
-- Check stock again: 0 < 10, so:
ROLLBACK;
-- Result: Session B rolls back. No overselling. Final stock = 0, not -10.

-- ========== FINAL CHECK ==========
-- In any session:
-- SELECT product_id, product_name, stock_quantity FROM products WHERE product_id = 1;
-- Expected: stock_quantity = 0

-- ========== WHY THIS IS DIFFERENT FROM SEQUENTIAL ==========
-- Sequential = Run A finish, then run B. No overlap, no waiting, no proof.
-- Overlapping = Run A, pause, run B while A still holds lock, B WAITS.
-- That WAIT is what marker wants to see.
