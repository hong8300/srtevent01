#!/bin/sh

OS_TYPE=`uname`
echo $OS_TYPE

if [ $OS_TYPE == "Darwin" ] ; then
    echo "-----> MAC shell start"
    BASE_DIR=/Users/hong/Rails/srtevent
elif [ $OS_TYPE == "Linux" ]; then
    echo "-----> AWS EC2 shell start"
    BASE_DIR=/home/srtuser/RAILS/srtevent01
else
    echo "Unkonwn OS type"
    exit 1
fi

RUBY=/Users/hong/.rbenv/shims/ruby
echo $BASE_DIR

ruby $BASE_DIR/cron/check_loop.rb $BASE_DIR/cron/status
