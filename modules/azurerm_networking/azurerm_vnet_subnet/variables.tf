variable "vnets" {
  description = "All the VNets"
  type = map(object({
    name                           = string
    location                       = string
    rg_key                         = string
    address_space                  = optional(list(string))
    dns_servers                    = optional(list(string))
    bgp_community                  = optional(number)
    private_endpoint_vnet_policies = optional(string)
    tags                           = optional(map(string))
    edge_zone                      = optional(string)
    flow_timeout_in_minutes        = optional(string)
    ddos_protection_plan = optional(object({
      id     = string
      enable = string
    }))

    ip_address_pool = optional(map(object({
      id                     = string
      number_of_ip_addresses = string
    })))

    subnet = optional(map(object({
      name                                          = string
      address_prefixes                              = list(string)
      security_group                                = optional(string)
      default_outbound_access_enabled               = optional(bool)
      private_endpoint_network_policies             = optional(string)
      private_link_service_network_policies_enabled = optional(bool)
      route_table_id                                = optional(string)
      service_endpoints                             = optional(list(string))
      service_endpoint_policy_ids                   = optional(list(string))
      delegation = optional(map(object({
        name = string
        service_delegation = map(object({
          name    = string
          actions = optional(list(string))
        }))
      })))
    })))

    encryption = optional(object({
      enforcement = string
    }))
    
  }))
}



variable "rg_names" {
  description = "Map of RG names from RG module"
  type        = map(string)
}
