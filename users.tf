data "azuread_client_config" "current" {}

data "azuread_user" "rost" {
  user_principal_name = "rst_test_az2_goin.work#EXT#@rsttestaz2goin.onmicrosoft.com"
}

resource "azuread_group" "aad-gr-ask-admin" {
  display_name     = "AKS-cluster-admins"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  # types            = ["Unified"]

  members = [
    data.azuread_user.rost.id
  ]
}