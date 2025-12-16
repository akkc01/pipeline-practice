variable "subscription_id" {}

variable "resource_groups" {
  description = "A map of resource groups to create. The key of the map will be used as the resource group identifier."
  type = map(object({
    name       = string
    location   = string
    managed_by = optional(string)
    tags       = optional(map(string), {})
  }))
}

variable "vnets" {
  description = "All the VNets"
  type = map(object({
    name          = string
    location      = string
    rg_key        = string
    address_space = optional(list(string))
    dns_servers   = optional(list(string))
    bgp_community = optional(number)

    ddos_protection_plan = optional(object({
      id     = string
      enable = string
    }))

    edge_zone               = optional(string)
    flow_timeout_in_minutes = optional(string)

    ip_address_pool = optional(map(object({
      id                     = string
      number_of_ip_addresses = string
    })))

    subnet = optional(map(object({
      name                            = string
      address_prefixes                = list(string)
      security_group                  = optional(string)
      default_outbound_access_enabled = optional(bool)
      delegation = optional(map(object({
        name = string
        service_delegation = map(object({
          name    = string
          actions = optional(list(string))
        }))
      })))

      private_endpoint_network_policies             = optional(string)
      private_link_service_network_policies_enabled = optional(bool)
      route_table_id                                = optional(string)
      service_endpoints                             = optional(list(string))
      service_endpoint_policy_ids                   = optional(list(string))
    })))

    private_endpoint_vnet_policies = optional(string)
    tags                           = optional(map(string))

    encryption = optional(object({
      enforcement = string
    }))
  }))
}

variable "subnets" {
  description = "Map of subnet configurations to create."
  type = map(object({
    subnet_name                                   = string
    virtual_network_name                          = string
    default_outbound_access_enabled               = optional(bool, true)
    private_endpoint_network_policies             = optional(string, "Disabled")
    private_link_service_network_policies_enabled = optional(bool, true)
    sharing_scope                                 = optional(string)
    service_endpoints                             = optional(list(string))
    service_endpoint_policy_ids                   = optional(list(string))
    rg_key                                        = string

    # Either one must be set
    address_prefixes = optional(list(string))

    ip_address_pool = optional(object({
      id                     = string
      number_of_ip_addresses = string
    }))

    # Optional configurations
    delegation = optional(list(object({
      name = string
      service_delegation = object({
        name    = string
        actions = optional(list(string))
      })
    })))


  }))
}

variable "pips" {
  description = "Map of public IP configurations"
  type = map(object({
    # Required Arguments
    pip_name          = string
    location          = string
    rg_key            = string
    allocation_method = string
    # Optional Arguments
    tags                    = optional(map(string))
    zones                   = optional(list(string))
    ddos_protection_mode    = optional(string)
    ddos_protection_plan_id = optional(string)
    domain_name_label       = optional(string)
    domain_name_label_scope = optional(string)
    edge_zone               = optional(string)
    idle_timeout_in_minutes = optional(number)
    ip_tags                 = optional(map(string))
    ip_version              = optional(string)
    public_ip_prefix_id     = optional(string)
    reverse_fqdn            = optional(string)
    sku                     = optional(string)
    sku_tier                = optional(string)
  }))
  default = {}
}

