output "nsg_ids" {
  description = "Map of NSG IDs created by this module"
  value = {
    for key, nsg in azurerm_network_security_group.nsg : key => nsg.id
  }
}
