#define MAX_BYTES_SIZE 1000
#define MIN_PSNR_VALUE 10
#define MAX_PSNR_VALUE 50

#define WEIGHTS_FILENAME 	  "weights.txt"
#define PROFIT_FILENAME 	  "profit.txt"
#define ORDERED_LIST_FILENAME "ordered_list.txt"

#define DEBUG 1

typedef struct {
	long precinct_id;
	int quality_layer;
} pre_id_ql;


typedef struct {
	long ne;
	pre_id_ql *list;
	long sum_bytes;
	double sum_profit;
} solution;

typedef struct {
	int method;
	int index_ql;
	double max_profit;
} best_solution;

// Memory management
int allocate_memory_for_weights(long max_precincts, int max_quality_layers, long *** weights);
int allocate_memory_for_profit(long max_precincts, int max_quality_layers, double ***profit);
int allocate_memory_for_ordered_list(long max_precincts, long **ordered_list);

// Knapsack algorithm
long rand_range_long(long min_n, long max_n);
double rand_range_double(double min_n, double max_n);
void method_1(long max_precincts, int max_quality_layers, long budget, long * ordered_list, long **weights, double **profit, solution *sol);
void method_2(long max_precincts, int max_quality_layers, long budget, long * ordered_list, long **weights, double **profit, int max_ql, solution *sol);
void print_solution(solution sol);
void check_methods(long max_precincts, int max_quality_layers, long budget, long *ordered_list, long **weights, double **profit);
best_solution find_best_solution(solution sol1, solution *sol2, int max_quality_layers);
void print_weights_values(long max_precincts, int max_quality_layers, long **weights);
void print_profit_values(long max_precincts, int max_quality_layers, double **profit);
void print_ordered_list_values(long ne_ordered_list, long *ordered_list);
void print_precincts_weight_profit(long ne_ordered_list, int max_quality_layers, long **weights, double **profit, long *ordered_list);

// Files management (Only for test purposes)
int create_file_of_weights(char filename[], long max_precincts, int max_quality_layers);
int read_file_of_weights(char filename[], long max_precincts, int max_quality_layers, long **weights);
int create_file_of_profit(char filename[], long max_precincts, int max_quality_layers);
int read_file_of_profit(char filename[], long max_precincts, int max_quality_layers, double **profit);
int create_file_ordered_list(char filename[], long max_precincts);
int read_file_ordered_list(char filename[], long max_precincts, long *ordered_list);
