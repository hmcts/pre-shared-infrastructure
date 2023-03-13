#.NET 6
Invoke-WebRequest -Uri https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.ps1 -OutFile dotnet-install.ps1
.\dotnet-install.ps1 -Channel STS


#Data Gateway
$url = "https://go.microsoft.com/fwlink/?LinkId=2116849&clcid=0x409"
$output = "$env:USERPROFILE\Downloads\MicrosoftDataGatewayInstaller.exe"

Invoke-WebRequest -Uri $url -OutFile $output

& $output /silent /install