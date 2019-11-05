FROM mcr.microsoft.com/windows/servercore:ltsc2019
SHELL ["powershell", "-NoLogo", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN mkdir C:\kube-proxy; \
  pushd C:\kube-proxy; \
  curl.exe -Lo kubernetes.tgz https://dl.k8s.io/v1.16.2/kubernetes-node-windows-amd64.tar.gz; \
  tar --strip 3 -xf .\kubernetes.tgz kubernetes/node/bin/kube-proxy.exe; \
  rm kubernetes.tgz

RUN curl.exe -Lo C:\windows\wins.exe https://github.com/rancher/wins/releases/download/v0.0.4/wins.exe

