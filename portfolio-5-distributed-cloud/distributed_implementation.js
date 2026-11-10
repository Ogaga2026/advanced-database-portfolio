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
  writeConcern: { w: "majority", j: true },
  readPreference: "primaryPreferred"
};

// PROPOSED failover behaviour
// If primary fails, secondaries hold an election.
// One secondary becomes new primary.
// This AIMS TO REDUCE data loss, it does NOT guarantee 100% no-data-loss.
// With w: majority, acknowledged writes are more likely to survive,
// but unacknowledged writes could still be lost during failover.

function getConnectionString(cfg) {
  const hosts = cfg.members.map(function(m) { return m.host; }).join(",");
  return "mongodb://" + hosts + "/naijacart?replicaSet=" + cfg.replicaSetName;
}

function explainSharding() {
  // PROPOSED sharding idea - not implemented
  // Shard key idea: warehouse_id
  // Reason: Orders are grouped by warehouse, so queries by warehouse stay on one shard.
  // This is a proposal only.
  return "Proposed shard key: warehouse_id";
}

console.log("Replica Set:", config.replicaSetName);
console.log("Connection:", getConnectionString(config));
console.log(explainSharding());
console.log("Status: PROPOSED - not tested in this portfolio");
