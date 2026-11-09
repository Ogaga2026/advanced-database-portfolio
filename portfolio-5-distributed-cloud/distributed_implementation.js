# Portfolio 5 - Distributed & Cloud - NaijaCart
MIT 8103 - Erhiyoma Oghenevwogaga - Ogaga2026

## IMPORTANT - Read This First

This section is a PROPOSED architecture, NOT tested with 3-node replica set in this repo.

Docker Compose in this repo runs 1 MongoDB instance (mongo:6) for development. It does NOT run 3 replica members.

Full 3-node replica + sharding infrastructure is NOT configured in docker-compose.yml in this repo. This is design proposal for production.

## Proposed Replica Set

Name: `naijacartRS`

- Lagos - Primary - handles writes
- Abuja - Secondary - handles reads, takes over if Lagos down
- Port Harcourt - Hidden Backup - for backup only, no reads

If Lagos down, Abuja becomes Primary automatically. No data loss because writeConcern is majority.

## Proposed Sharding

Shard key for products:

```javascript
sh.shardCollection("naijacart.products", { category: 1, warehouse_id: 1 })
