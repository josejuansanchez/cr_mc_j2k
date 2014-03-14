# This is the directory where the executables files are written
EXE=~/bin

CC	= gcc
CFLAGS	= -Wall -pipe -O2 -D_DEBUG_
#CFLAGS	= -g
LIB=./lib

$(LIB)/%.o :: %.c
	$(CC) $(CFLAGS) -c $< -o $@

#$(EXE)/video_show:	video_show.c $(LIB)/args.o $(LIB)/malloc.o
#		$(CC) $(CFLAGS) $^ -o $@ -L/usr/X11R6/lib -lX11

$(EXE)/video_show:	video_show_opengl.c $(LIB)/args.o $(LIB)/malloc.o
		$(CC) $(CFLAGS) $^ -o $@ -lglut -lGLU

BIN	+= $(EXE)/video_show

#BIN	+= $(EXE)/video_show_opengl

test:
	@if ! [ -d $(EXE) ]; then \
		echo "Makefile: Unable to locate the directory \"$(EXE)\""; \
		echo "Makefile: Please, edit the Makefile file and modify the \"EXE\" variable"; \
		echo "Makefile: according to the path to this directory"; \
	fi

all:	test $(BIN)

clean:	test
	rm -f $(LIB)/* $(BIN)
