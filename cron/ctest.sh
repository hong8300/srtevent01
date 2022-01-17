#!/bin/sh

while true
do
    date
    ps -def | grep ffmpeg | grep -v "grep"
    sleep 5
done
