#!/bin/bash

# Download .NET
curl -LJO https://dotnet.microsoft.com/download/dotnet-core/thank-you/runtime-desktop-3.1.10-windows-x64-installer

# Install .NET
dotnet-runtime-desktop-3.1.10-windows-x64-installer.exe /quiet

# Clean up
rm dotnet-runtime-desktop-3.1.10-windows-x64-installer.exe

# Download Data Gateway
curl -LJO https://aka.ms/gatewayinstaller

# Install Data Gateway
MicrosoftDataGatewayInstaller.exe /quiet

# Clean up
rm MicrosoftDataGatewayInstaller.exe

# Download Npgsql 4.0.10.0
curl -LJO https://github.com/npgsql/npgsql/releases/download/v4.0.10.0/Npgsql.4.0.10.0.nupkg

# Install Npgsql
dotnet add package Npgsql.4.0.10.0.nupkg

# Clean up
rm Npgsql.4.0.10.0.nupkg

echo 'Installation complete.'