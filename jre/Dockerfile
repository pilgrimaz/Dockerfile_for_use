FROM pilgrima/alpine-glibc:latest
## VERSION:v1.8.0_401
MAINTAINER pilgrima
ADD jre1.8.tar.gz /usr/java/jdk/
ENV JAVA_HOME /usr/java/jdk/jre1.8.0_401
ENV PATH ${PATH}:${JAVA_HOME}/bin
ONBUILD RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --no-cache tzdata \
    && ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone
