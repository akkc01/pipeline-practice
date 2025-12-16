resource "azurerm_windows_virtual_machine" "wvm" {
  for_each              = var.wvm
  name                  = each.value.vm_name
  location              = each.value.location
  resource_group_name   = var.rg_name[each.value.rg_key]
  size                  = each.value.size
  admin_username        = data.azurerm_key_vault_secret.vm_username[each.key].value
  admin_password        = data.azurerm_key_vault_secret.vm_password[each.key].value
  network_interface_ids = [data.azurerm_network_interface.nic[each.key].id]

  dynamic "os_disk" {
    for_each = each.value.os_disk != null ? [each.value.os_disk] : []

    content {
      name                 = lookup(os_disk.value, "name", null)
      caching              = lookup(os_disk.value, "caching", "ReadWrite")
      storage_account_type = lookup(os_disk.value, "storage_account_type", "Standard_LRS")
      disk_size_gb         = lookup(os_disk.value, "disk_size_gb", null)
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
}
