# NaijaCart - Advanced Database Portfolio
Erhiyoma Oghenevwogaga - Ogaga2026

NaijaCart is an e-commerce database for Nigeria, built with 6 tables only:
warehouses, customers, products, orders, order_items, payments

## Structure

- [Portfolio 1 - Database Design](./portfolio-1-database-design/)
- [Portfolio 2 - Sample Data](./portfolio-2-sample-data/)
- [Portfolio 3 - Transactions & Concurrency](./portfolio-3-transactions-concurrency/)
- [Portfolio 4 - NoSQL Implementation](./portfolio-4-nosql/)
- [Portfolio 5 - Distributed / Cloud - PROPOSED](./portfolio-5-distributed-cloud/)

## How To Run

docker-compose up -d
PostgreSQL: localhost:5432
MongoDB: localhost:27017

## Consistency Rule

Prices MUST match in BOTH systems.
Example: Laptop Stand = 25000 in PostgreSQL AND 25000 in MongoDB.
If you see 35000 anywhere, na mistake.

## Final Reflection - What I Learned

1. Design first: I learned to design 6 tables with proper keys before writing any code. This stopped confusion later.

2. Transactions protect business: In Portfolio 3, I used place_order() with FOR UPDATE row-level lock. This stops 2 users from buying the same last product and overselling.

3. SQL vs NoSQL: PostgreSQL is good for orders and payments where consistency matters. MongoDB is good for flexible product attributes like sizes and colours. Both must keep same prices.

4. Honesty in Portfolio 5: Portfolio 5 is PROPOSED, not tested. I did not claim I tested what I did not test.

5. Next step: I want to add indexes and test with more data to improve performance.
