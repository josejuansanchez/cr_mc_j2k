CC = g++
# LINUX
#KAKADU_DIR = /home/josejuan/cr_mc_j2k/src/Kakadu/v6_4_1-00305L
# MAC
KAKADU_DIR = /Users/josejuansanchez/UAL/git/cr_mc_j2k/src/Kakadu/v6_4_1-00305L

INCLUDES = -I$(KAKADU_DIR)/coresys/common -I$(KAKADU_DIR)/apps/args 
INCLUDES += -I$(KAKADU_DIR)/apps/image -I$(KAKADU_DIR)/apps/compressed_io 
INCLUDES += -I$(KAKADU_DIR)/apps/support -I$(KAKADU_DIR)/apps/jp2
OPTIONS = -O -Wall -Wno-uninitialized -Wno-deprecated
DEFINES = -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -DKDU_PENTIUM_GCC
CFLAGS = $(INCLUDES) $(OPTIONS) $(DEFINES)

all: JP2Util.o

JP2Util.o: JP2Util.cpp
	$(CC) $(CFLAGS) -c JP2Util.cpp
	
clean:
	rm -f JP2Util.o
