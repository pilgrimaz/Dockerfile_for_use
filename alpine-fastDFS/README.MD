#### 基于版本  
> alpine3.6     
> libfastcommon-1.0.48   
> fastdfs-6.07   
> fastdfs-nginx-module-1.22 
> nginx1.18  

#### 说明
启动脚本借助于网上的脚本进行改动   
1. monitor 查看集群信息   
2. storage 启动一个storage容器   
  变量说明   
  PORT 修改storaged的监听端口，不指定则默认为23000   
  TRACKER_SERVER 修改trakcer_server的地址，格式为 IP(域名地址):端口，不指定则为当前eth0的IP：22122   
  TRACKER_SERVER2 增加tracker_server的地址，多trakcer_server使用，增加一个地址   
  TRACKER_SERVER3 增加tracker_server的地址，多trakcer_server使用，增加一个地址   
  TRACKER_SERVER4 增加tracker_server的地址，多trakcer_server使用，增加一个地址   
  LISTEN_PORT 修改nginx的监听端口   
  GROUP_NAME 修改storage的group   
    
3. tracker 启动一个tracker容器   
  PORT 修改trackerd的监听端口，不指定则默认为22122   


