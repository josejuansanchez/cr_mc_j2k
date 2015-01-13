default:	all

# Compiler
CC := gcc

# Flags
CFLAGS := -g -O3 -pipe
CFLAGS += -Wno-unused-result

# Directories
BIN = bin
EXE =

$(BIN)/differencespgm: src/differencespgm.c bin/PGM.o bin/iroutines.o
	@echo "   Differences PGM:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/differencespgm.c -o $@ -lm
EXE	+= $(BIN)/differencespgm

$(BIN)/differencespgm2: src/differencespgm2.c bin/PGM.o bin/iroutines.o
	@echo "   Differences2 PGM:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/differencespgm2.c -o $@ -lm
EXE	+= $(BIN)/differencespgm2

$(BIN)/differencespgmprecincts: src/differencespgmprecincts.c bin/PGM.o bin/iroutines.o
	@echo "   Differences PGM Precincts:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/differencespgmprecincts.c -o $@ -lm
EXE	+= $(BIN)/differencespgmprecincts

$(BIN)/differencesthumbnails: src/differencesthumbnails.c bin/PGM.o bin/iroutines.o
	@echo "   Differences Thumbnails:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/differencesthumbnails.c -o $@ -lm
EXE	+= $(BIN)/differencesthumbnails

$(BIN)/differencesthumbnailsprecincts: src/differencesthumbnailsprecincts.c bin/PGM.o bin/iroutines.o
	@echo "   Differences Thumbnails Precincts:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/differencesthumbnailsprecincts.c -o $@ -lm
EXE	+= $(BIN)/differencesthumbnailsprecincts

$(BIN)/differences: src/differences.c bin/PGM.o bin/iroutines.o
	@echo "   Differences:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/differences.c -o $@ -lm
EXE	+= $(BIN)/differences

$(BIN)/mergewois: src/mergewois.c bin/PGM.o bin/iroutines.o
	@echo "   Merge Wois:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/mergewois.c -o $@ -lm
EXE	+= $(BIN)/mergewois

$(BIN)/mergewoismax: src/mergewoismax.c bin/PGM.o bin/iroutines.o
	@echo "   Merge Wois Max:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/mergewoismax.c -o $@ -lm
EXE	+= $(BIN)/mergewoismax

$(BIN)/merge: src/merge.c bin/PGM.o bin/iroutines.o
	@echo "   Merge:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/merge.c -o $@ -lm
EXE	+= $(BIN)/

$(BIN)/divideprecincts: src/divideprecincts.c bin/PGM.o bin/iroutines.o
	@echo "   Divide Precints:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/divideprecincts.c -o $@ -lm
EXE	+= $(BIN)/merge

$(BIN)/divideprecincts2: src/divideprecincts2.c bin/PGM.o bin/iroutines.o
	@echo "   Divide Precints 2:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/divideprecincts2.c -o $@ -lm
EXE	+= $(BIN)/divideprecincts2

$(BIN)/deleteheader: src/deleteheader.c bin/PGM.o bin/iroutines.o
	@echo "   Delete Headers:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/deleteheader.c -o $@ -lm
EXE	+= $(BIN)/deleteheader

$(BIN)/extract: src/extract.c bin/PGM.o bin/iroutines.o
	@echo "   Extract:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/extract.c -o $@ -lm
EXE	+= $(BIN)/extract

$(BIN)/limitprecincts: src/limitprecincts.c bin/PGM.o bin/iroutines.o
	@echo "   Limit Precints:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/limitprecincts.c -o $@ -lm
EXE	+= $(BIN)/limitprecincts

$(BIN)/limitprecincts2: src/limitprecincts2.c bin/PGM.o bin/iroutines.o
	@echo "   Limit Precints2:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/limitprecincts2.c -o $@ -lm
EXE	+= $(BIN)/limitprecincts2

$(BIN)/limitprecincts3: src/limitprecincts3.c bin/PGM.o bin/iroutines.o
	@echo "   Limit Precints3:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/limitprecincts3.c -o $@ -lm
EXE	+= $(BIN)/limitprecincts3

$(BIN)/limitprecincts_threshold: src/limitprecincts_threshold.c bin/PGM.o bin/iroutines.o
	@echo "   Limit Precints Threshold:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/limitprecincts_threshold.c -o $@ -lm
