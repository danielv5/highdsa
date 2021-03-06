#!/bin/sh

## -------------------- description --------------------
## shell 脚本的模板,使用时修改相应的位置即可
## -----------------------------------------------------

## definition
APP_NAME=kibana/kibana-4.6.6-linux-x86_64 # modify 01
SERVICE_DIR=/home/husen/$APP_NAME
SERVICE_NAME=kibana-app # modify 02
PID=$SERVICE_NAME\.pid

## pretreatment
cd $SERVICE_DIR

case "$1" in

    start)
		echo "--- starting kibana ..." # modify 03
        nohup ./bin/kibana >/dev/null 2>&1 & # modify 04
        echo $! > $SERVICE_DIR/$PID
        echo "--- start $SERVICE_NAME success"
        ;;

    stop)
		echo "--- stoping kibana ..." # modify 05
        kill `cat $SERVICE_DIR/$PID`
        rm -rf $SERVICE_DIR/$PID
        echo "--- stop $SERVICE_NAME, and wait 5s ..." 

        sleep 5s	
        P_ID=`ps -ef | grep -w kibana | grep -v "grep" | awk '{print $2}'`
        if [ "$P_ID" == "" ]; then
            echo "--- $SERVICE_NAME process not exists or stop success"
        else
            echo "--- $SERVICE_NAME process pid is:$P_ID"
            echo "--- begin force kill $SERVICE_NAME process, pid is:$P_ID"
            kill -9 $P_ID
        fi
        ;;

    restart)
        $0 stop
        sleep 2
        $0 start
        echo "--- restart $SERVICE_NAME"
        ;;

    *)
        ## restart
        $0 stop
        sleep 2
        $0 start
        ;;

esac
exit 0