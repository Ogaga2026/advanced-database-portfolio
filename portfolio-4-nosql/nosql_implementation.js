// ---------- PRODUCTS ----------
db.products.insertMany([
  {
    _id: 1,
    product_id: 1,
    name: "Laptop Stand",
    category: "Accessories",
    price: 25000,
    stock_quantity: 50,
    warehouse_id: 1
  },
  {
    _id: 2,
    product_id: 2,
    name: "Wireless Mouse",
    category: "Accessories",
    price: 12000,
    stock_quantity: 100,
    warehouse_id: 1
  }
]);

// ---------- CUSTOMERS ----------
db.customers.insertMany([
  {
    _id: 1,
    customer_id: 1,
    full_name: "Ada Odi",
    email: "ada@example.com",
    phone: "08030000001",
    city: "Lagos",
    state: "Lagos State"
  },
  {
    _id: 2,
    customer_id: 2,
    full_name: "Tunde Bakare",
    email: "tunde@example.com",
    phone: "08030000002",
    city: "Abuja",
    state: "FCT"
  }
]);

// ---------- ORDERS ----------
db.orders.insertMany([
  { _id: 1, order_id: 1, customer_id: 1, warehouse_id: 1, order_date: "2026-11-09", status: "pending", total_amount: 25000 },
  { _id: 2, order_id: 2, customer_id: 2, warehouse_id: 1, order_date: "2026-11-09", status: "pending", total_amount: 12000 },
  { _id: 3, order_id: 3, customer_id: 1, warehouse_id: 2, order_date: "2026-11-09", status: "pending", total_amount: 25000 }
]);

// ---------- ORDER ITEMS ----------
db.order_items.insertMany([
  { _id: 1, order_item_id: 1, order_id: 1, product_id: 1, quantity: 1, unit_price: 25000 },
  { _id: 2, order_item_id: 2, order_id: 2, product_id: 2, quantity: 1, unit_price: 12000 },
  { _id: 3, order_item_id: 3, order_id: 3, product_id: 1, quantity: 1, unit_price: 25000 }
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
// { _id: "Accessories", total_sales: 62000, total_items_sold: 3 }
//
// ---------- DESIGN DECISION ----------
// Why MongoDB fits catalog: Product documents can carry different
// optional fields without schema change. E.g. Laptop Stand could add
// { attributes: { material: "Aluminium", adjustable: true } } while
// Wireless Mouse adds { attributes: { battery: "AA", wireless_range_m: 10 } }.
// In PostgreSQL, we would need extra tables or NULL columns for this.
