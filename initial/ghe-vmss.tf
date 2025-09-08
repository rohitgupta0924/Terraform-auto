# variable "extra_tags" {
#   default = {
#     managed_by  = "terraform. for ghe: github.se.com"
#     environment = "dit"
#   }
# }

# //Fresh block just for this:
# locals {
#   ghe_resource_group = {
#     name     = azurerm_resource_group.rg.name,
#     id       = azurerm_resource_group.rg.id,
#     location = azurerm_resource_group.rg.location
#   }
# }

# //Org-runner-pool with two agent in the same VM, with labels: project-label
# module "org_pool" {
#   #source                              = "git::https://github.schneider-electric.com/DevSecOps/terraform-module-azure-ghe-runner.git?ref=tags/2.1.1"
#   source = "./terraform-module-azure-ghe-runner"

#   name                         = "vmss-a2e-ghrunners"
#   resource_group               = local.ghe_resource_group
#   subnet_id                    = data.azurerm_subnet.wl_sn.id
#   tags                         = merge(local.tags, var.extra_tags)
#   caf_naming_convention_enable = false
#   ssh_key_data = [
#     file("runnerkey.pub")
#   ]

#   ghe_scope                              = "A2E-NewGen" # GHE Organization-level runner
#   ghe_app_id                             = 375
#   ghe_app_private_key_keyvault_secret_id = azurerm_key_vault_secret.org_secret.id
#   ghe_runner_group                       = "A2ENewGen-Linux-RunnerGroup"
#   agent_count                            = 1
#   instance_count                         = 1
#   #image_id = ""
#   instance_type = "Standard_B2s" #"Standard_F2s_v2"
#   ghe_labels    = "A2E-NewGen"
#   managed_identities = [
#     "${azurerm_user_assigned_identity.runner_muid.id}"
#   ]
# }

# # resource "azurerm_monitor_autoscale_setting" "this" {
# #   location            = local.ghe_resource_group.location
# #   name                = "vmss-a2e-ghrunners-scale-settings"
# #   resource_group_name = "rg-a2e-ghrunners"
# #   tags                = merge(local.tags, var.extra_tags)
# #   target_resource_id  = module.org_pool.scale_set.id
# #   profile {
# #     name = "Default"
# #     capacity {
# #       default = 1
# #       maximum = 2
# #       minimum = 1
# #     }
# #     rule {
# #       scale_action {
# #         direction = "Increase"
# #         cooldown  = "PT1M"
# #         type      = "ChangeCount"
# #         value     = 1
# #       }
# #       metric_trigger {
# #         metric_name        = "Percentage CPU"
# #         metric_namespace   = "microsoft.compute/virtualmachinescalesets"
# #         metric_resource_id = module.org_pool.scale_set.id
# #         time_grain         = "PT1M"
# #         operator           = "GreaterThan"
# #         statistic          = "Average"
# #         threshold          = 30
# #         time_aggregation   = "Average"
# #         time_window        = "PT5M"
# #       }
# #     }
# #     rule {
# #       scale_action {
# #         direction = "Decrease"
# #         cooldown  = "PT5M"
# #         type      = "ChangeCount"
# #         value     = 1
# #       }
# #       metric_trigger {
# #         metric_name        = "Percentage CPU"
# #         metric_namespace   = "microsoft.compute/virtualmachinescalesets"
# #         metric_resource_id = module.org_pool.scale_set.id #"/subscriptions/5a24dfcd-770d-4c34-b320-1a4b42ca46bc/resourceGroups/rg-a2e-ghrunners/providers/Microsoft.Compute/virtualMachineScaleSets/vmss-a2e-ghrunners"
# #         time_grain         = "PT1M"
# #         operator           = "LessThan"
# #         statistic          = "Average"
# #         threshold          = 5
# #         time_aggregation   = "Average"
# #         time_window        = "PT20M"
# #       }
# #     }
# #   }
# # }
