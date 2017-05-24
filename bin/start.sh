#!/bin/sh

B_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
DOCKER_DATA_FOLDER=$B_DIR/docker-data

chmod -R 777 $DOCKER_DATA_FOLDER
mkdir -p $DOCKER_DATA_FOLDER
source "$B_DIR/nodes.sh"
# source "$B_DIR/stop.sh"

echo "Starting cassaandra.."
cassandraId=$(docker run -d -P -v $DOCKER_DATA_FOLDER:/data:rw --name $cassandraNodeName meabed/cassandra)
echo "Finding IP of cassandra container.."
cassandraIP=$("$B_DIR"/ipof.sh $cassandraId)

echo "Starting Nutch container.."
echo "cassandraNodeName: $cassandraNodeName"
echo "nutchNodeName: $nutchNodeName"
docker run -d -p 8899:8899 -P -e CASSANDRA_NODE_NAME=$cassandraNodeName -it --link $cassandraNodeName:$cassandraNodeName --net bridge -v $DOCKER_DATA_FOLDER:/data:rw --name $nutchNodeName meabed/nutch:2.3
