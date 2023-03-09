# pre product infrastructure
Pre-Recorded Evidence Project - Core infrastructure

The infrastructure for PRE is brought up in 3 stages:
1. https://github.com/hmcts/pre-network
2. https://github.com/hmcts/pre-vault
3. https://github.com/hmcts/pre-shared-infrastructure  - YOU ARE HERE

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
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 3.37.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.2.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.36.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.37.0 |
| <a name="provider_azurerm.mgmt"></a> [azurerm.mgmt](#provider\_azurerm.mgmt) | 3.37.0 |
| <a name="provider_azurerm.oms"></a> [azurerm.oms](#provider\_azurerm.oms) | 3.37.0 |
| <a name="provider_azurerm.private_dns"></a> [azurerm.private\_dns](#provider\_azurerm.private\_dns) | 3.37.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_data_gateway_vm"></a> [data\_gateway\_vm](#module\_data\_gateway\_vm) | git@github.com:hmcts/terraform-vm-module.git | master |
| <a name="module_data_store_db_v14"></a> [data\_store\_db\_v14](#module\_data\_store\_db\_v14) | git@github.com:hmcts/terraform-module-postgresql-flexible.git | master |
| <a name="module_dynatrace-oneagent-edit"></a> [dynatrace-oneagent-edit](#module\_dynatrace-oneagent-edit) | git@github.com:hmcts/terraform-module-vm-bootstrap.git | master |
| <a name="module_finalsa_storage_account"></a> [finalsa\_storage\_account](#module\_finalsa\_storage\_account) | git@github.com:hmcts/cnp-module-storage-account | master |
| <a name="module_ingestsa_storage_account"></a> [ingestsa\_storage\_account](#module\_ingestsa\_storage\_account) | git@github.com:hmcts/cnp-module-storage-account | master |
| <a name="module_log_analytics_workspace"></a> [log\_analytics\_workspace](#module\_log\_analytics\_workspace) | git@github.com:hmcts/terraform-module-log-analytics-workspace-id.git | master |
| <a name="module_sa_storage_account"></a> [sa\_storage\_account](#module\_sa\_storage\_account) | git@github.com:hmcts/cnp-module-storage-account | master |

## Resources

| Name | Type |
|------|------|
| [azurerm_automation_account.pre-aa](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/automation_account) | resource |
| [azurerm_dev_test_global_vm_shutdown_schedule.dtgtwyvm](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/dev_test_global_vm_shutdown_schedule) | resource |
| [azurerm_key_vault_secret.POSTGRES_PASS](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.POSTGRES_USER](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.finalsa_storage_account_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.ingestsa_storage_account_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.sa_storage_account_connection_string](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/key_vault_secret) | resource |
| [azurerm_managed_disk.vmdatadisk](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/managed_disk) | resource |
| [azurerm_media_services_account.ams](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/media_services_account) | resource |
| [azurerm_media_transform.EncodeToMP](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/media_transform) | resource |
| [azurerm_media_transform.analysevideo](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/media_transform) | resource |
| [azurerm_monitor_diagnostic_setting.ams_1](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.storageblobfinalsa](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.storageblobingestsa](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.storageblobsa](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/network_interface) | resource |
| [azurerm_private_dns_zone_virtual_network_link.postgres_dg](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_virtual_machine_data_disk_attachment.vmdatadisk](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_extension.aad](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.edit](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/resources/windows_virtual_machine) | resource |
| [azuread_groups.groups](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/groups) | data source |
| [azuread_groups.pre-groups](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/groups) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/data-sources/client_config) | data source |
| [azurerm_disk_encryption_set.pre-des](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/data-sources/disk_encryption_set) | data source |
| [azurerm_key_vault.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/data-sources/key_vault) | data source |
| [azurerm_key_vault_secret.dtgtwy_password](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.dtgtwy_username](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.dynatrace-tenant-id](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.dynatrace-token](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.vm_password](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_key_vault_secret.vm_username](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/data-sources/key_vault_secret) | data source |
| [azurerm_log_analytics_workspace.loganalytics](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.datagateway_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/data-sources/subnet) | data source |
| [azurerm_subnet.endpoint_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/data-sources/subnet) | data source |
| [azurerm_subnet.jenkins_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/data-sources/subnet) | data source |
| [azurerm_subnet.pipelineagent_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/data-sources/subnet) | data source |
| [azurerm_subnet.videoedit_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/data-sources/subnet) | data source |
| [azurerm_user_assigned_identity.managed_identity](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/data-sources/user_assigned_identity) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/3.37.0/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_DNSResGroup"></a> [DNSResGroup](#input\_DNSResGroup) | Private DNS zone configuration (for postgres) | `string` | `"core-infra-intsvc-rg"` | no |
| <a name="input_PrivateDNSZone"></a> [PrivateDNSZone](#input\_PrivateDNSZone) | n/a | `string` | `"private.postgres.database.azure.com"` | no |
| <a name="input_bastion_snet_address"></a> [bastion\_snet\_address](#input\_bastion\_snet\_address) | n/a | `any` | n/a | yes |
| <a name="input_common_tags"></a> [common\_tags](#input\_common\_tags) | n/a | `map(string)` | n/a | yes |
| <a name="input_cors_rules"></a> [cors\_rules](#input\_cors\_rules) | cors rule for final storage account | <pre>list(object({<br>    allowed_headers    = list(string)<br>    allowed_methods    = list(string)<br>    allowed_origins    = list(string)<br>    exposed_headers    = list(string)<br>    max_age_in_seconds = number<br>  }))</pre> | <pre>[<br>  {<br>    "allowed_headers": [<br>      "*"<br>    ],<br>    "allowed_methods": [<br>      "GET",<br>      "POST"<br>    ],<br>    "allowed_origins": [<br>      "https://*.justice.gov.uk",<br>      "https://*.blob.core.windows.net",<br>      "https://*.files.core.windows.net"<br>    ],<br>    "exposed_headers": [<br>      "*"<br>    ],<br>    "max_age_in_seconds": 600<br>  }<br>]</pre> | no |
| <a name="input_data_gateway_snet_address"></a> [data\_gateway\_snet\_address](#input\_data\_gateway\_snet\_address) | n/a | `any` | n/a | yes |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | n/a | `string` | `"pre-db"` | no |
| <a name="input_datagateway_spec"></a> [datagateway\_spec](#input\_datagateway\_spec) | n/a | `string` | `"Standard_F8s_v2"` | no |
| <a name="input_dts_pre_app_admin"></a> [dts\_pre\_app\_admin](#input\_dts\_pre\_app\_admin) | n/a | `any` | n/a | yes |
| <a name="input_dts_pre_ent_appreg_oid"></a> [dts\_pre\_ent\_appreg\_oid](#input\_dts\_pre\_ent\_appreg\_oid) | n/a | `any` | n/a | yes |
| <a name="input_dynatrace_server"></a> [dynatrace\_server](#input\_dynatrace\_server) | The server URL, if you want to configure an alternative communication endpoint. | `string` | `null` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `any` | n/a | yes |
| <a name="input_hostgroup"></a> [hostgroup](#input\_hostgroup) | n/a | `any` | `null` | no |
| <a name="input_install_dynatrace_oa"></a> [install\_dynatrace\_oa](#input\_install\_dynatrace\_oa) | n/a | `bool` | `true` | no |
| <a name="input_ip_rules"></a> [ip\_rules](#input\_ip\_rules) | PowerPlatformInfra.UKSouth | `list(string)` | <pre>[<br>  "20.49.145.249/30",<br>  "20.49.166.40/30",<br>  "20.49.166.118/30",<br>  "20.49.166.129/30",<br>  "20.49.244.238/30",<br>  "20.58.70.192/27",<br>  "20.58.70.224/28",<br>  "20.90.125.211",<br>  "20.90.124.134",<br>  "20.90.129.0/27",<br>  "20.90.129.32/28",<br>  "20.90.131.0/26",<br>  "20.90.131.64/27",<br>  "20.90.131.120/29",<br>  "20.90.169.112/30",<br>  "20.108.81.107/30",<br>  "51.11.24.198/30",<br>  "51.11.25.68/30",<br>  "51.11.25.172/30",<br>  "51.11.172.30/30",<br>  "51.11.172.56/30",<br>  "51.11.172.160/30",<br>  "51.104.30.172/30",<br>  "51.104.30.192/26",<br>  "51.104.31.0/27",<br>  "51.104.31.32/28",<br>  "51.104.31.48/29",<br>  "51.104.31.64/26",<br>  "51.104.248.11/30",<br>  "51.132.161.225/30",<br>  "51.132.215.162/30",<br>  "51.132.215.182/30",<br>  "51.143.208.216/29",<br>  "51.145.104.29/30",<br>  "51.140.77.227",<br>  "51.140.245.29",<br>  "51.140.80.51",<br>  "51.140.61.124",<br>  "51.141.47.105",<br>  "51.141.124.13",<br>  "51.105.77.96/27",<br>  "51.140.148.0/28",<br>  "51.140.211.0/28",<br>  "51.140.212.224/27"<br>]</pre> | no |
| <a name="input_jenkins_AAD_objectId"></a> [jenkins\_AAD\_objectId](#input\_jenkins\_AAD\_objectId) | n/a | `any` | n/a | yes |
| <a name="input_jenkins_ptlsbox_appid"></a> [jenkins\_ptlsbox\_appid](#input\_jenkins\_ptlsbox\_appid) | n/a | `string` | `"a87b3880-6dce-4f9d-b4c4-c4cf3622cb5d"` | no |
| <a name="input_jenkins_ptlsbox_oid"></a> [jenkins\_ptlsbox\_oid](#input\_jenkins\_ptlsbox\_oid) | n/a | `string` | `"6df94cb5-c203-4493-bc8a-3f6aad1133e1"` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"UK South"` | no |
| <a name="input_mgmt_net_name"></a> [mgmt\_net\_name](#input\_mgmt\_net\_name) | n/a | `any` | n/a | yes |
| <a name="input_mgmt_net_rg_name"></a> [mgmt\_net\_rg\_name](#input\_mgmt\_net\_rg\_name) | n/a | `any` | n/a | yes |
| <a name="input_mgmt_subscription_id"></a> [mgmt\_subscription\_id](#input\_mgmt\_subscription\_id) | n/a | `any` | n/a | yes |
| <a name="input_num_datagateway"></a> [num\_datagateway](#input\_num\_datagateway) | n/a | `number` | `2` | no |
| <a name="input_num_vid_edit_vms"></a> [num\_vid\_edit\_vms](#input\_num\_vid\_edit\_vms) | n/a | `number` | `2` | no |
| <a name="input_pgsql_admin_username"></a> [pgsql\_admin\_username](#input\_pgsql\_admin\_username) | n/a | `string` | `"psqladmin"` | no |
| <a name="input_pgsql_sku"></a> [pgsql\_sku](#input\_pgsql\_sku) | n/a | `string` | `"GP_Standard_D2s_v3"` | no |
| <a name="input_pgsql_storage_mb"></a> [pgsql\_storage\_mb](#input\_pgsql\_storage\_mb) | n/a | `string` | `"32768"` | no |
| <a name="input_power_app_user_oid"></a> [power\_app\_user\_oid](#input\_power\_app\_user\_oid) | n/a | `string` | `"56a29187-3d5f-4262-99d6-c635776e0eac"` | no |
| <a name="input_privatendpt_snet_address"></a> [privatendpt\_snet\_address](#input\_privatendpt\_snet\_address) | n/a | `any` | n/a | yes |
| <a name="input_product"></a> [product](#input\_product) | n/a | `string` | `"pre"` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `"sds"` | no |
| <a name="input_sa_account_tier"></a> [sa\_account\_tier](#input\_sa\_account\_tier) | n/a | `string` | `"Standard"` | no |
| <a name="input_sa_replication_type"></a> [sa\_replication\_type](#input\_sa\_replication\_type) | n/a | `string` | `"GRS"` | no |
| <a name="input_schedules"></a> [schedules](#input\_schedules) | n/a | <pre>list(object({<br>    name      = string<br>    frequency = string<br>    interval  = number<br>    run_time  = string<br>    start_vm  = bool<br>  }))</pre> | `[]` | no |
| <a name="input_server"></a> [server](#input\_server) | n/a | `any` | `null` | no |
| <a name="input_subscription"></a> [subscription](#input\_subscription) | n/a | `string` | `""` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | n/a | `any` | n/a | yes |
| <a name="input_vid_edit_vm_spec"></a> [vid\_edit\_vm\_spec](#input\_vid\_edit\_vm\_spec) | n/a | `string` | `"Standard_E4s_v4"` | no |
| <a name="input_video_edit_vm_snet_address"></a> [video\_edit\_vm\_snet\_address](#input\_video\_edit\_vm\_snet\_address) | n/a | `any` | n/a | yes |
| <a name="input_vm_data_disks"></a> [vm\_data\_disks](#input\_vm\_data\_disks) | n/a | `any` | n/a | yes |
| <a name="input_vm_private_ip"></a> [vm\_private\_ip](#input\_vm\_private\_ip) | n/a | `any` | n/a | yes |
| <a name="input_vm_type"></a> [vm\_type](#input\_vm\_type) | n/a | `string` | `"windows"` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | n/a | `any` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | Availability Zone for Postgres | `string` | `"1"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->