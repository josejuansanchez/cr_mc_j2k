# This is the directory where the executables files are written
BIN=$(HOME)/bin

# The C Compiler
CC	= g++

# Compilation flags
#CFLAGS	= -O3 -pipe
CFLAGS	= -g

# This is the directory for the libraries
LIB	= .

# Compilation of the libraries
$(LIB)/%.o :: %.cpp
	$(CC) $(CFLAGS) -c $< -o $@

$(BIN)/dwt2d:	main_dwt2d.cpp $(LIB)/dwt2d.o $(LIB)/dprfb.o $(LIB)/13_7.o $(LIB)/SP.o $(LIB)/5_3.o $(LIB)/Haar.o $(LIB)/mallok.o
	$(CC) $(CFLAGS) $^ -o $@

$(BIN)/rdwt2d:	main_rdwt2d.cpp $(LIB)/rdwt2d.o $(LIB)/dwt2d.o $(LIB)/dprfb.o $(LIB)/13_7.o $(LIB)/SP.o $(LIB)/5_3.o $(LIB)/Haar.o $(LIB)/mallok.o
	$(CC) $(CFLAGS) $^ -o $@

$(BIN)/unitary2d: main_unitary2d.cpp $(LIB)/dwt2d.o $(LIB)/dprfb.o $(LIB)/unitary.o $(LIB)/mallok.o
	$(CC) $(CFLAGS) $^ -o $@

EXE	+= $(BIN)/dwt2d
EXE	+= $(BIN)/rdwt2d
EXE	+= $(BIN)/unitary2d

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
