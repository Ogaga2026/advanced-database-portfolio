// Portfolio 4 - NoSQL Implementation
// NaijaCart - MongoDB - Matches Portfolio 1 data
// Use: mongosh naijacart_nosql < nosql_implementation.js
// OR copy-paste inside mongosh

// Switch to NoSQL database
// use naijacart_nosql;

// Drop existing collections for clean run
db.customers.drop();
db.products.drop();
db.orders.drop();

// 1. Customers - flexible document, matches Portfolio 1 customers
db.customers.insertMany([
  { _id: 1, full_name: "Tunde Okonkwo", email: "tunde.okonkwo@gmail.com", phone: "08030000001", city: "Ikeja", state: "Lagos", total_orders: 2 },
  { _id: 2, full_name: "Amaka Johnson", email: "amaka.johnson@gmail.com", phone: "08030000002", city: "Lekki", state: "Lagos", total_orders: 2 },
  { _id: 3, full_name: "Emeka Obi", email: "emeka.obi@gmail.com", phone: "08030000003", city: "Ikeja", state: "Lagos", total_orders: 1 }
]);

// 2. Products - BEST USE CASE for NoSQL
// Why? Ankara get different sizes, iPhone get storage variants.
// In SQL, this go need many tables. In Mongo, we just add flexible field.
db.products.insertMany([
  { _id: 1, name: "Ankara Fabric", category: "Fashion", price: 15000, stock_quantity: 100, warehouse: "Lagos Main", attributes: { sizes: ["2 yards", "4 yards", "6 yards"], colours: ["Red", "Blue", "Yellow"] } },
  { _id: 2, name: "Laptop Stand", category: "Electronics", price: 25000, stock_quantity: 50, warehouse: "Lagos Main", attributes: { material: "Aluminium", adjustable: true } },
  { _id: 3, name: "Wireless Mouse", category: "Electronics", price: 12000, stock_quantity: 200, warehouse: "Lagos Main", attributes: { wireless: true, battery: "AA" } },
  { _id: 4, name: "Bag of Rice 50kg", category: "Groceries", price: 85000, stock_quantity: 80, warehouse: "Abuja Hub", attributes: { weight_kg: 50, brand: "Mama Gold" } }
]);

// 3. Orders - Embedded items, no JOIN needed. Fast read for 1 order.
db.orders.insertMany([
  { _id: 1, customer_id: 1, total_amount: 27000, status: "completed", payment_method: "card", items: [{ product_id: 1, qty: 1, unit_price: 15000 }, { product_id: 3, qty: 1, unit_price: 12000 }], created_at: new Date() },
  { _id: 2, customer_id: 2, total_amount: 35000, status: "completed", payment_method: "transfer", items: [{ product_id: 2, qty: 1, unit_price: 35000 }], created_at: new Date() }
]);

// 4. Indexes - for fast queries
db.customers.createIndex({ email: 1 }, { unique: true });
db.products.createIndex({ category: 1 });
db.products.createIndex({ name: "text" });
db.orders.createIndex({ customer_id: 1 });

// 5. Queries

// Q1: Find all Fashion products
// db.products.find({ category: "Fashion" });

// Q2: Find low stock products
// db.products.find({ stock_quantity: { $lt: 50 } });

// Q3: Find orders for customer 1
// db.orders.find({ customer_id: 1 });

// Q4: Aggregation - Total sales per category
// db.orders.aggregate([
//   { $unwind: "$items" },
//   { $group: { _id: "$status", total_sales: { $sum: "$total_amount" }, count: { $sum: 1 } } }
// ]);

// Q5: Aggregation - Most popular product
// db.orders.aggregate([
//   { $unwind: "$items" },
//   { $group: { _id: "$items.product_id", total_qty: { $sum: "$items.qty" } } },
//   { $sort: { total_qty: -1 } },
//   { $limit: 5 }
// ]);

// WHY HYBRID? - This is the main answer for Portfolio 4
// SQL (Postgres from Portfolio 1) is for:
// - Transactions (orders, payments) - ACID compliance
// - Structured data with relationships
// - Inventory control with FOR UPDATE locking
//
// NoSQL (MongoDB here) is for:
// - Flexible product catalog (Ankara get different sizes, iPhone get storage variants)
// - Customer behaviour tracking (Lagos customers browse differently)
// - Fast reads for product recommendations
//
// Conclusion: NaijaCart uses BOTH. SQL for money, NoSQL for flexible catalog.
