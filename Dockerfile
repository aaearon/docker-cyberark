FROM mcr.microsoft.com/windows/servercore:ltsc2019

# https://github.com/StefanScherer/dockerfiles-windows/blob/95d291587a545abde49707aba554968897291f62/dotnet/Dockerfile#L7-L10
RUN curl -fSLo dotnet-framework-installer.exe https://download.visualstudio.microsoft.com/download/pr/7afca223-55d2-470a-8edc-6a1739ae3252/abd170b4b0ec15ad0222a809b761a036/ndp48-x86-x64-allos-enu.exe && \
    .\dotnet-framework-installer.exe /q && \
    del .\dotnet-framework-installer.exe  && \
    powershell Remove-Item -Force -Recurse ${Env:TEMP}\*

USER ContainerAdministrator

SHELL ["powershell"]

ARG CPM_INSTALLATION_ARCHIVE="Central Policy Manager-Rls-v12.1.1.zip"
ENV VAULT_USER='Administrator'
ENV VAULT_PASS='banana'
ENV PVWA_URL='https://comp01/'
ENV ACCEPT_EULA='yes'
ENV VAULT_IP='192.168.0.50'
ENV CPM_USERNAME='CPM_docker'

COPY ["InstallFiles/${CPM_INSTALLATION_ARCHIVE}", "/tmp/"]
COPY ["Update-XmlConfig.ps1", "/tmp/"]

RUN ["powershell", "Expand-Archive", "/tmp/$Env:CPM_INSTALLATION_ARCHIVE","-DestinationPath", "/tmp", "-Force"]

WORKDIR /tmp/InstallationAutomation/Installation
RUN ["powershell", "/tmp/InstallationAutomation/Installation/CPMInstallation.ps1"]

COPY ["run.ps1", "/app/"]
ENTRYPOINT ["powershell", "/app/run.ps1"]
