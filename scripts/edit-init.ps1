iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

$newPath = "C:\ProgramData\chocolatey\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
[Environment]::SetEnvironmentVariable("Path", "$newPath;$currentPath", "Machine")

Start-Sleep -Seconds 5

# Install platform required packages and modules from
# https://raw.githubusercontent.com/hmcts/CIS-harderning/master/windows-install.ps1
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -force
Install-Module -Name AuditPolicyDsc -force
Install-Module -Name SecurityPolicyDsc -force
Install-Module -Name NetworkingDsc -force
Install-Module -Name PSDesiredStateConfiguration -force

# Install PRE specific requirements
choco feature enable -n allowGlobalConfirmation;
choco install ffmpeg;
choco install microsoftazurestorageexplorer;
choco install azure-cli;