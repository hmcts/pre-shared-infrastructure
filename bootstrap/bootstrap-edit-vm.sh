#! /bin/bash

# Install Azure CLI
curl -L https://aka.ms/InstallAzureCli | bash

# Install FFmpeg
wget https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-latest-win64-static.zip
unzip ffmpeg-latest-win64-static.zip
mv ffmpeg-*-win64-static/bin/ffmpeg.exe /usr/bin
rm -rf ffmpeg-latest-win64-static.zip ffmpeg-*-win64-static

# Install Storage Explorer
wget https://go.microsoft.com/fwlink/?linkid=2103511 -O Microsoft.AzureStorageExplorer.msi
msiexec /i Microsoft.AzureStorageExplorer.msi /qn
rm -rf Microsoft.AzureStorageExplorer.msi

# Verify installation
az --version
ffmpeg -version
SeExplorer -version