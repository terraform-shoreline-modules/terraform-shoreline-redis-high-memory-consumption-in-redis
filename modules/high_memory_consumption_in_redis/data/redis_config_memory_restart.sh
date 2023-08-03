

#!/bin/bash



# Set the path to the Redis configuration file

REDIS_CONFIG_FILE=${PATH_TO_REDIS_CONFIG_FILE}



# Set the maximum memory available for Redis (in gigabytes)

REDIS_MAX_MEMORY=${MAXIMUM_MEMORY_IN_GB}



# Update the maxmemory setting in the Redis configuration file

sed -i "s/\(maxmemory\s*\)[0-9]*[mMgG]\?/\1${REDIS_MAX_MEMORY}g/" $REDIS_CONFIG_FILE



# Restart the Redis service

systemctl restart redis.service