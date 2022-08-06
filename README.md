# docker-cyberark-cpm

1. Install [Docker Desktop on Windows with support for Hyper-V backend and Windows Containers](https://docs.docker.com/desktop/install/windows-install/#hyper-v-backend-and-windows-containers).
1. After starting Docker Desktop, [switch to Windows containers](https://docs.docker.com/desktop/faqs/windowsfaqs/#how-do-i-switch-between-windows-and-linux-containers).
1. Download and place the installation archive for the desired Central Policy Manager release in `InstallFiles`. Do not unzip.
1. Run `docker build --build-arg CPM_INSTALLATION_ARCHIVE="Central Policy Manager-Rls-v12.6.zip" .`, defining `CPM_INSTALLATION_ARCHIVE` to the name of the installation archive you downloaded, to build the image.
