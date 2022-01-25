#!/bin/sh

# cron for Mac
# */1 * * * * /Users/hong/RAILS/srtevent/cron/check_loop.sh
#
# cron for AWS EC2
#

# LOG=/tmp/check_loop.log
OS_TYPE=`uname`


# check OS type
if [ $OS_TYPE == "Darwin" ] ; then
    echo "-----> MAC shell start" 
    BASE_DIR=/Users/hong/Rails/srtevent
    FFMPEG=/opt/homebrew/bin/ffmpeg
    WRITE_DIR=/Users/hong/Desktop/tmp
    API_URL="http://0.0.0.0:3000/api/v1/events"
    PS_OPTION="-a"
    PS_EVENT_INDEX=5
elif [ $OS_TYPE == "Linux" ]; then
    echo "-----> AWS EC2 shell start"
    BASE_DIR=/home/srtuser/RAILS/srtevent01
    FFMPEG=/usr/bin/ffmpeg
    WRITE_DIR=/mnt/srtnfs
    API_URL="http://0.0.0.0/api/v1/events"
    PS_OPTION="-def"
    PS_EVENT_INDEX=9
else
    echo "Unknown OS type" 
    exit 1
fi

# echo $#

# check exec mode
if [ $1 == "exec_check" ] ; then
    # production mode
    if [ $# == 1 ] ; then
        sleep 16
    fi
    ruby $BASE_DIR/cron/check_loop.rb $BASE_DIR $FFMPEG $WRITE_DIR $API_URL $PS_OPTION $PS_EVENT_INDEX
    sleep 30
    ruby $BASE_DIR/cron/check_loop.rb $BASE_DIR $FFMPEG $WRITE_DIR $API_URL $PS_OPTION $PS_EVENT_INDEX

elif [ $1 == "exec_kick" ] ; then
    # production mode
    if [ $# == 1 ] ; then
        sleep 1
    fi
    ruby $BASE_DIR/cron/check_kick.rb $BASE_DIR $API_URL
    sleep 30
    ruby $BASE_DIR/cron/check_kick.rb $BASE_DIR $API_URL
else
    echo "Unknown exec type" 
    exit 2
fi


# ruby $BASE_DIR/cron/check_loop.rb $BASE_DIR/cron $FFMPEG $WRITE_DIR


