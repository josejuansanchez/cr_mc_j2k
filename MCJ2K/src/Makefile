default:	all

CC = g++

BIN = ../bin
EXE =
CFLAGS = -g
#CFLAGS  = -g -O3 -pipe
GCC_FLAGS = -g -O3 -pipe
CPP_FLAGS = -g -O3 -pipe
DEFS =

# Activa el modo depuraci'on y env'ia los mensajes a trav'es de
# stdout.
#DEFS += -D DEBUG

# Write the executed commands to a trace file
DEFS += -D TRACE

# Reglas
$(BIN)/% :: %.c
	gcc $(GCC_FLAGS) $< -o $@ -lm

$(BIN)/% :: %.cpp
	g++ $(CPP_FLAGS) $< -o $@ -lm

PYs := $(willcard *.py)

TMPs =
TMPs += $(PYs:%.py=$(BIN)/%)
$(BIN)/%:	%.py
	(echo "changequote({{,}})dnl"; cat $*.py) | m4 $(DEFS) > $@; chmod +x $@

$(BIN)/%.py:	%.py
	(echo "changequote({{,}})dnl"; cat $*.py) | m4 $(DEFS) > $@; chmod +x $@

#CPPM4s := $(wildcard *.cpp.m4)

#TMPs =
#TMPs += $(CPPM4s:%.cpp.m4=%.cpp)
#%.cpp:	%.cpp.m4
#	(echo "changequote(\`[[[', \`]]]')"; cat $*.cpp.m4) | m4 $(DEFS) > $*.cpp

$(HOME)/bin/mctf:	mctf.sh
	(echo "changequote({{,}})dnl"; cat $<) | m4 $(DEFS) > $@; chmod +x $@
#	m4 $(DEFS) < $< > $@; chmod +x $@
EXE	+= $(HOME)/bin/mctf

$(HOME)/bin/mcj2k:	mcj2k.sh
	(echo "changequote({{,}})dnl"; cat $<) | m4 $(DEFS) > $@; chmod +x $@
#	m4 $(DEFS) < $< > $@; chmod +x $@
EXE	+= $(HOME)/bin/mcj2k

$(HOME)/bin/mcjpg:	mcjpg.sh
	(echo "changequote({{,}})dnl"; cat $<) | m4 $(DEFS) > $@; chmod +x $@
#	m4 $(DEFS) < $< > $@; chmod +x $@
EXE	+= $(HOME)/bin/mcjpg

$(HOME)/bin/vshow:	vshow.sh
	(echo "changequote({{,}})dnl"; cat $<) | m4 $(DEFS) > $@; chmod +x $@
EXE	+= $(HOME)/bin/vshow

$(BIN)/split:	split.cpp display.cpp
	$(CC) $(CFLAGS) -D ANALYZE $< -o $@ -lm
EXE += $(BIN)/split

$(BIN)/merge:	split.cpp display.cpp
	$(CC) $(CFLAGS) $< -o $@ -lm
EXE += $(BIN)/merge

$(BIN)/motion_estimate:	motion_estimate.cpp Haar.cpp 5_3.cpp dwt2d.cpp texture.cpp motion.cpp display.cpp
EXE += $(BIN)/motion_estimate

$(BIN)/me:	me.cpp Haar.cpp 5_3.cpp dwt2d.cpp texture.cpp motion.cpp display.cpp PGM.cpp io_operations.cpp
	$(CC) $(CFLAGS) $< -o $@ -lm
EXE += $(BIN)/me

$(BIN)/media:	media.cpp texture.cpp motion.cpp
	$(CC) $(CFLAGS) $< -o $@ -lm
EXE += $(BIN)/media

$(BIN)/me_xfield_topgm:	me_xfield_topgm.c
	$(CC) $(CFLAGS) $< -o $@ -lm
EXE += $(BIN)/me_xfield_topgm