variable "nics_with_data" {
  description = "Map of Network Interfaces with configuration details."
  type = map(object({
    nic_name    = string
    location    = string
    rg_key      = string # rg name fetch karne ke liye  module se
    pip_name    = string # data block me public ip ke liye
    subnet_name = string # data block me subnet name ke liye
    vnet_name   = string # data block me vnet name ke liye
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

variable "nsg" {
  description = "Map of NSGs with their location and rules"
  type = map(object({
    nsg_name = string
    location = string
    rg_key   = string
    tags     = optional(map(string), {})
    security_rule = list(object({
      name                                       = string
      priority                                   = number
      direction                                  = string
      access                                     = string
      protocol                                   = string
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

variable "nic_nsg_map" {
  description = "Mapping of NICs to NSGs"
  type = map(object({
    nic_key = string
    nsg_key = string
  }))
}

variable "key_vaults" {
  description = "Map of Key Vault configurations."
  type = map(object({
    name                            = string
    location                        = string
    sku_name                        = string
    rg_key                          = string
    soft_delete_retention_days      = optional(number, 90)
    purge_protection_enabled        = optional(bool, false)
    enabled_for_deployment          = optional(bool, false)
    enabled_for_disk_encryption     = optional(bool, false)
    enabled_for_template_deployment = optional(bool, false)
    rbac_authorization_enabled      = optional(bool, false)
    public_network_access_enabled   = optional(bool, true)
    tags                            = optional(map(string), {})

    network_acls = optional(object({
      bypass                     = string
      default_action             = string
      ip_rules                   = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
    }), null)

    access_policies = optional(list(object({
      # tenant_id               = string
      # object_id               = string
      application_id          = optional(string)
      key_permissions         = optional(list(string), [])
      secret_permissions      = optional(list(string), [])
      certificate_permissions = optional(list(string), [])
      storage_permissions     = optional(list(string), [])
    })), [])
  }))
}

variable "key_vault_secrets" {
  description = "Map of Key Vault Secret configurations."
  type = map(object({
    kv_secret = string
    kv_value  = string
    # key_vault_id        = string
    rg_key  = string
    kv_name = string

  }))
}

variable "lvm" {
  description = "Map of Linux Virtual Machines to create."
  type = map(object({
    vm_name         = string
    location        = string
    rg_key          = string
    nic_name        = string
    size            = string
    kv_name         = string
    username_secret = string
    password_secret = string
    # admin_username                  = string
    # admin_password                  = optional(string)
    disable_password_authentication = optional(bool, true)
    tags                            = optional(map(string))
    zone                            = optional(string)
    encryption_at_host_enabled      = optional(bool, false)
    priority                        = optional(string, "Regular")
    eviction_policy                 = optional(string)
    provision_vm_agent              = optional(bool, true)
    allow_extension_operations      = optional(bool, true)
    network_interface_ids           = optional(list(string), [])
    computer_name                   = optional(string)
    custom_data                     = optional(string)
    source_image_id                 = optional(string)
    admin_ssh_keys = optional(list(object({
      username   = string
      public_key = string
    })))
    license_type                  = optional(string)
    availability_set_id           = optional(string)
    capacity_reservation_group_id = optional(string)
    dedicated_host_id             = optional(string)
    dedicated_host_group_id       = optional(string)
    disk_controller_type          = optional(string)
    edge_zone                     = optional(string)
    max_bid_price                 = optional(number)
    platform_fault_domain         = optional(number)
    secure_boot_enabled           = optional(bool)
    vtpm_enabled                  = optional(bool)
    virtual_machine_scale_set_id  = optional(string)
    proximity_placement_group_id  = optional(string)
    reboot_setting                = optional(string)
    patch_mode                    = optional(string)
    patch_assessment_mode         = optional(string)


    os_disk = object({
      name                         = optional(string, null)
      caching                      = optional(string, "ReadWrite")
      os_disk_storage_account_type = optional(string, "Standard_LRS")
      disk_size_gb                 = optional(number, null)
    })

    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }))

    boot_diagnostics = optional(object({
      storage_account_uri = optional(string)
    }))

    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))

    additional_capabilities = optional(object({
      ultra_ssd_enabled   = optional(bool)
      hibernation_enabled = optional(bool)
    }))

    termination_notification = optional(object({
      enabled = bool
      timeout = optional(string)
    }))

    os_image_notification = optional(object({
      timeout = optional(string)
    }))

    gallery_application = optional(list(object({
      version_id                                  = string
      automatic_upgrade_enabled                   = optional(bool)
      configuration_blob_uri                      = optional(string)
      order                                       = optional(number)
      tag                                         = optional(string)
      treat_failure_as_deployment_failure_enabled = optional(bool)
    })), [])

    secret = optional(list(object({
      key_vault_id = string
      certificate = list(object({
        url = string
      }))
    })), [])

  }))
}

variable "wvm" {
  description = "Configuration for Windows VMs, VNets, Subnets, and NICs"
  type = map(object({
    rg_key          = string
    location        = string
    kv_rg           = string
    kv_name         = string
    username_secret = string
    password_secret = string
    vm_name         = string
    size            = string
    nic_name        = string

    os_disk = optional(object({
      name                 = optional(string)
      caching              = optional(string)
      storage_account_type = optional(string)
      disk_size_gb         = optional(number)
    }))

    source_image_reference = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    }))
  }))
}

