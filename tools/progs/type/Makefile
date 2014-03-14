# This is the directory where the executables files are written
EXE=~/bin

CC=gcc
CFLAGS=-pipe -O3
#CFLAGS=-g -D DEBUG

BIN	+=	$(EXE)/ascii2int
BIN	+=	$(EXE)/char2ascii
BIN	+=	$(EXE)/char2double
BIN	+=	$(EXE)/char2float
BIN	+=	$(EXE)/char2int
BIN	+=	$(EXE)/char2short
BIN	+=	$(EXE)/char2uchar
BIN	+=	$(EXE)/char2ushort
BIN	+=	$(EXE)/double2ascii
BIN	+=	$(EXE)/double2char
BIN	+=	$(EXE)/double2float
BIN	+=	$(EXE)/double2int
BIN	+=	$(EXE)/double2short
BIN	+=	$(EXE)/double2uchar
BIN	+=	$(EXE)/double2ushort
BIN	+=	$(EXE)/float2ascii
BIN	+=	$(EXE)/float2char
BIN	+=	$(EXE)/float2double
BIN	+=	$(EXE)/float2int
BIN	+=	$(EXE)/float2short
BIN	+=	$(EXE)/float2uchar
BIN	+=	$(EXE)/float2ushort
BIN	+=	$(EXE)/int2ascii
BIN	+=	$(EXE)/int2char
BIN	+=	$(EXE)/int2double
BIN	+=	$(EXE)/int2float
BIN	+=	$(EXE)/int2network
BIN	+=	$(EXE)/int2short
BIN	+=	$(EXE)/int2uchar
BIN	+=	$(EXE)/int2ushort
BIN	+=	$(EXE)/short2ascii
BIN	+=	$(EXE)/short2char
BIN	+=	$(EXE)/short2double
BIN	+=	$(EXE)/short2float
BIN	+=	$(EXE)/short2int
BIN	+=	$(EXE)/short2uchar
BIN	+=	$(EXE)/short2ushort
BIN	+=	$(EXE)/uchar2ascii
BIN	+=	$(EXE)/uchar2char
BIN	+=	$(EXE)/uchar2double
BIN	+=	$(EXE)/uchar2float
BIN	+=	$(EXE)/uchar2int
BIN	+=	$(EXE)/uchar2short
BIN	+=	$(EXE)/uchar2ushort
BIN	+=	$(EXE)/ushort2char
BIN	+=	$(EXE)/ushort2double
BIN	+=	$(EXE)/ushort2float
BIN	+=	$(EXE)/ushort2int
BIN	+=	$(EXE)/ushort2short
BIN	+=	$(EXE)/ushort2uchar

$(EXE)/% :: %.c
	$(CC) $(CFLAGS) $< -o $@

test:
	@if ! [ -d $(EXE) ]; then \
		echo "Makefile: Unable to locate the directory \"$(EXE)\""; \
		echo "Makefile: Please, edit the Makefile file and modify the \"EXE\" variable"; \
		echo "Makefile: according to the path to this directory"; \
	fi

all:	test $(BIN)

clean:	test
	rm -f $(BIN)
