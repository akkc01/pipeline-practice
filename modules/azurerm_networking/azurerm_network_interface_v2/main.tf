resource "azurerm_network_interface" "nic" {
  for_each = var.nics_with_data
  # Required arguments
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = var.rg_name[each.value.rg_key]
  # Optional arguments
  auxiliary_mode                 = try(each.value.auxiliary_mode, null)
  auxiliary_sku                  = try(each.value.auxiliary_sku, null)
  dns_servers                    = try(each.value.dns_servers, null)
  edge_zone                      = try(each.value.edge_zone, null)
  ip_forwarding_enabled          = try(each.value.ip_forwarding_enabled, null)
  accelerated_networking_enabled = try(each.value.accelerated_networking_enabled, null)
  internal_dns_name_label        = try(each.value.internal_dns_name_label, null)
  tags                           = try(each.value.tags, null)


  # Required block: ip_configuration
  dynamic "ip_configuration" {
    for_each = each.value.ip_configuration != null ? each.value.ip_configuration : []
    content {
      name                          = ip_configuration.value.name
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      subnet_id                     = data.azurerm_subnet.subnet[each.key].id
      # Optional fields inside ip_configuration
      gateway_load_balancer_frontend_ip_configuration_id = try(ip_configuration.value.gateway_load_balancer_frontend_ip_configuration_id, null)
      private_ip_address_version                         = try(ip_configuration.value.private_ip_address_version, null)
      public_ip_address_id                               = data.azurerm_public_ip.pip[each.key].id
      primary                                            = try(ip_configuration.value.primary, false)
      private_ip_address                                 = try(ip_configuration.value.private_ip_address, null)

    }
  }
}

