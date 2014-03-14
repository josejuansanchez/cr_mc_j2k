# Compilador
CC := gcc
# Flags
CFLAGS := -g

#Objetivos
all : differencespgm mergewois divideprecincts distinctOne distinctTwo snr \
      mergewoismax printprecincts deleteheader extract limitprecincts drawblocks printblock  \
      limitprecincts2 sumpgm differencespgm2 merge divideprecincts2 differencespgmprecincts joinprecincts \
      analyze avg limitprecincts3 differencesthumbnails differencesthumbnailsprecincts count txttodat countsops drawoneblock \
      extractcache sortcache viewcache drawblocks_txt print_wois_list create_image_pgm get_header_size_j2c limitprecincts_threshold \
      adaptative_threshold fusion fusion2 differencesppm countplt getprecinct differences move_pixels viewblocks cookcache

differencespgm: differencespgm.c PGM.o iroutines.o
	@echo "   Differences PGM:"
	$(CC) $(CFLAGS) PGM.o iroutines.o differencespgm.c -o $@ -lm

differencespgm2: differencespgm2.c PGM.o iroutines.o
	@echo "   Differences2 PGM:"
	$(CC) $(CFLAGS) PGM.o iroutines.o differencespgm2.c -o $@ -lm

differencespgmprecincts: differencespgmprecincts.c PGM.o iroutines.o
	@echo "   Differences PGM Precincts:"
	$(CC) $(CFLAGS) PGM.o iroutines.o differencespgmprecincts.c -o $@ -lm

differencesthumbnails: differencesthumbnails.c PGM.o iroutines.o
	@echo "   Differences Thumbnails:"
	$(CC) $(CFLAGS) PGM.o iroutines.o differencesthumbnails.c -o $@ -lm

differencesthumbnailsprecincts: differencesthumbnailsprecincts.c PGM.o iroutines.o
	@echo "   Differences Thumbnails Precincts:"
	$(CC) $(CFLAGS) PGM.o iroutines.o differencesthumbnailsprecincts.c -o $@ -lm

differences: differences.c PGM.o iroutines.o
	@echo "   Differences:"
	$(CC) $(CFLAGS) PGM.o iroutines.o differences.c -o $@ -lm

mergewois: mergewois.c PGM.o iroutines.o
	@echo "   Merge Wois:"
	$(CC) $(CFLAGS) PGM.o iroutines.o mergewois.c -o $@ -lm

mergewoismax: mergewoismax.c PGM.o iroutines.o
	@echo "   Merge Wois Max:"
	$(CC) $(CFLAGS) PGM.o iroutines.o mergewoismax.c -o $@ -lm

merge: merge.c PGM.o iroutines.o
	@echo "   Merge:"
	$(CC) $(CFLAGS) PGM.o iroutines.o merge.c -o $@ -lm

divideprecincts: divideprecincts.c PGM.o iroutines.o
	@echo "   Divide Precints:"
	$(CC) $(CFLAGS) PGM.o iroutines.o divideprecincts.c -o $@ -lm

divideprecincts2: divideprecincts2.c PGM.o iroutines.o
	@echo "   Divide Precints 2:"
	$(CC) $(CFLAGS) PGM.o iroutines.o divideprecincts2.c -o $@ -lm

deleteheader: deleteheader.c PGM.o iroutines.o
	@echo "   Delete Headers:"
	$(CC) $(CFLAGS) PGM.o iroutines.o deleteheader.c -o $@ -lm

extract: extract.c PGM.o iroutines.o
	@echo "   Extract:"
	$(CC) $(CFLAGS) PGM.o iroutines.o extract.c -o $@ -lm

limitprecincts: limitprecincts.c PGM.o iroutines.o
	@echo "   Limit Precints:"
	$(CC) $(CFLAGS) PGM.o iroutines.o limitprecincts.c -o $@ -lm

limitprecincts2: limitprecincts2.c PGM.o iroutines.o
	@echo "   Limit Precints2:"
	$(CC) $(CFLAGS) PGM.o iroutines.o limitprecincts2.c -o $@ -lm

limitprecincts3: limitprecincts3.c PGM.o iroutines.o
	@echo "   Limit Precints3:"
	$(CC) $(CFLAGS) PGM.o iroutines.o limitprecincts3.c -o $@ -lm

limitprecincts_threshold: limitprecincts_threshold.c PGM.o iroutines.o
	@echo "   Limit Precints Threshold:"
	$(CC) $(CFLAGS) PGM.o iroutines.o limitprecincts_threshold.c -o $@ -lm

sumpgm: sumpgm.c PGM.o iroutines.o
	@echo "   SumPGM:"
	$(CC) $(CFLAGS) PGM.o iroutines.o sumpgm.c -o $@ -lm

distinctOne: distinctOne.c distinct.o
	@echo "   distinctOne:"
	$(CC) $(CFLAGS) distinct.o distinctOne.c -o $@

distinctTwo: distinctTwo.c distinct.o
	@echo "   distinctTwo:"
	$(CC) $(CFLAGS) distinct.o distinctTwo.c -o $@

printprecincts: printprecincts.c iroutines.o
	@echo "   Print Precincts:"
	$(CC) $(CFLAGS) iroutines.o printprecincts.c -o $@ -lm

drawblocks: drawblocks.c PGM.o iroutines.o
	@echo "   Draw Blocks:"
	$(CC) $(CFLAGS) PGM.o iroutines.o drawblocks.c -o $@ -lm

drawoneblock: drawoneblock.c PGM.o iroutines.o
	@echo "   Draw One Block:"
	$(CC) $(CFLAGS) PGM.o iroutines.o drawoneblock.c -o $@ -lm

