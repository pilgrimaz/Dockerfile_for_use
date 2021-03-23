FROM alpine:latest

ENV HOME /root
ENV NGINXMODE fastdfs-nginx-module-1.22
ENV FDFSVER fastdfs-6.07
ENV LIBFDFSCOMVER libfastcommon-1.0.48

#安装准备
RUN apk update \
    && apk add --no-cache gcc g++ make automake autoconf libtool pcre pcre-dev zlib zlib-dev openssl-dev wget vim --repository https://mirrors.tuna.tsinghua.edu.cn/alpine/v3.6/main


#下载fastdfs.libfastcommon.nginx插件源码
RUN cd /root \
    && wget http://nginx.org/download/nginx-1.15.4.tar.gz 
ADD libfastcommon-1.0.48.tar.gz ${HOME}/
ADD fastdfs-6.07.tar.gz ${HOME}/
ADD fastdfs-nginx-module-1.22.tar.gz ${HOME}/

 # 安装libfastcommon
 RUN cd ${HOME}/${LIBFDFSCOMVER}/ \
    && ./make.sh  \
    && ./make.sh install

# 安装fastdfs
RUN cd ${HOME}/${FDFSVER}/ \
    && ./make.sh \
    && ./make.sh install \
    && cp /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf \
    && cp /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf \
    && cp /etc/fdfs/client.conf.sample /etc/fdfs/client.conf \
    && cp ${HOME}/${FDFSVER}/conf/http.conf /etc/fdfs/ \
    && cp ${HOME}/${FDFSVER}/conf/mime.types /etc/fdfs/ \
    && sed -i "s|/home/yuqing/fastdfs|/var/local/fdfs/tracker|g" /etc/fdfs/tracker.conf \
    && sed -i "s|/home/yuqing/fastdfs|/var/local/fdfs/storage|g" /etc/fdfs/storage.conf \
    && sed -i "s|/home/yuqing/fastdfs|/var/local/fdfs/storage|g" /etc/fdfs/client.conf

# 获取nginx源码
RUN cd ${HOME} \
    && tar -zxvf nginx-1.15.4.tar.gz  \
    && cd nginx-1.15.4/ \
    && ./configure --add-module=${HOME}/${NGINXMODE}/src/ \
    && make \
    && make install

# 设置nginx和fastdfs联合环境，并配置nginx
RUN cp ${HOME}/${NGINXMODE}/src/mod_fastdfs.conf /etc/fdfs \
#    && sed -i "s|^store_path0.*$|store_path0=/var/local/fdfs/storage|g" /etc/fdfs/mod_fastdfs.conf \
#    && sed -i "s|^url_have_group_name =.*$|url_have_group_name = true|g" /etc/fdfs/mod_fastdfs.conf \
#    && cd ${HOME}/${FDFSVER}/conf/ \
    && mkdir -p /var/local/fdfs/storage/data /var/local/fdfs/tracker; \
    ln -s /var/local/fdfs/storage/data/ /var/local/fdfs/storage/data/M00; \
    echo -e "\
    events {\n\
        worker_connections  1024;\n\
    }\n\
    http {\n\
        include       mime.types;\n\
        default_type  application/octet-stream;\n\
        server {\n\
            listen 8888;\n\
            server_name localhost;\n\
            location ~ /group[0-9]/M00 {\n\
                ngx_fastdfs_module;\n\
            }\n\
        }\n\
    }">/usr/local/nginx/conf/nginx.conf

# 清理文件
RUN rm -rf ${HOME}/*

# 配置启动脚本，在启动时中根据环境变量替换nginx端口、fastdfs端口

ENV FASTDFS_BASE_PATH /var/local/fdfs
ADD start.sh .

# 暴露端口。改为采用host网络，不需要单独暴露端口
# EXPOSE 80 22122

ENTRYPOINT ["/bin/bash","/start.sh"]
