variable "nics_with_data" {
  description = "Map of Network Interfaces with configuration details."
  type = map(object({
    nic_name            = string
    location            = string
    rg_key              = string  # rg name fetch karne ke liye  module se
    pip_name            = string  # data block me public ip ke liye
    subnet_name         = string  # data block me subnet name ke liye
    vnet_name           = string  # data block me vnet name ke liye
    # Optional arguments
    auxiliary_mode                 = optional(string)
    auxiliary_sku                  = optional(string)
    dns_servers                    = optional(list(string))
    edge_zone                      = optional(string)
    ip_forwarding_enabled          = optional(bool)
    accelerated_networking_enabled = optional(bool)
    internal_dns_name_label        = optional(string)
    tags                           = optional(map(string))
    # IP configuration block (required)
    ip_configuration = list(object({
      name                                               = string
      private_ip_address_allocation                      = string
      gateway_load_balancer_frontend_ip_configuration_id = optional(string)
      subnet_id                                          = optional(string)
      private_ip_address_version                         = optional(string)
      public_ip_address_id                               = optional(string)
      primary                                            = optional(bool)
      private_ip_address                                 = optional(string)
      # it will define which subnet and pip to use from tfvars
      subnet_key = optional(string)
      pip_key    = optional(string)
      vnet_key   = optional(string)
    }))
  }))
}


variable "rg_name" {
  description = "Map of RG names from RG module"
  type        = map(string)
}
