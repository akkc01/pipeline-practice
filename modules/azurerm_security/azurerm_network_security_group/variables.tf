variable "nsg" {
  description = "Map of NSGs with their location and rules"
  type = map(object({
    nsg_name            = string
    location            = string
    rg_key              = string
    tags                = optional(map(string), {})
    security_rule = list(object({
      name      = string
      priority  = number
      direction = string
      access    = string
      protocol  = string
      # Optional fields inside security_rule
      source_port_range                          = optional(string)
      destination_port_range                     = optional(string)
      destination_port_ranges                    = optional(list(string))
      source_port_ranges                         = optional(list(string))
      source_address_prefix                      = optional(string)
      source_address_prefixes                    = optional(list(string))
      destination_address_prefix                 = optional(string)
      description                                = optional(string)
      source_application_security_group_ids      = optional(list(string))
      destination_application_security_group_ids = optional(list(string))
    }))
  }))
}


variable "rg_names" {
  description = "Map of RG names from RG module"
  type        = map(string)
}
