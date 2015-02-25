#! /bin/bash

export MCTF_TEXTURE_CODEC="cp"
export MCTF_MOTION_CODEC="j2k"

if [[ "$1" != "info" ]] ; then
    mctf $@
else
    mctf $1_cp $2 $3 $4
fi
