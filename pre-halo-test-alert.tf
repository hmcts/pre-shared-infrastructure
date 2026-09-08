module "pre-halo-test-alert" {
  count             = var.env == "stg" ? 1 : 0
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = data.azurerm_application_insights.app_insights.location
  app_insights_name = data.azurerm_application_insights.app_insights.name

  alert_name  = "PRE_API_halo_test"
  alert_desc  = "TEST ONLY (non-prod): to trial Halo webhook integration by alerting on non-200 responses from GET /health-endpoint-not-real."
  common_tags = var.common_tags

  app_insights_query = <<EOF
requests
| where name == "GET /health-endpoint-not-real" and resultCode != "200"
| where cloud_RoleInstance startswith "pre-api-java"
EOF

  frequency_in_minutes       = "5"
  time_window_in_minutes     = "5"
  severity_level             = "3"
  action_group_name          = data.azurerm_monitor_action_group.halo_itsm_nonprod.name
  action_group_rg_name       = data.azurerm_monitor_action_group.halo_itsm_nonprod.resource_group_name
  custom_email_subject       = "PRE API Halo Webhook Test (Not a real alert)"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "3"
  resourcegroup_name         = "${var.product}-${var.env}"
}
