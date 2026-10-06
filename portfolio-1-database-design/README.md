# Portfolio 1: Database Design - ShopNaija E-commerce

### Overview
Designed a normalized relational database for a Nigerian e-commerce platform (ShopNaija) with 5 tables to handle customers, products, orders, and payments.

### Entities & Relationships
- **Customers (1) -> Orders (M):** One customer can place many orders
- **Orders (1) -> Order_Items (M):** One order can have many items
- **Products (1) -> Order_Items (M):** One product can be in many orders
- **Orders (1) -> Payments (1):** One order has one payment

### Key Features
- Primary Keys & Foreign Keys with CASCADE delete
- CHECK constraints (price > 0, quantity > 0)
- UNIQUE constraint on email
- Timestamp for audit trail
- 3NF Normalized

### Files
- `schema.sql` - Full DDL script
- `ER_Diagram.png` - Entity Relationship Diagram
