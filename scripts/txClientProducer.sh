#!/bin/bash

#
# $1 - number of orders to publish
#
for i in `seq 1 $1`; do


        cmd="docker run -it --rm mesosphere/kafka-client /bin/bash -c ";
        cmd+="\"echo '{orderNo : ";

        cmd+=${i};
        cmd+=", itemNo : 12345, qty : 5, total : 999.99}' | ";
        cmd+="./kafka-console-producer.sh --broker-list broker-0.kafka.mesos:10039 --topic txq;\"";

        echo cmd is..
        echo $cmd

        eval $cmd;


done;
