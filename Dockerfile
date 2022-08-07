FROM mcr.microsoft.com/windows/servercore:ltsc2019
USER ContainerAdministrator

ARG CPM_INSTALLATION_ARCHIVE="Central Policy Manager-Rls-v12.6.zip"

# https://github.com/StefanScherer/dockerfiles-windows/blob/95d291587a545abde49707aba554968897291f62/dotnet/Dockerfile#L7-L10
RUN curl -fSLo dotnet-framework-installer.exe https://download.visualstudio.microsoft.com/download/pr/7afca223-55d2-470a-8edc-6a1739ae3252/abd170b4b0ec15ad0222a809b761a036/ndp48-x86-x64-allos-enu.exe && \
    .\dotnet-framework-installer.exe /q && \
    del .\dotnet-framework-installer.exe  && \
    powershell Remove-Item -Force -Recurse ${Env:TEMP}\*

COPY ["InstallFiles/Central Policy Manager-Rls-v12.1.1.zip", "/tmp/"]
COPY ["Update-XmlConfig.ps1", "/tmp/"]

RUN ["powershell", "Expand-Archive", "'/tmp/Central Policy Manager-Rls-v12.1.1.zip'","-DestinationPath", "/tmp", "-Force"]

WORKDIR /tmp/InstallationAutomation/Installation
RUN ["powershell", "/tmp/Update-XmlConfig.ps1", "-File", "/tmp/InstallationAutomation/Installation/InstallationConfig.xml", "-ParameterNameValueHashtable", "@{Company = 'ioSharp'}"]
RUN ["powershell", "/tmp/InstallationAutomation/Installation/CPMInstallation.ps1"]

WORKDIR /tmp/InstallationAutomation/Registration
RUN ["powershell", "/tmp/Update-XmlConfig.ps1", "-File", "/tmp/InstallationAutomation/Registration/CPMRegisterComponentConfig.xml", "-ParameterNameValueHashtable", "@{acceptEula = 'yes'; vaultip = '192.168.0.50'; username = 'CPM_docker'}"]
RUN ["powershell", "/tmp/InstallationAutomation/Registration/CPMRegisterCommponent.ps1", "-pwd", "banana"]

ENTRYPOINT ["powershell", "Get-Content", "'/Program Files (x86)/CyberArk/Password Manager/Logs/pm.log'", "-Wait"]
