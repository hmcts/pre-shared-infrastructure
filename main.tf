resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location
  tags     = var.common_tags
}

resource "null_resource" "cleanall" {
  provisioner "local-exec" {
    command = "$resources = az resource list --resource-group pre-stg | ConvertFrom-Json; foreach ($resource in $resources) {az resource delete --resource-group pre-sbox --ids $resource.id --verbose}"
    interpreter = ["PowerShell", "-Command"]
  }
}