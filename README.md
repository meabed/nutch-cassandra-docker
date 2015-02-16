####Apache Nutch With Cassandra With Elasticsearch and Hadoop on Docker
=======================
------

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
