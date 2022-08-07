# docker-cyberark

## CPM

1. Install [Docker Desktop on Windows with support for Hyper-V backend and Windows Containers](https://docs.docker.com/desktop/install/windows-install/#hyper-v-backend-and-windows-containers).
1. After starting Docker Desktop, [switch to Windows containers](https://docs.docker.com/desktop/faqs/windowsfaqs/#how-do-i-switch-between-windows-and-linux-containers).
1. Download and place the installation archive for the Central Policy Manager 12.1.1 release in `InstallFiles`. Do not unzip.
1. Run `docker build -t cpm .` to build the image.
1. Start the container with

   ```docker
   docker run -e ACCEPT_EULA=yes -e PVWA_URL=https://yourpvwa.domain.com -e VAULT_USER=Administrator -e VAULT_PASS=@dminPassword -e VAULT_IP=192.168.0.50 -e CPM_USERNAME=CPM_Docker
   ```
