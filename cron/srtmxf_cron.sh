#!/bin/sh
#
# Kick FFMPEG shell
#
EVENT_ID=$1
SERVER_PORT=$2
PASSPH=$3
FILENAME=$4
FFMPEG=$5

MARK_AD="&"
MARK_SP=" "
MARK_DC='"'

CMD="$5 -y -i "
SERVER_MODE="mode=listener"
SERVER_PASS="passphrase="$PASSPH
SERVER_AND_MODE="srt://:$SERVER_PORT?$SERVER_MODE$MARK_AD$SERVER_PASS"
VIDEO_FMT="-vcodec mpeg2video -s 1920x1080 -b:v 50000k -minrate 50000k -maxrate 50000k -r 29.97 -pix_fmt yuv422p -profile:v 0 -level:v 2 -acodec pcm_s24le -ar 48000"
EXECMD=$CMD$MARK_DC$SERVER_AND_MODE$MARK_DC$MARK_SP$VIDEO_FMT$MARK_SP$FILENAME
echo --- start ffmpeg ----
echo $EXECMD

