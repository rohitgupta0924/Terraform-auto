
resource "azapi_resource" "api_app" {
  name      = var.webapp_name
  type      = "Microsoft.Web/sites@2022-09-01"
  parent_id = var.resource_group_id
  location  = var.location
  identity {
    type = "SystemAssigned"
  }
  body = jsonencode({
    kind = "api"
    properties = {
      clientAffinityEnabled     = true
      clientCertEnabled         = false
      clientCertMode            = "Required"
      enabled                   = true
      httpsOnly                 = true
      keyVaultReferenceIdentity = "SystemAssigned"
      publicNetworkAccess       = "Disabled"
      serverFarmId              = "${var.service_plan_id}"
      virtualNetworkSubnetId    = "${var.ob_subnet_id}"
      vnetRouteAllEnabled       = true
      siteConfig = {
        alwaysOn        = true
        http20Enabled   = false
        numberOfWorkers = 1
      }
    }
  })
  lifecycle {
    ignore_changes = [tags["ModifiedAt"]]
  }
  tags = var.tags
}

resource "azurerm_private_endpoint" "pep" {
  name                = "pvtep-${var.webapp_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.wl_subnet_id
  private_service_connection {
    is_manual_connection           = false
    name                           = "svcconn-pvtep-${var.webapp_name}"
    private_connection_resource_id = azapi_resource.api_app.id
    subresource_names              = var.subresource_names
  }
  tags = var.tags
  lifecycle {
    ignore_changes = [private_dns_zone_group, tags["ModifiedAt"]]
  }
}

resource "null_resource" "dnscheck" {
  depends_on = [azurerm_private_endpoint.pep]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    working_dir = path.module
    command     = "chmod +x dnsresolve_check.sh"
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "${path.module}/dnsresolve_check.sh ${var.webapp_name}.privatelink.azurewebsites.net"
  }
}