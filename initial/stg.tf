# resource "azurerm_storage_account" "stg_acc" {
#   name                             = var.stg_name
#   account_replication_type         = var.account_replication_type
#   account_tier                     = var.account_tier
#   location                         = var.location
#   resource_group_name              = azurerm_resource_group.rg.name
#   account_kind                     = var.account_kind
#   min_tls_version                  = var.min_tls_version
#   https_traffic_only_enabled       = var.enable_https_traffic_only
#   allow_nested_items_to_be_public  = var.allow_nested_items_to_be_public
#   cross_tenant_replication_enabled = var.cross_tenant_replication_enabled
#   public_network_access_enabled    = var.public_network_access_enabled
#   network_rules {
#     default_action = "Deny"
#     bypass         = ["AzureServices"]
#   }
#   blob_properties {
#     delete_retention_policy {
#       days = 7
#     }
#   }
#   tags = local.dtags
#   lifecycle {
#     ignore_changes = [tags["ModifiedAt"]]
#   }
# }

# resource "azurerm_private_endpoint" "stg_acc_pvtep" {
#   location            = var.location
#   name                = "pvtep-${var.stg_name}"
#   resource_group_name = azurerm_resource_group.rg.name
#   subnet_id           = data.azurerm_subnet.wl_sn.id
#   tags                = local.tags
#   private_service_connection {
#     is_manual_connection           = false
#     name                           = "pvtsvcconn-pvtep-${var.stg_name}"
#     private_connection_resource_id = azurerm_storage_account.stg_acc.id
#     subresource_names              = var.subresource_names
#   }
#   lifecycle {
#     ignore_changes = [private_dns_zone_group, tags["ModifiedAt"]]
#   }
# }

# resource "null_resource" "dnscheck" {
#   depends_on = [azurerm_private_endpoint.stg_acc_pvtep]

#   provisioner "local-exec" {
#     interpreter = ["/bin/bash", "-c"]
#     working_dir = path.module
#     command     = "chmod +x dnsresolve_check.sh"
#   }
#   provisioner "local-exec" {
#     interpreter = ["/bin/bash", "-c"]
#     command     = "${path.module}/dnsresolve_check.sh ${var.stg_name}.privatelink.blob.core.windows.net"
#   }
# }
