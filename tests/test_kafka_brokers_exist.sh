#!/bin/bash

set -e

KIP=$1
KPORT=$2
KBR=$3

# Check if required arguments are passed
if [ -z "$KIP" ] && [ -z "$KPORT" ]
then
    echo "Syntax: $0 <kafka_ip> <kafka_port> [<broker_name>] "
    echo "Examples:"
    echo "    $0 <kafka_ip> <kafka_port> [<broker_name>]"
    echo ""
    exit 1
fi

# Set default broker if not provided
if [ -z "$KBR" ]
then
    KBR=ids
fi

test_kafka_broker () {
    echo dump | nc "$1" "$2" > /dev/null
    EC=$?
    if [ ${EC} == 0 ]
        echo dump | nc "$1" "$2" grep brokers |  grep "$3" > /dev/null
        EC2=$?
        if [ ${EC2} == 0 ]
        then
            echo "Kafka service is up and $3 broker is available"
            exit 0
        else
            echo "Kafka service is up but no $3 broker available"
            exit 1
        fi
    then
        echo "Kafka is not running at $1:$2"
        exit 2
    fi
}

test_kafka_broker "$KIP" "$KPORT" "$KBR"
