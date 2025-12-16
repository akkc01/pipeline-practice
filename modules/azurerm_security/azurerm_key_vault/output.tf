output "key_vault_names" {
  description = "Names of all created Key Vaults"
  value = {
    for kv_key, kv in azurerm_key_vault.kv :
    kv_key => kv.name
  }
}


# for one key_vault id--

# output "key_vault_kv1_id" {
#   description = "ID of specific Key Vault kv1"
#   value       = azurerm_key_vault.kv["kv1"].id
# }
