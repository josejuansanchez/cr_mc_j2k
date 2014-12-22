# Compilador
CC := gcc
# Flags
CFLAGS := -g

#Objetivos
all : create_woi_list

create_woi_list: create_woi_list.c
	@echo "  main:"
	$(CC) $(CFLAGS) create_woi_list.c -o $@ -lm

clean :
	@echo "   Remove binaries..."
	rm -f *.o create_woi_list