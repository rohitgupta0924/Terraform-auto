resource "azurerm_mssql_database" "sqldb" {
  name                 = var.sqldbname
  server_id            = var.server_id
  storage_account_type = var.stgacctype
  sku_name             = var.sku_name
  tags                 = var.tags
  lifecycle {
    ignore_changes = [tags["ModifiedAt"]]
  }
}