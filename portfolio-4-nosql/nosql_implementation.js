// MIT 8103 - Portfolio 4: NoSQL Implementation
// NaijaCart E-commerce - MongoDB

// 1. Customers Collection
db.Customers.insertOne({
  customer_id: 301,
  name: "Ogaga",
  email: "ogaga@naijacart.com",
  address: { city: "Lagos", state: "Lagos", country: "Nigeria" },
  orders: [1001, 1002]
})

// 2. Products with embedded reviews
db.Products.insertOne({
  product_id: 101,
  name: "iPhone 15",
  category: "Electronics",
  price: 1200000,
  stock: 50,
  specs: { ram: "8GB", storage: "256GB", color: "Black" },
  reviews: [
    { customer_id: 301, rating: 5, comment: "Very fast delivery!" }
  ]
})

// 3. Orders - Denormalized
db.Orders.insertOne({
  order_id: 1001,
  customer: { customer_id: 301, name: "Ogaga" },
  items: [{ product_id: 101, quantity: 1, price: 1200000 }],
  total: 1200000,
  status: "Completed"
})

// 4. When to use NoSQL in NaijaCart
// - Product catalog: flexible attributes
// - Shopping cart: fast access
// - Activity logs & Reviews
