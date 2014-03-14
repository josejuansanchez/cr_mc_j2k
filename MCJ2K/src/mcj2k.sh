#! /bin/bash
export MCTF_TEXTURE_CODEC="j2k"
export MCTF_MOTION_CODEC="j2k"
export SLOPES="44000,43500,43000"
if [[ "$1" != "info" ]] ; then
    mctf $@
else
    mctf $1_j2k $2 $3
fi
