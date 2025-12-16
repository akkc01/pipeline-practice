resource "azurerm_key_vault" "kv" {
  for_each = var.key_vaults

  name                            = each.value.name
  location                        = each.value.location
  resource_group_name             = var.rg_names[each.value.rg_key]
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = each.value.sku_name
  soft_delete_retention_days      = each.value.soft_delete_retention_days
  purge_protection_enabled        = each.value.purge_protection_enabled
  enabled_for_deployment          = lookup(each.value, "enabled_for_deployment", false)
  enabled_for_disk_encryption     = lookup(each.value, "enabled_for_disk_encryption", false)
  enabled_for_template_deployment = lookup(each.value, "enabled_for_template_deployment", false)
  rbac_authorization_enabled      = lookup(each.value, "rbac_authorization_enabled", false)
  public_network_access_enabled   = lookup(each.value, "public_network_access_enabled", true)
  tags                            = lookup(each.value, "tags", {})

  dynamic "network_acls" {
    for_each = each.value.network_acls != null ? [each.value.network_acls] : []
    content {
      bypass                     = lookup(network_acls.value, "bypass", "AzureServices")
      default_action             = lookup(network_acls.value, "default_action", "Deny")
      ip_rules                   = lookup(network_acls.value, "ip_rules", [])
      virtual_network_subnet_ids = lookup(network_acls.value, "virtual_network_subnet_ids", [])
    }
  }

  dynamic "access_policy" {
    for_each = lookup(each.value, "access_policies", [])
    content {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = data.azurerm_client_config.current.object_id
      application_id          = lookup(access_policy.value, "application_id", null)
      key_permissions         = lookup(access_policy.value, "key_permissions", [])
      secret_permissions      = lookup(access_policy.value, "secret_permissions", [])
      certificate_permissions = lookup(access_policy.value, "certificate_permissions", [])
      storage_permissions     = lookup(access_policy.value, "storage_permissions", [])
    }
  }
}