$(BIN)/me_yfield_topgm:	me_yfield_topgm.c
	$(CC) $(CFLAGS) $< -o $@ -lm
EXE += $(BIN)/me_yfield_topgm

$(BIN)/gnutopgm: gnutopgm.c
	$(CC) $(CFLAGS) $< -o $@ -lm
EXE += $(BIN)/gnutopgm

$(BIN)/suma:	suma.cpp texture.cpp motion.cpp
	$(CC) $(CFLAGS) $< -o $@ -lm
EXE += $(BIN)/suma

$(BIN)/divide:	divide.cpp texture.cpp motion.cpp
	$(CC) $(CFLAGS) $< -o $@ -lm
EXE += $(BIN)/divide


$(BIN)/decorrelate:	decorrelate.cpp Haar.cpp 5_3.cpp dwt2d.cpp texture.cpp motion.cpp display.cpp entropy.o
	$(CC) $(CFLAGS) -D ANALYZE $< entropy.o -o $@ -lm
EXE += $(BIN)/decorrelate

$(BIN)/correlate:	decorrelate.cpp Haar.cpp 5_3.cpp dwt2d.cpp texture.cpp motion.cpp display.cpp
	$(CC) $(CFLAGS) $< -o $@ -lm
EXE += $(BIN)/correlate

$(BIN)/update:	update.cpp Haar.cpp 5_3.cpp dwt2d.cpp texture.cpp motion.cpp display.cpp
	$(CC) $(CFLAGS) -D ANALYZE $< -o $@ -lm
EXE += $(BIN)/update

$(BIN)/un_update:	update.cpp Haar.cpp 5_3.cpp dwt2d.cpp texture.cpp motion.cpp display.cpp
	$(CC) $(CFLAGS) $< -o $@ -lm
EXE += $(BIN)/un_update

$(BIN)/display.py:	display.py
	(echo "changequote({{,}})dnl"; cat $<) | m4 $(DEFS) > $@; chmod +x $@
EXE += $(BIN)/display.py

$(BIN)/analyze_step:	analyze_step.py
	(echo "changequote({{,}})dnl"; cat $<) | m4 $(DEFS) > $@; chmod +x $@
EXE	+= $(BIN)/analyze_step

$(BIN)/GOP.py:	GOP.py
	cp $^ $@
EXE += $(BIN)/GOP.py

$(BIN)/analyze:	analyze.py
	(echo "changequote({{,}})dnl"; cat $<) | m4 $(DEFS) > $@; chmod +x $@
EXE	+= $(BIN)/analyze

$(BIN)/interlevel_motion_decorrelate:	interlevel_motion_decorrelate.cpp
	$(CC) $(CFLAGS) -D ANALYZE $^ -o $@ -lm
EXE += $(BIN)/interlevel_motion_decorrelate

$(BIN)/bidirectional_motion_decorrelate: bidirectional_motion_decorrelate.cpp
	$(CC) $(CFLAGS) -D ANALYZE $^ -o $@ -lm
EXE += $(BIN)/bidirectional_motion_decorrelate

$(BIN)/motion_compress_cp:	motion_compress_cp.py
EXE	+= $(BIN)/motion_compress_cp

$(BIN)/motion_compress_j2k:	motion_compress_j2k.py
EXE	+= $(BIN)/motion_compress_j2k

$(BIN)/motion_compress_gzip:	motion_compress_gzip.py
EXE	+= $(BIN)/motion_compress_gzip

$(BIN)/interlevel_motion_correlate:	interlevel_motion_decorrelate.cpp motion.cpp
	$(CC) $(CFLAGS) $(DEFS) $< -o $@ -lm
EXE += $(BIN)/interlevel_motion_correlate

$(BIN)/bidirectional_motion_correlate: bidirectional_motion_decorrelate.cpp motion.cpp
	$(CC) $(CFLAGS) $(DEFS) $< -o $@ -lm
