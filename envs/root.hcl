locals {

    spn_client_id                                    = "b78f544b-ede0-4ed2-8c2c-0d7474acef8c"
    region                                           = "uksouth"
    cluster_name                                     = "k8tre"
    azure_tenant_id                                  = "30a82846-a29e-4b6b-af27-9b19418ee1b3"
    azure_tetre_subscription_id                      = "443fc06f-050e-4794-83d8-eaeee691d453"
    entra_admin_group_id                             = "8495e6fa-3c66-403b-abfe-227062b5d9d0"
 
    common_tags = {
        "Cost Centre"   = "ICT"
        "Environment"   = "TETRE"
        "Service Owner" = "ICT"
        "Service Name"  = "TETRE"
        "Service"       = "TETRE"
        "ServiceName"   = "TETRE"
    }

}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
    terraform {
        backend "azurerm" {
            resource_group_name   = "rg-kare-con-uks-backup"
            storage_account_name  = "sttetreiacstate"
            container_name        = "tfstate"
            key                   = "${path_relative_to_include()}/tetre.tfstate"
        }
    }
EOF

}