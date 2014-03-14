BIN = ~/bin
LIB = ~/lib
CFLAGS = #-O3
CC = g++

$(BIN)/pnm2raw:	pnm2raw.cc $(LIB)/args.o $(LIB)/pnm_in.o
		$(CC) $(CFLAGS) $^ -o $@

$(LIB)/%.o :: %.cc
	$(CC) $(CFLAGS) -c $< -o $@

default:	$(BIN)/pnm2raw

clean:
	rm -f $(LIB)/args.o $(LIB)/pnm_in.o $(BIN)/pnm2raw