#!/bin/bash

set -x



##############################  ##############################
#                                                 PARÁMETROS ESPECÍFICOS                         #
##############################  ##############################

resoluciones=(parametros4096x4096 parametros2048x2048 parametros1024x1024 parametros512x512 parametros256x256 parametros64x64 parametros32x32 parametros16x16 parametros8x8)
cuantificaciones=(40 36 32 28 24)

VIDEO_NAME=sun
X_NATIVE=4096
Y_NATIVE=4096
FPS=30
PICTURES=65
PICTURES_TOTAL=129
VIDEO_NATIVE=$VIDEO_NAME""_$X_NATIVE""x$Y_NATIVE""x$FPS""x420x$PICTURES_TOTAL.yuv

#name_original=ducks_take_off_2160p50.y4m
#URL=http://media.xiph.org/video/derf/y4m/ducks_take_off_2160p50.y4m


set +x


