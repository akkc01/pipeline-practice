# # Auto generate mapping for association module
# locals {
#   nic_nsg_map = {
#     for key in keys(module.network_interface.nic_ids) : key => {
#       network_interface_id      = module.network_interface.nic_ids[key]
#       network_security_group_id = module.nsg.nsg_ids[key]
#     }
#   }
# }