drawblocks_txt: drawblocks_txt.c PGM.o iroutines.o
	@echo "   Draw Blocks TXT:"
	$(CC) $(CFLAGS) PGM.o iroutines.o drawblocks_txt.c -o $@ -lm

printblock: printblock.c PGM.o iroutines.o
	@echo "   Print Block:"
	$(CC) $(CFLAGS) PGM.o iroutines.o printblock.c -o $@ -lm

joinprecincts: joinprecincts.c PGM.o iroutines.o
	@echo "   Join:"
	$(CC) $(CFLAGS) PGM.o iroutines.o joinprecincts.c -o $@ -lm

snr: snr.c
	@echo "   snr:"
	$(CC) $(CFLAGS) snr.c -o $@ -lm

avg: avg.c PGM.o iroutines.o
	@echo "   avg:"
	$(CC) $(CFLAGS)  PGM.o iroutines.o avg.c -o $@ -lm

count: count.c PGM.o iroutines.o
	@echo "   count:"
	$(CC) $(CFLAGS)  PGM.o iroutines.o count.c -o $@ -lm

txttodat: txttodat.c PGM.o iroutines.o
	@echo "   txttodat:"
	$(CC) $(CFLAGS)  PGM.o iroutines.o txttodat.c -o $@ -lm

PGM.o: PGM.c PGM.h
	@echo "   PGM:"
	$(CC) $(CFLAGS) -c PGM.c -o $@

iroutines.o: iroutines.c iroutines.h
	@echo "   iroutines:"
	$(CC) $(CFLAGS) -c iroutines.c -o $@ -lm

distinct.o: distinct.c distinct.h
	@echo "   distinct:"
	$(CC) $(CFLAGS) -c distinct.c -o $@

libcache.o: libcache.c libcache.h
	@echo "   iroutines:"
	$(CC) $(CFLAGS) -c libcache.c -o $@ -lm

analyze: analyze.c
	@echo "   analyze:"
	$(CC) $(CFLAGS) analyze.c -o $@ -lm

countsops: countsops.c
	@echo "  countsops:"
	$(CC) $(CFLAGS) countsops.c -o $@ -lm

extractcache: extractcache.c
	@echo "  extractcache:"
	$(CC) $(CFLAGS) extractcache.c -o $@ -lm

sortcache: sortcache.c libcache.o
	@echo "  sortcache:"
	$(CC) $(CFLAGS) libcache.o sortcache.c -o $@ -lm

viewcache: viewcache.c libcache.o
	@echo "  viewcache:"
	$(CC) $(CFLAGS) libcache.o viewcache.c -o $@ -lm

print_wois_list: print_wois_list.c
	@echo "  print_wois_list:"
	$(CC) $(CFLAGS) print_wois_list.c -o $@ -lm

create_image_pgm: create_image_pgm.c
	@echo "  create_image_pgm:"
	$(CC) $(CFLAGS) PGM.o create_image_pgm.c  -o $@ -lm

get_header_size_j2c: get_header_size_j2c.c
	@echo "  get_header_size_j2c:"
	$(CC) $(CFLAGS) get_header_size_j2c.c -o $@ -lm

adaptative_threshold: adaptative_threshold.c
	@echo "  adaptative_threshold:"
	$(CC) $(CFLAGS) PGM.o iroutines.o adaptative_threshold.c -o $@ -lm

fusion: fusion.c PGM.o iroutines.o
	@echo "   Fusion:"
	$(CC) $(CFLAGS) PGM.o iroutines.o fusion.c -o $@ -lm

fusion2: fusion2.c PGM.o iroutines.o
	@echo "   Fusion2:"
	$(CC) $(CFLAGS) PGM.o iroutines.o fusion2.c -o $@ -lm

PPM.o: PPM.c PPM.h
	@echo "   PPM:"
	$(CC) $(CFLAGS) -c PPM.c -o $@

differencesppm: differencesppm.c PPM.o iroutines.o
	@echo "   Differences PPM:"
	$(CC) $(CFLAGS) PPM.o iroutines.o differencesppm.c -o $@ -lm

countplt: countplt.c
	@echo "  countplt:"
	$(CC) $(CFLAGS) countplt.c -o $@ -lm

getprecinct: getprecinct.c
	@echo "  getprecinct:"
	$(CC) $(CFLAGS) getprecinct.c -o $@ -lm

move_pixels: move_pixels.c PGM.o
	@echo "   Move Pixels:"
	$(CC) $(CFLAGS) PGM.o move_pixels.c -o $@ -lm

viewblocks: viewblocks.c PGM.o iroutines.o
	@echo "   View Blocks:"
	$(CC) $(CFLAGS) PGM.o iroutines.o viewblocks.c -o $@ -lm

cookcache: cookcache.c libcache.o
	@echo "  cookcache:"
	$(CC) $(CFLAGS) libcache.o cookcache.c -o $@ -lm


clean :
	@echo "   Remove binaries..."
	rm -f *.o differencespgm mergewois divideprecincts distinctOne distinctTwo snr \
	mergewoismax printprecincts deleteheader extract limitprecincts drawblocks printblock \
	limitprecincts2 sumpgm differencespgm2 merge divideprecincts2 differencespgmprecincts joinprecincts \
  	analyze avg limitprecincts3 differencesthumbnails differencesthumbnailsprecincts count txttodat countsops drawoneblock \
	extractcache sortcache viewcache drawblocks_txt print_wois_list create_image_pgm get_header_size_j2c limitprecincts_threshold \
	adaptative_threshold fusion2 differencesppm countplt getprecinct fusion differences move_pixels viewblocks cookcache