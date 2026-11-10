// ============================================================
// NaijaCart - Portfolio 4 - NoSQL Implementation (MongoDB)
// Database: NaijaCart_NoSQL
// ============================================================

// ------------------------------------------------------------
// DESIGN DECISION: Embedded vs Referenced
// ------------------------------------------------------------
// We use REFERENCED design for orders, order_items, products.
// Why:
// - Products are shared by many orders, if we embed product
//   inside every order, price change go need update everywhere.
// - Customers are shared by many orders.
// - Order_items reference product_id and order_id.
// We use EMBEDDED only for small, one-to-one data that
// no dey shared, e.g. customer address fit be inside customer.
// For this portfolio, we keep address fields inside customer
// document as simple fields: city, state, phone.
// ------------------------------------------------------------

// ------------------------------------------------------------
// 1. PRODUCTS COLLECTION
// ------------------------------------------------------------
// _id is explicitly set to numeric values to match product_id.
// That is why _id: 1 appears, not ObjectId("...").
// This makes Postgres and Mongo easy to compare.
// ------------------------------------------------------------
db.products.insertMany([
  { _id: 1, product_id: 1, name: "Laptop Stand", category: "Accessories", price: 25000, stock_quantity: 50, warehouse_id: 1 },
  { _id: 2, product_id: 2, name: "Wireless Mouse", category: "Accessories", price: 12000, stock_quantity: 100, warehouse_id: 1 }
]);

// ------------------------------------------------------------
// 2. CUSTOMERS COLLECTION
// ------------------------------------------------------------
db.customers.insertMany([
  { _id: 1, customer_id: 1, full_name: "Ada Odi", email: "ada@example.com", phone: "08030000001", city: "Lagos", state: "Lagos State" },
  { _id: 2, customer_id: 2, full_name: "Tunde Bakare", email: "tunde@example.com", phone: "08030000002", city: "Abuja", state: "FCT" }
]);

// ------------------------------------------------------------
// 3. ORDERS COLLECTION
// ------------------------------------------------------------
// total_amount must match sum of its order_items.
// Order 1 = 25000 + 24000 = 49000
// Order 2 = 25000
// Order 3 = 0 (no items yet, pending)
// ------------------------------------------------------------
db.orders.insertMany([
  { _id: 1, order_id: 1, customer_id: 1, warehouse_id: 1, order_date: "2026-11-09", status: "pending", total_amount: 49000 },
  { _id: 2, order_id: 2, customer_id: 2, warehouse_id: 1, order_date: "2026-11-09", status: "pending", total_amount: 25000 },
  { _id: 3, order_id: 3, customer_id: 1, warehouse_id: 1, order_date: "2026-11-09", status: "pending", total_amount: 0 }
]);

// ------------------------------------------------------------
// 4. ORDER_ITEMS COLLECTION
// ------------------------------------------------------------
db.order_items.insertMany([
  { _id: 1, order_item_id: 1, order_id: 1, product_id: 1, quantity: 1, unit_price: 25000 },
  { _id: 2, order_item_id: 2, order_id: 1, product_id: 2, quantity: 2, unit_price: 12000 },
  { _id: 3, order_item_id: 3, order_id: 2, product_id: 1, quantity: 1, unit_price: 25000 }
]);

// ------------------------------------------------------------
// 5. QUERY 1: Find all products in Accessories
// ------------------------------------------------------------
db.products.find({ category: "Accessories" });

// ------------------------------------------------------------
// 6. QUERY 2: Find all orders for Customer 1 (Ada Odi)
// ------------------------------------------------------------
db.orders.find({ customer_id: 1 });

// ------------------------------------------------------------
// 7. AGGREGATION: Total Sales Per Category
// ------------------------------------------------------------
// Calculation:
// Item 1: 1 x 25000 = 25000
// Item 2: 2 x 12000 = 24000
// Item 3: 1 x 25000 = 25000
// Total = 74000, Items = 1 + 2 + 1 = 4
// ------------------------------------------------------------
db.order_items.aggregate([
  {
    $lookup: {
      from: "products",
      localField: "product_id",
      foreignField: "product_id",
      as: "product_info"
    }
  },
  { $unwind: "$product_info" },
  {
    $group: {
      _id: "$product_info.category",
      total_sales: { $sum: { $multiply: ["$quantity", "$unit_price"] } },
      total_items_sold: { $sum: "$quantity" }
    }
  },
  { $sort: { total_sales: -1 } }
]);

// Expected Result:
// { _id: "Accessories", total_sales: 74000, total_items_sold: 4 }

// ------------------------------------------------------------
// DESIGN DECISION: Why MongoDB fits Catalog
// ------------------------------------------------------------
// Why MongoDB fits catalog: Product documents can carry
// different optional fields without schema change.
// E.g. Laptop Stand could add attributes:
// { material: "Aluminium", adjustable: true }
// while Wireless Mouse adds attributes:
// { battery: "AA", wireless_range_m: 10 }.
// In PostgreSQL, we would need extra tables or NULL columns
// for this. In MongoDB, each document can differ.
// ------------------------------------------------------------
