
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-azure-migration-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks-azmig-dev-3519"
  sku_tier            = "Free"

  default_node_pool {
    name           = "system"
    node_count     = 1
    vm_size        = "Standard_D2s_v5"
    vnet_subnet_id = azurerm_subnet.subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    pod_cidr            = "192.168.0.0/16"
    load_balancer_sku   = "standard"
  }

  tags = {
    Environment = "Dev"
    Project     = "AWS-to-Azure-Migration"
  }
}
