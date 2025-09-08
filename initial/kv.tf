# variable "sku_name" {
#   type        = string
#   default     = "standard"
#   description = "The sku for the kv instance"
# }

# variable "kv_subresource_names" {
#   type        = list(string)
#   default     = ["vault"]
#   description = "List of components to be exposed via private endpoint"
# }

# data "azurerm_client_config" "current" {}

# resource "azurerm_key_vault" "kv" {
#   depends_on                    = [azurerm_resource_group.rg]
#   name                          = var.kvname
#   location                      = var.location
#   public_network_access_enabled = var.public_network_access_enabled
#   resource_group_name           = azurerm_resource_group.rg.name
#   sku_name                      = var.sku_name
#   tags                          = local.dtags
#   lifecycle {
#     ignore_changes = [tags["ModifiedAt"]]
#   }
#   tenant_id = data.azurerm_client_config.current.tenant_id
#   network_acls {
#     default_action = "Deny"
#     bypass         = "AzureServices"
#   }
# }


# resource "azurerm_private_endpoint" "pep_kv" {
#   depends_on          = [azurerm_key_vault.kv]
#   location            = var.location
#   name                = "pvtep-${var.kvname}"
#   resource_group_name = azurerm_resource_group.rg.name
#   subnet_id           = data.azurerm_subnet.wl_sn.id
#   tags                = local.tags

#   private_service_connection {
#     is_manual_connection           = false
#     name                           = "pvtsvcconn-pvtep-${var.kvname}"
#     private_connection_resource_id = azurerm_key_vault.kv.id
#     subresource_names              = var.kv_subresource_names
#   }
#   lifecycle {
#     ignore_changes = [private_dns_zone_group, tags["ModifiedAt"]]
#   }
# }

# resource "null_resource" "dnscheck_kv" {
#   depends_on = [azurerm_private_endpoint.pep_kv]

#   provisioner "local-exec" {
#     interpreter = ["/bin/bash", "-c"]
#     working_dir = path.module
#     command     = "chmod +x dnsresolve_check.sh"
#   }
#   provisioner "local-exec" {
#     interpreter = ["/bin/bash", "-c"]
#     command     = "${path.module}/dnsresolve_check.sh ${var.kvname}.privatelink.vaultcore.azure.net"
#   }
# }

# #We need to figure this part out
# # resource "azurerm_key_vault_access_policy" "user_policy" {
# #   depends_on = [azurerm_private_endpoint.pep_kv]    
# #   key_vault_id = azurerm_key_vault.kv.id
# #   tenant_id    = data.azurerm_client_config.current.tenant_id
# #   object_id    = data.azurerm_client_config.current.object_id #ADM766676@se.com : ObjID -> f554135e-2ee4-4834-b5c6-7515f7beb64a

# #   secret_permissions = [
# #     "Get", "Set", "List"
# #   ]
# # }

# // Part of pre-req for creation of ghe runner using vmss
# resource "azurerm_key_vault_secret" "org_secret" {
#   depends_on   = [azurerm_private_endpoint.pep_kv]
#   name         = "a2enewgen-org-register-runner"
#   key_vault_id = azurerm_key_vault.kv.id
#   value        = base64encode(file("${path.module}/a2enewgen-org-register-runner.2025-02-09.private-key.pem"))

#   tags = local.tags
#   lifecycle {
#     ignore_changes = [tags["ModifiedAt"]]
#   }
# }

# //Runners User Assigned managed identity creation
# resource "azurerm_user_assigned_identity" "runner_muid" {
#   depends_on          = [azurerm_private_endpoint.pep_kv]
#   location            = var.location
#   name                = "managed-id-a2enewgen-ghrunners"
#   resource_group_name = azurerm_resource_group.rg.name
#   tags                = local.tags
#   lifecycle {
#     ignore_changes = [tags["ModifiedAt"]]
#   }
# }

# //Role assignment for the managed identity --> relook this later
# resource "azurerm_role_assignment" "ghe_runner_role" {
#   scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
#   role_definition_name = "[SEALZ-PROD] rcd-lz-owner"
#   principal_id         = azurerm_user_assigned_identity.runner_muid.principal_id
# }

# //Key vault secret reader permssion for the identity
# resource "azurerm_key_vault_access_policy" "runner_muid_policy" {
#   depends_on   = [azurerm_private_endpoint.pep_kv]
#   key_vault_id = azurerm_key_vault.kv.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = azurerm_user_assigned_identity.runner_muid.principal_id

#   secret_permissions = [
#     "Get",
#   ]
# }

