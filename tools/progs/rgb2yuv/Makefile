# This is the directory where the executables files are written
BIN=$(HOME)/bin

# The C Compiler
CC	= g++

# Compilation flags
CFLAGS	= -O3 -pipe
#CFLAGS	= -g

# The directory for the libraries
LIB	= .

# Compilation of the libraries
$(LIB)/%.o :: %.cpp
	$(CC) $(CFLAGS) -c $< -o $@

$(BIN)/rgb2yuv:	main_rgb2yuv.cpp $(LIB)/rgb2yuv.o
	$(CC) $(CFLAGS) $^ -o $@

$(BIN)/yuv2rgb:	main_yuv2rgb.cpp $(LIB)/rgb2yuv.o
	$(CC) $(CFLAGS) $^ -o $@

EXE	+= $(BIN)/rgb2yuv
EXE	+= $(BIN)/yuv2rgb

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
