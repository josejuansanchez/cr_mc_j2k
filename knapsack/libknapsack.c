#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include "libknapsack.h"

long rand_range_long(long min_n, long max_n)
{
    return rand() % (max_n - min_n + 1) + min_n;
}

double rand_range_double(double min_n, double max_n)
{
    return (double)rand()/RAND_MAX * (max_n - min_n) + min_n;
}

// Allocate memory for weights
int allocate_memory_for_weights(long max_precincts, int max_quality_layers, long *** weights) {
	int i;
	*weights = NULL;
	*weights = (long **) malloc(max_precincts*(sizeof(long *)));
	
	if (*weights == NULL) return -1;

	for(i=0; i<max_precincts; i++) {
		(*weights)[i] = (long *) malloc(max_quality_layers*(sizeof(long)));
	}
	return 1;
}

// Allocate memory for profit
int allocate_memory_for_profit(long max_precincts, int max_quality_layers, double ***profit) {
	int i;
	*profit = NULL;
	*profit = (double **) malloc(max_precincts*(sizeof(double *)));

	if (*profit == NULL) return -1;

	for(i=0; i<max_precincts; i++) {
		(*profit)[i] = (double *) malloc(max_quality_layers*(sizeof(double)));
	}
	return 1;
}

// Allocate memory for ordered_list
int allocate_memory_for_ordered_list(long max_precincts, long **ordered_list) {
	*ordered_list = NULL;
	*ordered_list = (long *) malloc(max_precincts*(sizeof(long)));

	if (*ordered_list == NULL) return -1;
	return 1;
}

void method_1(long max_precincts, int max_quality_layers, long budget, long * ordered_list, long **weights, double **profit, solution *sol) {

	if (DEBUG) printf("\n\n**** Method: 1 ****\n");

	int end = 0;
	int i, j;

	// Initialize the total number of bytes used and the profit
	sol->sum_bytes = 0;
	sol->sum_profit = 0;	

	// Allocate memory for the solution
	sol->list = (pre_id_ql *) malloc(max_precincts*max_quality_layers*(sizeof(pre_id_ql)));

	// Initialize the initial number of elements
	sol->ne = 0;

	for(j=0; j<max_quality_layers && !end; j++) { 	

		for (i=0; i<max_precincts && !end; i++) {
			long pos = ordered_list[i];

			if (weights[pos][j] >= budget) {
				end = 1;
				break;
			}

			if (DEBUG) printf("[%4ld][%d]\t", pos, j);
			
			sol->sum_profit = sol->sum_profit + profit[pos][j];
			sol->sum_bytes = sol->sum_bytes + weights[pos][j];
			budget = budget - weights[pos][j];

			// Add a new element to the solution list
			sol->list[sol->ne].precinct_id = pos;
			sol->list[sol->ne].quality_layer = j;
			sol->ne++;			
		}
		if (DEBUG) printf("\n");
	}
}

// max_ql: The number of the last layer that we are going to check
//
void method_2(long max_precincts, int max_quality_layers, long budget, long * ordered_list, long **weights, double **profit, int max_ql, solution *sol) {

	if (DEBUG) printf("\n\n**** Method: 2 \tmax_ql: %d ****\n", max_ql);

	int end = 0;
	int i, j;

	// Initialize the total number of bytes used and the profit
	sol->sum_bytes = 0;
	sol->sum_profit = 0;	

	// Allocate memory for the solution
	sol->list = (pre_id_ql *) malloc(max_precincts*max_quality_layers*(sizeof(pre_id_ql)));

	// Initialize the initial number of elements
	sol->ne = 0;

	for (i=0; i<max_precincts && !end; i++) {

		long pos = ordered_list[i];

		for(j=0; j<=max_ql && !end; j++) { 

			if (weights[pos][j] >= budget) {
				end = 1;
				break;
			}

			if (DEBUG) printf("[%4ld][%d]\t", pos, j);

			sol->sum_profit = sol->sum_profit + profit[pos][j];
			sol->sum_bytes = sol->sum_bytes + weights[pos][j];
			budget = budget - weights[pos][j];

			// Add a new element to the solution list
			sol->list[sol->ne].precinct_id = pos;
			sol->list[sol->ne].quality_layer = j;
			sol->ne++;
		}
		if (DEBUG) printf("\n");
	}
}

