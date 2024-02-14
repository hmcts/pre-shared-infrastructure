# pre product infrastructure
Pre-Recorded Evidence Project - Core infrastructure

The infrastructure for PRE is brought up in 4 stages:
1. https://github.com/hmcts/pre-network
2. https://github.com/hmcts/pre-vault
3. https://github.com/hmcts/pre-shared-infrastructure  - YOU ARE HERE
4. https://github.com/hmcts/pre-functions

## Getting started

The terraform version is managed by `.terraform-version` file in the root of the repo, you can update this whenever you want.

## Lint

Please run `terraform fmt` before submitting a pull request.

Documentation is kept up-to-date using terraform-docs.

We've included [pre-commit](https://pre-commit.com/) hooks to help with this.

Install it with:
```shell
$ brew install pre-commit
# or
$ pip3 install pre-commit
```

then run:
```command
$ pre-commit install
```

## Workflow

1. Make your changes locally
2. Format your change with `terraform fmt` or the pre-commit hook
3. Submit a pull request
4. Check the terraform plan from the build link that will be posted on your PR
5. Get someone else to review your PR
6. Merge the PR
7. It will automatically be deployed to AAT and Prod environments
8. Once successful in AAT and Prod then merge your change to demo, ithc, and perftest branches.

## LICENSE

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.75.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.2.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.9 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.75.0 |
| <a name="provider_azurerm.mgmt"></a> [azurerm.mgmt](#provider\_azurerm.mgmt) | 3.75.0 |
| <a name="provider_azurerm.oms"></a> [azurerm.oms](#provider\_azurerm.oms) | 3.75.0 |
| <a name="provider_azurerm.private_dns"></a> [azurerm.private\_dns](#provider\_azurerm.private\_dns) | 3.75.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_application_insights"></a> [application\_insights](#module\_application\_insights) | git@github.com:hmcts/terraform-module-application-insights | main |
| <a name="module_backup_vault"></a> [backup\_vault](#module\_backup\_vault) | git@github.com:hmcts/pre-shared-infrastructure.git//modules/backup_vault | remove_vaults |
| <a name="module_data_gateway_vm"></a> [data\_gateway\_vm](#module\_data\_gateway\_vm) | git@github.com:hmcts/terraform-module-virtual-machine.git | master |
| <a name="module_data_store_db_v14"></a> [data\_store\_db\_v14](#module\_data\_store\_db\_v14) | git@github.com:hmcts/terraform-module-postgresql-flexible.git | master |
| <a name="module_edit_vm"></a> [edit\_vm](#module\_edit\_vm) | git@github.com:hmcts/terraform-module-virtual-machine.git | master |
| <a name="module_finalsa_storage_account"></a> [finalsa\_storage\_account](#module\_finalsa\_storage\_account) | git@github.com:hmcts/cnp-module-storage-account | master |
| <a name="module_finalsa_storage_account_backup"></a> [finalsa\_storage\_account\_backup](#module\_finalsa\_storage\_account\_backup) | git@github.com:hmcts/cnp-module-storage-account | master |
| <a name="module_ingestsa_storage_account"></a> [ingestsa\_storage\_account](#module\_ingestsa\_storage\_account) | git@github.com:hmcts/cnp-module-storage-account | master |
| <a name="module_ingestsa_storage_account_backup"></a> [ingestsa\_storage\_account\_backup](#module\_ingestsa\_storage\_account\_backup) | git@github.com:hmcts/cnp-module-storage-account | master |
| <a name="module_log_analytics_workspace"></a> [log\_analytics\_workspace](#module\_log\_analytics\_workspace) | git@github.com:hmcts/terraform-module-log-analytics-workspace-id.git | master |
| <a name="module_sa_storage_account"></a> [sa\_storage\_account](#module\_sa\_storage\_account) | git@github.com:hmcts/cnp-module-storage-account | master |
| <a name="module_sa_storage_account_backup"></a> [sa\_storage\_account\_backup](#module\_sa\_storage\_account\_backup) | git@github.com:hmcts/cnp-module-storage-account | master |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.API_POSTGRES_DATABASE](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.API_POSTGRES_HOST](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.API_POSTGRES_PASS](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.API_POSTGRES_PORT](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.API_POSTGRES_USER](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.POSTGRES_HOST](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.POSTGRES_PASS](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.POSTGRES_USER](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.appinsights-key](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.appinsights-non-prod-key](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.appinsights_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.dg_password](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.dg_username](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.edit_password](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.edit_username](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.finalsa_storage_account_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.ingestsa_storage_account_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.sa_storage_account_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/key_vault_secret) | resource |
| [azurerm_management_lock.storage-backup-final](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/management_lock) | resource |
| [azurerm_management_lock.storage-backup-ingest](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/management_lock) | resource |
| [azurerm_management_lock.storage-backup-sa](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/management_lock) | resource |
| [azurerm_media_content_key_policy.ams_default_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/media_content_key_policy) | resource |
| [azurerm_media_services_account.ams](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/media_services_account) | resource |
| [azurerm_media_transform.EncodeToMP](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/media_transform) | resource |
| [azurerm_media_transform.analysevideo](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/media_transform) | resource |
| [azurerm_monitor_action_group.pre-support](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_diagnostic_setting.ams_1](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.storageblobfinalsa](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.storageblobingestsa](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.storageblobsa](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_metric_alert.postgres_alert_active_connections](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.postgres_alert_cpu](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.postgres_alert_failed_connections](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.postgres_alert_memory](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.postgres_alert_storage_utilization](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.storage_final_alert_capacity](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.storage_ingest_alert_capacity](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/monitor_metric_alert) | resource |
| [azurerm_private_dns_zone_virtual_network_link.ams_zone_link](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.ams_streamingendpoint_private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/private_endpoint) | resource |
| [azurerm_role_assignment.powerapp_appreg_final](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.powerapp_appreg_final_contrib](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.powerapp_appreg_finalbackup](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.powerapp_appreg_ingest](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.powerapp_appreg_ingest_contrib](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.powerapp_appreg_ingestfinal](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.powerapp_appreg_sa](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.powerapp_appreg_sa2](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.powerapp_appreg_sa_cont](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.powerapp_appreg_sabackup](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.sp_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.vm_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.vm_reader](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/role_assignment) | resource |
| [azurerm_storage_blob.b2c_copyright_png](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.b2c_favicon](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.b2c_login_css](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.b2c_login_html](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.b2c_logo_gov](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.b2c_mfa_css](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/storage_blob) | resource |
| [azurerm_storage_blob.b2c_mfa_html](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/storage_blob) | resource |
| [azurerm_virtual_machine_extension.aad](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.edit_init](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/resources/virtual_machine_extension) | resource |
| [random_password.dg_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.vm_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.dg_username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [random_string.vm_username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azuread_group.edit_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_group.pre_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_service_principal.pre_sp](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azurerm_bastion_host.bastion](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/data-sources/bastion_host) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/data-sources/client_config) | data source |
| [azurerm_key_vault.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.dynatrace-tenant-id](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.dynatrace-token](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.slack_monitoring_address](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.symmetrickey](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_log_analytics_workspace.loganalytics](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.datagateway_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/data-sources/subnet) | data source |
| [azurerm_subnet.endpoint_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/data-sources/subnet) | data source |
| [azurerm_subnet.jenkins_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/data-sources/subnet) | data source |
| [azurerm_subnet.pipelineagent_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/data-sources/subnet) | data source |
| [azurerm_subnet.videoedit_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/data-sources/subnet) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/data-sources/subscription) | data source |
| [azurerm_user_assigned_identity.managed_identity](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/data-sources/user_assigned_identity) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.75.0/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_subscription_id"></a> [aks\_subscription\_id](#input\_aks\_subscription\_id) | n/a | `string` | `"867a878b-cb68-4de5-9741-361ac9e178b6"` | no |
| <a name="input_apim_service_url"></a> [apim\_service\_url](#input\_apim\_service\_url) | The URL of the pre-api for the APIm service | `any` | n/a | yes |
| <a name="input_bastion_snet_address"></a> [bastion\_snet\_address](#input\_bastion\_snet\_address) | n/a | `any` | n/a | yes |
| <a name="input_cnp_vault_sub"></a> [cnp\_vault\_sub](#input\_cnp\_vault\_sub) | The subscription ID of the subscription that contains the CNP KeyVault | `any` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | n/a | `map(string)` | n/a | yes |
| <a name="input_cors_rules"></a> [cors\_rules](#input\_cors\_rules) | cors rule for final storage account | <pre>list(object({<br>    allowed_headers    = list(string)<br>    allowed_methods    = list(string)<br>    allowed_origins    = list(string)<br>    exposed_headers    = list(string)<br>    max_age_in_seconds = number<br>  }))</pre> | <pre>[<br>  {<br>    "allowed_headers": [<br>      "*"<br>    ],<br>    "allowed_methods": [<br>      "GET",<br>      "POST"<br>    ],<br>    "allowed_origins": [<br>      "https://*.justice.gov.uk",<br>      "https://*.blob.core.windows.net",<br>      "https://*.files.core.windows.net"<br>    ],<br>    "exposed_headers": [<br>      "*"<br>    ],<br>    "max_age_in_seconds": 600<br>  }<br>]</pre> | no |
| <a name="input_data_gateway_snet_address"></a> [data\_gateway\_snet\_address](#input\_data\_gateway\_snet\_address) | n/a | `any` | n/a | yes |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | n/a | `string` | `"pre-db"` | no |
| <a name="input_dg_vm_data_disks"></a> [dg\_vm\_data\_disks](#input\_dg\_vm\_data\_disks) | n/a | `any` | n/a | yes |
| <a name="input_dg_vm_private_ip"></a> [dg\_vm\_private\_ip](#input\_dg\_vm\_private\_ip) | n/a | `any` | n/a | yes |
| <a name="input_dns_resource_group"></a> [dns\_resource\_group](#input\_dns\_resource\_group) | Private DNS zone configuration (for postgres) | `string` | `"core-infra-intsvc-rg"` | no |
| <a name="input_dts_pre_backup_appreg_oid"></a> [dts\_pre\_backup\_appreg\_oid](#input\_dts\_pre\_backup\_appreg\_oid) | n/a | `any` | n/a | yes |
| <a name="input_dts_pre_ent_appreg_oid"></a> [dts\_pre\_ent\_appreg\_oid](#input\_dts\_pre\_ent\_appreg\_oid) | n/a | `any` | n/a | yes |
| <a name="input_dynatrace_server"></a> [dynatrace\_server](#input\_dynatrace\_server) | The server URL, if you want to configure an alternative communication endpoint. | `string` | `null` | no |
| <a name="input_edit_vm_data_disks"></a> [edit\_vm\_data\_disks](#input\_edit\_vm\_data\_disks) | n/a | `any` | n/a | yes |
| <a name="input_edit_vm_private_ip"></a> [edit\_vm\_private\_ip](#input\_edit\_vm\_private\_ip) | n/a | `any` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `any` | n/a | yes |
| <a name="input_hostgroup"></a> [hostgroup](#input\_hostgroup) | n/a | `any` | `null` | no |
| <a name="input_immutability_period_backup"></a> [immutability\_period\_backup](#input\_immutability\_period\_backup) | n/a | `any` | n/a | yes |
| <a name="input_install_dynatrace_oa"></a> [install\_dynatrace\_oa](#input\_install\_dynatrace\_oa) | n/a | `bool` | `true` | no |
| <a name="input_jenkins_AAD_objectId"></a> [jenkins\_AAD\_objectId](#input\_jenkins\_AAD\_objectId) | n/a | `any` | n/a | yes |
| <a name="input_jenkins_ptlsbox_appid"></a> [jenkins\_ptlsbox\_appid](#input\_jenkins\_ptlsbox\_appid) | n/a | `string` | `"a87b3880-6dce-4f9d-b4c4-c4cf3622cb5d"` | no |
| <a name="input_jenkins_ptlsbox_oid"></a> [jenkins\_ptlsbox\_oid](#input\_jenkins\_ptlsbox\_oid) | n/a | `string` | `"6df94cb5-c203-4493-bc8a-3f6aad1133e1"` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"UK South"` | no |
| <a name="input_location_backup"></a> [location\_backup](#input\_location\_backup) | n/a | `string` | `"UK West"` | no |
| <a name="input_mgmt_net_name"></a> [mgmt\_net\_name](#input\_mgmt\_net\_name) | n/a | `any` | n/a | yes |
| <a name="input_mgmt_net_rg_name"></a> [mgmt\_net\_rg\_name](#input\_mgmt\_net\_rg\_name) | n/a | `any` | n/a | yes |
| <a name="input_mgmt_subscription_id"></a> [mgmt\_subscription\_id](#input\_mgmt\_subscription\_id) | n/a | `any` | n/a | yes |
| <a name="input_num_datagateway"></a> [num\_datagateway](#input\_num\_datagateway) | n/a | `number` | `2` | no |
| <a name="input_num_vid_edit_vms"></a> [num\_vid\_edit\_vms](#input\_num\_vid\_edit\_vms) | n/a | `number` | `1` | no |
| <a name="input_pgsql_admin_username"></a> [pgsql\_admin\_username](#input\_pgsql\_admin\_username) | n/a | `string` | `"psqladmin"` | no |
| <a name="input_pgsql_storage_mb"></a> [pgsql\_storage\_mb](#input\_pgsql\_storage\_mb) | n/a | `string` | `"32768"` | no |
| <a name="input_powerbi_dg_vm_data_disks"></a> [powerbi\_dg\_vm\_data\_disks](#input\_powerbi\_dg\_vm\_data\_disks) | n/a | `any` | n/a | yes |
| <a name="input_powerbi_dg_vm_private_ip"></a> [powerbi\_dg\_vm\_private\_ip](#input\_powerbi\_dg\_vm\_private\_ip) | n/a | `any` | n/a | yes |
| <a name="input_pre_ent_appreg_app_id"></a> [pre\_ent\_appreg\_app\_id](#input\_pre\_ent\_appreg\_app\_id) | n/a | `any` | n/a | yes |
| <a name="input_private_dns_zone"></a> [private\_dns\_zone](#input\_private\_dns\_zone) | n/a | `string` | `"private.postgres.database.azure.com"` | no |
| <a name="input_privatendpt_snet_address"></a> [privatendpt\_snet\_address](#input\_privatendpt\_snet\_address) | n/a | `any` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | n/a | `string` | `"pre"` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `"sds"` | no |
| <a name="input_restore_policy_days"></a> [restore\_policy\_days](#input\_restore\_policy\_days) | n/a | `any` | n/a | yes |
| <a name="input_retention_duration"></a> [retention\_duration](#input\_retention\_duration) | n/a | `any` | n/a | yes |
| <a name="input_sa_account_tier"></a> [sa\_account\_tier](#input\_sa\_account\_tier) | n/a | `string` | `"Standard"` | no |
| <a name="input_sa_replication_type"></a> [sa\_replication\_type](#input\_sa\_replication\_type) | n/a | `string` | `"GRS"` | no |
| <a name="input_schedules"></a> [schedules](#input\_schedules) | n/a | <pre>list(object({<br>    name      = string<br>    frequency = string<br>    interval  = number<br>    run_time  = string<br>    start_vm  = bool<br>  }))</pre> | `[]` | no |
| <a name="input_server"></a> [server](#input\_server) | n/a | `any` | `null` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | n/a | `any` | n/a | yes |
| <a name="input_video_edit_vm_snet_address"></a> [video\_edit\_vm\_snet\_address](#input\_video\_edit\_vm\_snet\_address) | n/a | `any` | n/a | yes |
| <a name="input_vm_type"></a> [vm\_type](#input\_vm\_type) | n/a | `string` | `"windows"` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | n/a | `any` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Availability Zone for Postgres | `string` | `"1"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->