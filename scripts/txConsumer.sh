#!/bin/bash

echo consuming from txq and producing to storeq now....;
echo group.id=TxGroup > ./tx.consumer.properties;


while true;
do
        ./kafka-console-consumer.sh \
                --zookeeper master.mesos:2181/kafka \
                --topic txq \
                --consumer.config ./tx.consumer.properties \
                --max-messages 1 \
                > txconsumer.tmp;

        #
        # append something to the end so we know it has been through the translator process
        #

        echo "{tx: true}" >> txconsumer.tmp;

        cat txconsumer.tmp | ./kafka-console-producer.sh --broker-list broker-0.kafka.mesos:10039 --topic storeq ;


        echo `date` - sleep for 1 second ZZZzzz...;
        sleep 1;
done;

