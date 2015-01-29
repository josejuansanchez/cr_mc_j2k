default:	all

# Compiler
CC = g++

# LINUX
KAKADU_DIR = /home/josejuan/cr_mc_j2k/src/Kakadu/v6_4_1-00305L
# MAC
#KAKADU_DIR = /Users/josejuansanchez/UAL/git/cr_mc_j2k/src/Kakadu/v6_4_1-00305L

# Directories
BIN = bin
EXE =

INCLUDES = -I$(KAKADU_DIR)/coresys/common -I$(KAKADU_DIR)/apps/args 
INCLUDES += -I$(KAKADU_DIR)/apps/image -I$(KAKADU_DIR)/apps/compressed_io 
INCLUDES += -I$(KAKADU_DIR)/apps/support -I$(KAKADU_DIR)/apps/jp2
OPTIONS = -O -Wall -Wno-uninitialized -Wno-deprecated -Wno-unused-result -Wno-sign-compare
DEFINES = -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -DKDU_PENTIUM_GCC
CFLAGS = $(INCLUDES) $(OPTIONS) $(DEFINES)

KAKADU_LIB = $(KAKADU_DIR)/lib/Linux-x86-64-gcc/libkdu_v64R.so

KAKADU_OBJ = $(KAKADU_DIR)/apps/make/kdu_stripe_decompressor.o
KAKADU_OBJ += $(KAKADU_DIR)/apps/make/kdu_region_decompressor.o
KAKADU_OBJ += $(KAKADU_DIR)/apps/make/jp2.o
KAKADU_OBJ += $(KAKADU_DIR)/apps/make/args.o
KAKADU_OBJ += $(KAKADU_DIR)/apps/make/kdu_stripe_compressor.o
KAKADU_OBJ +=$(KAKADU_DIR)/managed/make/kdu_cache.o

../JP2Util/JP2Util.o: ../JP2Util/JP2Util.cpp
	$(CC) $(CFLAGS) -c ../JP2Util/JP2Util.cpp -o ../JP2Util/JP2Util.o
	
../Util/Args.o: ../Util/Args.cpp
	$(CC) $(CFLAGS) -c ../Util/Args.cpp -o ../Util/Args.o

$(BIN)/jp2_area.o: src/jp2_area.cpp src/jp2_area.h
	$(CC) $(CFLAGS) -c src/jp2_area.cpp -o $@ -lm -g
EXE += $(BIN)/jp2_area.o

$(BIN)/getbytes_thumbnails_0: ../JP2Util/JP2Util.o ../Util/Args.o $(BIN)/jp2_area.o src/getbytes_thumbnails_0.cpp
	$(CC) $(CFLAGS) src/getbytes_thumbnails_0.cpp $(BIN)/jp2_area.o 	\
			../JP2Util/JP2Util.o 										\
			../Util/Args.o												\
			$(KAKADU_OBJ) $(KAKADU_LIB) 								\
			-o $@ -lm -lpthread -g
EXE += $(BIN)/getbytes_thumbnails_0

$(BIN)/getbytes_thumbnails_n: ../JP2Util/JP2Util.o ../Util/Args.o $(BIN)/jp2_area.o src/getbytes_thumbnails_n.cpp
	$(CC) $(CFLAGS) src/getbytes_thumbnails_n.cpp $(BIN)/jp2_area.o 	\
			../JP2Util/JP2Util.o 										\
			../Util/Args.o												\
			$(KAKADU_OBJ) $(KAKADU_LIB) 								\
			-o $@ -lm -lpthread -g
EXE += $(BIN)/getbytes_thumbnails_n

$(BIN)/j2ctocache: ../JP2Util/JP2Util.o ../Util/Args.o $(BIN)/jp2_area.o src/j2ctocache.cpp
	$(CC) $(CFLAGS) src/j2ctocache.cpp $(BIN)/jp2_area.o 	\
			../JP2Util/JP2Util.o 							\
			../Util/Args.o									\
			$(KAKADU_OBJ) $(KAKADU_LIB) 					\
			-o $@ -lm -lpthread -g
EXE += $(BIN)/j2ctocache

$(BIN)/woistocache: ../JP2Util/JP2Util.o ../Util/Args.o $(BIN)/jp2_area.o src/woistocache.cpp
	$(CC) $(CFLAGS) src/woistocache.cpp $(BIN)/jp2_area.o 	\
			../JP2Util/JP2Util.o 							\
			../Util/Args.o									\
			$(KAKADU_OBJ) $(KAKADU_LIB) 					\
			-o $@ -lm -lpthread -g
EXE += $(BIN)/woistocache

$(BIN)/decodefromcache: ../JP2Util/JP2Util.o ../Util/Args.o $(BIN)/jp2_area.o src/decodefromcache.cpp
	$(CC) $(CFLAGS) src/decodefromcache.cpp $(BIN)/jp2_area.o 	\
			../JP2Util/JP2Util.o 								\
			../Util/Args.o										\
			$(KAKADU_OBJ) $(KAKADU_LIB) 						\
			-o $@ -lm -lpthread -g
EXE += $(BIN)/decodefromcache

$(BIN)/test: ../JP2Util/JP2Util.o ../Util/Args.o $(BIN)/jp2_area.o src/test.cpp
	$(CC) $(CFLAGS) src/test.cpp $(BIN)/jp2_area.o			\
			../JP2Util/JP2Util.o 							\
			../Util/Args.o									\
			$(KAKADU_OBJ) $(KAKADU_LIB) 					\
			-o $@ -lm -lpthread -g
EXE += $(BIN)/test

#Objetives
all: directories $(EXE)

clean: 
	@echo "   Removing binaries..."
	rm -rf $(BIN)/*	
	rm -f ../JP2Util/*.o
	rm -f ../Util/*.o

directories:
	mkdir -p $(BIN)