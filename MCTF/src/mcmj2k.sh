#! /bin/bash

export MCTF_TEXTURE_CODEC="mj2k"
export MCTF_MOTION_CODEC="j2k"
export SLOPES="44500,44250,44000,43700,43400"

if [[ "$1" != "info" ]] ; then
    mctf $@
else
    mctf $1_mj2k $2 $3 $4
fi
