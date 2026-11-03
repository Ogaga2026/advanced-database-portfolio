# MIT 8103 Final Documentation (6 Marks)

**Student:** Ogagaja2026
**GitHub:** https://github.com/Ogaga2026/advanced-database-portfolio
**Course:** MIT 8103 Advanced Database Systems - September Cohort
**Case Study:** NaijaCart E-commerce Platform (Nigeria)

## 1. Executive Summary
This portfolio implements complete advanced database concepts using ONE case study (NaijaCart) across all 5 portfolios as required by assignment.

- Portfolio 1 (7 marks): Database Design & Modelling - ER Diagram with Customers, Products, Orders, OrderItems, Payments, Categories. Relational schema, Keys, Constraints, 3NF Normalization.
- Portfolio 2 (7 marks): Query Processing & Optimization - SQL queries, sample data, EXPLAIN ANALYZE execution plans, indexing strategies for performance.
- Portfolio 3 (7 marks): Transactions & Concurrency - ACID properties, COMMIT, ROLLBACK, Isolation Levels (Read Committed, Repeatable Read), Deadlock detection and prevention.
- Portfolio 4 (7 marks): NoSQL & Advanced Models - Same case study in MongoDB (Document for catalog), Redis (Key-Value for cart), Neo4j (Graph for recommendations).
- Portfolio 5 (6 marks): Distributed & Cloud - Replication (Lagos Primary, Abuja Replica, Port Harcourt Backup), Sharding by customer_id, CAP Theorem (AP for catalog, CP for payments), AWS deployment (RDS Multi-AZ, MongoDB Atlas, ElastiCache).

All work shows progressive commits with meaningful messages.

## 2. GitHub Structure & Evidence
Link: https://github.com/Ogaga2026/advanced-database-portfolio

Folders:
- portfolio-1-database-design/
- portfolio-2-sample-data/
- portfolio-3-transactions-concurrency/
- portfolio-4-nosql/
- portfolio-5-distributed-cloud/
- README.md (main overview)
- Final_Documentation.md (this file)

Commit history proves step-by-step development, not bulk upload.

## 3. Reflection
I learned how one business problem can be solved with different database paradigms. The most interesting was CAP theorem - understanding that in Nigeria e-commerce, you must prioritize Consistency for payments (CP) but can prioritize Availability for product browsing (AP). Replication across Lagos, Abuja, PH makes system resilient.

Challenge was mapping Portfolio 3 vs 5 correctly and GitHub file naming, which I resolved.

## 4. AI-Use Declaration
I used Meta AI as tutor to explain concepts (replication, sharding, CAP), generate README templates, and structure this documentation. All code, decisions, and final understanding are my own. I tested all scripts before committing.

## 5. Conclusion
All requirements met: One organization (NaijaCart), 5 portfolios (34 marks), GitHub link with progressive commits, and this final documentation (6 marks). Total 40 marks complete.

GitHub: https://github.com/Ojpgaja2026/advanced-database-portfolio
