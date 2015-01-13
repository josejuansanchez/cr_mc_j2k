CC = g++
KAKADU_DIR = /home/josejuan/cr_mc_j2k/src/Kakadu/v6_4_1-00305L

INCLUDES = -I$(KAKADU_DIR)/coresys/common -I$(KAKADU_DIR)/apps/args 
INCLUDES += -I$(KAKADU_DIR)/apps/image -I$(KAKADU_DIR)/apps/compressed_io 
INCLUDES += -I$(KAKADU_DIR)/apps/support -I$(KAKADU_DIR)/apps/jp2
OPTIONS = -O -Wall -Wno-uninitialized -Wno-deprecated
DEFINES = -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -DKDU_PENTIUM_GCC
CFLAGS = $(INCLUDES) $(OPTIONS) $(DEFINES)

KAKADU_LIB = $(KAKADU_DIR)/lib/Linux-x86-64-gcc/libkdu_v64R.so

KAKADU_OBJ = $(KAKADU_DIR)/apps/make/kdu_stripe_decompressor.o
KAKADU_OBJ += $(KAKADU_DIR)/apps/make/kdu_region_decompressor.o
KAKADU_OBJ += $(KAKADU_DIR)/apps/make/jp2.o
KAKADU_OBJ += $(KAKADU_DIR)/apps/make/args.o
KAKADU_OBJ += $(KAKADU_DIR)/apps/make/kdu_stripe_compressor.o
KAKADU_OBJ +=$(KAKADU_DIR)/managed/make/kdu_cache.o

all: getbytes_thumbnails_0 getbytes_thumbnails_n j2ctocache woistocache decodefromcache test

../JP2Util/JP2Util.o: ../JP2Util/JP2Util.cpp
	$(CC) $(CFLAGS) -c ../JP2Util/JP2Util.cpp -o ../JP2Util/JP2Util.o
	
../Util/Args.o: ../Util/Args.cpp
	$(CC) $(CFLAGS) -c ../Util/Args.cpp -o ../Util/Args.o

jp2_area.o: jp2_area.cpp jp2_area.h
	$(CC) $(CFLAGS) -c jp2_area.cpp -o jp2_area.o -lm -g

getbytes_thumbnails_0: ../JP2Util/JP2Util.o ../Util/Args.o jp2_area.o getbytes_thumbnails_0.cpp
	$(CC) $(CFLAGS) getbytes_thumbnails_0.cpp jp2_area.o				\
			../JP2Util/JP2Util.o 					\
			../Util/Args.o						\
			$(KAKADU_OBJ) $(KAKADU_LIB) 				\
			-o getbytes_thumbnails_0 -lm -lpthread -g

getbytes_thumbnails_n: ../JP2Util/JP2Util.o ../Util/Args.o jp2_area.o getbytes_thumbnails_n.cpp
	$(CC) $(CFLAGS) getbytes_thumbnails_n.cpp jp2_area.o				\
			../JP2Util/JP2Util.o 					\
			../Util/Args.o						\
			$(KAKADU_OBJ) $(KAKADU_LIB) 				\
			-o getbytes_thumbnails_n -lm -lpthread -g

j2ctocache: ../JP2Util/JP2Util.o ../Util/Args.o jp2_area.o j2ctocache.cpp
	$(CC) $(CFLAGS) j2ctocache.cpp jp2_area.o				\
			../JP2Util/JP2Util.o 					\
			../Util/Args.o						\
			$(KAKADU_OBJ) $(KAKADU_LIB) 				\
			-o j2ctocache -lm -lpthread -g

woistocache: ../JP2Util/JP2Util.o ../Util/Args.o jp2_area.o woistocache.cpp
	$(CC) $(CFLAGS) woistocache.cpp jp2_area.o				\
			../JP2Util/JP2Util.o 					\
			../Util/Args.o						\
			$(KAKADU_OBJ) $(KAKADU_LIB) 				\
			-o woistocache -lm -lpthread -g

decodefromcache: ../JP2Util/JP2Util.o ../Util/Args.o jp2_area.o decodefromcache.cpp
	$(CC) $(CFLAGS) decodefromcache.cpp jp2_area.o				\
			../JP2Util/JP2Util.o 					\
			../Util/Args.o						\
			$(KAKADU_OBJ) $(KAKADU_LIB) 				\
			-o decodefromcache -lm -lpthread -g

test: ../JP2Util/JP2Util.o ../Util/Args.o jp2_area.o test.cpp
	$(CC) $(CFLAGS) test.cpp jp2_area.o				\
			../JP2Util/JP2Util.o 					\
			../Util/Args.o						\
			$(KAKADU_OBJ) $(KAKADU_LIB) 				\
			-o test -lm -lpthread -g

clean: 
	rm -f getbytes_thumbnails_0 getbytes_thumbnails_n j2ctocache woistocache decodefromcache test
	rm -f *~ *.o
	rm -f ../JP2Util/*.o
	rm -f ../Util/*.o
