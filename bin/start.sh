#!/bin/sh

B_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
DOCKER_DATA_FOLDER=$B_DIR/docker-data

chmod -R 777 $DOCKER_DATA_FOLDER

source "$B_DIR/nodes.sh"
source "$B_DIR/stop.sh"

cassandraId=$(docker run -d -P -v $DOCKER_DATA_FOLDER:/data:rw --name $cassandraNodeName meabed/cassandra)
cassandraIP=$("$B_DIR"/ipof.sh $cassandraId)
# -p 9200:9200
# http://dockerhost:9200/_plugin/kopf/
# http://dockerhost:9200/_plugin/HQ/

esId=$(docker run -d -p 9200:9200 -P -v $DOCKER_DATA_FOLDER:/data:rw --name $esNodeName meabed/elasticsearch)
esIP=$("$B_DIR"/ipof.sh $esId)

docker run -d -p 8899:8899 -P -e CASSANDRA_NODE_NAME=$cassandraNodeName -e ES_NODE_NAME=$esNodeName -it --link $esNodeName:$esNodeName --link $cassandraNodeName:$cassandraNodeName -v $DOCKER_DATA_FOLDER:/data:rw --name $nutchNodeName meabed/nutch
