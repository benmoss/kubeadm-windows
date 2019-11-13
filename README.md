# kubeadm-windows

## Instructions

- Provision a control plane node with kubeadm and grab the `kubeadm join` command from it
- Install docker and the Windows "Containers" feature and reboot the machine,
  or use a VM template that already has these installed. A script to do this is
  available [here](./install_docker.ps1).
- Install kubelet, kubeadm and [wins](https://github.com/rancher/wins) and
  ensure they are on your path and that wins and kubelet are installed as services. A
  script to do these steps is available [here](./windows-node.ps1). This script
  also will create a docker network named `host`, which we need for getting
  kubelet to allow us to run Flannel as a DaemonSet.
- Run the `kubeadm join` command on your Windows node.
- Install flannel onto your cluster using the manifest
  [here](./flannel/flannel.yml). This installs DaemonSets for both Linux and
  Windows nodes.
- Install kube-proxy onto your cluster using the manifest
  [here](./kube-proxy/kube-proxy.yml). This is only a Windows DaemonSet as the
  Linux one is installed by kubeadm.
- Your nodes should become `Ready` as Flannel initializes and configures networking.

## Use with Kind
- We've tested bringing up a Linux cluster with
  [kind](https://github.com/kubernetes-sigs/kind) and joining a Windows VM to
  it from VMware Fusion. The same should work for tools like Virtualbox or
  Hyper-V, the only requirement is that the Windows node is on the same network
  as the `kind` cluster.
- The `kubeadm join` command can be retrieved by `docker exec`-ing onto the
  control plane container and running `kubeadm token create
  --print-join-command`.
- A minimal `kind` config is included [here](./kind.yml). This just removes the
  default CNI so we can use Flannel instead.

## Notes/Caveats
- `wins` has some security implications, we need to investigate / recommend
  solutions for controlling access to its API.
- The kubelet binary needed is right now a custom build since the patch in
  https://github.com/kubernetes/kubernetes/pull/84649 is needed to enable
  hostNetworking for Windows pods and as of now has not been released in an
  official release.
