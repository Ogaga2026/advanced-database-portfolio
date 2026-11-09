// Portfolio 5 - Distributed & Cloud Implementation
// NaijaCart - MongoDB Distributed + Postgres Cloud
// Matches Portfolio 1-4 data

// ============================================================
// PART 1: REPLICATION - High Availability
// Why? If Lagos primary server dies during Black Friday,
// NaijaCart must NOT go down.
// ============================================================

// Replica Set Config - 3 nodes
// Primary: Lagos (priority 2 - preferred primary)
// Secondary: Abuja (priority 1 - can become primary)
// Arbiter / Hidden: Port Harcourt (priority 0, hidden - for backup only, never becomes primary)

var config = {
  _id: "naijacartRS",
  members: [
    { _id: 0, host: "lagos-primary:27017", priority: 2 },
    { _id: 1, host: "abuja-replica:27017", priority: 1 },
    { _id: 2, host: "portharcourt-backup:27017", hidden: true, priority: 0 }
  ]
};

rs.initiate(config);
rs.status();

// How it works:
// - All writes go to Primary (Lagos)
// - Secondaries copy data automatically (async replication)
// - If Primary dies, election happens in <10 seconds, Abuja becomes new Primary
// - App automatically reconnects, customers don't notice downtime

// ============================================================
// PART 2: SHARDING - Horizontal Scaling
// Why? One server cannot hold all NaijaCart products + orders
// when we scale to 1M customers.
// ============================================================

// Enable sharding on database
sh.enableSharding("naijacart_distributed");

// Choose shard key: { category: 1, warehouse_id: 1 }
// Why this key?
// - category spreads data evenly (Fashion, Electronics, Groceries)
// - warehouse_id keeps Lagos data together, Abuja data together
// - Bad key would be customer_id alone - one hot customer could overload one shard

sh.shardCollection("naijacart_distributed.products", { category: 1, warehouse_id: 1 });

// Example data - will be split across shards automatically
db.products.insertOne({ name: "Test Phone", category: "Electronics", warehouse_id: 1 });
db.products.insertOne({ name: "Ankara Fabric", category: "Fashion", warehouse_id: 1 });

// Check distribution
// sh.status();

// ============================================================
// PART 3: CONSISTENCY & WRITE CONCERN - CAP Theorem
// ============================================================

// CAP Theorem: You cannot have Consistency + Availability + Partition Tolerance all at once.
// NaijaCart choice:
// - For ORDERS / PAYMENTS (Postgres + Mongo): Choose Consistency + Partition Tolerance (CP)
//   We use writeConcern: "majority" - wait until majority of replicas confirm write.
//   Slower but money must never be lost.
// - For PRODUCT CATALOG / RECOMMENDATIONS: Choose Availability + Partition Tolerance (AP)
//   We use readPreference: "secondaryPreferred" - read from secondary if primary is busy.
//   Faster, small delay is okay.

// For orders - STRONG consistency
db.getMongo().setReadPref("primary");
db.orders.insertOne(
  { customer_id: 1, total_amount: 27000, status: "pending" },
  { writeConcern: { w: "majority", wtimeout: 5000 } }
);

// For catalog - HIGH availability
// db.products.find({ category: "Fashion" }).readPref("secondaryPreferred");

// ============================================================
// PART 4: CLOUD DEPLOYMENT - Where to host?
// ============================================================
// Option A: MongoDB Atlas (Cloud) - Recommended for NaijaCart
// - Managed replica set + sharding, auto-backup, monitoring
// - Region: Choose closest to Nigeria - eu-west-1 (Ireland) or af-south-1 (South Africa)
// - Atlas handles failover automatically
//
// Option B: Postgres on Cloud (for Portfolio 1 data)
// - AWS RDS Postgres / Supabase / Neon
// - Enable Multi-AZ for high availability (same as replica set)
// - Daily automated backups + Point-in-Time Recovery
//
// Option C: Hybrid (Best Answer)
// - Postgres on RDS for orders/payments (needs ACID)
// - MongoDB Atlas for catalog/behaviour (needs flexibility + scale)
// - This is what Portfolio 4 already explained, Portfolio 5 scales it.

// ============================================================
// PART 5: FAILURE SCENARIOS
// ============================================================
// Scenario 1: Lagos primary dies
// -> Abuja secondary auto-promoted. Downtime <10s. No data loss if writeConcern=majority.
//
// Scenario 2: Network partition between Lagos and Abuja
// -> Lagos (majority side) continues writes. Abuja (minority) becomes read-only.
// -> When network returns, Abuja syncs back. This is Partition Tolerance.
//
// Scenario 3: Black Friday - 10x traffic
// -> Add more shards (sh.addShard). Add read replicas for catalog.
// -> No downtime, just add nodes.

// Conclusion:
// NaijaCart is distributed because one server = single point of failure.
// Replication = availability. Sharding = scalability. CAP choice = consistency for money, availability for catalog.
