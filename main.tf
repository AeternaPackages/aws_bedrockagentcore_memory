locals {
  bedrockagentcore_memories = { for k1, v1 in var.bedrockagentcore_memories : k1 => { description = v1.description, encryption_key_arn = v1.encryption_key_arn, event_expiry_duration = v1.event_expiry_duration, indexed_key = v1.indexed_key, memory_execution_role_arn = v1.memory_execution_role_arn, name = v1.name, region = v1.region, stream_delivery_resources = v1.stream_delivery_resources, tags = v1.tags } }

  bedrockagentcore_memory_strategies = merge([
    for k1, v1 in var.bedrockagentcore_memories : {
      for k2, v2 in coalesce(v1.bedrockagentcore_memory_strategies, {}) :
      "${k1}/${k2}" => merge(v2, {
        memory_id = module.bedrockagentcore_memories.bedrockagentcore_memories_id["${k1}"]
      })
    }
  ]...)
}

module "bedrockagentcore_memories" {
  source                    = "git::https://github.com/AeternaModules/aws_bedrockagentcore_memory.git?ref=v6.58.0"
  bedrockagentcore_memories = local.bedrockagentcore_memories
}

module "bedrockagentcore_memory_strategies" {
  source                             = "git::https://github.com/AeternaModules/aws_bedrockagentcore_memory_strategy.git?ref=v6.58.0"
  bedrockagentcore_memory_strategies = local.bedrockagentcore_memory_strategies
  depends_on                         = [module.bedrockagentcore_memories]
}

