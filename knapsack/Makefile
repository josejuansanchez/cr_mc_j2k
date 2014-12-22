# Compilador
CC := gcc
# Flags
CFLAGS := -g

#Objetivos
all : knapsack

libknapsack.o: libknapsack.c libknapsack.h
	@echo "   libknapsack:"
	$(CC) $(CFLAGS) -c libknapsack.c -o $@ -lm

knapsacktest: knapsacktest.c libknapsack.o
	@echo "  knapsacktest:"
	$(CC) $(CFLAGS) libknapsack.o knapsacktest.c -o $@ -lm

knapsack: knapsack.c libknapsack.o parson/parson.c
	@echo "  knapsack:"
	$(CC) $(CFLAGS) libknapsack.o knapsack.c parson/parson.c -o $@ -lm


clean :
	@echo "   Remove binaries..."
	rm -f *.o knapsacktest knapsack