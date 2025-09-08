data "azurerm_subnet" "appgwsn" {
  name                 = "snet-newgen-appgw"
  virtual_network_name = "vnet-spoke-digaccesstoenergydit001-prod-fc-001"
  resource_group_name  = "rg-management-prod-fc"
}

resource "azurerm_application_gateway" "apgw" {
  name                = "apgw-a2e-newgen-uat-01"
  enable_http2        = true
  location            = "francecentral"
  resource_group_name = "rg-newgen-uat-01"

  sku {
    capacity = 1
    name     = "Standard_v2"
    tier     = "Standard_v2"
  }
  zones = ["1"]

  frontend_ip_configuration {
    name                          = "appGwPrivateFrontendIpIPv4"
    private_ip_address_allocation = "Static"
    subnet_id                     = data.azurerm_subnet.appgwsn.id
    private_ip_address            = "10.144.46.228"
  }
  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = data.azurerm_subnet.appgwsn.id
  }

  frontend_port {
    name = "port_http"
    port = 80
  }

  http_listener {
    name                           = "lstr-http"
    frontend_ip_configuration_name = "appGwPrivateFrontendIpIPv4"
    frontend_port_name             = "port_http"
    protocol                       = "Http"
  }

  backend_address_pool {
    name  = "defaultaddresspool"
    fqdns = ["wap-newgen-fe-uat-01.azurewebsites.net"]
  }

  backend_address_pool {
    name  = "bp-apiapp"
    fqdns = ["apiapp-newgen-be-api-uat-01.azurewebsites.net"]
  }

  //default backendhttpsettings as placeholder
  backend_http_settings {
    name                                = "defaulthttpsetting"
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "hp-default"
    protocol                            = "Https"
    request_timeout                     = 20
  }

  backend_http_settings {
    name                                = "bs-apiapp"
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "hp-apiapp"
    protocol                            = "Https"
    request_timeout                     = 20
  }

  probe {
    name                                      = "hp-default"
    interval                                  = 30
    path                                      = "/"
    pick_host_name_from_backend_http_settings = true
    protocol                                  = "Https"
    timeout                                   = 30
    unhealthy_threshold                       = 3
    match {
      status_code = ["200-399"]
    }
  }

  probe {
    name                                      = "hp-apiapp"
    interval                                  = 30
    path                                      = "/swagger/index.html"
    pick_host_name_from_backend_http_settings = true
    protocol                                  = "Https"
    timeout                                   = 30
    unhealthy_threshold                       = 3
    match {
      status_code = ["200-399"]
    }
  }

  request_routing_rule {
    name               = "rr-pathbased"
    url_path_map_name  = "rr-pathbased"
    http_listener_name = "lstr-http"
    priority           = 101
    rule_type          = "PathBasedRouting"
  }

  url_path_map {
    name                               = "rr-pathbased"
    default_backend_address_pool_name  = "defaultaddresspool"
    default_backend_http_settings_name = "defaulthttpsetting"

    path_rule {
      name                       = "rules-apiapp"
      backend_address_pool_name  = "bp-apiapp"
      backend_http_settings_name = "bs-apiapp"
      paths                      = ["/api*", "/swagger*"]
    }
  }
}
