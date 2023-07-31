iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

$newPath = "C:\ProgramData\chocolatey\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
[Environment]::SetEnvironmentVariable("Path", "$newPath;$currentPath", "Machine")
Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1

Start-Sleep -Seconds 5

choco feature enable -n allowGlobalConfirmation;
choco install ffmpeg;
choco install microsoftazurestorageexplorer;
choco install azure-cli;
choco install 7zip.install;
choco install openssh;
refreshenv;