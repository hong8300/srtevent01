#!/bin/sh

# cron for Mac
# */1 * * * * /Users/hong/RAILS/srtevent/cron/check_loop.sh
#
# cron for AWS EC2
#

LOG=/tmp/check_loop.log
OS_TYPE=`uname`
echo "---------------------------------------------" >> $LOG
date >> $LOG
echo "----CHECK OS TYPE----" >> $LOG
echo $OS_TYPE >> $LOG

if [ $OS_TYPE == "Darwin" ] ; then
    echo "-----> MAC shell start" >> $LOG
    BASE_DIR=/Users/hong/Rails/srtevent
    FFMPEG=/opt/homebrew/bin/ffmpeg
    WRITE_DIR=/Users/hong/Desktop/tmp
elif [ $OS_TYPE == "Linux" ]; then
    echo "-----> AWS EC2 shell start" >> $LOG
    BASE_DIR=/home/srtuser/RAILS/srtevent01
    FFMPEG=/opt/homebrew/bin/ffmpeg
    WRITE_DIR=/tmp
else
    echo "Unkonwn OS type" >> $LOG
    exit 1
fi

which ruby >> $LOG

RUBY=/Users/hong/.rbenv/shims/ruby
echo $BASE_DIR >> $LOG

ruby $BASE_DIR/cron/check_loop.rb $BASE_DIR/cron $FFMPEG $WRITE_DIR


