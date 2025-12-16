data "azurerm_client_config" "current" {}


data "azurerm_key_vault" "kv1" {
  for_each = var.key_vault_secrets

  name                = each.value.kv_name
  resource_group_name = var.rg_names[each.value.rg_key]
}