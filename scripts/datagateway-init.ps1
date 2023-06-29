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
$Psversion = (Get-Host).Version

# Define the download URL for PowerShell 7 MSI installer
$downloadUrl = "https://github.com/PowerShell/PowerShell/releases/download/v7.2.0/PowerShell-7.2.0-win-x64.msi"

# Define the temporary file path for downloading the installer
$tempFile = "$env:TEMP\PowerShell-7.2.0-win-x64.msi"

# Download the PowerShell 7 installer
Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile

# Install PowerShell 7 using the downloaded installer
Start-Process -Wait -FilePath msiexec.exe -ArgumentList "/i `"$tempFile`" /qn"

# Remove the temporary installer file
Remove-Item -Path $tempFile -Force

# Verify the installed version
$pwshPath = Join-Path -Path $env:ProgramFiles -ChildPath "PowerShell\7\pwsh.exe"

Write-Host "PowerShell 7 has been installed"

# Install Dotnet Framework 4.8
Invoke-WebRequest -Uri "https://go.microsoft.com/fwlink/?linkid=2088631" -OutFile dotnet-install.exe
Start-Process -Wait -FilePath "dotnet-install.exe" -ArgumentList "/q"



# az login --service-principal --username $clientId --password $clientSecret --tenant $tenantId

# # Execute another PowerShell script with PowerShell 7
# $scriptPath = "C:\path\to\anotherScript.ps1"
# Start-Process pwsh -ArgumentList "-File $scriptPath" -Wait
