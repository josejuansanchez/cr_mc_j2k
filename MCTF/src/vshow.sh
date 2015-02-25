set -x
mplayer $1 -demuxer rawvideo -rawvideo w=352:h=288 -loop 0 -fps $2 > /dev/null 2> /dev/null &
set +x