terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26.0"
    }
  }
  #required_version = ">= 1.7.0"
}

provider "azurerm" {
  alias           = "azure-connectivity"
  subscription_id = var.azure_tetre_subscription_id
  features {}
}

resource "azurerm_resource_group" "netbird_rg" {
  name     = "rg-tetre-netbird"
  location = var.region
  provider = azurerm.azure-connectivity
  tags      = var.common_tags
}


resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-netbird"
  address_space       = ["10.0.0.0/16"]
  location            = var.region
  resource_group_name = azurerm_resource_group.netbird_rg.name
  provider = azurerm.azure-connectivity
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-netbird"
  resource_group_name  = azurerm_resource_group.netbird_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  provider = azurerm.azure-connectivity
}

resource "azurerm_public_ip" "public_ip" {
  name                = "netbird-public-ip"
  resource_group_name = azurerm_resource_group.netbird_rg.name
  provider = azurerm.azure-connectivity
  location            = var.region
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic" {
  name                = "netbird-nic"
  location            = var.region
  resource_group_name = azurerm_resource_group.netbird_rg.name
  provider = azurerm.azure-connectivity

  ip_configuration {
    name                          = "nic-ip"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

# ----------------------------
# VM
# ----------------------------
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "netbird-vm"
  resource_group_name = azurerm_resource_group.netbird_rg.name
  location            = var.region
  size                = var.vm_size
  admin_username      = "netbird-admin"
  admin_password      = var.admin_password
  provider = azurerm.azure-connectivity

  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

 custom_data = base64encode(file("${path.module}/cloud-init-netbird.yaml"))
}