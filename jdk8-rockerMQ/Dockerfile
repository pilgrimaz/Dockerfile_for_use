FROM pilgrima/jre:v0.3
ADD rocketmq.tar.gz /home/
ENV ROCKETMQ_HOME=/home/rocketmq
WORKDIR /home/rocketmq/bin
CMD ["/bin/sh" "-c" "cd ${ROCKETMQ_HOME}/bin  && ${ROCKETMQ_HOME}/bin/mqbroker -c /etc/rocketmq/broker.conf"] 
