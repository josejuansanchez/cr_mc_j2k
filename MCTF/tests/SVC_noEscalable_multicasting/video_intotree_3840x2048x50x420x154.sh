#!/bin/bash

set -x



##############################	##############################
#						  PARÁMETROS ESPECÍFICOS		 	 #
##############################	##############################

resoluciones=(parametros3840x2048 parametros1920x1024 parametros960x512 parametros480x256 parametros240x128 parametros352x288 parametros120x64)
cuantificaciones=(40 36 32 28 24)

VIDEO_NAME=intotree
X_NATIVE=3840
Y_NATIVE=2048
FPS=50
PICTURES=129
PICTURES_TOTAL=154
VIDEO_NATIVE=$VIDEO_NAME""_$X_NATIVE""x$Y_NATIVE""x$FPS""x420x$PICTURES_TOTAL.yuv

#name_original=ducks_take_off_2160p50.y4m
#URL=http://media.xiph.org/video/derf/y4m/ducks_take_off_2160p50.y4m


set +x


