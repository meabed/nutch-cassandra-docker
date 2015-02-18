####Apache Nutch 2.x with Cassandra With Elasticsearch on Docker
=======================
------

This project is 3 Docker containers running Apache Nutch 2.x configured with Cassandra storage and ElasticSearch.

Due to the lack of integration information between Nutch 2.x / Cassandra / ElasticSearch, I have created this docker containers with configuration and integration between them.

###Usage:

```

# Build the images ( this will build the 3 application )
./bin/build.sh

# Start all 3 containers with data folders from scripts
./bin/start.sh

# stop all containers 
./bin/stop.sh

# restart containers 
./bin/stop.sh

```


###MAC OSx notes

```
mkdir ~/docker-data
mkdir ~/docker-data/cassandra
mkdir -p ~/docker-data/es
mkdir -p ~/docker-data/es/data/elasticsearch
mkdir -p ~/docker-data/es/log
mkdir -p ~/docker-data/es/plugins
mkdir -p ~/docker-data/es/work
mkdir ~/docker-data/nutch

chmod -R 777  ~/docker-data/

VBoxManage sharedfolder add boot2docker-vm -name home -hostpath ~/

boot2docker up
boot2docker ssh

#mkdir /data
#mount -t vboxsf -o uid=1000,gid=50 data /data
#vi /etc/fstab
#data            /data           vboxsf   rw,nodev,relatime    0 0
#docker-enter
```
