#!/bin/bash

#
# $1 - broker-list
# $2 - number of messages to publish
#
# usage:
#  txProducer.sh broker-0.kafka.mesos:9729 3
#
for i in `seq 1 $2`; do

        cmd="echo 'Message ${i}' | ";
        cmd+="./kafka-console-producer.sh --broker-list ${1} --topic txq;";


        echo $cmd
        eval $cmd;


done;
