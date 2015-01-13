default:	all

# Compiler
CC := gcc

# Flags
CFLAGS := -g -O3 -pipe
CFLAGS += -Wno-unused-result

# Directories
BIN = bin
EXE =

$(BIN)/create_woi_list: src/create_woi_list.c
	@echo "  create_woi_list:"
	$(CC) $(CFLAGS) src/create_woi_list.c -o $@ -lm
EXE += $(BIN)/create_woi_list

#Objetives
all :	$(EXE)

clean :
	@echo "   Remove binaries..."
	rm -f $(BIN)/*	