variable "bedrockagentcore_memories" {
  description = <<EOT
Map of bedrockagentcore_memories, attributes below
Required:
    - event_expiry_duration
    - name
Optional:
    - description
    - encryption_key_arn
    - memory_execution_role_arn
    - region
    - tags
    - indexed_key (block)
    - stream_delivery_resources (block)
Nested bedrockagentcore_memory_strategies (aws_bedrockagentcore_memory_strategy):
    Required:
        - name
        - type
    Optional:
        - description
        - memory_execution_role_arn
        - namespace_templates
        - namespaces
        - region
        - configuration (block)
        - reflection_configuration (block)
EOT

  type = map(object({
    event_expiry_duration     = number
    name                      = string
    description               = optional(string)
    encryption_key_arn        = optional(string)
    memory_execution_role_arn = optional(string)
    region                    = optional(string)
    tags                      = optional(map(string))
    indexed_key = optional(list(object({
      key  = string
      type = string
    })))
    stream_delivery_resources = optional(list(object({
      resource = optional(list(object({
        kinesis = optional(list(object({
          content_configuration = optional(list(object({
            level = optional(string)
            type  = string
          })))
          data_stream_arn = string
        })))
      })))
    })))
    bedrockagentcore_memory_strategies = optional(map(object({
      name                      = string
      type                      = string
      description               = optional(string)
      memory_execution_role_arn = optional(string)
      namespace_templates       = optional(set(string))
      namespaces                = optional(set(string))
      region                    = optional(string)
      configuration = optional(list(object({
        consolidation = optional(list(object({
          append_to_prompt = string
          model_id         = string
        })))
        extraction = optional(list(object({
          append_to_prompt = string
          model_id         = string
        })))
        reflection = optional(list(object({
          append_to_prompt    = string
          model_id            = string
          namespace_templates = set(string)
        })))
        type = string
      })))
      reflection_configuration = optional(list(object({
        namespace_templates = set(string)
      })))
    })))
  }))

  validation {
    condition = alltrue(concat(
      [for kk in keys(var.bedrockagentcore_memories) : !strcontains(kk, "/")],
      flatten([for k0, v0 in var.bedrockagentcore_memories : [for kk in keys(coalesce(v0.bedrockagentcore_memory_strategies, {})) : !strcontains(kk, "/")]])
    ))
    error_message = "Map keys in this package must not contain '/': it is used internally as a nesting-key separator, so a key containing it can silently collide two different nested entries into one. Rename the offending key(s)."
  }
}
