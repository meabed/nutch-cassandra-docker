#!/bin/sh

B_DIR="`pwd`/"
docker pull meabed/debian-jdk

#
docker build -t "meabed/nutch" $B_DIR/nutch/
docker build -t "meabed/cassandra" $B_DIR/cassandra/
docker build -t "meabed/elasticsearch" $B_DIR/elasticsearch/
