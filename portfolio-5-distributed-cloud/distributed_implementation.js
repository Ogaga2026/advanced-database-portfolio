// NaijaCart - Portfolio 5 - Distributed / Cloud - PROPOSED
// Erhiyoma Oghenevwogaga - Ogaga2026
// Status: PROPOSED, NOT tested. This is a design proposal only.
// Goal: Show how NaijaCart COULD scale with a replica set.

const config = {
  replicaSetName: "naijacartRS",
  members: [
    { host: "mongo-primary:27017", priority: 2 },
    { host: "mongo-secondary-1:27017", priority: 1 },
    { host: "mongo-secondary-2:27017", priority: 1 }
  ],
  // These values MUST be in the connection string to take effect.
  // Keeping them only in this object does nothing.
  writeConcern: { w: "majority", j: true },
  readPreference: "primaryPreferred",
  retryWrites: true
};

// PROPOSED failover behaviour
// If primary fails, secondaries hold an election.
// One secondary becomes new primary.
// This AIMS TO REDUCE data loss, it does NOT guarantee 100% no-data-loss.
// With w: majority, acknowledged writes are more likely to survive,
// but unacknowledged writes could still be lost during failover.

function getConnectionString(cfg) {
  const hosts = cfg.members.map(function(m) { return m.host; }).join(",");
  // Include writeConcern + readPreference here, otherwise they are ignored.
  return "mongodb://" + hosts + "/naijacart?replicaSet=" + cfg.replicaSetName
    + "&w=majority&journal=true&readPreference=" + cfg.readPreference
    + "&retryWrites=true";
}

function explainSharding() {
  // PROPOSED sharding idea - not implemented
  // Proposed shard key: { warehouse_id: 1, order_id: 1 } - COMPOUND
  // Limitation: warehouse_id alone has only 2 values (low cardinality),
  // so this key will NOT spread evenly on its own. Adding order_id helps
  // split chunks, but order_id is monotonic, so new writes can still
  // hotspot on the last chunk. Queries by warehouse_id alone may still
  // need to check more than one shard.
  // Alternative to consider: hashed shard key on order_id, e.g. { order_id: "hashed" },
  // which spreads writes evenly but cannot target by warehouse.
  return "Proposed shard key: { warehouse_id: 1, order_id: 1 } - PROPOSED, NOT tested";
}

console.log("Replica Set:", config.replicaSetName);
console.log("Connection:", getConnectionString(config));
console.log("Sharding:", explainSharding());
console.log("Status: PROPOSED - not tested in this portfolio");
