# Portfolio 5 - Distributed & Cloud - NaijaCart - Erhiyoma Oghenevogaga

## 1. Why Distributed?
One server = single point of failure.
If Lagos server dies on Black Friday, NaijaCart must NOT go down.
Solution: Replication for availability + Sharding for scalability + Cloud for management.

## 2. Replication - High Availability
Replica Set: `naijacartRS`
- **Primary:** `lagos-primary:27017` (priority: 2) - handles all writes
- **Secondary:** `abuja-replica:27017` (priority: 1) - copies data, can become Primary
- **Hidden Backup:** `portharcourt-backup:27017` (priority: 0, hidden) - backup only, never becomes Primary

```js
rs.initiate(config);
rs.status();
