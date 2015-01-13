default:	all

# Compiler
CC := gcc

# Flags
CFLAGS := -g -O3 -pipe
CFLAGS += -Wno-unused-result

# Directories
BIN = bin
EXE =

$(BIN)/libknapsack.o: src/libknapsack.c src/libknapsack.h
	@echo "   libknapsack:"
	$(CC) $(CFLAGS) -c src/libknapsack.c -o $@ -lm
EXE += $(BIN)/libknapsack.o

$(BIN)/knapsacktest: src/knapsacktest.c bin/libknapsack.o
	@echo "  knapsacktest:"
	$(CC) $(CFLAGS) bin/libknapsack.o src/knapsacktest.c -o $@ -lm
EXE += $(BIN)/knapsacktest

$(BIN)/knapsack: src/knapsack.c bin/libknapsack.o src/parson/parson.c
	@echo "  knapsack:"
	$(CC) $(CFLAGS) bin/libknapsack.o src/knapsack.c src/parson/parson.c -o $@ -lm
EXE += $(BIN)/knapsack

#Objetives
all : directories $(EXE)

clean :
	@echo "   Remove binaries..."
	rm -rf $(BIN)/*

directories:
	mkdir -p $(BIN)