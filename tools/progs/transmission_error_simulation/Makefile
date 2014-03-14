# This is the directory where the executables files are written
EXE=~/bin

CC	= gcc
CFLAGS	= -pipe -O3

BIN	+= $(EXE)/tes
BIN	+= $(EXE)/rtes

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
