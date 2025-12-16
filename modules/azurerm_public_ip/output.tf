output "public_ip_ids" {
  value = {
    for pip_key, pip_resource in azurerm_public_ip.pip : pip_key => pip_resource.id
  }
}


output "public_ip_name_and_address" {
  description = "Map of Public IP resource names to their assigned IP addresses."
  value = {
    for k, v in azurerm_public_ip.pip :
    v.name => v.ip_address
  }
}

