FROM flink:1.14.4-scala_2.12-java11

COPY example-streaming-job/build/libs/*.jar /opt/flink/usrlib/

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt-get update && \
    apt-get install -y libjemalloc2