#! /bin/bash

export MCTF_TEXTURE_CODEC="image_to_j2k"
export MCTF_MOTION_CODEC="image_to_j2k"

if [[ "$1" != "info" ]] ; then
    mctf $@
else
    mctf $1_j2k $2 $3 $4
fi
