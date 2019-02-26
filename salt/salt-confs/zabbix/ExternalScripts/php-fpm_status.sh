#!/bin/bash
############################################################
# $Name: php-fpm_status.sh
############################################################
PHPFPM_COMMAND=$1
PHPFPM_PORT=55888 #根据监听不同端口进行调整
start_since(){
/usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm-status" |awk '/^start since:/ {print $NF}'
}
accepted_conn(){
/usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm-status" |awk '/^accepted conn:/ {print $NF}'
}
listen_queue(){
/usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm-status" |awk '/^listen queue:/ {print $NF}'
}
max_listen_queue(){
/usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm-status" |awk '/^max listen queue:/ {print $NF}'
}
listen_queue_len(){
/usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm-status" |awk '/^listen queue len:/ {print $NF}'
}
idle_processes(){
/usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm-status" |awk '/^idle processes:/ {print $NF}'
}
active_processes(){
/usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm-status" |awk '/^active processes:/ {print $NF}'
}
total_processes(){
/usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm-status" |awk '/^total processes:/ {print $NF}'
}
max_active_processes(){
/usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm-status" |awk '/^max active processes:/ {print $NF}'
}
max_children_reached(){
/usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm-status" |awk '/^max children reached:/ {print $NF}'
}
slow_requests(){
/usr/bin/curl -s "http://127.0.0.1:"$PHPFPM_PORT"/phpfpm-status" |awk '/^slow requests:/ {print $NF}'
}
case $PHPFPM_COMMAND in
start_since)
start_since;
;;
accepted_conn)
accepted_conn;
;;
listen_queue)
listen_queue;
;;
max_listen_queue)
max_listen_queue;
;;
listen_queue_len)
listen_queue_len;
;;
idle_processes)
idle_processes;
;;
active_processes)
active_processes;
;;
total_processes)
total_processes;
;;
max_active_processes)
max_active_processes;
;;
max_children_reached)
max_children_reached;
;;
slow_requests)
slow_requests;
;;
*)
echo $"USAGE:$0 {start_since|accepted_conn|listen_queue|max_listen_queue|listen_queue_len|idle_processes|active_processes|total_processes|max_active_processes|max_children_reached}"
esac
