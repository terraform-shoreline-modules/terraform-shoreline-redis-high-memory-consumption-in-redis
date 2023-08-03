
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High memory consumption in Redis
---

This incident type relates to Redis, a popular in-memory data structure store that is widely used in software development. The incident occurs when there is high memory consumption in Redis, which can lead to performance issues and potentially cause the system to crash. This incident type is critical as it can impact the functionality of the system and requires immediate attention to resolve.

### Parameters
```shell
# Environment Variables

export MAXIMUM_MEMORY_IN_GB="PLACEHOLDER"

export PATH_TO_REDIS_CONFIG_FILE="PLACEHOLDER"

export MAXIMUM_MEMORY_SIZE_IN_BYTES="PLACEHOLDER"
```

## Debug

### Check if Redis is running
```shell
systemctl status redis
```

### Check Redis version
```shell
redis-cli --version
```

### Check Redis configuration file
```shell
cat /etc/redis/redis.conf
```

### Check Redis memory usage
```shell
redis-cli info memory | grep used_memory_human
```

### Check Redis memory limit
```shell
redis-cli info memory | grep maxmemory_human
```

### Check Redis memory usage by database
```shell
redis-cli info memory | grep db
```

### Check Redis keyspace statistics
```shell
redis-cli info keyspace
```

### Check Redis slow log
```shell
redis-cli slowlog get
```

### Check system memory usage
```shell
free -m
```

### Check system swap usage
```shell
swapon -s
```

### Check system disk usage
```shell
df -h
```

### Check system logs for any related errors
```shell
journalctl -u redis
```

## Repair

### Increase the memory available to Redis by modifying the Redis configuration file.
```shell


#!/bin/bash



# Set the path to the Redis configuration file

REDIS_CONFIG_FILE=${PATH_TO_REDIS_CONFIG_FILE}



# Set the maximum memory available for Redis (in gigabytes)

REDIS_MAX_MEMORY=${MAXIMUM_MEMORY_IN_GB}



# Update the maxmemory setting in the Redis configuration file

sed -i "s/\(maxmemory\s*\)[0-9]*[mMgG]\?/\1${REDIS_MAX_MEMORY}g/" $REDIS_CONFIG_FILE



# Restart the Redis service

systemctl restart redis.service


```

### Use Redis' built-in eviction policies to automatically remove least recently used keys when memory consumption gets too high.
```shell


#!/bin/bash



# Define Redis eviction policy settings

MAX_MEMORY=${MAXIMUM_MEMORY_SIZE_IN_BYTES}

MAX_MEMORY_POLICY=allkeys-lru



# Update Redis configuration file with new settings

echo "maxmemory $MAX_MEMORY" >> /etc/redis/redis.conf

echo "maxmemory-policy $MAX_MEMORY_POLICY" >> /etc/redis/redis.conf



# Restart Redis service to apply changes

systemctl restart redis.service


```