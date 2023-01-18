module "tags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = var.env
  product     = "pre-recorded-evidence"
  builtFrom   = "https://github.com/HMCTS/pre-shared-infrastructure.git"
  expiresAfter = "2023-02-16" # YYYY-MM-DD
}

locals {
  common_tags = module.tags.common_tags
}
