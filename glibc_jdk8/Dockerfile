FROM pilgrima/alpine-glibc:latest
MAINTAINER pilgrima<xuliang@indeci.cn>
LABEL version="alpine:3.13.2 glibc:2.33-r0"
ADD jre1.8.tar.gz /usr/java/jdk/
ENV JAVA_HOME /usr/java/jdk/jre1.8.0_271
ENV PATH ${PATH}:${JAVA_HOME}/bin
ONBUILD RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --no-cache tzdata \
    && ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone
