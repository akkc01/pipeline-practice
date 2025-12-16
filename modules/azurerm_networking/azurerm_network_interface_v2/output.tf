output "nic_ids" {
  description = "IDs of all created network interfaces"
  value       = { for k, nic in azurerm_network_interface.nic : k => nic.id }
}

output "private_ip_addresses" {
  description = "Map of NICs and their private IP addresses."
  value = {
    for nic_key, nic in azurerm_network_interface.nic : nic_key => nic.ip_configuration[0].private_ip_address
  }
}

