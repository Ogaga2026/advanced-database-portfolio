// Portfolio 5 - Distributed and Cloud Database - Erhiyome Oghenevogaga - Ogaga2026
// MIT 8103 - NaijaCart High Availability for Black Friday Lagos

// === 1. REPLICATION STRATEGY (Primary-Secondary) ===
use('naijacart_distributed');

// Configure Replica Set for NaijaCart - Lagos Primary, Abuja & PH Secondary
const replicaSetConfig = {
  _id: "naijacartRS",
  members: [
    { _id: 0, host: "lagos-primary.naijacart.com:27017", priority: 2 }, // Primary - Handles WRITES
    { _id: 1, host: "abuja-replica.naijacart.com:27017", priority: 1 }, // Secondary 1 - Handles READS
    { _id: 2, host: "portharcourt-backup.naijacart.com:27017", priority: 0, hidden: true } // Hidden backup
  ]
};

// Initiate replica set
// rs.initiate(replicaSetConfig);
// rs.status();

// === 2. SHARDING STRATEGY ===
sh.enableSharding("naijacart_distributed");

// Shard products by category + warehouse for Lagos traffic
sh.shardCollection("naijacart_distributed.products", { "category": 1, "warehouse": 1 });
sh.shardCollection("naijacart_distributed.orders", { "customer_id": 1, "created_at": 1 });

// === 3. DISTRIBUTED TRANSACTIONS WITH REPLICA SET ===
// insertMany with writeConcern for high availability
db.products.insertMany([
  { _id: 201, name: "iPhone 15", category: "Electronics", price_ngn: 1500000, warehouse: "Lagos", stock: 100 },
  { _id: 202, name: "Ankara", category: "Fashion", price_ngn: 45000, warehouse: "Abuja", stock: 200 }
], { writeConcern: { w: "majority", wtimeout: 5000 } });

// Read Preference - Read from Secondary for product browsing
db.getMongo().setReadPref("secondaryPreferred");
db.products.find({ category: "Electronics" }).readPref("secondaryPreferred");

// === 4. CLOUD DEPLOYMENT CONFIG ===
const cloudConfig = {
  provider: "AWS",
  region: "af-south-1 (Cape Town) closest to Nigeria",
  autoScaling: true,
  backupStrategy: "Daily snapshots to S3, Point-in-time recovery",
  monitoring: "CloudWatch for Lagos traffic spikes"
};

// === 5. FAILOVER TEST ===
// If Lagos Primary fails, Abuja automatically becomes Primary - Zero downtime
// rs.stepDown() on Primary to test failover

// === 6. DISTRIBUTED QUERY - Aggregation across shards ===
db.orders.aggregate([
  { $group: { _id: "$warehouse", total_sales: { $sum: "$total_ngn" } } },
  { $sort: { total_sales: -1 } }
], { readConcern: { level: "majority" } });
