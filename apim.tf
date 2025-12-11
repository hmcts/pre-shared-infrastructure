resource "azurerm_monitor_activity_log_alert" "apim_create_update_api_failed" {
  name                = "apim_create_update_api_failed"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [data.azurerm_api_management.sds_api_mgmt.id]

  description = <<EOT
    Create or Update API failed. Actions:
    (1) Check that this alert is for pre-api
    (2) Check whether the latest pre-api master build has failed
    (3) Re-run the master build and confirm it has succeeded
    EOT

  tags = var.common_tags

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.ApiManagement/service/apis/write"
    status         = "Failed"
  }

  action {
    action_group_id = azurerm_monitor_action_group.pre-support[count.index].id
  }
}