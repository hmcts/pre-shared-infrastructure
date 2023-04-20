# #.NET 6
# Invoke-WebRequest -Uri https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.ps1 -OutFile dotnet-install.ps1
# .\dotnet-install.ps1 -Channel STS


# #Data Gateway
# $url = "https://go.microsoft.com/fwlink/?LinkId=2116849&clcid=0x409"
# $output = "$env:USERPROFILE\Downloads\MicrosoftDataGatewayInstaller.exe"

# Invoke-WebRequest -Uri $url -OutFile $output

# & $output /silent /install

# # need npgsql 4.0.13

$Psversion = (Get-Host).Version

if($Psversion.Major -ge 7)
{

if (!(Get-Module "DataGateway")) {
Install-Module -Name DataGateway
}

# Connect to Azure and select the key vault
Connect-AzAccount
$VaultName = "pre-dev"

$recoverySecretName = "dg1-recovery-key"
$recoverySecret = Get-AzKeyVaultSecret -VaultName $VaultName -Name $recoverySecretName
$recoverySecretValue = $recoverySecret.SecretValueText

$passwordSecretName = "bi-dg1-password"
$passwordSecret = Get-AzKeyVaultSecret -VaultName $VaultName -Name $passwordSecretName
$passwordSecretValue = $recoverySecret.SecretValueText

$securePassword =  $passwordSecretValue
$ApplicationId ="7394ca1a-31de-4433-beca-2ca1a2043d5c";
$Tenant = "531ff96d-0ae9-462a-8d2d-bec7c0b42082";
$GatewayName = "PowerBI-dg-dev";
$RecoverKey = $recoverySecretValue
$userIDToAddasAdmin = "3083d1ef-be3d-4c21-a98a-ce52b97dcdc3"


#Gateway Login

Connect-DataGatewayServiceAccount -ApplicationId $ApplicationId -ClientSecret $securePassword  -Tenant $Tenant


#Installing Gateway

Install-DataGateway -AcceptConditions


#Configuring Gateway

$GatewayDetails = Add-DataGatewayCluster -Name $GatewayName -RecoveryKey  $RecoverKey


#Add User as Admin
Add-DataGatewayClusterUser -GatewayClusterId $GatewayDetails.GatewayObjectId -PrincipalObjectId $userIDToAddasAdmin -AllowedDataSourceTypes $null -Role Admin

}
else{
exit 1
}
