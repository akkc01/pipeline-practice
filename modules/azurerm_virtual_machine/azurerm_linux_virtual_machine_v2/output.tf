output "vm_names" {
  description = "Map of VM keys to their names."
  value = {
    for k, v in azurerm_linux_virtual_machine.lvm : k => v.name
  }
}
