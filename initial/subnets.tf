# locals {
#   tags = merge(
#     var.tags,
#     { "ModifiedAt" = formatdate("DD-MMM-YYYY hh:mm AA", timestamp()) }
#   )
#   dtags = merge(var.data_tags, local.tags)
# }

# resource "azurerm_resource_group" "rg" {
#   name     = var.gh_runner_rg_name
#   location = var.location
#   tags     = local.tags
#   lifecycle {
#     ignore_changes = [tags["ModifiedAt"]]
#   }
# }

# resource "azurerm_subnet" "subnets" {
#   for_each             = var.subnets
#   name                 = each.value.name
#   resource_group_name  = var.net_rg_name
#   virtual_network_name = var.vnet_name
#   address_prefixes     = each.value.addr_prefix

#   dynamic "delegation" {
#     for_each = each.value.enable_delegation ? [1] : []
#     content {
#       name = "${each.value.name}-delegation"
#       service_delegation {
#         name    = "Microsoft.Web/serverFarms"
#         actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
#       }
#     }
#   }
#   lifecycle {
#     ignore_changes = [
#       service_endpoint_policy_ids,
#       service_endpoints
#     ]
#   }
# }

# # output "subnets_details" {
# #   value       = azurerm_subnet.subnets
# #   description = "Output the details for the provisioned subnet"
# # }