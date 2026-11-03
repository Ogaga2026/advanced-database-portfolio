// NaijaCart Distributed - MIT 8103 - Ogaga2026 - CORRECTED VERIFIED
replicaSetConfig = {
  _id: "naijacartRS",
  members: [
    {_id: 0, host: "lagos-primary:27017", priority: 2},
    {_id: 1, host: "abuja-replica:27017", priority: 1},
    {_id: 2, host: "portharcourt-backup:27017", hidden: true, priority: 0}
  ]
}
rs.initiate(replicaSetConfig)
rs.status()
sh.enableSharding("naijacart_distributed")
sh.shardCollection("naijacart_distributed.products", {category: 1, warehouse_id: 1})
db.products.insertOne({name:"Test HA"}, {writeConcern: {w: "majority", wtimeout: 5000}})
db.getMongo().setReadPref("secondaryPreferred")
