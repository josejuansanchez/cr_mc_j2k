# This is the directory where the executables files are written
EXE=~/bin

CC	= gcc
#CFLAGS	= -pipe -O3
CFLAGS	= -g -D DEBUG

BIN	+= $(EXE)/add
BIN	+= $(EXE)/not
BIN	+= $(EXE)/and
BIN	+= $(EXE)/mult
BIN	+= $(EXE)/div
BIN	+= $(EXE)/abs
BIN	+= $(EXE)/normalize
BIN	+= $(EXE)/zero_less_than
BIN	+= $(EXE)/zero_absless_than
BIN	+= $(EXE)/stop

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
