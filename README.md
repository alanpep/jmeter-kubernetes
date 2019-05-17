# JMeter Cluster Support for Kubernetes and OpenShift

Kubernetes v1.8+ or OpenShift v3.5+ is required.

## Setup
1. Create the Kubernetes resources:
   ```
   export NAMESPACE=<new-kubernetes-namespace>
   
   kubectl create ns $NAMESPACE
   kubectl apply -f kube/ -n $NAMESPACE
   kubectl get all -n $NAMESPACE
   ```

2. Create the JMeter database in InfluxDB:

   `kubectl exec -it $(kubectl get po -n $NAMESPACE | grep jmeter-influxdb | awk '{print $1}') -- influx -execute 'CREATE DATABASE jmeter'`

3. Create the InfluxDB data source in Grafana:
   ```
   export JMETER_GRAFANA_POD=$(kubectl get po -n $NAMESPACE | grep jmeter-grafana | awk '{print $1}')

   kubectl exec -it JMETER_GRAFANA_POD -- curl 'http://admin:admin@127.0.0.1:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"jmeterdb","type":"influxdb","url":"http://jmeter-influxdb:8086","access":"proxy","isDefault":true,"database":"jmeter","user":"admin","password":"admin"}'
   ```
   Output:
   ```
   {"datasource":{"id":1,"orgId":1,"name":"jmeterdb","type":"influxdb","typeLogoUrl":"","access":"proxy","url":"http://jmeter-influxdb:8086","password":"admin","user":"admin","database":"jmeter","basicAuth":false,"basicAuthUser":"","basicAuthPassword":"","withCredentials":false,"isDefault":true,"secureJsonFields":{},"version":1,"readOnly":false},"id":1,"message":"Datasource added","name":"jmeterdb"}
   ```

4. Copy `/load_test` to `/tmp/load_test` in the `jmeter-master` pod, then make `/tmp/load_test` an executable file. `/load_test` is a ConfigMap mounted as a volume (read-only):
   ```
   export JMETER_MASTER_POD=$(kubectl get po -n $NAMESPACE | grep jmeter-master | awk '{print $1}')

   kubectl exec -n $NAMESPACE $JMETER_MASTER_POD cp /load_test /tmp/load_test
   kubectl exec -n $NAMESPACE $JMETER_MASTER_POD chmod 755 /tmp/load_test
   ```

## Running Tests
Copy the JMX file to the `jmeter-master` pod and initiate the test using the `/jmeter/load_test` script:
```
kubectl cp cloudssky.jmx -n $NAMESPACE $JMETER_MASTER_POD:/tmp/tests.jmx
kubectl exec -n $NAMESPACE $JMETER_MASTER_POD /tmp/load_test tests.jmx
```
To stop a test:

`kubectl exec -n $NAMESPACE $JMETER_MASTER_POD /jmeter/apache-jmeter-4.0/bin/stoptest.sh`

## Links
* [Load Testing JMeter On Kubernetes](https://goo.gl/mkoX9E)
* [Grafana Reporter](https://github.com/IzakMarais/reporter)

## Notes
* Investigate tuning the JVM heap of `jmeter-master` pod

## Cleanup
`kubectl delete -f kube/ -n $NAMESPACE`
