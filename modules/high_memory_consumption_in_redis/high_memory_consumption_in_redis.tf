resource "shoreline_notebook" "high_memory_consumption_in_redis" {
  name       = "high_memory_consumption_in_redis"
  data       = file("${path.module}/data/high_memory_consumption_in_redis.json")
  depends_on = [shoreline_action.invoke_redis_config_memory_restart,shoreline_action.invoke_redis_memory_settings]
}

resource "shoreline_file" "redis_config_memory_restart" {
  name             = "redis_config_memory_restart"
  input_file       = "${path.module}/data/redis_config_memory_restart.sh"
  md5              = filemd5("${path.module}/data/redis_config_memory_restart.sh")
  description      = "Increase the memory available to Redis by modifying the Redis configuration file."
  destination_path = "/agent/scripts/redis_config_memory_restart.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "redis_memory_settings" {
  name             = "redis_memory_settings"
  input_file       = "${path.module}/data/redis_memory_settings.sh"
  md5              = filemd5("${path.module}/data/redis_memory_settings.sh")
  description      = "Use Redis' built-in eviction policies to automatically remove least recently used keys when memory consumption gets too high."
  destination_path = "/agent/scripts/redis_memory_settings.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_redis_config_memory_restart" {
  name        = "invoke_redis_config_memory_restart"
  description = "Increase the memory available to Redis by modifying the Redis configuration file."
  command     = "`chmod +x /agent/scripts/redis_config_memory_restart.sh && /agent/scripts/redis_config_memory_restart.sh`"
  params      = ["MAXIMUM_MEMORY_IN_GB","PATH_TO_REDIS_CONFIG_FILE"]
  file_deps   = ["redis_config_memory_restart"]
  enabled     = true
  depends_on  = [shoreline_file.redis_config_memory_restart]
}

resource "shoreline_action" "invoke_redis_memory_settings" {
  name        = "invoke_redis_memory_settings"
  description = "Use Redis' built-in eviction policies to automatically remove least recently used keys when memory consumption gets too high."
  command     = "`chmod +x /agent/scripts/redis_memory_settings.sh && /agent/scripts/redis_memory_settings.sh`"
  params      = ["MAXIMUM_MEMORY_SIZE_IN_BYTES"]
  file_deps   = ["redis_memory_settings"]
  enabled     = true
  depends_on  = [shoreline_file.redis_memory_settings]
}