EXE	+= $(BIN)/limitprecincts_threshold

$(BIN)/sumpgm: src/sumpgm.c bin/PGM.o bin/iroutines.o
	@echo "   SumPGM:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/sumpgm.c -o $@ -lm
EXE	+= $(BIN)/sumpgm

$(BIN)/distinctOne: src/distinctOne.c bin/distinct.o
	@echo "   distinctOne:"
	$(CC) $(CFLAGS) bin/distinct.o src/distinctOne.c -o $@
EXE	+= $(BIN)/distinctOne

$(BIN)/distinctTwo: src/distinctTwo.c bin/distinct.o
	@echo "   distinctTwo:"
	$(CC) $(CFLAGS) bin/distinct.o src/distinctTwo.c -o $@
EXE	+= $(BIN)/distinctTwo

$(BIN)/printprecincts: src/printprecincts.c bin/iroutines.o
	@echo "   Print Precincts:"
	$(CC) $(CFLAGS) bin/iroutines.o src/printprecincts.c -o $@ -lm
EXE	+= $(BIN)/printprecincts

$(BIN)/drawblocks: src/drawblocks.c bin/PGM.o bin/iroutines.o
	@echo "   Draw Blocks:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/drawblocks.c -o $@ -lm
EXE	+= $(BIN)/drawblocks

$(BIN)/drawoneblock: src/drawoneblock.c bin/PGM.o bin/iroutines.o
	@echo "   Draw One Block:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/drawoneblock.c -o $@ -lm
EXE	+= $(BIN)/drawoneblock

$(BIN)/drawblocks_txt: src/drawblocks_txt.c bin/PGM.o bin/iroutines.o
	@echo "   Draw Blocks TXT:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/drawblocks_txt.c -o $@ -lm
EXE	+= $(BIN)/drawblocks_txt

$(BIN)/printblock: src/printblock.c bin/PGM.o bin/iroutines.o
	@echo "   Print Block:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/printblock.c -o $@ -lm
EXE	+= $(BIN)/printblock

$(BIN)/joinprecincts: src/joinprecincts.c bin/PGM.o bin/iroutines.o
	@echo "   Join:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/joinprecincts.c -o $@ -lm
EXE	+= $(BIN)/joinprecincts

$(BIN)/snr: src/snr.c
	@echo "   snr:"
	$(CC) $(CFLAGS) src/snr.c -o $@ -lm
EXE	+= $(BIN)/snr

$(BIN)/avg: src/avg.c bin/PGM.o bin/iroutines.o
	@echo "   avg:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/avg.c -o $@ -lm
EXE	+= $(BIN)/avg

$(BIN)/count: src/count.c bin/PGM.o bin/iroutines.o
	@echo "   count:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/count.c -o $@ -lm
EXE	+= $(BIN)/count

$(BIN)/txttodat: src/txttodat.c bin/PGM.o bin/iroutines.o
	@echo "   txttodat:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/txttodat.c -o $@ -lm
EXE	+= $(BIN)/txttodat

$(BIN)/PGM.o: src/PGM.c src/PGM.h
	@echo "   PGM:"
	$(CC) $(CFLAGS) -c src/PGM.c -o $@
EXE	+= $(BIN)/PGM.o

$(BIN)/iroutines.o: src/iroutines.c src/iroutines.h
	@echo "   iroutines:"
	$(CC) $(CFLAGS) -c src/iroutines.c -o $@ -lm
EXE	+= $(BIN)/iroutines.o

$(BIN)/distinct.o: src/distinct.c src/distinct.h
	@echo "   distinct:"
	$(CC) $(CFLAGS) -c src/distinct.c -o $@
EXE	+= $(BIN)/distinct.o

$(BIN)/libcache.o: src/libcache.c src/libcache.h
	@echo "   iroutines:"
	$(CC) $(CFLAGS) -c src/libcache.c -o $@ -lm
EXE	+= $(BIN)/libcache.o

$(BIN)/analyze: src/analyze.c
	@echo "   analyze:"
	$(CC) $(CFLAGS) src/analyze.c -o $@ -lm
EXE	+= $(BIN)/analyze

