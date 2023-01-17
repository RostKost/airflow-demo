# create resource group for the azure kubernetes service (AKS)
resource "azurerm_resource_group" "rg-airflow-aks" {
  name     = var.resource_group_name
  location = var.location

  tags = merge(var.org_tags)

  lifecycle {
    prevent_destroy = false
  }
}

# resource "azurerm_management_lock" "resource-group-level" {
#   name       = "${var.resource_group_name}-lock"
#   scope      = azurerm_resource_group.rg-airflow-aks.id
#   lock_level = "CanNotDelete"
#   notes      = "Locking the parent AKS Resource Group"
# }

resource "azurerm_resource_group" "rg-airflow-aks-vnet" {
  name     = lookup(var.profile, "resource_group_vnet")
  location = var.location

  tags = merge(var.org_tags)

  lifecycle {
    prevent_destroy = false
  }
}
