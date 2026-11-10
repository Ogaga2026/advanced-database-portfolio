// NaijaCart - Portfolio 4 - NoSQL MongoDB
// Erhiyoma Oghenevwogaga - Ogaga2026

// Use database
use NaijaCart;

// ---------- PRODUCTS ----------
db.products.insertMany([
  {
    product_id: 1,
    name: "Ankara Fabric",
    category: "Fashion",
    price: 25000,
    stock_quantity: 10,
    warehouse_id: 1
  },
  {
    product_id: 2,
    name: "Laptop Stand",
    category: "Electronics",
    price: 250000,
    stock_quantity: 10,
    warehouse_id: 2
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

// ---------- CUSTOMERS ----------
db.customers.insertOne({
  customer_id: 1,
  full_name: "Erhiyoma Oghenevwogaga",
  email: "erhiyoma@test.com",
  phone: "08030000000",
  city: "Lagos",
  state: "Lagos"
});

// ---------- ORDERS ----------
// CORRECTED: Both orders now use customer_id: 1, because only customer 1 exists
db.orders.insertMany([
  { order_id: 1, customer_id: 1, warehouse_id: 2, order_date: "2026-11-09", status: "completed", total_amount: 250000 },
  { order_id: 2, customer_id: 1, warehouse_id: 1, order_date: "2026-11-09", status: "completed", total_amount: 45000 }
]);

// ---------- ORDER ITEMS ----------
db.order_items.insertMany([
  { order_item_id: 1, order_id: 1, product_id: 2, quantity: 1, unit_price: 250000 },
  { order_item_id: 2, order_id: 2, product_id: 3, quantity: 1, unit_price: 45000 }
]);

// ---------- CORRECT AGGREGATION - Total Sales Per Category ----------
// MUST group by product category via products
// MUST NOT group by order status
// MUST NOT double-count: use quantity * unit_price per line item

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
// { _id: "Electronics", total_sales: 250000, total_items_sold: 1 }
// { _id: "Fashion", total_sales: 45000, total_items_sold: 1 }

// ---------- DESIGN DECISION ----------
// Why MongoDB fits catalog: Product catalog has flexible attributes.
// Sneakers has sizes and colours, Laptop Stand does not.
// In MongoDB, each document can have different fields.
// In PostgreSQL, we would need extra tables or NULL columns for this.
