resource "azurerm_network_interface_security_group_association" "assoc" {
  for_each = var.nic_nsg_map

  network_interface_id      = var.nic_ids[each.value.nic_key]
  network_security_group_id = var.nsg_ids[each.value.nsg_key]
}
