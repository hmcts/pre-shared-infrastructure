$Psversion = (Get-Host).Version
if($Psversion.Major -ge 7)
{
    if (!(Get-Module "DataGateway")) {
        Install-Module -Name DataGateway -Force
    }

    # Connect to Azure and select the key vault

    # Gateway Login
    Connect-DataGatewayServiceAccount -ApplicationId $ApplicationId -ClientSecret $clientSecret -Tenant $Tenant

    Write-Host 1

    # Install Gateway
    Install-DataGateway -AcceptConditions

    Write-Host 2

    # Configure Gateway
    $GatewayDetails = Add-DataGatewayCluster -OverwriteExistingGateway -RegionKey uksouth -Name $GatewayName -RecoveryKey $recoveryKey

    $gateway = (Get-DataGatewayCluster -RegionKey uksouth)[$gatewayNumber].Id

    Write-Host 3

    # Add User as Admin
    Add-DataGatewayClusterUser -GatewayClusterId $gateway -PrincipalObjectId $userIDToAddasAdmin -AllowedDataSourceTypes $null -Role Admin -RegionKey uksouth
}
else {
    exit 1
}
