output "subnet_ids" {
  description = "IDs of all created subnets"
  value = {
    for key, subnet in azurerm_subnet.subnet :
    key => subnet.id
  }
}


# variable "target_subnet_key" {
#   description = "Key of the subnet whose ID should be output"
#   type        = string
# }

# output "target_subnet_id" {
#   description = "ID of the selected subnet"
#   value       = azurerm_subnet.subnet[var.target_subnet_key].id
# }
