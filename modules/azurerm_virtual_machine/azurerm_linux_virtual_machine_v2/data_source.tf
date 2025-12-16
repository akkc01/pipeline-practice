data "azurerm_network_interface" "nic" {
    for_each = var.lvm

  name                = each.value.nic_name
  resource_group_name = var.rg_names[each.value.rg_key] 
}

data "azurerm_key_vault" "kv" {
  for_each = var.lvm
  name                = each.value.kv_name
  resource_group_name = var.rg_names[each.value.rg_key]
}

# fetch vm useranme
data "azurerm_key_vault_secret" "vm_username" {
  for_each = var.lvm

  name         = each.value.username_secret
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}

# Fetch vm password 
data "azurerm_key_vault_secret" "vm_password" {
  for_each = var.lvm

  name         = each.value.password_secret
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}

