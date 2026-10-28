# Normalisation - NaijaCart

**1NF:** All attributes atomic. sku UNIQUE, email UNIQUE, no multivalued attributes.

**2NF:** Order_Items uses composite PK (order_id, product_id). quantity and unit_price depend on full key.

**3NF:** Removed transitive dependencies:
- Products -> Vendors (business_name moved out)
- Products -> Categories (category name moved out)
- Orders -> Customers (city moved out)
- No calculated fields stored except total_amount (can be derived)

Relationships: Vendors 1:M Products, Categories 1:M Products, Customers 1:M Orders, Orders 1:M Order_Items, Orders 1:1 Payments, Orders 1:1 Shipments
