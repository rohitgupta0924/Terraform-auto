data "azurerm_subnet" "wl_sn" {
  name                 = var.wl_sn_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.net_rg_name
}

data "azurerm_subnet" "ob_sn" {
  name                 = var.ob_sn_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.net_rg_name
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.tags
  lifecycle {
    ignore_changes = [tags["ModifiedAt"]]
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "sqlsvr" {
  source                       = "../terraform_mod/sqlsvr"
  sqlsvrname                   = local.sqlsvrname
  location                     = var.location
  rg_name                      = azurerm_resource_group.rg.name
  administrator_login          = var.administrator_login
  administrator_login_password = random_password.password.result
  ad_login_username            = var.ad_login_username
  ad_object_id                 = var.ad_object_id
  ad_tenant_id                 = var.ad_tenant_id
  subnet_id                    = data.azurerm_subnet.wl_sn.id
  tags                         = local.tags
  dtags                        = local.dtags
}

module "sqldb" {
  source     = "../terraform_mod/sqldb"
  sqldbname  = local.sqldbname
  server_id  = module.sqlsvr.svr_id
  stgacctype = var.stgacctype
  sku_name   = var.sku_name
  tags       = local.tags
}

module "storage_accounts" {
  source              = "../terraform_mod/stgacc"
  stg_name            = local.stgaccname
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  wl_subnet_id        = data.azurerm_subnet.wl_sn.id
  tags                = local.tags
  data_tags           = local.dtags
}

resource "azurerm_storage_table" "stgtable" {
  depends_on           = [module.storage_accounts]
  for_each             = toset(var.table_names)
  name                 = each.value
  storage_account_name = local.stgaccname
}

resource "azurerm_storage_container" "containers" {
  depends_on           = [module.storage_accounts]
  for_each             = toset(var.container_names)
  name                 = each.value
  storage_account_name = local.stgaccname
}

resource "azurerm_service_plan" "winasp1" {
  name                = local.service_plan_name_windows1
  location            = var.location
  os_type             = "Windows"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = var.asp_sku_windows1
  tags                = local.tags
  lifecycle {
    ignore_changes = [tags["ModifiedAt"]]
  }
}

resource "azurerm_service_plan" "winasp2" {
  name                = local.service_plan_name_windows2
  location            = var.location
  os_type             = "Windows"
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = var.asp_sku_windows2
  tags                = local.tags
  lifecycle {
    ignore_changes = [tags["ModifiedAt"]]
  }
}

module "apiapp_win_be" {
  source              = "../terraform_mod/api_webapp_win"
  webapp_name         = local.webappbename
  resource_group_name = azurerm_resource_group.rg.name
  resource_group_id   = azurerm_resource_group.rg.id
  location            = var.location
  service_plan_id     = azurerm_service_plan.winasp1.id
  ob_subnet_id        = data.azurerm_subnet.ob_sn.id
  wl_subnet_id        = data.azurerm_subnet.wl_sn.id
  tags                = local.tags
}

module "webapps_win_fe" {
  depends_on          = [module.apiapp_win_be]
  source              = "../terraform_mod/webapp_win"
  webapp_name         = local.webappfename
  wl_subnet_id        = data.azurerm_subnet.wl_sn.id
  ob_subnet_id        = data.azurerm_subnet.ob_sn.id
  service_plan_id     = azurerm_service_plan.winasp1.id
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  tags                = local.tags
}

module "apiapp_win_bewebjob" {
  source              = "../terraform_mod/api_webapp_win"
  webapp_name         = local.webjobbename
  resource_group_name = azurerm_resource_group.rg.name
  resource_group_id   = azurerm_resource_group.rg.id
  location            = var.location
  service_plan_id     = azurerm_service_plan.winasp2.id
  ob_subnet_id        = data.azurerm_subnet.ob_sn.id
  wl_subnet_id        = data.azurerm_subnet.wl_sn.id
  tags                = local.tags
}

#app_command_line    = var.bewebapp_appcommandline
# variable "bewebapp_appcommandline" {
#   type        = string
#   description = "Command line to be executed for the Frontend Webapp."
# }
#bewebapp_appcommandline = "pm2 start index.js --no-daemon"

# module "webapp_lin_fe" {
#   depends_on          = [module.apiapp_win_be]
#   source              = "../terraform_mod/webapp_lin"
#   webapp_name         = local.webappfename
#   app_command_line    = "pm2 start index.js --no-daemon"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.rg.name
#   service_plan_id     = azurerm_service_plan.linasp.id
#   ob_subnet_id        = data.azurerm_subnet.ob_sn.id
#   subnet_id           = data.azurerm_subnet.wl_sn.id
#   tags                = local.tags
# }

