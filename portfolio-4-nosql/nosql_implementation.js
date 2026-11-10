// ============================================================
// NaijaCart - Portfolio 4 - NoSQL Implementation (MongoDB)
// ============================================================
// Purpose: Show NoSQL design for NaijaCart
// Source of truth: portfolio-2-sample-data/sample-data.sql
// Postgres and MongoDB MUST match exactly - Issue 1 Fixed
// ============================================================

// ------------------------------------------------------------
// 1. CLEANUP - Drop existing collections
// ------------------------------------------------------------
db.warehouses.drop();
db.customers.drop();
db.products.drop();
db.orders.drop();
db.order_items.drop();
db.payments.drop();

// ------------------------------------------------------------
// 2. WAREHOUSES - Matches Postgres warehouses
// ------------------------------------------------------------
db.warehouses.insertMany([
  { warehouse_id: 1, name: "Lagos Main", city: "Lagos", state: "Lagos State", capacity: 10000 },
  { warehouse_id: 2, name: "Abuja Hub", city: "Abuja", state: "FCT", capacity: 8000 }
]);

// ------------------------------------------------------------
// 3. CUSTOMERS - Matches Postgres customers
// ------------------------------------------------------------
// Postgres: 1 = Ada Obi, 2 = Tunde Bakare
db.customers.insertMany([
  {
    customer_id: 1,
    full_name: "Ada Obi",
    email: "ada@example.com",
    phone: "08030000001",
    city: "Lagos",
    state: "Lagos State"
  },
  {
    customer_id: 2,
    full_name: "Tunde Bakare",
    email: "tunde@example.com",
    phone: "08030000002",
    city: "Abuja",
    state: "FCT"
  }
]);

// ------------------------------------------------------------
// 4. PRODUCTS - ISSUE 1 FIXED
// ------------------------------------------------------------
// Postgres sample-data.sql:
// (1, 'Laptop Stand', 'Accessories', 25000, 50, 1)
// (2, 'Wireless Mouse', 'Accessories', 12000, 100, 1)
// NOTE: No Ankara Fabric. No 250000 price.
// MongoDB now = Postgres exactly.
db.products.insertMany([
  {
    product_id: 1,
    name: "Laptop Stand",
    category: "Accessories",
    price: 25000,
    stock_quantity: 50,
    warehouse_id: 1
  },
  {
    product_id: 2,
    name: "Wireless Mouse",
    category: "Accessories",
    price: 12000,
    stock_quantity: 100,
    warehouse_id: 1
  }
]);

// ------------------------------------------------------------
// 5. ORDERS - Matches Postgres orders
// ------------------------------------------------------------
// Postgres totals: Order 1 = 25000, Order 2 = 12000, Order 3 = 25000
db.orders.insertMany([
  { order_id: 1, customer_id: 1, warehouse_id: 1, status: "pending", total_amount: 25000 },
  { order_id: 2, customer_id: 2, warehouse_id: 1, status: "pending", total_amount: 12000 },
  { order_id: 3, customer_id: 1, warehouse_id: 2, status: "pending", total_amount: 25000 }
]);

// ------------------------------------------------------------
// 6. ORDER ITEMS - Matches Postgres order_items
// ------------------------------------------------------------
db.order_items.insertMany([
  { order_item_id: 1, order_id: 1, product_id: 1, quantity: 1, unit_price: 25000 },
  { order_item_id: 2, order_id: 2, product_id: 2, quantity: 1, unit_price: 12000 },
  { order_item_id: 3, order_id: 3, product_id: 1, quantity: 1, unit_price: 25000 }
]);

// ------------------------------------------------------------
// 7. PAYMENTS - Matches Postgres payments
// ------------------------------------------------------------
db.payments.insertMany([
  { payment_id: 1, order_id: 1, amount: 25000, payment_method: "Card", status: "pending" },
  { payment_id: 2, order_id: 2, amount: 12000, payment_method: "Transfer", status: "pending" },
  { payment_id: 3, order_id: 3, amount: 25000, payment_method: "Card", status: "pending" }
]);

// ------------------------------------------------------------
// 8. INDEXES - For query optimisation
// ------------------------------------------------------------
db.orders.createIndex({ warehouse_id: 1 });
db.products.createIndex({ product_id: 1 });
db.customers.createIndex({ customer_id: 1 });
db.order_items.createIndex({ order_id: 1 });

// ------------------------------------------------------------
// 9. VERIFICATION QUERIES
// Output in mongo_results.txt MUST match inserts above
// ------------------------------------------------------------
print("=== PRODUCTS ===");
printjson(db.products.find().sort({ product_id: 1 }).toArray());

print("=== ORDERS ===");
printjson(db.orders.find().sort({ order_id: 1 }).toArray());

print("=== WAREHOUSE SALES ===");
printjson(db.orders.aggregate([
  { $group: { _id: "$warehouse_id", total_sales: { $sum: "$total_amount" } } },
  { $sort: { _id: 1 } }
]).toArray());

print("=== DONE - Postgres and MongoDB now match ===");
