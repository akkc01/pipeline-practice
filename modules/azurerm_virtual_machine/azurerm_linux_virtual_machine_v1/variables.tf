variable "virtual_machines" {
  description = "Map of Linux Virtual Machines to create."
  type = map(object({
    name                            = string
    location                        = string
    rg_key                          = string
    nic_key                         = string
    size                            = string
    admin_username                  = string
    admin_password                  = optional(string)
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


variable "rg_names" {
  description = "Map of RG names from RG module"
  type        = map(string)
}


