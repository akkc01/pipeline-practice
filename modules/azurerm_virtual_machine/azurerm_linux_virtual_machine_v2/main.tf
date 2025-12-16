resource "azurerm_linux_virtual_machine" "lvm" {
  for_each = var.lvm

  name                            = each.value.vm_name
  resource_group_name             = var.rg_names[each.value.rg_key]
  location                        = each.value.location
  size                            = each.value.size
  network_interface_ids           = [data.azurerm_network_interface.nic[each.key].id] # Optional fields
  admin_username                  = data.azurerm_key_vault_secret.vm_username[each.key].value
  admin_password                  = data.azurerm_key_vault_secret.vm_password[each.key].value
  disable_password_authentication = try(each.value.disable_password_authentication, false)
  tags                            = try(each.value.tags, {})
  zone                            = try(each.value.zone, null)
  encryption_at_host_enabled      = try(each.value.encryption_at_host_enabled, false)
  priority                        = try(each.value.priority, "Regular")
  eviction_policy                 = try(each.value.eviction_policy, null)
  provision_vm_agent              = try(each.value.provision_vm_agent, true)
  allow_extension_operations      = try(each.value.allow_extension_operations, true)
  source_image_id                 = try(each.value.source_image_id, null)
  computer_name                   = try(each.value.computer_name, null)
  custom_data                     = try(each.value.custom_data, null)
  license_type                    = try(each.value.license_type, null)
  availability_set_id             = try(each.value.availability_set_id, null)
  capacity_reservation_group_id   = try(each.value.capacity_reservation_group_id, null)
  dedicated_host_id               = try(each.value.dedicated_host_id, null)
  dedicated_host_group_id         = try(each.value.dedicated_host_group_id, null)
  disk_controller_type            = try(each.value.disk_controller_type, null)
  edge_zone                       = try(each.value.edge_zone, null)
  max_bid_price                   = try(each.value.max_bid_price, null)
  platform_fault_domain           = try(each.value.platform_fault_domain, null)
  secure_boot_enabled             = try(each.value.secure_boot_enabled, null)
  vtpm_enabled                    = try(each.value.vtpm_enabled, null)
  virtual_machine_scale_set_id    = try(each.value.virtual_machine_scale_set_id, null)
  proximity_placement_group_id    = try(each.value.proximity_placement_group_id, null)
  reboot_setting                  = try(each.value.reboot_setting, null)
  patch_mode                      = try(each.value.patch_mode, "ImageDefault")
  patch_assessment_mode           = try(each.value.patch_assessment_mode, "ImageDefault")

  # Reuired Argument -os_disk block
  dynamic "os_disk" {
    for_each = each.value.os_disk != null ? [each.value.os_disk] : []

    content {
      name                 = lookup(os_disk.value, "name", null)
      caching              = lookup(os_disk.value, "caching", "ReadWrite")
      storage_account_type = lookup(os_disk.value, "storage_account_type", "Standard_LRS")
      disk_size_gb         = lookup(os_disk.value, "disk_size_gb", null)
    }
  }

  # Optinal Arguments--
  # SSH key block (optional)
  dynamic "admin_ssh_key" {
    for_each = each.value.admin_ssh_keys != null ? each.value.admin_ssh_keys : []
    content {
      username   = admin_ssh_key.value.username
      public_key = admin_ssh_key.value.public_key
    }
  }
  dynamic "source_image_reference" {
    for_each = each.value.source_image_reference != null ? [each.value.source_image_reference] : []

    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  dynamic "boot_diagnostics" {
    for_each = lookup(each.value, "boot_diagnostics", null) != null ? [each.value.boot_diagnostics] : []
    content {
      storage_account_uri = lookup(boot_diagnostics.value, "storage_account_uri", null)
    }
  }

  dynamic "identity" {
    for_each = lookup(each.value, "identity", null) != null ? [each.value.identity] : []
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  # Additional Capabilities
  dynamic "additional_capabilities" {
    for_each = try(each.value.additional_capabilities != null ? [each.value.additional_capabilities] : [])
    content {
      ultra_ssd_enabled   = try(additional_capabilities.value.ultra_ssd_enabled, null)
      hibernation_enabled = try(additional_capabilities.value.hibernation_enabled, null)
    }
  }

  # Termination Notification
  dynamic "termination_notification" {
    for_each = try(each.value.termination_notification != null ? [each.value.termination_notification] : [])
    content {
      enabled = termination_notification.value.enabled
      timeout = try(termination_notification.value.timeout, null)
    }
  }

  # OS Image Notification
  dynamic "os_image_notification" {
    for_each = try(each.value.os_image_notification != null ? [each.value.os_image_notification] : [])
    content {
      timeout = try(os_image_notification.value.timeout, null)
    }
  }

  # Gallery Application
  dynamic "gallery_application" {
    for_each = try(each.value.gallery_application, [])
    content {
      version_id                                  = gallery_application.value.version_id
      automatic_upgrade_enabled                   = try(gallery_application.value.automatic_upgrade_enabled, false)
      configuration_blob_uri                      = try(gallery_application.value.configuration_blob_uri, null)
      order                                       = try(gallery_application.value.order, 0)
      tag                                         = try(gallery_application.value.tag, null)
      treat_failure_as_deployment_failure_enabled = try(gallery_application.value.treat_failure_as_deployment_failure_enabled, false)
    }
  }

  # Secrets from Key Vault
  dynamic "secret" {
    for_each = try(each.value.secret, [])
    content {
      key_vault_id = secret.value.key_vault_id
      dynamic "certificate" {
        for_each = secret.value.certificate
        content {
          url = certificate.value.url
        }
      }
    }
  }



}







