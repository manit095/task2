# Create Resource group
resource "azurerm_resource_group" "rg" {
  name = "rg-aks-example"
  location = local.resource_location
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name = "vnet-aks-example"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = ["10.0.0.0/16"]
}

# Create 2 public subnet
resource "azurerm_subnet" "public_subnets" {
  count = 2
  name = "public-subnet-${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.${count.index}.0/24"]

  delegation {
    name = "publicDelegation"
    service_delegation {
      name = "Microsoft.Network/virtualNetworks"
      actions = ["Microsoft.Network/virtualNetworks/*"]
    }
  }
}

# Create 2 private subnet

resource "azurerm_subnet" "private_subnets" {
  count = 2
  name = "private-subnet-${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.${count.index + 2}.0/24"]
}

# Create AKS Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name = "aks-cluster-example"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix = "aksdns"

  default_node_pool {
    name = "nodepool"
    node_count = 2
    vm_size = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.private_subnets[0].id
    orchestrator_version = "1.27.3"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
    outbound_type = "loadBalancer"
  }
}

resource "azurerm_lb" "public_lb" {
  name = "public-lb"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"

  frontend_ip_configuration {
    name = "frontend"
    subnet_id = azurerm_subnet.public_subnets[0].id
  }
}
