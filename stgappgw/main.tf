data "azurerm_subnet" "appgwsn" {
  name                 = "snet-appgw-a2e-villaya-01"
  virtual_network_name = "vnet-spoke-digaccesstoenergydit001-prod-fc-001"
  resource_group_name  = "rg-management-prod-fc"
}

resource "azurerm_application_gateway" "apgw" {
  name                = "apgw-a2e-villaya-stg-01"
  enable_http2        = true
  location            = "francecentral"
  resource_group_name = "rg-a2e-villaya-stg-01"

  sku {
    capacity = 2
    name     = "Standard_v2"
    tier     = "Standard_v2"
  }
  zones = ["1", "2"]

  frontend_ip_configuration {
    name                          = "appGwPrivateFrontendIpIPv4"
    private_ip_address_allocation = "Static"
    subnet_id                     = data.azurerm_subnet.appgwsn.id
    private_ip_address            = "10.240.240.108"
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
    name                           = "lstr-ngvillaya-http"
    frontend_ip_configuration_name = "appGwPrivateFrontendIpIPv4"
    frontend_port_name             = "port_http"
    protocol                       = "Http"
  }

  backend_address_pool {
    name  = "defaultaddresspool"
    fqdns = ["wap-a2e-villaya-stg-02.azurewebsites.net"]
  }

  backend_address_pool {
    name  = "bp-wap-a2e-villaya-stg"
    fqdns = ["wap-a2e-villaya-stg-02.azurewebsites.net"]
  }

  //default backendhttpsettings as placeholder
  backend_http_settings {
    name                                = "defaulthttpsetting"
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "hp-villaya-stg-01"
    protocol                            = "Https"
    request_timeout                     = 20
  }

  backend_http_settings {
    name                                = "wap-a2e-villaya-stg-02"
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = "hp-villaya-stg-01"
    protocol                            = "Https"
    request_timeout                     = 20
  }

  probe {
    name                                      = "hp-villaya-stg-01"
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

  request_routing_rule {
    name               = "rule-ngvillaya-stg-pathbased"
    url_path_map_name  = "rule-ngvillaya-stg-pathbased"
    http_listener_name = "lstr-ngvillaya-http"
    priority           = 101
    rule_type          = "PathBasedRouting"
  }

  url_path_map {
    default_backend_address_pool_name  = "defaultaddresspool"
    default_backend_http_settings_name = "defaulthttpsetting"
    name                               = "rule-ngvillaya-stg-pathbased"
    path_rule {
      name                       = "wap-a2e-villaya-stg-02"
      backend_address_pool_name  = "bp-wap-a2e-villaya-stg"
      backend_http_settings_name = "wap-a2e-villaya-stg-02"
      paths                      = ["/newgen*"]
    }
  }
}