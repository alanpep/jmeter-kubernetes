# JMeter Cluster Support for Kubernetes and OpenShift
Please read [Load Testing JMeter On Kubernetes](https://goo.gl/mkoX9E) on Medium.

## Prerequisites

Kubernetes > v1.8

OpenShift > v3.5

## Quickstart
### Deploy JMeter, InfluxDB, and Grafana
```
export NAMESPACE=<new-kubernetes-namespace>

kubectl create ns $NAMESPACE
kubectl apply -f kube/ -n $NAMESPACE
kubectl get all -n $NAMESPACE
```

### Cleanup JMeter, InfluxDB, and Grafana
`kubectl delete -f kube -n <new-kubernetes-namespace>`

## Notes
### Deployment with `oc`
`oc` is the OpenShift Client.