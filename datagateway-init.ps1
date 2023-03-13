$url = "https://go.microsoft.com/fwlink/?LinkId=2116849&clcid=0x409"
$output = "$env:USERPROFILE\Downloads\MicrosoftDataGatewayInstaller.exe"

Invoke-WebRequest -Uri $url -OutFile $output

& $output /silent /install