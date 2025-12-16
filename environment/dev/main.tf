module "rg" {
  source          = "../../modules/azurerm_resource_group"
  resource_groups = var.resource_groups
}

module "vnet" {
  depends_on = [module.rg]
  source     = "../../modules/azurerm_networking/azurerm_vnet_subnet"
  vnets      = var.vnets
  rg_names   = module.rg.names
}

module "subnet" {
  depends_on = [module.rg, module.vnet]
  source     = "../../modules/azurerm_networking/azurerm_subnet"
  subnets    = var.subnets
  rg_names   = module.rg.names
}

module "pips" {
  depends_on = [module.rg]
  source     = "../../modules/azurerm_public_ip"
  pips       = var.pips
  rg_names   = module.rg.names
}

module "nics_with_data" {
  depends_on     = [module.rg, module.pips, module.subnet, module.vnet]
  source         = "../../modules/azurerm_networking/azurerm_network_interface_v2"
  nics_with_data = var.nics_with_data
  rg_name        = module.rg.names
}

module "nsg" {
  depends_on = [module.rg]
  source     = "../../modules/azurerm_security/azurerm_network_security_group"
  nsg        = var.nsg
  rg_names   = module.rg.names
}

module "association" {
  depends_on  = [module.rg, module.nsg, module.nics_with_data]
  source      = "../../modules/azurerm_nsg_nic_assoc"
  nic_ids     = module.nics_with_data.nic_ids
  nsg_ids     = module.nsg.nsg_ids
  nic_nsg_map = var.nic_nsg_map
}

module "kv" {
  depends_on = [module.rg]
  source     = "../../modules/azurerm_security/azurerm_key_vault"
  key_vaults = var.key_vaults
  rg_names   = module.rg.names
}

module "kvs" {
  depends_on        = [module.rg, module.kv]
  source            = "../../modules/azurerm_security/azurerm_key_vault_secret"
  key_vault_secrets = var.key_vault_secrets
  rg_names          = module.rg.names
}


module "lvm" {
  depends_on = [module.rg, module.nics_with_data, module.pips, module.nsg, module.kv, module.kvs]
  source     = "../../modules/azurerm_virtual_machine/azurerm_linux_virtual_machine_v2"
  lvm        = var.lvm
  rg_names   = module.rg.names
}

module "wvm" {
  depends_on = [module.rg, module.nics_with_data, module.pips, module.nsg, module.kv, module.kvs, module.association, module.lvm]
  source     = "../../modules/azurerm_virtual_machine/azurerm_windows_virtual_machine"
  wvm        = var.wvm
  rg_name    = module.rg.names
}

