resource "azurerm_virtual_network" "librechat_network" {
  name                = "librechat_network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "librechat_subnet" {
  name                 = "librechat_subnet"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.librechat_network.name
  address_prefixes     = ["10.0.1.0/24"]

  service_endpoints = ["Microsoft.AzureCosmosDB", "Microsoft.Web"]

  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

# Network Security Group for LibreChat subnet
resource "azurerm_network_security_group" "librechat_nsg" {
  name                = "librechat-nsg${random_string.random_postfix.result}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  # Allow outbound HTTPS traffic for MCP servers and external APIs
  security_rule {
    name                       = "AllowOutboundHTTPS"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
    description                = "Allow outbound HTTPS for MCP servers and APIs"
  }

  # Allow outbound HTTP traffic (some services may use it)
  security_rule {
    name                       = "AllowOutboundHTTP"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
    description                = "Allow outbound HTTP"
  }

  # Allow outbound DNS
  security_rule {
    name                       = "AllowOutboundDNS"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    description                = "Allow DNS resolution"
  }

  tags = {
    Purpose = "LibreChat Network Security"
  }
}

# Associate NSG with the subnet
resource "azurerm_subnet_network_security_group_association" "librechat_nsg_association" {
  subnet_id                 = azurerm_subnet.librechat_subnet.id
  network_security_group_id = azurerm_network_security_group.librechat_nsg.id
}
