MAKEFILE = Makefile

all:
	cd ../tools; make -f $(MAKEFILE) all	
	cd ../tools/dssim; make -f $(MAKEFILE)
	cd ../knapsack/tools/knapsack; make -f $(MAKEFILE) all	
	cd ../knapsack/tools/j2c_to_knapsack_files; make -f $(MAKEFILE) all 
	cd ../src/CR; make -f $(MAKEFILE) all 
	cd ../MCJ2K/src; make -f $(MAKEFILE) all 

clean:
	cd ../tools; make -f $(MAKEFILE) clean
	cd ../tools/dssim; make -f $(MAKEFILE) clean	
	cd ../knapsack/tools/knapsack; make -f $(MAKEFILE) clean	
	cd ../knapsack/tools/j2c_to_knapsack_files; make -f $(MAKEFILE) clean 
	cd ../src/CR; make -f $(MAKEFILE) clean 	
	cd ../MCJ2K/src; make -f $(MAKEFILE) clean 