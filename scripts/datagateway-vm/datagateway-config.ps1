param (
    [string]$recoveryKey,
    [string]$clientSecret,
    [string]$clientId,
    [string]$tenantId,
    [string]$userIDToAddasAdmin,
    [string]$gatewayName,
    [int]$gatewayNumber
)

$Psversion = (Get-Host).Version
if($Psversion.Major -ge 7)
{
    if (!(Get-Module "DataGateway")) {
        Install-Module -Name DataGateway -Force
    }

    # Connect to Azure and select the key vault

    # Gateway Login
    Connect-DataGatewayServiceAccount -ApplicationId $clientId -ClientSecret $clientSecret -Tenant $Tenant

    # Install Gateway
    Install-DataGateway -AcceptConditions

    # Configure Gateway
    Add-DataGatewayCluster -OverwriteExistingGateway -RegionKey uksouth -Name $GatewayName -RecoveryKey $recoveryKey

    $gateway = (Get-DataGatewayCluster -RegionKey uksouth)[$gatewayNumber].Id

    # Add User as Admin
    Add-DataGatewayClusterUser -GatewayClusterId $gateway -PrincipalObjectId $userIDToAddasAdmin -AllowedDataSourceTypes $null -Role Admin -RegionKey uksouth
}
else {
    exit 1
}