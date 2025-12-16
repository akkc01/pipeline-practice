resource "azurerm_network_security_group" "nsg" {
  for_each = var.nsg

  name                = each.value.nsg_name
  location            = each.value.location
  resource_group_name = var.rg_names[each.value.rg_key]
  # Optional fields
  tags = each.value.tags

  dynamic "security_rule" {
    for_each = each.value.security_rule != null ? each.value.security_rule : []
    content {
      name      = security_rule.value.name
      priority  = security_rule.value.priority
      direction = security_rule.value.direction
      access    = security_rule.value.access
      protocol  = security_rule.value.protocol
      # Optional fields inside security_rule
      source_port_range                          = try(security_rule.value.source_port_range, null)
      destination_port_range                     = try(security_rule.value.destination_port_range, null)
      source_port_ranges                         = try(security_rule.value.source_port_ranges, null)
      destination_port_ranges                    = try(security_rule.value.destination_port_ranges, null)
      source_address_prefix                      = try(security_rule.value.source_address_prefix, null)
            source_address_prefixes                      = try(security_rule.value.source_address_prefixes, null)
      destination_address_prefix                 = try(security_rule.value.destination_address_prefix, null)
      description                                = try(security_rule.value.description, null)
      source_application_security_group_ids      = try(security_rule.value.source_application_security_group_ids, null)
      destination_application_security_group_ids = try(security_rule.value.destination_application_security_group_ids, null)

    }
  }


}
