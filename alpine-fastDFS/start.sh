#!/bin/bash
if [ -n "$GROUP_NAME" ] ; then  

sed -i "s|group_name =.*$|group_name=${GROUP_NAME}|g" /etc/fdfs/storage.conf
sed -i "s|group_name=.*$|group_name=${GROUP_NAME}|g" /etc/fdfs/mod_fastdfs.conf

fi 


if [ "$1" = "monitor" ] ; then
  if [ -n "$TRACKER_SERVER" ] ; then  
    sed -i "s|tracker_server =.*$|tracker_server=${TRACKER_SERVER}|g" /etc/fdfs/client.conf
  fi
  fdfs_monitor /etc/fdfs/client.conf
  exit 0
elif [ "$1" = "storage" ] ; then
  FASTDFS_MODE="storage"
  sed -i "s|store_path0.*$|store_path0=/var/local/fdfs/storage|g" /etc/fdfs/mod_fastdfs.conf
  sed -i "s|url_have_group_name =.*$|url_have_group_name = true|g" /etc/fdfs/mod_fastdfs.conf
  if [ -n "$PORT" ] ; then  
    sed -i "s|^storage_server_port=.*$|storage_server_port=${PORT}|g" /etc/fdfs/mod_fastdfs.conf
  fi
  if [ -n "$TRACKER_SERVER" ] ; then  
    sed -i "s|tracker_server =.*$|tracker_server=${TRACKER_SERVER}|g" /etc/fdfs/storage.conf
    sed -i "s|tracker_server =.*$|tracker_server=${TRACKER_SERVER}|g" /etc/fdfs/client.conf
    sed -i "s|tracker_server=.*$|tracker_server=${TRACKER_SERVER}|g" /etc/fdfs/mod_fastdfs.conf
  else
    IP=`ifconfig eth0 | grep inet | awk '{print \$2}'| awk -F: '{print \$2}'`;
    sed -i "s|tracker_server =.*$|tracker_server=${IP}:22122|g" /etc/fdfs/storage.conf
    sed -i "s|tracker_server =.*$|tracker_server=${IP}:22122|g" /etc/fdfs/client.conf
    sed -i "s|tracker_server=.*$|tracker_server=${IP}:22122|g" /etc/fdfs/mod_fastdfs.conf
  fi
  if [ -n "$TRACKER_SERVER2" ] ; then
    sed -i "\$a tracker_server =${TRACKER_SERVER2}" /etc/fdfs/storage.conf
    sed -i "\$a tracker_server =${TRACKER_SERVER2}" /etc/fdfs/client.conf
    sed -i "\$a tracker_server=${TRACKER_SERVER2}" /etc/fdfs/mod_fastdfs.conf
  fi 
  if [ -n "$TRACKER_SERVER3" ] ; then
    sed -i "\$a tracker_server =${TRACKER_SERVER3}" /etc/fdfs/storage.conf
    sed -i "\$a tracker_server =${TRACKER_SERVER3}" /etc/fdfs/client.conf
    sed -i "\$a tracker_server=${TRACKER_SERVER3}" /etc/fdfs/mod_fastdfs.conf
  fi 
  if [ -n "$TRACKER_SERVER4" ] ; then
    sed -i "\$a tracker_server =${TRACKER_SERVER4}" /etc/fdfs/storage.conf
    sed -i "\$a tracker_server =${TRACKER_SERVER4}" /etc/fdfs/client.conf
    sed -i "\$a tracker_server=${TRACKER_SERVER4}" /etc/fdfs/mod_fastdfs.conf

  fi 
  if [ -n "$LISTEN_PORT" ] ; then
    sed -i "s|listen .*$|listen ${LISTEN_PORT};|g" /usr/local/nginx/conf/nginx.conf
    sed -i "s|http.server_port =.*$|http.server_port=${LISTEN_PORT}|g" /etc/fdfs/storage.conf
  fi
  /usr/local/nginx/sbin/nginx
else 
  FASTDFS_MODE="tracker"
fi


if [ -n "$PORT" ] ; then  
sed -i "s|^port =.*$|port=${PORT}|g" /etc/fdfs/"$FASTDFS_MODE".conf
fi


FASTDFS_LOG_FILE="${FASTDFS_BASE_PATH}/${FASTDFS_MODE}/logs/${FASTDFS_MODE}d.log"
PID_NUMBER="${FASTDFS_BASE_PATH}/data/fdfs_${FASTDFS_MODE}d.pid"

echo "try to start the $FASTDFS_MODE node..."
if [ -f "$FASTDFS_LOG_FILE" ]; then 
	rm "$FASTDFS_LOG_FILE"
fi
# start the fastdfs node.	
fdfs_${FASTDFS_MODE}d /etc/fdfs/${FASTDFS_MODE}.conf start

# wait for pid file(important!),the max start time is 5 seconds,if the pid number does not appear in 5 seconds,start failed.
TIMES=5
while [ ! -f "$PID_NUMBER" -a $TIMES -gt 0 ]
do
    sleep 1s
	TIMES=`expr $TIMES - 1`
done

# if the storage node start successfully, print the started time.
# if [ $TIMES -gt 0 ]; then
#     echo "the ${FASTDFS_MODE} node started successfully at $(date +%Y-%m-%d_%H:%M)"
	
# 	# give the detail log address
#     echo "please have a look at the log detail at $FASTDFS_LOG_FILE"

#     # leave balnk lines to differ from next log.
#     echo
#     echo

    
	
# 	# make the container have foreground process(primary commond!)
#     tail -F --pid=`cat $PID_NUMBER` /dev/null
# # else print the error.
# else
#     echo "the ${FASTDFS_MODE} node started failed at $(date +%Y-%m-%d_%H:%M)"
# 	echo "please have a look at the log detail at $FASTDFS_LOG_FILE"
# 	echo
#     echo
# fi
tail -f "$FASTDFS_LOG_FILE"

