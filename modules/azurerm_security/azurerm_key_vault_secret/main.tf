
resource "azurerm_key_vault_secret" "secrets" {
  for_each = var.key_vault_secrets

  name         = each.value. kv_secret
  value        = each.value. kv_value
  key_vault_id = data.azurerm_key_vault.kv1[each.key].id
}
