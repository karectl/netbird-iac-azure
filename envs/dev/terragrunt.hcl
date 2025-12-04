include "root" {
  path = find_in_parent_folders("root.hcl")
  expose  = true
}

locals {
  environment = "dev"
}

terraform {
  source = "../../modules/netbird"
}

inputs = {
  region                                    = include.root.locals.region
  azure_tetre_subscription_id               = include.root.locals.azure_tetre_subscription_id
  tenant_id                                 = include.root.locals.azure_tenant_id
  vm_size                                   = "Standard_D2d_v5"
  common_tags                               = include.root.locals.common_tags
}

