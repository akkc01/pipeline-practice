resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name                                          = each.value.subnet_name
  resource_group_name                           = var.rg_names[each.value.rg_key]
  virtual_network_name                          = each.value.virtual_network_name
  default_outbound_access_enabled               = lookup(each.value, "default_outbound_access_enabled", true)
  private_endpoint_network_policies             = lookup(each.value, "private_endpoint_network_policies", "Disabled")
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", true)
  sharing_scope                                 = lookup(each.value, "sharing_scope", null)
  service_endpoints                             = lookup(each.value, "service_endpoints", null)
  service_endpoint_policy_ids                   = lookup(each.value, "service_endpoint_policy_ids", null)

  # Exactly one of these should be used
  address_prefixes = lookup(each.value, "address_prefixes", null)

  dynamic "ip_address_pool" {
    for_each = each.value.ip_address_pool != null ? [each.value.ip_address_pool] : []
    content {
      id                     = ip_address_pool.value.id
      number_of_ip_addresses = ip_address_pool.value.number_of_ip_addresses
    }
  }

  dynamic "delegation" {
    for_each = each.value.delegation != null ? each.value.delegation : []
    content {
      name = delegation.value.name

      dynamic "service_delegation" {
        for_each = [delegation.value.service_delegation]
        content {
          name    = service_delegation.value.name
          actions = lookup(service_delegation.value, "actions", null)
        }
      }
    }
  }
}