$(BIN)/countsops: src/countsops.c
	@echo "  countsops:"
	$(CC) $(CFLAGS) src/countsops.c -o $@ -lm
EXE	+= $(BIN)/countsops

$(BIN)/extractcache: src/extractcache.c
	@echo "  extractcache:"
	$(CC) $(CFLAGS) src/extractcache.c -o $@ -lm
EXE	+= $(BIN)/extractcache

$(BIN)/sortcache: src/sortcache.c bin/libcache.o
	@echo "  sortcache:"
	$(CC) $(CFLAGS) bin/libcache.o src/sortcache.c -o $@ -lm
EXE	+= $(BIN)/sortcache

$(BIN)/viewcache: src/viewcache.c bin/libcache.o
	@echo "  viewcache:"
	$(CC) $(CFLAGS) bin/libcache.o src/viewcache.c -o $@ -lm
EXE	+= $(BIN)/viewcache

$(BIN)/print_wois_list: src/print_wois_list.c
	@echo "  print_wois_list:"
	$(CC) $(CFLAGS) src/print_wois_list.c -o $@ -lm
EXE	+= $(BIN)/print_wois_list

$(BIN)/create_image_pgm: src/create_image_pgm.c
	@echo "  create_image_pgm:"
	$(CC) $(CFLAGS) bin/PGM.o src/create_image_pgm.c  -o $@ -lm
EXE	+= $(BIN)/create_image_pgm

$(BIN)/get_header_size_j2c: src/get_header_size_j2c.c
	@echo "  get_header_size_j2c:"
	$(CC) $(CFLAGS) src/get_header_size_j2c.c -o $@ -lm
EXE	+= $(BIN)/get_header_size_j2c

$(BIN)/adaptative_threshold: src/adaptative_threshold.c
	@echo "  adaptative_threshold:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/adaptative_threshold.c -o $@ -lm
EXE	+= $(BIN)/adaptative_threshold

$(BIN)/fusion: src/fusion.c bin/PGM.o bin/iroutines.o
	@echo "   Fusion:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/fusion.c -o $@ -lm
EXE	+= $(BIN)/fusion

$(BIN)/fusion2: src/fusion2.c bin/PGM.o bin/iroutines.o
	@echo "   Fusion2:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/fusion2.c -o $@ -lm
EXE	+= $(BIN)/fusion2

$(BIN)/PPM.o: src/PPM.c src/PPM.h
	@echo "   PPM:"
	$(CC) $(CFLAGS) -c src/PPM.c -o $@
EXE	+= $(BIN)/PPM.o

$(BIN)/differencesppm: src/differencesppm.c bin/PPM.o bin/iroutines.o
	@echo "   Differences PPM:"
	$(CC) $(CFLAGS) bin/PPM.o bin/iroutines.o src/differencesppm.c -o $@ -lm
EXE	+= $(BIN)/differencesppm

$(BIN)/countplt: src/countplt.c
	@echo "  countplt:"
	$(CC) $(CFLAGS) src/countplt.c -o $@ -lm
EXE	+= $(BIN)/countplt

$(BIN)/getprecinct: src/getprecinct.c
	@echo "  getprecinct:"
	$(CC) $(CFLAGS) src/getprecinct.c -o $@ -lm
EXE	+= $(BIN)/getprecinct

$(BIN)/move_pixels: src/move_pixels.c bin/PGM.o
	@echo "   Move Pixels:"
	$(CC) $(CFLAGS) bin/PGM.o src/move_pixels.c -o $@ -lm
EXE	+= $(BIN)/move_pixels

$(BIN)/viewblocks: src/viewblocks.c bin/PGM.o bin/iroutines.o
	@echo "   View Blocks:"
	$(CC) $(CFLAGS) bin/PGM.o bin/iroutines.o src/viewblocks.c -o $@ -lm
EXE	+= $(BIN)/viewblocks

$(BIN)/cookcache: src/cookcache.c bin/libcache.o
	@echo "  cookcache:"
	$(CC) $(CFLAGS) bin/libcache.o src/cookcache.c -o $@ -lm
EXE	+= $(BIN)/cookcache

# Objetives
all: 	$(EXE)

clean :
	@echo "   Remove binaries..."
	rm -f $(BIN)/*