void print_solution(solution sol) {
	printf("\n{\"sum_bytes\": %ld, \"sum_profit\": %f}\n", sol.sum_bytes, sol.sum_profit);
}

best_solution find_best_solution(solution sol1, solution *sol2, int max_quality_layers) {
	int i;

	// Number of the method with the best solution (1 or 2)
	int sol_method;
	
	// If the best solution is 3, it is necessary to store the number of the quality layer
	// where we get the best value
	int sol_index_ql;

	double max_profit = -1;

	for(i=0; i<max_quality_layers; i++) {
		if (sol2[i].sum_profit > max_profit) {
			max_profit = sol2[i].sum_profit;
			sol_method = 2;
			sol_index_ql = i;
		}
	}

	if (sol1.sum_profit > max_profit) {
		max_profit = sol1.sum_profit;
		sol_method = 1;
		sol_index_ql = -1;
	}

	// Test
	best_solution the_best_solution;
	the_best_solution.method = sol_method;
	the_best_solution.max_profit = max_profit;

	if (sol_method == 2) {
		// The number of the quality layer is zero based	
		the_best_solution.index_ql = sol_index_ql;	
		
		if (DEBUG) printf("\nThe best solution is the method: %d with: %d quality layer with a profit of: %lf\n", sol_method, sol_index_ql, max_profit);
		if (DEBUG) printf(" ** NOTE: The number of the quality layer is zero based **\n");
	} else {
		if (DEBUG) printf("\nThe best solution is the method: %d with a profit of: %lf\n", sol_method, max_profit);
	}
	return the_best_solution;
}

// Print weights values
void print_weights_values(long max_precincts, int max_quality_layers, long **weights) {
	int i, j;
	printf("\nweights (precincts sizes in bytes): \n");
	for(i=0; i<max_precincts; i++) {
		for(j=0; j<max_quality_layers; j++){
			printf(" %4ld ", weights[i][j]);
		}
		printf("\n");
	}	
}

// Print profit values
void print_profit_values(long max_precincts, int max_quality_layers, double **profit) {
	int i, j;
	printf("\nprofit (psnr or ssim values): \n");
	for(i=0; i<max_precincts; i++) {
		for(j=0; j<max_quality_layers; j++){
			printf(" %4.2lf ", profit[i][j]);
		}
		printf("\n");
	}	
}

// Print ordered_list values
void print_ordered_list_values(long ne_ordered_list, long *ordered_list) {
	int i;
	printf("\nordered_list: \n");
	for(i=0; i<ne_ordered_list; i++) {
		printf(" %4ld ", ordered_list[i]);
	}
}

// Print the precincts with their weight and profit
void print_precincts_weight_profit(long ne_ordered_list, int max_quality_layers, long **weights, double **profit, long *ordered_list) {
	int i, j;
	printf("\n\n");
	for(i=0; i<ne_ordered_list; i++) {

		long pos = ordered_list[i];

		for(j=0; j<max_quality_layers; j++) {
			printf("w[%ld][%d] = %ld / %lf  \t", pos, j, weights[pos][j], profit[pos][j]);
		}
		printf("\n");
	}
}

// Create the file of weights 
int create_file_of_weights(char filename[], long max_precincts, int max_quality_layers) {
	FILE *f = fopen(filename,"w");
	if (!f) return -1;

	int i, j;
	for(i=0; i<max_precincts; i++) {
		for(j=0; j<max_quality_layers; j++){
			long weight = rand_range_long(j*100, (j+1)*100);
			fprintf(f,"%ld\n",weight);
		}
	}

	fclose(f);
	return 1;
}

// Read the file of weights 
int read_file_of_weights(char filename[], long max_precincts, int max_quality_layers, long **weights) {
	FILE *f = fopen(filename,"r");
	if (!f) return -1;

	int i, j;
	for(i=0; i<max_precincts; i++) {
		for(j=0; j<max_quality_layers; j++){	
			fscanf(f, "%ld\n", &weights[i][j]);
		}
	}

	fclose(f);
	return 1;
}

