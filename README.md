# demo-kafka-dcos

A simple demo to install a Kafka broker on a K8S cluster and then create a few simple producer and consumer deployments. 
## Create a cluster

```sh
podman machine init --cpus=4 --memory=4000

# Create a 3 node cluster for kafka
kind create cluster --config kindConfig.yaml
```

## Install kafka

```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install kafka bitnami/kafka
```

Wait for the kafka deployment to become ready. I may take a few minutes and it will fail a few times but it should eventually work.

```sh
$ kubectl get pods
NAME                READY   STATUS    RESTARTS      AGE
kafka-0             1/1     Running   3 (51s ago)   2m4s
kafka-zookeeper-0   1/1     Running   0             2m4s
```

## Deploy Producer and Consumer

Apply the deploy folder to create a producer and consumer K8S deployments. For more detail look a the producer and consumer yaml files in the `deploy` folder.

```sh
kubectl apply -f deploy
```

Watch the consumer logs to see the messages it is receiving.

```sh
kubectl logs deployment/consumer -f
```

You can play around with scaling up/down the producers and consumers to see the affect.  

```sh
kubectl scale --replicas=6 deployment/producer
kubectl scale --replicas=3 deployment/consumer
```

From here you can imagine using he `docker.io/bitnami/kafka:3.2.3-debian-11-r1` as a base image in your own dockerfile to create a custom service that can produce and consume. After that once the prototype is solid you would want to use the Kafka API directly and not use the shell scripts here. But this is a good way to get started