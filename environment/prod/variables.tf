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

variable "stgaccount" {
  description = "A map of storage accounts to create. The key of the map will be used as the storage account identifier."
  type = map(object({

    # Required Arguments
    name                     = string
    location                 = string
    rg_key                   = string
    account_tier             = string
    account_replication_type = string

    # Optional Arguments
    account_kind                      = optional(string)
    provisioned_billing_model_version = optional(string)
    tags                              = optional(map(string))
    cross_tenant_replication_enabled  = optional(bool)
    access_tier                       = optional(string)
    edge_zone                         = optional(string)
    https_traffic_only_enabled        = optional(bool)
    min_tls_version                   = optional(string)
    allow_nested_items_to_be_public   = optional(bool)
    shared_access_key_enabled         = optional(bool)
    public_network_access_enabled     = optional(bool)
    default_to_oauth_authentication   = optional(bool)
    is_hns_enabled                    = optional(bool)
    nfsv3_enabled                     = optional(bool)
    large_file_share_enabled          = optional(bool)
    local_user_enabled                = optional(bool)
    queue_encryption_key_type         = optional(string)
    table_encryption_key_type         = optional(string)
    infrastructure_encryption_enabled = optional(bool)
    allowed_copy_scope                = optional(string)
    sftp_enabled                      = optional(bool)
    dns_endpoint_type                 = optional(string)


    # Block Arguments (Optional Arguments)
    custom_domain = optional(object({
      name          = string
      use_subdomain = optional(bool)
    }))

    customer_managed_key = optional(object({
      user_assigned_identity_id = string
      key_vault_key_id          = optional(string)
      managed_hsm_key_id        = optional(string)
    }))

    identity = optional(object({
      type         = string
      identity_ids = list(string)
    }))

    blob_properties = optional(object({
      cors_rule = optional(list(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })), [])
      delete_retention_policy = optional(object({
        days = number
      }), { days = 7 })
      restore_policy = optional(object({
        days = number
      }), { days = 7 })
      versioning_enabled            = optional(bool)
      change_feed_enabled           = optional(bool)
      change_feed_retention_in_days = optional(number)
      default_service_version       = optional(string)
      last_access_time_enabled      = optional(bool)
      container_delete_retention_policy = optional(object({
        days = optional(number)
      }))
    }))

    queue_properties = optional(object({
      cors_rule = optional(list(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })), [])
      logging = optional(object({
        delete                = bool
        read                  = bool
        write                 = bool
        version               = string
        retention_policy_days = optional(number)
      }))
      hour_metrics = optional(object({
        enabled               = bool
        version               = string
        include_apis          = optional(bool)
        retention_policy_days = optional(number)
      }))
      minute_metrics = optional(object({
        enabled               = bool
        version               = string
        include_apis          = optional(bool)
        retention_policy_days = optional(number)
      }))
    }))

    static_website = optional(object({
      index_document     = optional(string)
      error_404_document = optional(string)
    }))

    share_properties = optional(object({
      cors_rule = optional(list(object({
        allowed_headers    = list(string)
        allowed_methods    = list(string)
        allowed_origins    = list(string)
        exposed_headers    = list(string)
        max_age_in_seconds = number
      })), [])
      retention_policy = optional(object({
        days = number
      }))
      smb = optional(object({
        versions                        = list(string)
        authentication_types            = list(string)
        kerberos_ticket_encryption_type = string
        channel_encryption_type         = string
        multichannel_enabled            = bool
      }))
    }))

    network_rules = optional(object({
      default_action             = string
      bypass                     = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
      ip_rules                   = optional(list(string), [])
      private_link_access = optional(object({
        endpoint_resource_id = string
        endpoint_tenant_id   = optional(string)
      }))
    }))

    azure_files_authentication = optional(object({
      directory_type                 = optional(string)
      default_share_level_permission = optional(string)
      active_directory = object({
        domain_name         = optional(string)
        netbios_domain_name = optional(string)
        forest_name         = optional(string)
        domain_guid         = optional(string)
        domain_sid          = optional(string)
        storage_sid         = optional(string)
      })
      })
    )

    routing = optional(object({
      choice                      = string
      publish_microsoft_endpoints = bool
      publish_internet_endpoints  = bool
    }))

    immutability_policy = optional(object({
      state                         = string
      allow_protected_append_writes = bool
      period_since_creation_in_days = number
    }))

    sas_policy = optional(object({
      expiration_period = string
      expiration_action = string

    }))

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

# variable "nics" {
#   description = "Map of Network Interfaces with configuration details."
#   type = map(object({
#     name                = string
#     location            = string
#     resource_group_name = string
#     rg_key              = string
#     # Optional arguments
#     auxiliary_mode                 = optional(string)
#     auxiliary_sku                  = optional(string)
#     dns_servers                    = optional(list(string))
#     edge_zone                      = optional(string)
#     ip_forwarding_enabled          = optional(bool)
#     accelerated_networking_enabled = optional(bool)
#     internal_dns_name_label        = optional(string)
#     tags                           = optional(map(string))

#     # IP configuration block (required)
#     ip_configuration = list(object({
#       name                                               = string
#       private_ip_address_allocation                      = string
#       gateway_load_balancer_frontend_ip_configuration_id = optional(string)
#       subnet_id                                          = optional(string)
#       private_ip_address_version                         = optional(string)
#       public_ip_address_id                               = optional(string)
#       primary                                            = optional(bool)
#       private_ip_address                                 = optional(string)
#       # it will define which subnet and pip to use from tfvars
#       #subnet_key = optional(string)
#       subnet_key = optional(string)
#       pip_key    = optional(string)
#       vnet_key   = optional(string)
#     }))
#   }))
# }

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

