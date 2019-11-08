FROM mcr.microsoft.com/windows/servercore:ltsc2019
SHELL ["powershell", "-NoLogo", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN mkdir C:\kube-proxy; \
  pushd C:\kube-proxy; \
  curl.exe -LO https://dl.k8s.io/v1.16.2/bin/windows/amd64/kube-proxy.exe

RUN mkdir "/Program Files/WindowsPowerShell/Modules/HNS"; \
  curl.exe -Lo "/Program Files/WindowsPowerShell/Modules/HNS/hns.psm1" https://raw.githubusercontent.com/microsoft/SDN/master/Kubernetes/windows/hns.psm1
ADD ./wins.exe /windows/wins.exe
# RUN curl.exe -Lo C:\windows\wins.exe https://github.com/rancher/wins/releases/download/v0.0.4/wins.exe

