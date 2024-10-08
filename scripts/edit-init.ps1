iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

$newPath = "C:\ProgramData\chocolatey\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
[Environment]::SetEnvironmentVariable("Path", "$newPath;$currentPath", "Machine")

Start-Sleep -Seconds 5

# Install PRE specific requirements
choco feature enable -n allowGlobalConfirmation;
choco install ffmpeg;
choco install microsoftazurestorageexplorer;
choco install azure-cli;