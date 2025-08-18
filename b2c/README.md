# Azure B2C

The purpose of this document is to outline how the Azure B2C infrastructure is stood up.

## This repo is public

Be aware that this repository is public and visible to the world.

## Initial set up

### Tenant
Tenant creation is automated, our instances of App Registrations exist on shared tenants which are created [via Terraform](https://github.com/hmcts/azure-b2c-tenant/tree/master) and administered by PlatOps.

### App Registration
Creating the app registration is a manual process, follow the [Microsoft documentation](https://learn.microsoft.com/en-us/azure/active-directory-b2c/tutorial-register-applications).
Currently, the name of our app registration is ```pre-portal-sso```.

We're not sure what ```pre-management-sso``` is. See [S28-4231](https://tools.hmcts.net/jira/browse/S28-4231).

The creation of the supporting app registrations which enable us to use custom policies is automated via the [Identity Experience Framework setup tool](https://b2ciefsetupapp.azurewebsites.net/) developed by Microsoft.

### Keys

See https://github.com/hmcts/pre-shared-infrastructure/settings/secrets/actions

Also see https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/Credentials/appId/d20a7462-f222-46b8-a363-d2e30eb274eb/isMSAApp~/false

We don't usually need to worry about keys as platops handles it.

## Permissions
We have not been granted permission by platops to manually upload policies via the Azure portal. If more permissions are needed, they can be requested. See [Slack thread](https://hmcts-reform.slack.com/archives/C8SR5CAMU/p1749134058306959) for background.


## Routine development

### Custom Policies

Uploading of custom policies is automated via a manually triggered GitHub Action. See [workflows definitions](https://github.com/hmcts/pre-shared-infrastructure/tree/master/.github/workflows). These files are run by [Github Actions](https://github.com/hmcts/pre-shared-infrastructure/actions/workflows/b2c_custom_policiesV2.yml).

Each environment has its own set of policies to facilitate testing of changes, they can be found under the custom_policies directory. E.g. staging's policy allows skipping 2FA to allow automated test accounts.

When updating custom policies, it can take a long time for the changes to be realised in the portal. This is expected behaviour due to caching, further information can be found in the [Microsoft docs](https://learn.microsoft.com/en-us/azure/active-directory-b2c/best-practices#operations%22https://learn.microsoft.com/en-us/azure/active-directory-b2c/best-practices#operations%22).

To test policies on different environments, you can change the code on your own branch in the staging folder, then use the Github action to push it to staging.

### B2C HTML injection
The main content of the B2C screens is injected by Microsoft. We don't own or maintain or edit the HTML content of these files. The best we can do is edit and style them via JavaScript and CSS.

The files under b2c_injection_reference are to assist with local development work e.g. styling, but they are not used for 'real' B2C.

### Custom Templates

The static files for the B2C display template (html, css, etc) are hosted in the presa\<env> storage account. The files can be found under the views directory.

You can use Azure Storage Explorer to look at and edit these files.

The files are deployed by the [CI/CD pipeline](https://sds-build.hmcts.net/job/HMCTS/job/pre-portal/).

### Manual deployment

If necessary for pre-merge testing, the files can be manually uploaded to e.g. the staging storage account using Azure Storage Explorer.  However, they will be overwritten if the portal is redeployed to that environment.

If deployment manually, you will need to substitute `{env}` in the files with `dev`, `stg`, `demo` or `prod`.


## Quirks

### Darts
We share a B2C instance with darts. We occasionally get darts-related alerts. Ignore them.

### CJSM email address
At the moment, B2C triggers the emails with TOTP verification codes. CJSM doesn't like receiving emails from externals. We could use API to check if users exist, and then trigger the TOTP emails from the API instead. This will then allow us to use the CJSM accounts again, which would be good from a security perspective. If we're sending to a CJSM account, we can make some big assumptions that we know that this is definitely going to be somebody that should be getting it because CJSM accounts are not easy to get. This calling of the API would be done through XML config.

Alternatively we could integrate B2C with Gov.Notify instead: use URO + custom policy + OAuth, route through the APIM because B2C is in a separate directory.

### Callbacks

See [pre-portal-sso > Authentication tab](https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/Authentication/appId/d20a7462-f222-46b8-a363-d2e30eb274eb/isMSAApp~/false)

This only applies to staging env.

Every time we open up a pull request on the portal, we need the portal to be able to log into the staging B2C and go back to that same PR.


## Troubleshooting


### Users

You can see a list of B2C registered users under Azure AD B2C > All users: https://portal.azure.com/#view/Microsoft_AAD_UsersAndTenants/UserManagementMenuBlade/~/AllUsers

### Bookmarks
A common bug we get is where some users bookmark B2C rather than the portal itself. This means they don't get the token sent from the portal, and the B2C doesn't know how to redirect them back to the portal. Solution: the user needs to start from the portal homepage, not from B2C.
