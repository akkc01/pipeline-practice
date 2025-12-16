data "azurerm_public_ip" "pip" {
  for_each            = var.nics_with_data
  name                = each.value.pip_name
  resource_group_name = var.rg_name[each.value.rg_key]
}


data "azurerm_subnet" "subnet" {
  for_each = var.nics_with_data

  name                 = each.value.subnet_name
  resource_group_name  = var.rg_name[each.value.rg_key]
  virtual_network_name = each.value.vnet_name
}
