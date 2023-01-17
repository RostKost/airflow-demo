module "aks" {
  source  = "Azure/aks/azurerm"
  version = "6.5.0"
  # https://registry.terraform.io/modules/Azure/aks/azurerm/6.5.0?tab=inputs
  # If you have not assigned client_id or client_secret, A SystemAssigned identity will be created.
  resource_group_name               = azurerm_resource_group.rg-airflow-aks.name
  client_id                         = var.client_id
  client_secret                     = var.client_secret
  kubernetes_version                = lookup(var.profile, "kubernetes_version")
  orchestrator_version              = lookup(var.profile, "kubernetes_version")
  prefix                            = lookup(var.profile, "dns_prefix")
  network_plugin                    = lookup(var.network_profile, "network_plugin")
  vnet_subnet_id                    = azurerm_subnet.aks-subnet.id
  os_disk_size_gb                   = 30
  sku_tier                          = "Paid" # defaults to Free
  role_based_access_control_enabled = lookup(var.profile, "role_based_access_control")
  rbac_aad_admin_group_object_ids   = [azuread_group.aad-gr-ask-admin.id]
  rbac_aad_managed                  = true
  private_cluster_enabled           = false # default value
  http_application_routing_enabled  = true
  azure_policy_enabled              = false # true, if network_plugin=azure
  enable_auto_scaling               = true
  agents_min_count                  = 1
  agents_max_count                  = 2
  agents_count                      = null # Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes.
  agents_max_pods                   = 50
  agents_pool_name                  = "exnodepool"
  agents_availability_zones         = ["1", "2"]
  agents_type                       = "VirtualMachineScaleSets"

  agents_labels = {
    "nodepool" : "defaultnodepool"
  }

  agents_tags = {
    "Agent" : "defaultnodepoolagent"
  }

  network_policy                 = null # azure, if network_plugin=azure
  net_profile_dns_service_ip     = "10.0.2.10"
  net_profile_docker_bridge_cidr = "170.10.0.1/16"
  net_profile_service_cidr       = "10.0.2.0/24"

  admin_username = lookup(var.linux_profile, "admin_username")
  public_ssh_key = file("${lookup(var.linux_profile, "ssh_public_key")}")

  maintenance_window = {
    allowed = [
      {
        day   = "Sunday",
        hours = [22, 23]
      },
    ]
    not_allowed = []
  }

  depends_on = [
    azurerm_resource_group.rg-airflow-aks,
    azurerm_resource_group.rg-airflow-aks-vnet,
    azurerm_subnet.aks-subnet
  ]

}
