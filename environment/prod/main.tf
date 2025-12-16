module "rg" {
  source          = "../../modules/azurerm_resource_group"
  resource_groups = var.resource_groups
}

module "storage" {
  depends_on = [module.rg]
  source     = "../../modules/azurerm_storage_account"
  stgaccount = var.stgaccount
  rg_names   = module.rg.names
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

# module "nics1" {
#   depends_on = [module.rg, module.vnet-subnet, module.pips]
#   source     = "../../modules/azurerm_networking/azurerm_network_interface"
#   nics = {
#     for nic_key, nic_val in var.nics : nic_key => merge(
#       nic_val,
#       {
#         ip_configuration = [
#           for ip_cfg in nic_val.ip_configuration : merge(
#             ip_cfg,
#             {
#               subnet_id            = module.vnet-subnet.subnet_ids[ip_cfg["vnet_key"]][ip_cfg["subnet_key"]]
#               public_ip_address_id = try(module.pips.public_ip_ids[ip_cfg["pip_key"]], null)
#             }
#           )
#         ]
#       }
#     )
#   }
#   rg_names = module.rg.names
# }

# module "nics" {
#   depends_on = [module.rg, module.vnet, module.pips]
#   source     = "../../modules/azurerm_networking/azurerm_network_interface_v1.1"
#   nics = var.nics
#   subnet_ids = module.vnet.subnet_ids
#   rg_names = module.rg.names
#   pip_ids = module.pips.public_ip_ids
# }

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

# module "lvm" {
#   depends_on = [module.rg, module.nics, module.pips, module.nsg]
#   source     = "../../modules/azurerm_virtual_machine/azurerm_linux_virtual_machine_v1"
#   virtual_machines = {
#     for vm_key, vm_val in var.virtual_machines : vm_key => merge(
#       vm_val,
#       {
#         network_interface_ids = [
#           module.nics.nic_ids[vm_val.nic_key]
#         ]
#       }
#     )
#   }
#   rg_names = module.rg.names
# }

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

module "sqlserver" {
  depends_on  = [module.rg, module.kv, module.kvs]
  source      = "../../modules/azurerm_sql_server_sql_db/azurerm_mssql_server"
  sql_servers = var.sql_servers
  rg_name     = module.rg.names
}

module "app_service_plans" {
  depends_on        = [module.rg]
  source            = "../../modules/azurerm_service_plan"
  service_plans = var.service_plans
  rg_name           = module.rg.names
}

module "app_services" {
  depends_on   = [module.rg, module.app_service_plans]
  source       = "../../modules/azurerm_app_service"
  app_services = var.app_services
  rg_name      = module.rg.names

}

module "log_analytics_workspaces" {
  depends_on               = [module.rg]
  source                   = "../../modules/azurerm_log_analytics_workspace"
  log_analytics_workspaces = var.log_analytics_workspaces
  rg_name                  = module.rg.names

}

module "container_app_environments" {
  depends_on                 = [module.rg, module.log_analytics_workspaces]
  source                     = "../../modules/azurerm_container_app/azurerm_container_app_environment"
  container_app_environments = var.container_app_environments
  rg_name                    = module.rg.names

}

module "container_app" {
  depends_on     = [module.rg, module.log_analytics_workspaces]
  source         = "../../modules/azurerm_container_app/azurerm_container_app"
  container_apps = var.container_apps
  rg_name        = module.rg.names
}
