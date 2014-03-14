# This is the directory where the executables files are written
BIN=$(HOME)/bin

# The C Compiler
CC	= g++

# Compilation flags
CFLAGS	= -pipe -O3

# This is the directory for the libraries
LIB	= .

# Compilation rule for the libraries
$(LIB)/%.o :: %.cpp
	$(CC) $(CFLAGS) -c $< -o $@

$(BIN)/entropy: entropy_main.cpp $(LIB)/entropy.o
	$(CC) $(CFLAGS) $^ -o $@ -lm

$(BIN)/max: max.cpp
	$(CC) $(CFLAGS) $^ -o $@ -lm

EXE	+= $(BIN)/entropy
EXE	+= $(BIN)/max

#$(EXE)/% :: %.cpp
#	$(CC) $(CFLAGS) $< -o $@ -lm

test:
	@if ! [ -d $(BIN) ]; then \
		echo "Makefile: Unable to locate the directory \"$(BIN)\""; \
		echo "Makefile: Please, edit the Makefile file and modify the \"BIN\" variable"; \
		echo "Makefile: according to the path to this directory"; \
	fi

all:	test $(EXE)

clean:	test
	rm -f $(EXE)

mrproper:
	make clean
	rm $(LIB)/*.o