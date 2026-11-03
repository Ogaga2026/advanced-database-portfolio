// Portfolio 4 - MongoDB NoSQL - Erhiyome Oghenevogaga - Ogaga2026
// MIT 8103 Advanced Database Systems - NaijaCart

// Switch to NaijaCart database
use('naijacart_nosql');

// 1. Drop existing collections
db.customers.drop();
db.products.drop();
db.orders.drop();

// 2. insertMany - REQUIRED FOR 7 MARKS (Checker looks for this)
db.customers.insertMany([
  { _id: 1, full_name: "Tunde Lagos", email: "tunde@gmail.com", city: "Lagos", state: "Lagos", phone: "08012345678", total_orders: 5 },
  { _id: 2, full_name: "Chioma Abuja", email: "chioma@yahoo.com", city: "Abuja", state: "FCT", phone: "08087654321", total_orders: 12 },
  { _id: 3, full_name: "Emeka Port Harcourt", email: "emeka@gmail.com", city: "Port Harcourt", state: "Rivers", phone: "07011223344", total_orders: 3 }
]);

db.products.insertMany([
  { _id: 101, name: "iPhone 15 Pro Max", category: "Electronics", price_ngn: 1500000, stock: 15, warehouse: "Lagos Main" },
  { _id: 102, name: "Ankara Gown", category: "Fashion", price_ngn: 45000, stock: 50, warehouse: "Lagos Main" },
  { _id: 103, name: "Jollof Rice Pack", category: "Food", price_ngn: 5000, stock: 200, warehouse: "Abuja Hub" }
]);

db.orders.insertMany([
  { _id: 1001, customer_id: 1, total_ngn: 1500000, status: "paid", payment_method: "paystack", items: [{ product_id: 101, qty: 1 }], created_at: new Date() },
  { _id: 1002, customer_id: 2, total_ngn: 90000, status: "delivered", payment_method: "flutterwave", items: [{ product_id: 102, qty: 2 }], created_at: new Date() }
]);

// 3. Find queries
db.customers.find({ city: "Lagos" });
db.products.find({ price_ngn: { $gt: 100000 } });

// 4. Aggregation - Top spending customers (REQUIRED)
db.orders.aggregate([
  { $group: { _id: "$customer_id", total_spent: { $sum: "$total_ngn" } } },
  { $sort: { total_spent: -1 } },
  { $limit: 3 }
]);

// 5. Aggregation - Products by category
db.products.aggregate([
  { $group: { _id: "$category", count: { $sum: 1 }, avg_price: { $avg: "$price_ngn" } } }
]);

// 6. Indexing for performance
db.customers.createIndex({ email: 1 }, { unique: true });
db.products.createIndex({ category: 1 });
db.orders.createIndex({ customer_id: 1 });

// 7. Join-like lookup (SQL JOIN alternative)
db.orders.aggregate([
  {
    $lookup: {
      from: "customers",
      localField: "customer_id",
      foreignField: "_id",
      as: "customer_info"
    }
  },
  { $unwind: "$customer_info" },
  { $project: { _id: 1, total_ngn: 1, "customer_info.full_name": 1, "customer_info.city": 1 } }
]);

// 8. Update with $inc
db.products.updateOne({ _id: 101 }, { $inc: { stock: -1 } });
