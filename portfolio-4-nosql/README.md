# Portfolio 4 - NoSQL Implementation - NaijaCart
MIT 8103 - Erhiyoma Oghenevwogaga - Ogaga2026

## Why MongoDB For NaijaCart?

Postgres dey for money - orders, payments, inventory. MongoDB dey for catalog.

Why? Because products get different attributes:
- Ankara Fabric get sizes and colours
- Laptop Stand get material and adjustable
- Sneakers get sizes and colours

For Postgres, this would need separate table. For MongoDB, we just embed `attributes` inside product document. No extra join.

## Collections

Collections mirror the 6 SQL tables:
- `products` - with embedded `attributes`
- `customers`
- `orders`
- `order_items`
- `warehouses`
- `payments`

## Price Consistency - IMPORTANT

Prices MUST match Postgres sample data. No duplicate price for same product.

- Laptop Stand = **25000 in BOTH Postgres and MongoDB**
- Ankara Fabric = 25000 in both
- Sneakers = 45000 in both

If you see Laptop Stand as 35000 in MongoDB, na mistake. Fix am to 25000.

## Example Product Document

```javascript
{
  product_id: 2,
  name: "Laptop Stand",
  category: "Electronics",
  price: 25000,
  stock_quantity: 10,
  warehouse_id: 1,
  attributes: { material: "Aluminium", adjustable: true }
}
