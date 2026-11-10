# NaijaCart - Portfolio 5 - Distributed & Cloud
**Erhiyoma Oghenevwogaga - Ogaga2026**

## Status: PROPOSED, NOT TESTED
This section is a PROPOSED architecture, NOT tested with 3-node replica set.
Docker Compose in this repo runs 1 MongoDB instance.
This is a design proposal only. No claim that 3 nodes were run.

## Files in this folder
- `distributed_implementation.js` - proposed replica set config + connection string + sharding idea
- `README.md` - this file

## Proposed Replica Set
- Replica Set Name: `naijacartRS`
- Members: 3
    - `mongo-primary:27017` - priority 2
    - `mongo-secondary-1:27017` - priority 1
    - `mongo-secondary-2:27017` - priority 1
- Write Concern: `w: "majority", j: true`
- Read Preference: `primaryPreferred`

## Failover - What Happens If Primary Fails
1. Secondaries detect primary is down.
2. They hold an election.
3. One secondary becomes new primary.
4. App reconnects using the same connection string.

This AIMS TO REDUCE data loss, it does NOT guarantee 100% no-data-loss.
Unacknowledged writes could still be lost during failover.

## Sharding - PROPOSED, NOT IMPLEMENTED
Proposed shard key: `{ warehouse_id: 1, order_id: 1 }`
Why compound? `warehouse_id` alone has only 2 values, so it would put all data on 2 shards.
Adding `order_id` spreads orders evenly, while queries by warehouse still stay on one shard.

## Connection String (Proposed)
`mongodb://mongo-primary:27017,mongo-secondary-1:27017,mongo-secondary-2:27017/naijacart?replicaSet=naijacartRS`
