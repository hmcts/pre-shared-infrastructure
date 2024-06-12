# Azure B2C

The purpose of this document is to outline how the Azure B2C infrastructure is stood up.

## Tenant
Tenant creation is automated, our instances of App Registrations exist on shared tenants which are created [via Terraform](https://github.com/hmcts/azure-b2c-tenant/tree/master) and administered by PlatOps.

## App Registration
Creating the app registration is a manual process, follow the [Microsoft documentation](https://learn.microsoft.com/en-us/azure/active-directory-b2c/tutorial-register-applications).
Currently, the name of our app registration is ```pre-portal-sso```.
The creation of the supporting app registrations which enable us to use custom policies is automated via the [Identity Experience Framework setup tool](https://b2ciefsetupapp.azurewebsites.net/) developed by Microsoft.

## Custom Policies
Uploading of custom policies is automated via a manually triggered GitHub Action. Each environment has its own set of policies to facilitate testing of changes, they can be found under the custom_policies directory.

When updating custom policies, it can take a long time for the changes to be realised in the portal. This is expected behaviour due to caching, further information can be found in the [Microsoft docs](https://learn.microsoft.com/en-us/azure/active-directory-b2c/best-practices#operations%22https://learn.microsoft.com/en-us/azure/active-directory-b2c/best-practices#operations%22).

## Custom Template
The static files for the B2C display template (html, css, etc) are hosted in the presa\<env> storage account. The files can be found under the views directory.
