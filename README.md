####Apache Nutch 2.x with Cassandra on Docker
=======================
------

This project is 3 Docker containers running Apache Nutch 2.x configured with Cassandra storage.

Due to the lack of integration information between Nutch 2.x / Cassandra, I have created this docker containers with configuration and integration between them.

This is project is fully operational but its still experimental, any feedback, suggestions or contribution will be highly appreciated! 

Current Nutch version is 2.3 ( There is a branch for 2.2.1 and it has ElasticSearch integrated since 2.3 missing elastic search indexerJob ).

###Usage notes:

1. Clone the repository.
2. Build the images and start the containers " NOTE: for Mac OS running boot2docker, Please read the Notes section Below ". 

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
3. Start Crawling with Nutch 2.x ( I have modified "bin/crawl" script to work with ElasticSearch, Sine there is no Nutch 2.x bin/crawl script that works with ElasticSearch) 


```
# Run the crawler, You can use docker exec command, or you can docker attach to the container and run the commands there, or use docker-enter if you are using Mac OS

docker exec NUTCH01 /opt/nutch/bin/crawl testUrls test_crawl 3

OR 

docker-enter NUTCH01

root@9ec43c388769:/# cd opt/nutch
root@9ec43c388769:/opt/nutch# ./bin/crawl
Missing seedDir : crawl <seedDir> <crawlID> <esNODE> <numberOfRounds>
root@9ec43c388769:/opt/nutch# ./bin/crawl testUrls test_crawl iData 3


```
###NOTES:

Nutch 2.x Container name : NUTCH01

----------

Cassandra Container name : CASS01

Cassandra installed with OpsCenter

--------

ElasticSearch Container name : ES01

ElasticSearch node name for usage in the crawling with Nutch : iData

ElasticSearch Installed with some GUI plugins so you can access the interface and see whats being indexed, URL as : 

You can see the ElasticSearch HQ Plugin UI in url :
 
http://<dockerhost_ip>:9200/_plugin/HQ

additionally there is 3 other plugins installed you can access them as the url above

 ```
royrusso/elasticsearch-HQ
lmenezes/elasticsearch-kopf
lukas-vlcek/bigdesk
mobz/elasticsearch-head
````

###MAC OSx notes
- you need to mount data folders to your VirtualMachine to be able to get persistent data every time you run this application.
- You might need to install docker-enter for easier access to the containers

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
