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
elif [ $OS_TYPE == "Linux" ]; then
    echo "-----> AWS EC2 shell start"
    BASE_DIR=/home/srtuser/RAILS/srtevent01
    FFMPEG=/opt/homebrew/bin/ffmpeg
    WRITE_DIR=/tmp
else
    echo "Unknown OS type" 
    exit 1
fi

# check exec mode
if [ $1 == "exec_check" ] ; then
   ruby $BASE_DIR/cron/check_loop.rb $BASE_DIR/cron $FFMPEG $WRITE_DIR
elif [ $1 == "exec_kick" ] ; then
   ruby $BASE_DIR/cron/check_kick.rb $BASE_DIR/cron 
else
    echo "Unknown Exec type" 
    exit 2
fi


# ruby $BASE_DIR/cron/check_loop.rb $BASE_DIR/cron $FFMPEG $WRITE_DIR


