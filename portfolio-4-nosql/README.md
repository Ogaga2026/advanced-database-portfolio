# Portfolio 4 - NoSQL Implementation - NaijaCart - Erhiyome Oghenevogaga

## Why MongoDB for NaijaCart?

### 1. SQL (MySQL) is for:
- Transactions (orders, payments) - ACID compliance
- Structured data with relationships
- Inventory control with FOR UPDATE locking

### 2. NoSQL (MongoDB) is for:
- Flexible product catalog (Ankara gown get different sizes, iPhone get storage variants)
- Customer behavior tracking (Lagos customers browse differently)
- Fast reads for product recommendations
- Scaling for Black Friday flash sales in Nigeria

## Collections Design

### customers collection
```json
{
  "_id": 1,
  "full_name": "Tunde Lagos",
  "city": "Lagos",
  "total_orders": 5
}
