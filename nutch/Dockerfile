#
# Nutch
# meabed/debian-jdk
# docker build -t meabed/nutch:latest .
#

FROM meabed/debian-jdk
MAINTAINER Mohamed Meabed "mo.meabed@gmail.com"

USER root
ENV DEBIAN_FRONTEND noninteractive

ENV NUTCH_VERSION 2.2.1

#ant
RUN apt-get install -y ant

#Download nutch

RUN mkdir -p /opt/downloads && cd /opt/downloads && curl -SsfLO "http://ftp-stud.hs-esslingen.de/pub/Mirrors/ftp.apache.org/dist/nutch/$NUTCH_VERSION/apache-nutch-$NUTCH_VERSION-src.tar.gz"
RUN cd /opt && tar xvfz /opt/downloads/apache-nutch-$NUTCH_VERSION-src.tar.gz
#WORKDIR /opt/apache-nutch-$NUTCH_VERSION
ENV NUTCH_ROOT /opt/apache-nutch-$NUTCH_VERSION
ENV HOME /root

#Nutch-default
# RUN sed -i '/^  <name>http.agent.name<\/name>$/{$!{N;s/^  <name>http.agent.name<\/name>\n  <value><\/value>$/  <name>http.agent.name<\/name>\n  <value>iData Bot<\/value>/;ty;P;D;:y}}' $NUTCH_ROOT/conf/nutch-default.xml

RUN vim -c 'g/name="gora-cassandra"/+1d' -c 'x' $NUTCH_ROOT/ivy/ivy.xml
RUN vim -c 'g/name="gora-cassandra"/-1d' -c 'x' $NUTCH_ROOT/ivy/ivy.xml

RUN vim -c '%s/name="elasticsearch" rev=.*/name="elasticsearch" rev="1.3.2"/g' -c 'x' $NUTCH_ROOT/ivy/ivy.xml
RUN vim -c '%s/item.failed()/item.isFailed()/g' -c 'x' $NUTCH_ROOT/src/java/org/apache/nutch/indexer/elastic/ElasticWriter.java

RUN cd $NUTCH_ROOT && ant runtime

#native libs
RUN rm  $NUTCH_ROOT/lib/native/*
#RUN mkdir -p $NUTCH_ROOT/lib/native/Linux-amd64-64
#RUN curl -Ls http://dl.bintray.com/meabed/hadoop-debian/hadoop-native-64-2.5.1.tar|tar -x -C $NUTCH_ROOT/lib/native/Linux-amd64-64/


#Modification and compilation again

ADD plugin/nutch2-index-html/src/plugin/ $NUTCH_ROOT/src/plugin/
RUN sed  -i '/dir="index-more" target="deploy".*/ s/.*/&\n     <ant dir="index-html" target="deploy"\/>/' $NUTCH_ROOT/src/plugin/build.xml
RUN sed  -i '/dir="index-more" target="clean".*/ s/.*/&\n     <ant dir="index-html" target="clean"\/>/' $NUTCH_ROOT/src/plugin/build.xml


RUN cd $NUTCH_ROOT && ant runtime

RUN ln -s /opt/apache-nutch-$NUTCH_VERSION/runtime/local /opt/nutch

ENV NUTCH_HOME /opt/nutch

# urls folder we will use in crawling $NUTCH_HOME/bin/crawl urls crawlId(test01) elasticsearch_node_name(iData) iteration(1)
RUN mkdir $NUTCH_HOME/urls
# Adding test urls to use in crawling
CMD mkdir -p $NUTCH_HOME/testUrls
ADD testUrls $NUTCH_HOME/testUrls

# Adding rawcontent that hold html of the page field in index to elasticsearch
RUN sed  -i '/field name="date" type.*/ s/.*/&\n\n        <field name="rawcontent" type="text" sstored="true" indexed="true" multiValued="false"\/>\n/' $NUTCH_HOME/conf/schema.xml

# remove nutche-site.xml default file to replace it by our configuration
RUN rm $NUTCH_HOME/conf/nutch-site.xml
ADD config/nutch-site.xml $NUTCH_HOME/conf/nutch-site.xml

# Changes to the crawl script to support Elasticsearch index instead of SOLR
RUN sed  -i '/^SOLRURL=".*/ s/.*/#&\nESNODE="$3"/' $NUTCH_HOME/bin/crawl

RUN sed  -i '/^if \[ "$SOLRURL".*/ s/.*/if \[ "$ESNODE" = "" \]; then\n    echo "Missing Elasticsearch Node Name : crawl <seedDir> <crawlID> <esNODE> <numberOfRounds>"\n    exit -1;\nfi\n\n\n&/' $NUTCH_HOME/bin/crawl
RUN sed  -i '/on SOLR index .*/ s/.*/  echo "Indexing $CRAWL_ID on Elasticsearch Node -> $ESNODE"\n  $bin\/nutch elasticindex $commonOptions $ESNODE -all -crawlId $CRAWL_ID\n\n\n&/' $NUTCH_HOME/bin/crawl

RUN vim -c 'g/SOLR dedup/-1,+5d' -c 'x' $NUTCH_HOME/bin/crawl
RUN vim -c 'g/"$SOLRURL" =/-1,+4d' -c 'x' $NUTCH_HOME/bin/crawl

RUN vim -c 'g/on SOLR index /-1,+2d' -c 'x' $NUTCH_HOME/bin/crawl
RUN vim -c '%s/<solrURL>/<esNODE>/' -c 'x' $NUTCH_HOME/bin/crawl

# Port that nutchserver will use
ENV NUTCHSERVER_PORT 8899

#RUN cd $NUTCH_HOME && ls -al

#RUN mkdir -p /opt/nutch/urls && cd /opt/crawl

ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

VOLUME ["/data"]

CMD ["/etc/bootstrap.sh", "-d"]

EXPOSE 8899
