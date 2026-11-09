// Portfolio 4 - NoSQL Implementation - NaijaCart
// Erhiyoma Oghenevwogaga - Ogaga2026
// MongoDB collections mirror the 6 SQL tables

// ========== PRODUCTS - PRICES MUST MATCH SQL ==========
// SQL: Laptop Stand = 25000. MongoDB MUST also be 25000. NOT 35000.
// If you see 35000 anywhere, na mistake. Fix am to 25000.

db.products.insertMany([
  {
    product_id: 1,
    name: "Ankara Fabric",
    category: "Fashion",
    price: 25000,
    stock_quantity: 10,
    warehouse_id: 1,
    attributes: { sizes: ["S", "M", "L"], colours: ["Red", "Blue"] }
  },
  {
    product_id: 2,
    name: "Laptop Stand",
    category: "Electronics",
    price: 25000,
    stock_quantity: 10,
    warehouse_id: 1,
    attributes: { material: "Aluminium", adjustable: true }
  },
  {
    product_id: 3,
    name: "Sneakers",
    category: "Fashion",
    price: 45000,
    stock_quantity: 5,
    warehouse_id: 2,
    attributes: { sizes: [40, 41, 42], colours: ["Black", "White"] }
  }
]);

db.customers.insertOne({
  customer_id: 1,
  full_name: "Erhiyoma Oghenevwogaga",
  email: "erhiyoma@test.com",
  phone: "08030000000",
  city: "Lagos",
  state: "Lagos"
});

db.orders.insertMany([
  { order_id: 1, customer_id: 1, warehouse_id: 2, order_date: "2026-11-09", status: "completed", total_amount: 25000 },
  { order_id: 2, customer_id: 2, warehouse_id: 1, order_date: "2026-11-09", status: "completed", total_amount: 45000 }
]);

db.order_items.insertMany([
  { order_item_id: 1, order_id: 1, product_id: 2, quantity: 1, unit_price: 25000 },
  { order_item_id: 2, order_id: 2, product_id: 3, quantity: 1, unit_price: 45000 }
]);

// ========== CORRECT AGGREGATION - Total Sales Per Category ==========
// MUST group by products.category via $lookup
// MUST NOT group by order status
// MUST NOT double-count: sum quantity * unit_price per line item

db.order_items.aggregate([
  {
    $lookup: {
      from: "products",
      localField: "product_id",
      foreignField: "product_id",
      as: "product"
    }
  },
  { $unwind: "$product" },
  {
    $group: {
      _id: "$product.category",
      total_sales: { $sum: { $multiply: ["$quantity", "$unit_price"] } },
      total_items_sold: { $sum: "$quantity" }
    }
  },
  { $sort: { total_sales: -1 } }
]);

// Expected result:
// { _id: "Fashion", total_sales: 45000, total_items_sold: 1 }
// { _id: "Electronics", total_sales: 25000, total_items_sold: 1 }

// WRONG VERSION - DO NOT USE:
// db.orders.aggregate([ { $group: { _id: "$status", total: { $sum: "$total_amount" } } } ])
// This is wrong because it groups by status, not category.
// And if you sum orders.total_amount after joining order_items, you double-count orders with many items.

// ========== WHY MongoDB FITS CATALOG ==========
// Products have different attributes: Ankara has sizes/colours, Laptop Stand has material/adjustable.
// In Postgres this would need separate table. In MongoDB we embed attributes inside product document.
