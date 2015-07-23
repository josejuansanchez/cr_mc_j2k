#!/usr/bin/python

import sys
import os

# Checking the environment variable CR_MC_J2K_HOME
if not os.environ["CR_MC_J2K_HOME"]:
	print "Error. CR_MC_J2K_HOME is not defined"
	sys.exit(-1)

CR_MC_J2K_HOME = os.environ["CR_MC_J2K_HOME"]

# Load the path where the images are located
IMAGES_DIRECTORY     = CR_MC_J2K_HOME + "/data/sequences/speedway_512x512"
THUMBNAILS_DIRECTORY = CR_MC_J2K_HOME + "/data/j2c_and_thumbnails"

# Compression parameters used in kdu_compress
CLAYERS=8
CLEVELS=4
CPRECINCTS="{128,128},{128,128},{128,128},{128,128},{128,128}"
CBLK="{16,16}"
CORDER="LRCP"

USE_MOTION_COMPENSATION = False

# Motion estimation parameters
X=512
Y=512
B=128    # block size

A=0     # subpixel accuracy = sub-pixel accuracy of the motion estimation
D=0     # border size = size of the border of the blocks in the motion estimation process
S=4     # search range = size of the searching area of the motion estimation
V=2     # Overlapping. Para difuminar los bordes de los bloques.

# Original image dimension
WIDTH_RECONS=512
HEIGHT_RECONS=512

# Precinct size at the maximum resolution level
W_PRECINT_SIZE=128
H_PRECINT_SIZE=128

# Thumbnails dimensions
XTHUMB=32
YTHUMB=32

# Calculate the precinct dimensions used in the thumbnail
W_PRECINT_SIZE_THUMBNAIL=XTHUMB/(WIDTH_RECONS/W_PRECINT_SIZE)
H_PRECINT_SIZE_THUMBNAIL=YTHUMB/(HEIGHT_RECONS/H_PRECINT_SIZE)

# Calculate the offset needed to apply to the coordinates of the thumbnail precincts 
# to get the equivalent coordinates at the original size of the image
W_OFFSET=W_PRECINT_SIZE/W_PRECINT_SIZE_THUMBNAIL
H_OFFSET=H_PRECINT_SIZE/H_PRECINT_SIZE_THUMBNAIL