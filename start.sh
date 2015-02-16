#!/bin/sh
B_DIR="`pwd`/"

#chmod -R 777 $B_DIR/scripts/docker-data

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

cassandraId=$(docker run -d -P -v /Users/docker-data:/data:rw --name $cassandraNodeName meabed/cassandra)
cassandraIP=$(./scripts/ipof.sh $cassandraId)
# -p 9200:9200
# http://dockerhost:9200/_plugin/kopf/
# http://dockerhost:9200/_plugin/HQ/

esId=$(docker run -d -p 9200:9200 -P -v /Users/docker-data:/data:rw --name $esNodeName meabed/elasticsearch)
esIP=$(./scripts/ipof.sh $esId)

docker run -d -p 8899:8899 -P -e CASSANDRA_NODE_NAME=$cassandraNodeName -e ES_NODE_NAME=$esNodeName -it --link $esNodeName:$esNodeName --link $cassandraNodeName:$cassandraNodeName -v /Users/docker-data:/data:rw --name $nutchNodeName meabed/nutch
