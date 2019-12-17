### Adding a Windows node to your AWS Cluster API cluster

Follow the [quick start guide] up to setting up a control machine. 
Apply [kube-proxy](https://raw.githubusercontent.com/benmoss/kubeadm-windows/master/kube-proxy/kube-proxy.yml)
```
kubectl apply -f https://raw.githubusercontent.com/benmoss/kubeadm-windows/master/kube-proxy/kube-proxy.yml
``` 
 
Modify the pod CIDR and apply [flannel.yml](https://raw.githubusercontent.com/benmoss/kubeadm-windows/master/flannel/flannel.yml) 
```
curl -L https://raw.githubusercontent.com/benmoss/kubeadm-windows/master/flannel/flannel.yml | sed 's/10\.244/192\.168/' -

kubectl apply -f https://raw.githubusercontent.com/benmoss/kubeadm-windows/master/flannel/flannel.yml
```

After completing the [quick start
guide](https://cluster-api.sigs.k8s.io/user/quick-start.html), at least up to
the point where you have a control plane, you can add Windows nodes to your
cluster using the instructions here.

First we need to create an additional security group in the VPC to allow UDP traffic over port 4789 for Flannel:

```
EXPORT VXLAN_SG_ID=$(aws ec2 create-security-group \
  --vpc-id $(kubectl get awsclusters capi-quickstart -o jsonpath='{.spec.networkSpec.vpc.id}') \
  --description "flannel overlay" \
  --group-name flannel | jq -r .GroupId)
aws ec2 authorize-security-group-ingress \
  --protocol udp \
  --port 4789 \
  --source-group $VXLAN_SG_ID \
  --group-id $VXLAN_SG_ID
```

Next we'll add our the security group to existing instances:

```
kubectl get awsmachines -o jsonpath="{range .items[*]}{.metadata.name}{'\n'}" | xargs -I{} kubectl patch awsmachine {} -p '{"spec": {"additionalSecurityGroups": {"id": "$VXLAN_SG_ID"}}}'
```

Create a Windows node by applying the [Machine Deployment YAML](./machinedeployment.yml) that includes the new security group
```
curl -L https://raw.githubusercontent.com/benmoss/kubeadm-windows/master/cluster-api-aws/machinedeployment.yml \
    | envsubst \
    | kubectl create -f -  
``` 

