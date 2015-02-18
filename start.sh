#!/bin/sh

B_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
DOCKER_DATA_FOLDER=$B_DIR/scripts/docker-data

chmod -R 777 $DOCKER_DATA_FOLDER

# cassandra
cassandraNodeName=CASS01
# elasticsearch
esNodeName=ES01
# apache nutch
nutchNodeName=NUTCH01

function isRunning {
    id=$(docker ps -a | grep $1 | awk '{print $1}')
    echo $id
}

cassandraRunning=$(isRunning $cassandraNodeName)
esRunning=$(isRunning $esNodeName)
nutchRunning=$(isRunning $nutchNodeName)


if [ -n "${cassandraRunning}" ]; then
    docker kill $cassandraNodeName && docker rm $cassandraNodeName
fi

if [ -n "${esRunning}" ]; then
    docker kill $esNodeName && docker rm $esNodeName
fi

if [ -n "${nutchRunning}" ]; then
    docker kill $nutchNodeName && docker rm $nutchNodeName
fi

cassandraId=$(docker run -d -P -v $DOCKER_DATA_FOLDER:/data:rw --name $cassandraNodeName meabed/cassandra)
cassandraIP=$(./scripts/ipof.sh $cassandraId)
# -p 9200:9200
# http://dockerhost:9200/_plugin/kopf/
# http://dockerhost:9200/_plugin/HQ/

esId=$(docker run -d -p 9200:9200 -P -v $DOCKER_DATA_FOLDER:/data:rw --name $esNodeName meabed/elasticsearch)
esIP=$(./scripts/ipof.sh $esId)

docker run -d -p 8899:8899 -P -e CASSANDRA_NODE_NAME=$cassandraNodeName -e ES_NODE_NAME=$esNodeName -it --link $esNodeName:$esNodeName --link $cassandraNodeName:$cassandraNodeName -v $DOCKER_DATA_FOLDER:/data:rw --name $nutchNodeName meabed/nutch
