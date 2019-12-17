== Adding a Windows node to your AWS Cluster API cluster

After completing the [quick start
guide](https://cluster-api.sigs.k8s.io/user/quick-start.html), at least up to
the point where you have a control plane, you can add Windows nodes to your
cluster using the instructions here.

First we need to create an additional security group in the VPC to allow UDP traffic over port 4789 for Flannel:

```
sg=$(aws ec2 create-security-group \
  --vpc-id $(kubectl get awsclusters capi-quickstart -o jsonpath='{.spec.networkSpec.vpc.id}') \
  --description "flannel overlay" \
  --group-name flannel | jq -r .GroupId)
aws ec2 authorize-security-group-ingress \
  --protocol udp \
  --port 4789 \
  --source-group $sg \
  --group-id $sg
```

Next we'll add our the security group to existing instances:

```
kubectl get awsmachines -o jsonpath="{range .items[*]}{.metadata.name}{'\n'}" | xargs -I{} kubectl patch awsmachine -p '{"spec": {"additionalSecurityGroups": {"id": "$sg"}}}'
```


