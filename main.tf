
resource "azurerm_log_analytics_workspace" "airflow-aks-log-workspace" {
  name                = lookup(var.monitoring, "workspace_name")
  location            = lookup(var.monitoring, "workspace_location")
  resource_group_name = azurerm_resource_group.rg-airflow-aks.name
  sku                 = lookup(var.monitoring, "workspace_sku")
  retention_in_days   = lookup(var.monitoring, "log_workspace_retention_in_days")
}

resource "azurerm_log_analytics_solution" "airflow-aks-log-solution" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.airflow-aks-log-workspace.location
  resource_group_name   = azurerm_resource_group.rg-airflow-aks.name
  workspace_resource_id = azurerm_log_analytics_workspace.airflow-aks-log-workspace.id
  workspace_name        = azurerm_log_analytics_workspace.airflow-aks-log-workspace.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

# # create the AKS cluster
# resource "azurerm_kubernetes_cluster" "airflow-aks" {
#   name                = lookup(var.profile, "cluster_name")
#   location            = azurerm_resource_group.rg-airflow-aks.location
#   resource_group_name = azurerm_resource_group.rg-airflow-aks.name
#   dns_prefix          = lookup(var.profile, "dns_prefix")

#   linux_profile {
#     admin_username = lookup(var.linux_profile, "admin_username")

#     ssh_key {
#       key_data = file("${lookup(var.linux_profile, "ssh_public_key")}")
#     }
#   }

#   kubernetes_version = lookup(var.profile, "kubernetes_version")

#   default_node_pool {
#     name       = "nodepool1"
#     node_count = 1
#     vm_size    = lookup(var.os, "vm_size")
#   }
#   network_profile {
#     network_plugin     = lookup(var.network_profile, "network_plugin")
#     docker_bridge_cidr = lookup(var.network_profile, "docker_bridge_cidr")
#     dns_service_ip     = lookup(var.network_profile, "dns_service_ip")
#     pod_cidr           = lookup(var.network_profile, "pod_cidr")
#     service_cidr       = lookup(var.network_profile, "service_cidr")
#     load_balancer_sku  = lookup(var.network_profile, "load_balancer_sku")
#   }

#   agent_pool_profile {
#     name            = "agentpool"
#     count           = lookup(var.profile, "nodes_count")
#     max_pods        = lookup(var.profile, "max_pods")
#     vm_size         = lookup(var.os, "vm_size")
#     os_type         = lookup(var.os, "os_type")
#     os_disk_size_gb = lookup(var.os, "os_disk_size_gb") # 0 will default to 30 GB
#     type            = lookup(var.os, "type")

#     # Required for advanced networking
#     vnet_subnet_id = azurerm_subnet.aks-subnet.id
#   }

#   service_principal {
#     client_id     = var.client_id
#     client_secret = var.client_secret
#   }

#   role_based_access_control {
#     enabled = lookup(var.profile, "role_based_access_control")
#     azure_active_directory {
#       client_app_id     = lookup(var.profile, "client_app_id")
#       server_app_id     = lookup(var.profile, "server_app_id")
#       server_app_secret = var.aad_server_app_secret
#     }
#   }

#   addon_profile {
#     http_application_routing {
#       enabled = lookup(var.profile, "http_application_routing")
#     }
#     oms_agent {
#       enabled                    = lookup(var.monitoring, "enable_oms_agent")
#       log_analytics_workspace_id = azurerm_log_analytics_workspace.airflow-aks-log-workspace.id
#     }
#   }

#   tags       = merge(var.org_tags, tomap({ "role" = "aks" }))
#   depends_on = [azurerm_resource_group.airflow-aks, azurerm_subnet.aks-subnet]

#   lifecycle {
#     prevent_destroy = true
#   }
# }