variable "sql_servers" {
  description = "Configuration for multiple Azure SQL Servers"
  type = map(object({
    sqlserver_name    = string
    rg_key            = string
    location          = string
    version           = string
    kv_name           = string
    sql_user_secret   = string
    sql_pass_secret   = string
    connection_policy = optional(string, "Default")
    # Optional identity block
    identity = optional(object({
      type = string
    }))

    tags = optional(map(string))
  }))
}

variable "sql_databases" {
  description = "Configuration for multiple Azure SQL Databases"
  type = map(object({
    # Required
    name = string
    # Optional
    auto_pause_delay_in_minutes                                = optional(number)
    create_mode                                                = optional(string, "Default")
    creation_source_database_id                                = optional(string)
    collation                                                  = optional(string)
    elastic_pool_id                                            = optional(string)
    enclave_type                                               = optional(string)
    geo_backup_enabled                                         = optional(bool, true)
    maintenance_configuration_name                             = optional(string, "SQL_Default")
    ledger_enabled                                             = optional(bool, false)
    license_type                                               = optional(string)
    max_size_gb                                                = optional(number)
    min_capacity                                               = optional(number)
    restore_point_in_time                                      = optional(string)
    recover_database_id                                        = optional(string)
    recovery_point_id                                          = optional(string)
    restore_dropped_database_id                                = optional(string)
    restore_long_term_retention_backup_id                      = optional(string)
    read_replica_count                                         = optional(number)
    read_scale                                                 = optional(bool)
    sample_name                                                = optional(string)
    sku_name                                                   = optional(string)
    storage_account_type                                       = optional(string, "Geo")
    transparent_data_encryption_enabled                        = optional(bool, true)
    transparent_data_encryption_key_vault_key_id               = optional(string)
    transparent_data_encryption_key_automatic_rotation_enabled = optional(bool, false)
    zone_redundant                                             = optional(bool)
    secondary_type                                             = optional(string, "Geo")
    tags                                                       = optional(map(string))

    # Optional Nested Blocks
    import = optional(object({
      storage_uri                  = string
      storage_key                  = string
      storage_key_type             = string
      administrator_login          = string
      administrator_login_password = string
      authentication_type          = string
      storage_account_id           = optional(string)
    }))

    threat_detection_policy = optional(object({
      state                      = optional(string, "Disabled")
      disabled_alerts            = optional(list(string))
      email_account_admins       = optional(string, "Disabled")
      email_addresses            = optional(list(string))
      retention_days             = optional(number)
      storage_account_access_key = optional(string)
      storage_endpoint           = optional(string)
    }))

    long_term_retention_policy = optional(object({
      weekly_retention  = optional(string, "PT0S")
      monthly_retention = optional(string, "PT0S")
      yearly_retention  = optional(string, "PT0S")
      week_of_year      = optional(number)
    }))

    short_term_retention_policy = optional(object({
      retention_days           = number
      backup_interval_in_hours = optional(number, 12)
    }))

    identity = optional(object({
      type         = string
      identity_ids = list(string)
    }))
  }))
}

variable "service_plans" {
  type = map(object({
    # Required
    sp_name             = string
    location            = string
    os_type             = string
    sku_name            = string
    rg_key              = string

    # Optional
    app_service_environment_id      = optional(string)
    premium_plan_auto_scale_enabled = optional(bool)
    maximum_elastic_worker_count    = optional(number)
    worker_count                    = optional(number)
    per_site_scaling_enabled        = optional(bool)
    zone_balancing_enabled          = optional(bool)
    tags                            = optional(map(string))
  }))
}


variable "app_services" {
  description = "Map of App Service configurations"
  type = map(object({
    appservice_name = string
    location        = string
    rg_key          = string
    sp_name        = string
    site_config = optional(object({
      always_on                = optional(bool)
      app_command_line         = optional(string)
      auto_swap_slot_name      = optional(string)
      default_documents        = optional(list(string))
      dotnet_framework_version = optional(string)
      ftps_state               = optional(string)
      health_check_path        = optional(string)
      http2_enabled            = optional(bool)
      ip_restriction = optional(list(object({
        ip_address                = optional(string)
        service_tag               = optional(string)
        virtual_network_subnet_id = optional(string)
        name                      = optional(string)
        priority                  = optional(number)
        action                    = optional(string)
      })))
      scm_use_main_ip_restriction = optional(bool)
      scm_type                    = optional(string)
      java_version                = optional(string)
      java_container              = optional(string)
      java_container_version      = optional(string)
      linux_fx_version            = optional(string)
      managed_pipeline_mode       = optional(string)
      min_tls_version             = optional(string)
      number_of_workers           = optional(number)
      php_version                 = optional(string)
      python_version              = optional(string)
      remote_debugging_enabled    = optional(bool)
      remote_debugging_version    = optional(string)
      use_32_bit_worker_process   = optional(bool)
      vnet_route_all_enabled      = optional(bool)
      websockets_enabled          = optional(bool)
    }))

    app_settings = map(string)

    connection_string = optional(object({
      name  = string
      type  = string
      value = string
    }))
  }))
}



variable "log_analytics_workspaces" {
  type = map(object({
    location          = string
    sku               = string
    rg_key            = string
    retention_in_days = number
    law_name          = string
  }))
}

variable "container_apps" {
  type = map(object({
    container_app_name = string
    rg_key             = string
    revision_mode      = string
    conappenv_name     = string
    container = object({
      name   = string
      image  = string
      cpu    = number
      memory = string
    })
  }))
}

variable "container_app_environments" {
  type = map(object({
    location       = string
    rg_key         = string
    conappenv_name = string
    law_name       = string
  }))
}