EXE += $(BIN)/bidirectional_motion_correlate

$(BIN)/motion_compress:	motion_compress.py
EXE	+= $(BIN)/motion_compress

$(BIN)/texture_compress_lfb_j2k:	texture_compress_lfb_j2k.py
EXE	+= $(BIN)/texture_compress_lfb_j2k

$(BIN)/texture_compress_lfb_jpg:	texture_compress_lfb_jpg.py
EXE	+= $(BIN)/texture_compress_lfb_jpg

$(BIN)/texture_compress_hfb_j2k:	texture_compress_hfb_j2k.py
EXE	+= $(BIN)/texture_compress_hfb_j2k

$(BIN)/texture_compress_hfb_jpg:	texture_compress_hfb_jpg.py
EXE	+= $(BIN)/texture_compress_hfb_jpg

$(BIN)/texture_compress:	texture_compress.py
EXE	+= $(BIN)/texture_compress

$(BIN)/compress:	compress.py
EXE	+= $(BIN)/compress

$(BIN)/synthesize_step:	synthesize_step.py
EXE	+= $(BIN)/synthesize_step

$(BIN)/synthesize:	synthesize.py
EXE	+= $(BIN)/synthesize

$(BIN)/motion_expand_cp:	motion_expand_cp.py
EXE	+= $(BIN)/motion_expand_cp

$(BIN)/motion_expand_j2k:	motion_expand_j2k.py
EXE	+= $(BIN)/motion_expand_j2k

$(BIN)/motion_expand_gzip:	motion_expand_gzip.py
EXE	+= $(BIN)/motion_expand_gzip

$(BIN)/motion_expand:	motion_expand.py
EXE	+= $(BIN)/motion_expand

$(BIN)/texture_expand_lfb_j2k:	texture_expand_lfb_j2k.py
EXE	+= $(BIN)/texture_expand_lfb_j2k

$(BIN)/texture_expand_lfb_jpg:	texture_expand_lfb_jpg.py
EXE	+= $(BIN)/texture_expand_lfb_jpg

$(BIN)/texture_expand_hfb_j2k:	texture_expand_hfb_j2k.py
EXE	+= $(BIN)/texture_expand_hfb_j2k

$(BIN)/texture_expand_hfb_jpg:	texture_expand_hfb_jpg.py
EXE	+= $(BIN)/texture_expand_hfb_jpg

$(BIN)/texture_expand:	texture_expand.py
EXE	+= $(BIN)/texture_expand

$(BIN)/expand:	expand.py
EXE	+= $(BIN)/expand

$(BIN)/info.py:
EXE	+= $(BIN)/info.py

$(BIN)/info_j2k:	$(BIN)/info.py info_j2k.py
EXE	+= $(BIN)/info_j2k

$(BIN)/info_jpg:	$(BIN)/info.py info_jpg.py
EXE	+= $(BIN)/info_jpg

$(BIN)/psnr:	psnr.py
EXE	+= $(BIN)/psnr

$(BIN)/snr:	snr.c
EXE	+= $(BIN)/snr

$(BIN)/vix2raw:	vix2raw.c
EXE	+= $(BIN)/vix2raw

$(BIN)/psnr_vs_br:	psnr_vs_br.py
EXE	+= $(BIN)/psnr_vs_br

$(BIN)/extract:	extract.py
EXE	+= $(BIN)/extract

#$(BIN)/mcj2k:	$(shell which mcj2k)
#			ln -s $< $@
#EXE	+= $(BIN)/mcj2k

#$(BIN)/mcj2k:	$(shell which mcj2k)
#			ln -s $< $@
#EXE	+= $(BIN)/mcj2k

#all:	$(EXE)
all: $(BIN)/me $(BIN)/decorrelate

objetives:
	@echo $(EXE) all clean

info:	objetives

clean:
	rm -f $(EXE) ../bin/*.pyc ../bin/*.py $(TMPs)
