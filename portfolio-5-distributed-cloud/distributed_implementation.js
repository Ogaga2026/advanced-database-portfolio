// MIT 8103 - Portfolio 5: Distributed and Cloud Database
// Case Study: NaijaCart E-commerce

// 1. REPLICATION - High Availability
db.adminCommand({
  replSetInitiate: {
    _id: "naijacartReplicaSet",
    members: [
      { _id: 0, host: "lagos-primary.naijacart.com:27017", priority: 2 },
      { _id: 1, host: "abuja-replica.naijacart.com:27017", priority: 1 },
      { _id: 2, host: "ph-replica.naijacart.com:27017", priority: 1 }
    ]
  }
})

// 2. SHARDING - For Scalability
sh.enableSharding("naijacartDB")
sh.shardCollection("naijacartDB.Orders", { customer_id: 1, order_id: 1 })
sh.shardCollection("naijacartDB.Products", { category: 1, product_id: 1 })

// 3. CONSISTENCY (CAP Theorem)
// Eventual for Catalog, Strong for Payments
db.Products.updateOne({ product_id: 101 }, { $inc: { views: 1 } }, { writeConcern: { w: 1 } })
db.Orders.insertOne({ order_id: 1005, total: 50000, status: "Paid" }, { writeConcern: { w: "majority", j: true } })

// 4. CLOUD STRATEGY
// Region: af-south-1 + eu-west-1 backup
// Primary: RDS PostgreSQL Multi-AZ for Orders
// NoSQL: MongoDB Atlas sharded for Catalog
// Cache: Redis for Cart
