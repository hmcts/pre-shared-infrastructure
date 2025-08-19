resource "azurerm_monitor_metric_alert" "redis_alert_errors" {
  count               = var.env == "stg" ? 1 : 0
  name                = "redis_errors"
  resource_group_name = data.azurerm_resource_group.rg-cache[0].name
  scopes              = [data.azurerm_redis_cache.portal_redis_cache.id]
  severity            = 1
  frequency           = "PT5M"
  window_size         = "PT5M"

  description = <<EOT
    Redis error reported. Actions:
    (1) Check that the portal is still up
    (2) Check health of the Azure Redis Cache
    EOT

  tags = var.common_tags

  criteria {
    metric_namespace = "Microsoft.Cache/Redis"
    metric_name      = "errors"
    aggregation      = "Total"
    operator         = "GreaterThanOrEqual"
    threshold        = 1
  }
  action {
    action_group_id = azurerm_monitor_action_group.pre-support[count.index].id
  }
}