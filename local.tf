locals {
  log_analytics_env_mapping = {
    sandbox       = ["sbox"]
    nonproduction = ["dev", "test", "ithc", "demo", "stg"]
    production    = ["prod", "mgmt"]
  }
  log_analytics_workspace = {
    sandbox = {
      subscription_id = "bf308a5c-0624-4334-8ff8-8dca9fd43783"
      name            = "hmcts-sandbox"
    }
    nonproduction = {
      subscription_id = "1c4f0704-a29e-403d-b719-b90c34ef14c9"
      name            = "hmcts-nonprod"
    }
    production = {
      subscription_id = "8999dec3-0104-4a27-94ee-6588559729d1"
      name            = "hmcts-prod"
    }
  }
}