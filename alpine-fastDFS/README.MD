#### 基于版本  
> alpine3.6   
> libfastcommon-1.0.48   
> fastdfs-6.07   
> fastdfs-nginx-module-1.22   

#### 说明
启动脚本借助于网上的脚本进行改动
1. monitor 查看集群信息
2. storage 启动一个storage容器
3. tracker 启动一个tracker容器

1和2在启动时需指定tracker_server地址
