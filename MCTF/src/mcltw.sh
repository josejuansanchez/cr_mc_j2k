#! /bin/bash
export MCTF_TEXTURE_CODEC="ltw"
export MCTF_MOTION_CODEC="j2k"
#export SLOPES="4.0"
if [[ "$1" != "info" ]] ; then
    mctf $@
else
    mctf $1_ltw $2 $3
fi
