# demo-kafka-dcos
Demo DCOS tasks that produce and consume from kafka queues

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

## Kafka client pod

To create a pod that you can use as a Kafka client run the following.  

```sh
kubectl run kafka-client --restart='Never' --image docker.io/bitnami/kafka:3.2.3-debian-11-r1 --namespace default --command -- sleep infinity
```

## Producer

Using the kafka pod create above run the following. This will give you a prompt where you can type a message and hit enter to publish that message.

```sh
kubectl exec --tty -i kafka-client --namespace default -- /bin/bash -c "kafka-console-producer.sh --broker-list kafka-0.kafka-headless.default.svc.cluster.local:9092 --topic test"
```

## Consumer

In a second terminal run the following to consume messages. Now each message you produce in your first terminal above will be see here.

```sh
kubectl exec --tty -i kafka-client --namespace default -- /bin/bash -c "kafka-console-consumer.sh --bootstrap-server kafka.default.svc.cluster.local:9092 --topic test --from-beginning"
```

From here you can imagine using he `docker.io/bitnami/kafka:3.2.3-debian-11-r1` as a base image in your own dockerfile to create a custom app.