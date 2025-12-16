# output "vault_uris" {
#   description = "Vault URIs of all fetched Key Vaults"
#   value = {
#     for kv_key, kv_data in data.azurerm_key_vault.kv2 :
#     kv_key => kv_data.vault_uri
#   }
# }