output "All_resource_groups" {
  value = module.rg.names
}

output "All_storage_accounts" {
  value = module.storage.storage_account_names
}

output "All_public_ip_addresses" {
  value = module.pips.public_ip_name_and_address
}

# output "All_nic_ids" {
#   value       = module.nics.nic_ids
# }

# output "All_private_ip_addresses" {
#   value       = module.nics.private_ip_addresses
# }

# output "All_VMs" {
#   value = module.lvm.vm_names
# }