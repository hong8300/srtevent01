#!/bin/sh

BASE_DIR=/Users/hong/Rails/srtevent
RUBY=/Users/hong/.rbenv/shims/ruby

echo $BASE_DIR

ruby $BASE_DIR/cron/check_loop.rb $BASE_DIR/cron/status
