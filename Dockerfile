FROM ubuntu:bionic
#FROM debezium/connect

# Install OpenJDK-8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get install -y curl && \
    apt-get clean;

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

COPY . ./

RUN tar -xzf kafka_2.13-2.6.0.tgz

RUN pwd > pwd.txt && \
    ls > ls.txt

RUN tar -xzf debezium-connector-postgres-1.2.5.Final-plugin.tar.gz && \
   cp ./debezium-connector-postgres/*.jar ./kafka_2.13-2.6.0/libs

CMD ["./kafka_2.13-2.6.0/bin/connect-distributed.sh" ,"./connect-distributed.properties"]

# docker build . -t kafkaconnect-eh
# docker run -it --name kafkaconnect-eh -p 8083:8083  kafkaconnect-eh
# curl -X POST -H "Content-Type: application/json" --data @pg-source-connector.json http://localhost:8083/connectors





