FROM mcr.microsoft.com/windows/servercore:ltsc2019
SHELL ["powershell", "-NoLogo", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN pushd C:\; \
  curl.exe -LO http://nginx.org/download/nginx-1.15.9.zip; \
  tar -xf nginx-1.15.9.zip nginx-1.15.9; \
  rm nginx-1.15.9.zip; \
  mv nginx-1.15.9 nginx

RUN curl.exe -Lo C:\windows\wins.exe https://github.com/rancher/wins/releases/download/v0.0.4/wins.exe

ENTRYPOINT ["powershell", "-NoLogo", "-NonInteractive", "-File", "./scripts/entry.ps1"]
