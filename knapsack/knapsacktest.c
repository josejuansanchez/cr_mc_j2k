#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include "libknapsack.h"

int main(int argc, char *argv[])
{
	long budget;
	long max_precincts;
	int max_quality_layers;
	long **weights;
	double **profit;
	long *ordered_list;
	int i, j;

	if (argc < 4) {
		printf("Usage: %s <max_precincts> <max_quality_layers> <budget>\n",argv[0]);
		exit(0);
	}

	// Check the intial value
	max_precincts = atoi(argv[1]);

	if (max_precincts <= 0) {
		printf("The max number of precincts must be a positive integer\n");
		exit(0);
	}

	// Check the intial value
	max_quality_layers = atoi(argv[2]);

	if (max_quality_layers <= 0) {
		printf("The max number of quality layers must be a positive integer\n");
		exit(0);
	}

	// Check the intial value
	budget = atoi(argv[3]);

	if (budget <= 0) {
		printf("The budget must be a positive integer\n");
		exit(0);
	}

  	// Initialize random generator
  	srand (time(NULL));	
	
	// Allocate memory for weights
	if (allocate_memory_for_weights(max_precincts, max_quality_layers, &weights) <= 0) {
		printf("Error allocating memory for weights.\n");
		exit(1);
	}

	// Allocate memory for profit
	if (allocate_memory_for_profit(max_precincts, max_quality_layers, &profit) <= 0) {
		printf("Error allocating memory for profit.\n");
		exit(1);
	}

	// Allocate memory for ordered_list
	if (allocate_memory_for_ordered_list(max_precincts, &ordered_list) <= 0) {
		printf("Error allocating memory for ordered list.\n");
		exit(1);
	}

	
	// Create initial values for weights
	if (create_file_of_weights(WEIGHTS_FILENAME, max_precincts, max_quality_layers) <=0 ) {
		printf("Error creating the file of weights: %s\n", WEIGHTS_FILENAME);
		exit(1);
	}

	// Read the values for weights (This step is for checking the values)
	if (read_file_of_weights(WEIGHTS_FILENAME, max_precincts, max_quality_layers, weights) <= 0) {
		printf("Error reading the file of weights: %s\n", WEIGHTS_FILENAME);
		exit(1);		
	}

	// Create initial values for profit
	if (create_file_of_profit(PROFIT_FILENAME, max_precincts, max_quality_layers) <= 0) {
		printf("Error creating the file of profit: %s\n", PROFIT_FILENAME);
		exit(1);
	}

	// Read the values for profit (This step is for checking the values)
	if (read_file_of_profit(PROFIT_FILENAME, max_precincts, max_quality_layers, profit) <= 0) {
		printf("Error reading the file of profit: %s\n", PROFIT_FILENAME);
		exit(1);
	}

	// Create initial values for ordered list
	if (create_file_ordered_list(ORDERED_LIST_FILENAME, max_precincts) <= 0) {
		printf("Error creating the file for the ordered list of precincts: %s\n", ORDERED_LIST_FILENAME);
		exit(1);
	}

	// Read the values for ordered list (This step is for checking the values)
	if (read_file_ordered_list(ORDERED_LIST_FILENAME, max_precincts, ordered_list) <= 0) {
		printf("Error reading the file for the ordered list of precincts: %s\n", ORDERED_LIST_FILENAME);
		exit(1);
	}

	if (DEBUG) {
		// Print weights values
		print_weights_values(max_precincts, max_quality_layers, weights);

		// Print profit values
		print_profit_values(max_precincts, max_quality_layers, profit);

		// Print ordered_list values
		print_ordered_list_values(max_precincts, ordered_list);

		// Print all the precincts with their weight and profit
		print_precincts_weight_profit(max_precincts, max_quality_layers, weights, profit, ordered_list);	
	}

	// Check all the methods in order to find the best solution
	check_methods(max_precincts, max_quality_layers, budget, ordered_list, weights, profit);

	return 0;
}
