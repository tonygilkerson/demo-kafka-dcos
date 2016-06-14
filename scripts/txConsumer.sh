#!/bin/bash
#
# $1 - broker list
# $2 - zookeeper host
#
# usage
#   txConsumer.sh broker-0.kafka.mesos:9729 master.mesos:2181/kafka
#

echo consuming from txq and producing to storeq now....;
echo group.id=TxGroup > ./tx.consumer.properties;


while true;
do
        ./kafka-console-consumer.sh \
                --zookeeper $2 \
                --topic txq \
                --consumer.config ./tx.consumer.properties \
                --max-messages 1 \
                > ./txConsumerIn.tmp;

        #
        # append something to the end so we know it has been through the translator process
        #
        while read m; do
                echo $m - TX > txConsumerOut.tmp;
        done <txConsumerIn.tmp

        echo Produce message... `cat txConsumerOut.tmp`;
        cat txConsumerOut.tmp | ./kafka-console-producer.sh --broker-list $1 --topic storeq ;


        echo `date` - sleep for 1 second ZZZzzz...;
        sleep 1;
done;
