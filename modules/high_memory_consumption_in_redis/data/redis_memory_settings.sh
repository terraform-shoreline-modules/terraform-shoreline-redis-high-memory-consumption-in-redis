

#!/bin/bash



# Define Redis eviction policy settings

MAX_MEMORY=${MAXIMUM_MEMORY_SIZE_IN_BYTES}

MAX_MEMORY_POLICY=allkeys-lru



# Update Redis configuration file with new settings

echo "maxmemory $MAX_MEMORY" >> /etc/redis/redis.conf

echo "maxmemory-policy $MAX_MEMORY_POLICY" >> /etc/redis/redis.conf



# Restart Redis service to apply changes

systemctl restart redis.service