// Create the file of profit 
int create_file_of_profit(char filename[], long max_precincts, int max_quality_layers) {
	FILE *f = fopen(filename,"w");
	if (!f) return -1;

	int i, j;
	for(i=0; i<max_precincts; i++) {
		for(j=0; j<max_quality_layers; j++){
			double profit_value = rand_range_double(j*10, (j+1)*10);
			fprintf(f,"%lf\n",profit_value);
		}
	}

	fclose(f);
	return 1;
}

// Read the file of profit 
int read_file_of_profit(char filename[], long max_precincts, int max_quality_layers, double **profit) {
	FILE *f = fopen(filename,"r");
	if (!f) return -1;

	int i, j;
	for(i=0; i<max_precincts; i++) {
		for(j=0; j<max_quality_layers; j++){
			fscanf(f, "%lf\n", &profit[i][j]);
		}
	}

	fclose(f);
	return 1;
}

// Create the file with the ordered list of precincts
int create_file_ordered_list(char filename[], long max_precincts) {
	FILE *f = fopen(filename,"w");
	if (!f) return -1;

	long *ordered_list;
	// Allocate memory for ordered_list
	ordered_list = (long *) malloc(max_precincts*(sizeof(long)));

	int i;
	// Initial values for the ordered list
	for(i=0; i<max_precincts; i++) {
		ordered_list[i] = -1;
	}

	long ne = 0;
	while(ne<max_precincts) {
		long id = rand_range_long(0, max_precincts - 1);
		int found = 0;
		for(i=0; (i<max_precincts) && (!found); i++) {
			if (ordered_list[i] == id) {
				found = 1;
				break;
			}
		}
		if (!found) {
			ordered_list[ne++] = id;
		}
	}

	for(i=0; i<max_precincts; i++) {
		fprintf(f, "%ld\n", ordered_list[i]);		
	}

	fclose(f);
	return 1;
}

// Create the file with the ordered list of precincts
int read_file_ordered_list(char filename[], long max_precincts, long *ordered_list) {
	FILE *f = fopen(filename,"r");
	if (!f) return -1;

	int i;
	for(i=0; i<max_precincts; i++) {
		fscanf(f, "%ld\n", &ordered_list[i]);		
	}

	fclose(f);
	return 1;
}

void check_methods(long max_precincts, int max_quality_layers, long budget, long *ordered_list, long **weights, double **profit) {
	// Check the method 1
	solution sol1;
	method_1(max_precincts, max_quality_layers, budget, ordered_list, weights, profit, &sol1);

	// Check the method 2
	solution *sol2;

	// Allocate memory for the array of solutions
	sol2 = (solution *) malloc (max_quality_layers*sizeof(solution));

	int i;
	for(i=0; i<max_quality_layers; i++) {
		method_2(max_precincts, max_quality_layers, budget, ordered_list, weights, profit, i, &sol2[i]);
	}

	// Find the best solution (max profit)	
	best_solution solution = find_best_solution(sol1, sol2, max_quality_layers);

	// Print the best solution
	printf("{\"solution\":");
	printf("\n\t{\"method\": %d,", solution.method);

	// **** IMPORTANT NOTE!!: We add +1 to the quality layer ****
	if (solution.method == 2) {		
		printf("\n\t\"ql\": %d,", solution.index_ql + 1);
	}	
	printf("\n\t\"max_profit\": %lf},", solution.max_profit);

	// Print the results for the method 1
	printf("\n\"method_1\": \n\t{\"sum_bytes\": %ld, \"sum_profit\": %f},\n", sol1.sum_bytes, sol1.sum_profit);

	// Print the results for the method 2
	printf("\"method_2\": [\n");
	for(i=0; i < max_quality_layers-1; i++) {
		printf("\t{\"ql\": %d, \"sum_bytes\": %ld, \"sum_profit\": %f},\n", (i+1), sol2[i].sum_bytes, sol2[i].sum_profit);
	}
	printf("\t{\"ql\": %d, \"sum_bytes\": %ld, \"sum_profit\": %f}]\n", (max_quality_layers), sol2[max_quality_layers-1].sum_bytes, sol2[max_quality_layers-1].sum_profit);	
	printf("}\n");
}
