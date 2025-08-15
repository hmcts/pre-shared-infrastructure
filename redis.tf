resource "azurerm_monitor_metric_alert" "redis_alert_errors" {
  name                = "redis_errors"
  resource_group_name = data.azurerm_resource_group.rg-cache.name
  scopes              = [data.azurerm_redis_cache.portal_redis_cache.id]
  severity            = 1

  description = <<EOT
    Redis error reported. Actions:
    (1) Check that the portal is still up: portal.pre-recorded-evidence.justice.gov.uk
    (2) Check redis health on Azure > Metrics > DTS-SHAREDSERVICES-PROD > pre-cache-prod > pre-portal-prod (Azure Cache for Redis).
    EOT

  tags = var.common_tags

  criteria {
    metric_namespace = "Microsoft.Cache/Redis"
    metric_name      = "errors"
    aggregation      = "Total"
    operator         = "GreaterThanOrEqual"
    threshold        = 1
  }
  window_size = "PT5M"
  frequency   = "PT5M"
  action {
    action_group_id = azurerm_monitor_action_group.pre-support[count.index].id
  }
}