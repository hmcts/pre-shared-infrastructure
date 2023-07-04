param (
    [string]$recoveryKey,
    [string]$clientSecret,
    [string]$clientId,
    [string]$tenantId,
    [string]$userIDToAddasAdmin,
    [string]$gatewayName,
    [int]$gatewayNumber
)

# NuGet
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name PackageManagement -Force

# Install npgsql 4.0.10 to the GAC
$Url = "https://github.com/npgsql/npgsql/releases/download/v4.0.10/Npgsql-4.0.10.msi"
$Filename = "Npgsql-4.0.10.msi"
Invoke-WebRequest -Uri $Url -OutFile $Filename
Start-Process -Wait -FilePath "msiexec.exe" -ArgumentList "/i $Filename /quiet ADDLOCAL=ALL GAC_INSTALL=1"
Remove-Item $Filename

# Az Cli
Invoke-WebRequest -Uri https://aka.ms/vs/16/release/vc_redist.x64.exe -OutFile vc_redist.x64.exe
.\vc_redist.x64.exe /quiet /install
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'

# install powershell 7
Invoke-Expression "& { $(Invoke-RestMethod 'https://aka.ms/install-powershell.ps1') } –useMSI -EnablePSRemoting -Quiet"

#Powershell 7
# Define the download URL for PowerShell 7 MSI installer
# $downloadUrl = "https://github.com/PowerShell/PowerShell/releases/download/v7.2.0/PowerShell-7.2.0-win-x64.msi"

# # Define the temporary file path for downloading the installer
# $tempFile = "$env:TEMP\PowerShell-7.2.0-win-x64.msi"

# # Download the PowerShell 7 installer
# Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile

# # Install PowerShell 7 using the downloaded installer
# Start-Process -Wait -FilePath msiexec.exe -ArgumentList "/i `"$tempFile`" /qn"

# # Remove the temporary installer file
# Remove-Item -Path $tempFile -Force

Write-Host "PowerShell 7 has been installed"

# Install Dotnet Framework 4.8
Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2088631" -OutFile dotnet-install.exe
Start-Process -Wait -FilePath "dotnet-install.exe" -ArgumentList "/q /norestart"

Set-ExecutionPolicy Bypass -Scope Process -Force
# use Powershell 7 from this point
pwsh

$Psversion = (Get-Host).Version
if ($Psversion.Major -ge 7)
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