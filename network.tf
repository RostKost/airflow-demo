
# module "network" {
#   source              = "Azure/network/azurerm"
#   resource_group_name = lookup(var.profile, "resource_group_vnet")
#   address_space       = ["${lookup(var.profile, "vnet_cidr")}"]
#   subnet_prefixes     = [lookup(var.profile, "subnet_cidr")]
#   subnet_names        = lookup(var.profile, "subnet_name")

#   depends_on          = [azurerm_resource_group.rg-airflow-aks-vnet]
# }

resource "azurerm_virtual_network" "aks-vnet" {
  name                = lookup(var.profile, "vnet_name")
  location            = azurerm_resource_group.rg-airflow-aks.location
  resource_group_name = azurerm_resource_group.rg-airflow-aks-vnet.name
  address_space       = ["${lookup(var.profile, "vnet_cidr")}"]

  depends_on = [azurerm_resource_group.rg-airflow-aks-vnet]
}

resource "azurerm_subnet" "aks-subnet" {
  name                 = lookup(var.profile, "subnet_name")
  virtual_network_name = azurerm_virtual_network.aks-vnet.name
  resource_group_name  = azurerm_virtual_network.aks-vnet.resource_group_name
  address_prefixes     = [lookup(var.profile, "subnet_cidr")]
  service_endpoints    = [lookup(var.network_profile, "service_endpoints")]

  depends_on = [azurerm_virtual_network.aks-vnet]
}
