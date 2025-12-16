data "azurerm_key_vault" "kv" {
  for_each = var.wvm

  name                = each.value.kv_name
  resource_group_name = each.value.kv_rg
}

# fetch vm useranme
data "azurerm_key_vault_secret" "vm_username" {
  for_each = var.wvm

  name         = each.value.username_secret
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}

# Fetch vm password 
data "azurerm_key_vault_secret" "vm_password" {
  for_each = var.wvm

  name         = each.value.password_secret
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}

data "azurerm_network_interface" "nic" {
  for_each = var.wvm

  name                = each.value.nic_name
  resource_group_name = var.rg_name[each.value.rg_key]
}
