# mkdir -force "C:\Program Files\windows-node"
# $env:Path += ";C:\Program Files\windows-node"
# [Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::Machine)
#
# $kubeletBinPath = "C:\Program Files\windows-node\kubelet.exe"
#
#upload forked kubelet to GS
# curl.exe -Lo $kubeletBinPath https://dl.k8s.io/v1.16.2/bin/windows/amd64/kubelet.exe
# curl.exe -Lo "C:\Program Files\windows-node\kubeadm.exe" https://dl.k8s.io/v1.16.2/bin/windows/amd64/kubeadm.exe
# curl.exe -Lo "C:\Program Files\windows-node\wins.exe" https://github.com/rancher/wins/releases/download/v0.0.4/wins.exe

#Install and configure Docker and create host network
# docker network create -d nat host
#
# stop-service rancher-wins
# wins.exe srv app run --register
# start-service rancher-wins

New-Service -Name "kubelet" -StartupType Automatic -DependsOn "docker" -BinaryPathName "$kubeletBinPath --windows-service --cert-dir=$env:SYSTEMDRIVE\var\lib\kubelet\pki --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --hostname-override=$(hostname) --pod-infra-container-image=`"mcr.microsoft.com/k8s/core/pause:1.2.0`" --enable-debugging-handlers  --cgroups-per-qos=false --enforce-node-allocatable=`"`" --network-plugin=cni --resolv-conf=`"`" --log-dir=/var/log/kubelet --logtostderr=false"

