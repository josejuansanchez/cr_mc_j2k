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

#KAKADU_LIB = $(KAKADU_DIR)/lib/libkdu_v45R.so
KAKADU_LIB = $(KAKADU_DIR)/lib/Linux-x86-64-gcc/libkdu_v64R.so

KAKADU_OBJ = $(KAKADU_DIR)/apps/make/kdu_stripe_decompressor.o
KAKADU_OBJ += $(KAKADU_DIR)/apps/make/kdu_region_decompressor.o
KAKADU_OBJ += $(KAKADU_DIR)/apps/make/jp2.o
KAKADU_OBJ += $(KAKADU_DIR)/apps/make/args.o
KAKADU_OBJ += $(KAKADU_DIR)/apps/make/kdu_stripe_compressor.o
#KAKADU_OBJ += $(KAKADU_DIR)/apps/make/kdu_cache.o
KAKADU_OBJ +=$(KAKADU_DIR)/managed/make/kdu_cache.o

all: getbytes

../JP2Util/JP2Util.o: ../JP2Util/JP2Util.cpp
	$(CC) $(CFLAGS) -c ../JP2Util/JP2Util.cpp -o ../JP2Util/JP2Util.o
	
../Util/Args.o: ../Util/Args.cpp
	$(CC) $(CFLAGS) -c ../Util/Args.cpp -o ../Util/Args.o

jp2_area.o: jp2_area.cpp jp2_area.h
	$(CC) $(CFLAGS) -c jp2_area.cpp -o jp2_area.o -lm

getbytes: ../JP2Util/JP2Util.o ../Util/Args.o jp2_area.o getbytes.cpp
	$(CC) $(CFLAGS) getbytes.cpp jp2_area.o					\
			../JP2Util/JP2Util.o 					\
			../Util/Args.o						\
			$(KAKADU_OBJ) $(KAKADU_LIB) 				\
			-o getbytes -lm	-lpthread

clean: 
	rm -f getbytes
	rm -f *~ *.o
	rm -f ../JP2Util/*.o
	rm -f ../Util/*.o

