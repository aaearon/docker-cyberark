# docker-cyberark-cpm

1. Install [Docker Desktop on Windows with support for Hyper-V backend and Windows Containers](https://docs.docker.com/desktop/install/windows-install/#hyper-v-backend-and-windows-containers).
1. After starting Docker Desktop, [switch to Windows containers](https://docs.docker.com/desktop/faqs/windowsfaqs/#how-do-i-switch-between-windows-and-linux-containers).
1. Download and place the installation archive for the Central Policy Manager 12.1.1 release in `InstallFiles`. Do not unzip.
1. Update the line with `RUN ["powershell", "/tmp/InstallationAutomation/Registration/CPMRegisterCommponent.ps1", "-pwd", "banana"]`, replacing `banana` with the password of the Administrator account.
1. Run `docker build  .` and then `docker run <image ID>`.
