#! /bin/bash
export MCTF_TEXTURE_CODEC="mjpeg"
export MCTF_MOTION_CODEC="j2k"
export SLOPES="30"
if [[ "$1" != "info" ]] ; then
    mctf $@
else
    mctf $1_jpg $2 $3
fi
