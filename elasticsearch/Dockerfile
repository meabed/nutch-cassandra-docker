#
# Elasticsearch
# meabed/debian-jdk
# docker build -t meabed/elasticsearch:latest .
#
# sudo sysctl -w vm.max_map_count=2621444
# sudo su
# echo "vm.max_map_count=262144" >> /etc/sysctl.conf

FROM meabed/debian-jdk
MAINTAINER Mohamed Meabed "mo.meabed@gmail.com"

USER root
ENV DEBIAN_FRONTEND noninteractive


ENV ES_VERSION 1.4.3

#tomcat
#RUN apt-get install -y tomcat7 tomcat7-admin

RUN mkdir -p /opt/downloads && cd /opt/downloads && curl -SsfLO "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$ES_VERSION.deb"
RUN dpkg -i /opt/downloads/elasticsearch-$ES_VERSION.deb

ENV ES_LOG_DIR /var/log/elasticsearch
ENV ES_DATE_DIR /var/lib/elasticsearch
ENV HOME /root

RUN /usr/share/elasticsearch/bin/plugin -install royrusso/elasticsearch-HQ
RUN /usr/share/elasticsearch/bin/plugin -install lmenezes/elasticsearch-kopf
RUN /usr/share/elasticsearch/bin/plugin -install lukas-vlcek/bigdesk
RUN /usr/share/elasticsearch/bin/plugin -install mobz/elasticsearch-head

RUN sed -i '/sysctl -q -w vm.max_map_count/ s/^#*/true\n#/' /etc/init.d/elasticsearch
RUN sed -i '/^ES_USER=el/ s/^#*/true\nES_USER=root\n#/' /etc/init.d/elasticsearch
RUN sed -i '/^ES_GROUP=el/ s/^#*/true\nES_GROUP=root\n#/' /etc/init.d/elasticsearch

RUN sed  -i "/^#cluster\.name.*/ s/.*/&\ncluster\.name: iData/"  /etc/elasticsearch/elasticsearch.yml


ADD config/elasticsearch.yml /opt/downloads/elasticsearch.yml

RUN cat /opt/downloads/elasticsearch.yml >> /etc/elasticsearch/elasticsearch.yml

RUN service ssh start && service elasticsearch start

ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

VOLUME ["/data"]

CMD ["/etc/bootstrap.sh", "-d"]


# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
EXPOSE 9200
EXPOSE 9300


