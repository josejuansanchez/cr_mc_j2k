DIRS += mux
DIRS += scalar
DIRS += snr
DIRS += type
DIRS += video_show
DIRS += vix2raw
DIRS += dwt
DIRS += info
DIRS += rgb2yuv

# Directorio con los ejecutables
BIN = ~/bin

all:
	@if ! [ -d $(BIN) ]; then \
		echo Creando $(BIN); \
		mkdir $(BIN); \
	fi

	@for i in $(DIRS); do \
		make -C $$i all;\
	done

clean:
	@for i in $(DIRS); do \
		make -C $$i clean;\
	done

mrproper:	clean
