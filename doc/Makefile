#------------- Report name -------------------------------------------------
PAPER = report

#------------- LaTeX modules (without extension) --------------------------
TEX_MODS = 

#------------- Paths for GPT, FIG and PPM objects -------------------------
GPT_PATH = graphics
FIG_PATH = figures
PPM_PATH = images

#------------- Objects names (without extension) --------------------------
GPT_OBJS = 

FIG_OBJS = 

PPM_OBJS =   

#------------- Target object pathnames ------------------------------------
TEX_OBJS = $(GPT_OBJS:%=$(GPT_PATH)/%.pdf)      \
           $(FIG_OBJS:%=$(FIG_PATH)/%.pdf)      \
           $(PPM_OBJS:%=$(PPM_PATH)/%.png)      

#------------- Main build -------------------------------------------------     
paper: $(TEX_MODS:%=%.tex) $(TEX_OBJS) $(PAPER).tex
	pdflatex $(PAPER)
	pdflatex $(PAPER)
                                                                                                        
#------------- PDF -> PS automatic build ----------------------------------  
%.ps: %.pdf
	pdftops $< - | a2ps --columns=1 --sides=2 -o - > $@

#------------- GPT -> FIG automatic build ---------------------------------  
%.fig: %.gpt
	(echo "set output \"$*.fig\"" | cat - $*.gpt) | gnuplot

#------------- FIG -> EPS + TEX automatic build ---------------------------
%.eps %.tex: %.fig
	fig2dev -L pstex $*.fig > $*.eps
	(fig2dev -L pstex_t -p $* $< | sed 's/special{psfile=/includegraphics{/g') > $*.tex

#------------- EPS -> PDF automatic build ---------------------------------  
%.pdf: %.eps
	epstopdf $*.eps

#------------- PPM -> PNG automatic build ---------------------------------
%.png: %.ppm
	pnmtopng < $*.ppm > $*.png

#------------- Cleaning ---------------------------------------------------
clean:  
	rm -f $(TEX_OBJS) $(TEX_OBJS:%.pdf=%.tex)
	rm -f *.log *.aux *.bbl *.blg *~ *.backup 
	rm -f *.toc *.out *.lot *.lof
	rm -f $(PAPER).pdf rm -f $(PROPOSAL).pdf

