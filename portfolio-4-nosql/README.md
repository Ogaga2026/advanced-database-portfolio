# Portfolio 4: NoSQL Implementation - NaijaCart

## Why NoSQL for NaijaCart?
- Product catalog: Different products have different attributes (phones vs clothes)
- Shopping cart: Needs fast read/write, temporary storage
- Reviews: Flexible schema, embedded data

## SQL vs NoSQL Comparison
| Feature | SQL (PostgreSQL) | NoSQL (MongoDB) |
|---------|------------------|-----------------|
| Structure | Fixed tables | Flexible documents |
| Best for | Orders, Payments, ACID transactions | Product catalog, Cart, Logs |
| Example in NaijaCart | Order processing | Product with varying specs |

## Collections Created
1. Customers - with embedded address and order list
2. Products - with embedded reviews and variable specs
3. Orders - denormalized for performance

## Advantage
MongoDB allows faster reads for catalog and handles unstructured data like reviews easily.
