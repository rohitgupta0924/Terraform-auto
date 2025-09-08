resource "azurerm_mssql_server" "sqlsvr" {
  name                          = var.sqlsvrname
  location                      = var.location
  resource_group_name           = var.rg_name
  administrator_login           = var.administrator_login
  administrator_login_password  = var.administrator_login_password
  public_network_access_enabled = var.public_network_access_enabled
  version                       = var.mssql_version
  azuread_administrator {
    azuread_authentication_only = var.azuread_authentication_only
    login_username              = var.ad_login_username
    object_id                   = var.ad_object_id
    tenant_id                   = var.ad_tenant_id
  }
  lifecycle {
    ignore_changes = [tags["ModifiedAt"]]
  }
  tags = var.dtags
}

resource "azurerm_private_endpoint" "pep_sql" {
  location            = var.location
  name                = "pvtep-${var.sqlsvrname}"
  resource_group_name = var.rg_name
  subnet_id           = var.subnet_id
  tags                = var.tags

  private_service_connection {
    is_manual_connection           = false
    name                           = "pvtsvcconn-pvtep-${var.sqlsvrname}"
    private_connection_resource_id = azurerm_mssql_server.sqlsvr.id
    subresource_names              = var.sql_subresource_names
  }
  lifecycle {
    ignore_changes = [private_dns_zone_group, tags["ModifiedAt"]]
  }
}

resource "null_resource" "dnscheck_sql_pep" {
  depends_on = [azurerm_private_endpoint.pep_sql]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    working_dir = path.module
    command     = "chmod +x dnsresolve_check.sh"
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "${path.module}/dnsresolve_check.sh ${var.sqlsvrname}.privatelink.database.windows.net"
  }
}