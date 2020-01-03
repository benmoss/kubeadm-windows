### Adding a Windows node to your AWS Cluster API cluster

Follow the [quick start guide](https://cluster-api.sigs.k8s.io/user/quick-start.html) up to setting up a control plane machine,
skipping the step to apply Calico, since it does not have open-source Windows support.

Apply the daemonset to run [kube-proxy](../kube-proxy/kube-proxy.yml) on Windows:
```
kubectl apply --kubeconfig=./capi-quickstart.kubeconfig -f https://raw.githubusercontent.com/benmoss/kubeadm-windows/master/kube-proxy/kube-proxy.yml
``` 
 
Create the Flannel DaemonSets for Linux and Windows, modifying the network CIDR to `192.168.0.0/16` to match the `cidrBlocks` from the Quick Start guide:
```
curl -s -L https://raw.githubusercontent.com/benmoss/kubeadm-windows/master/flannel/flannel.yml | \
  | sed 's/10\.244/192\.168/' - \
  | kubectl --kubeconfig=./capi-quickstart.kubeconfig apply -f -
```

Create an additional security group in the VPC to allow UDP traffic over port 4789 for Flannel:
```
export VXLAN_SG_ID=$(aws ec2 create-security-group \
  --vpc-id $(kubectl get awsclusters capi-quickstart -o jsonpath='{.spec.networkSpec.vpc.id}') \
  --description "flannel overlay" \
  --group-name flannel | jq -r .GroupId)

aws ec2 authorize-security-group-ingress \
  --protocol udp \
  --port 4789 \
  --source-group $VXLAN_SG_ID \
  --group-id $VXLAN_SG_ID
```

Add the security group to any existing instances:
```
kubectl get awsmachines -o jsonpath="{range .items[*]}{.metadata.name}{'\n'}" \
  | xargs -I{} kubectl patch awsmachine {} --type merge -p '{"spec": {"additionalSecurityGroups": [{"id": "'$VXLAN_SG_ID'"}]}}'
```

Create a Windows node by applying the [Machine Deployment YAML](./machinedeployment.yml) that includes the new security group:
```
curl -L https://raw.githubusercontent.com/benmoss/kubeadm-windows/master/cluster-api-aws/machinedeployment.yml \
    | envsubst \
    | kubectl create -f -  
``` 

The Windows node will take a bit longer than Linux nodes to come online, but you should see it appear and enter the `Ready` state on its own after it boots and runs Flannel.
