# Find the Dockerfile for mcr.microsoft.com/azure-functions/powershell:3.0-powershell${VARIANT}-core-tools at this URL
# https://github.com/Azure/azure-functions-docker/blob/dev/host/3.0/buster/amd64/powershell

# Update the VARIANT arg in devcontainer.json to pick a supported PowerShell version: 7, 6
ARG VARIANT=7
FROM mcr.microsoft.com/azure-functions/powershell:3.0-powershell${VARIANT}-core-tools
RUN sudo apt install nmap -y
RUN sudo apt install -y azurecli
RUN install-module az
RUN import-module az
RUN install-module azuread
RUN import-module azuread
RUN . ./PsSec.ps1



