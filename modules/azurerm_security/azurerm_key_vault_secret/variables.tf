variable "key_vault_secrets" {
  description = "Map of Key Vault Secret configurations."
  type = map(object({
    kv_secret           = string
    kv_value            = string
    #key_vault_id        = string
    rg_key              = string
    kv_name             = string

  }))
}


variable "rg_names" {
  description = "Map of RG names from RG module"
  type        = map(string)
}
