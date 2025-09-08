resource "azurerm_linux_web_app" "webapp" {
  name                                     = var.webapp_name
  client_affinity_enabled                  = var.client_affinity_enabled
  https_only                               = var.https_only
  location                                 = var.location
  public_network_access_enabled            = var.public_network_access_enabled
  resource_group_name                      = var.resource_group_name
  service_plan_id                          = var.service_plan_id
  virtual_network_subnet_id                = var.ob_subnet_id
  app_settings                             = var.appsettings
  ftp_publish_basic_authentication_enabled = var.ftp_publish_basic_authentication_enabled
  identity {
    type         = var.enable_system_assigned_identity && var.enable_user_assigned_identity ? "SystemAssigned, UserAssigned" : var.enable_system_assigned_identity ? "SystemAssigned" : var.enable_user_assigned_identity ? "UserAssigned" : "None"
    identity_ids = var.enable_user_assigned_identity ? var.user_assigned_identity_ids : null
  }
  logs {
    http_logs {
      file_system {
        retention_in_days = var.retention_in_days
        retention_in_mb   = var.retention_in_mb
      }
    }
  }
  site_config {
    always_on              = var.always_on
    use_32_bit_worker      = var.use_32_bit_worker
    app_command_line       = var.app_command_line
    ftps_state             = var.ftps_state
    vnet_route_all_enabled = var.vnet_route_all_enabled
    application_stack {
      node_version = var.node_version
    }
    cors {
      allowed_origins = var.allowed_origins
    }
  }
  dynamic "connection_string" {
    for_each = var.connection_strings
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }
  tags = var.tags
  lifecycle {
    ignore_changes = [tags["ModifiedAt"]]
  }
}

resource "azurerm_private_endpoint" "pep" {
  name                = "pvtep-${var.webapp_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  private_service_connection {
    is_manual_connection           = false
    name                           = "svcconn-pvtep-${var.webapp_name}"
    private_connection_resource_id = azurerm_linux_web_app.webapp.id
    subresource_names              = var.subresource_names
  }
  tags = merge(var.tags, { "ModifiedAt" = formatdate("DD-MMM-YYYY hh:mm AA", timestamp()) })
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