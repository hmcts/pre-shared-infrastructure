locals {
  resource_group_name  = "${var.prefix}-${var.env}"
  mgmt_network_name    = var.mgmt_net_name
  mgmt_network_rg_name = var.mgmt_net_rg_name

  hub = {
    nonprod = {
      subscription = "fb084706-583f-4c9a-bdab-949aac66ba5c"
      ukSouth = {
        name         = "hmcts-hub-nonprodi"
        peering_name = "hubUkS"
        next_hop_ip  = "10.11.72.36"
      }
      ukWest = {
        name         = "ukw-hub-nonprodi"
        peering_name = "hubUkW"
        next_hop_ip  = "10.49.72.36"
      }
    }
    sbox = {
      subscription = "ea3a8c1e-af9d-4108-bc86-a7e2d267f49c"
      ukSouth = {
        name         = "hmcts-hub-sbox-int"
        peering_name = "hubUkS"
        next_hop_ip  = "10.10.200.36"
      }
      ukWest = {
        name         = "ukw-hub-sbox-int"
        peering_name = "hubUkW"
        next_hop_ip  = "10.48.200.36"
      }
    }
    prod = {
      subscription = "0978315c-75fe-4ada-9d11-1eb5e0e0b214"
      ukSouth = {
        name         = "hmcts-hub-prod-int"
        peering_name = "hubUkS"
        next_hop_ip  = "10.11.8.36"
      }
      ukWest = {
        name         = "ukw-hub-prod-int"
        peering_name = "hubUkW"
        next_hop_ip  = "10.49.8.36"
      }
    }
  }

  hub_to_env_mapping = {
    sbox    = ["sbox", "ptlsbox"]
    nonprod = ["demo", "dev", "aat", "test", "ithc", "ptl"]
    prod    = ["prod", "stg", "ptl", "dev"]
  }

  regions = [
    "ukSouth",
    "ukWest"
  ]

  hub_name = [for x in keys(local.hub_to_env_mapping) : x if contains(local.hub_to_env_mapping[x], var.env)][0]
}