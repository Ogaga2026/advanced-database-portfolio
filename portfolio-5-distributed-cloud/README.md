## 3. Implementation Details
- `rs.initiate()` - Setup replication
- `sh.enableSharding()` and `sh.shardCollection()` - Sharding for 5M+ products
- `writeConcern: {w: "majority"}` - Ensures data written to majority
- `readPref: secondaryPreferred` - Scale reads to Abuja replica
- `insertMany` with majority write

## 4. Cloud Benefits for NaijaCart
- High Availability: Lagos down -> Abuja takes over
- Scalability: Sharding handles Black Friday 10k users
- Fault Tolerance: Hidden backup in Port Harcourt
- Low Latency: Read from nearest secondary

## 5. Deployment
docker-compose up -d -- Includes MongoDB replica set

Name: Erhiyome Oghenevogaga Matric: Ogaga2026
