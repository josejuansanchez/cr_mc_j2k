#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include "libknapsack.h"
#include "parson/parson.h"

// Read JSON Files
int get_number_of_precincts_from_json_file(char *filename);
int get_number_of_quality_layers_from_json_file(char *filename);
int load_weights_from_json_file(char *filename, long max_precincts, int max_quality_layers, long **weights);
int load_profit_from_json_file(char *filename, long max_precincts, int max_quality_layers, double **profit);

// Read and load the ordered list of wois
int load_ordered_list_of_wois_file(char ordered_list_filename[], long *ne, long *ordered_list, char image_info_filename[]);
int convert_woi_coords_to_precinct_id_from_json_file(char *image_info_filename, int coord_x, int coord_y);

int main(int argc, char *argv[])
{
	long budget;
	long max_precincts;
	int max_quality_layers;
	long **weights;
	double **profit;
	long *ordered_list;
	int i, j;
	char image_info_filename[256];
	char ordered_list_filename[256];
	long ne_ordered_list;

	if (argc < 4) {
		printf("Usage: %s <image_info_filename.json> <ordered_list_of_wois.txt> <budget>\n",argv[0]);
		exit(0);
	}

	// Get the name of image info filename (JSON)
	strcpy(image_info_filename, argv[1]);

	// Get the number of precincts from JSON file
	max_precincts = (long int) get_number_of_precincts_from_json_file(image_info_filename);

	if (max_precincts <= 0) {
		printf("The max number of precincts must be a positive integer\n");
		exit(0);
	}

	// Get the number of quality layers from JSON file
	max_quality_layers = get_number_of_quality_layers_from_json_file(image_info_filename);

	if (max_quality_layers <= 0) {
		printf("The max number of quality layers must be a positive integer\n");
		exit(0);
	}

	// Get the name of the ordered list fo WOIs
	strcpy(ordered_list_filename, argv[2]);

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
	
	// Read the values for weights (This step is for checking the values)
	if (load_weights_from_json_file(image_info_filename, max_precincts, max_quality_layers, weights) <= 0) {
		printf("Error reading the JSON file and loading the weights: %s\n", image_info_filename);
		exit(1);
	}

	// Read the values for profit (This step is for checking the values)
	if (load_profit_from_json_file(image_info_filename, max_precincts, max_quality_layers, profit) <= 0) {
		printf("Error reading the JSON file and loading the profit: %s\n", image_info_filename);
		exit(1);
	}

	// Read and load the ordered list of wois
	if (load_ordered_list_of_wois_file(ordered_list_filename, &ne_ordered_list, ordered_list, image_info_filename) <= 0) {
		printf("Error reading and loading the ordered list of wois: %s\n", ordered_list_filename);
		exit(1);		
	}

	if (DEBUG) {
		// Print weights values
		print_weights_values(max_precincts, max_quality_layers, weights);

		// Print profit values
		print_profit_values(max_precincts, max_quality_layers, profit);

		// Print ordered_list values
		print_ordered_list_values(ne_ordered_list, ordered_list);

		// Print all the precincts with their weight and profit
		print_precincts_weight_profit(ne_ordered_list, max_quality_layers, weights, profit, ordered_list);
	}

	// Check all the methods in order to find the best solution
	check_methods(ne_ordered_list, max_quality_layers, budget, ordered_list, weights, profit);

	return 0;
}

// JSON files management
//
//*****************************************************************************************************
int get_number_of_precincts_from_json_file(char *filename) {
    JSON_Object *root_object;
    JSON_Value *root_value = NULL;
    root_value = json_parse_file(filename);
    root_object = json_value_get_object(root_value);
    return (int) json_object_get_number(root_object, "number_of_precincts");
}

int get_number_of_quality_layers_from_json_file(char *filename) {
    JSON_Object *root_object;
    JSON_Array *array;
    JSON_Value *root_value = NULL;
    root_value = json_parse_file(filename);

    root_object = json_value_get_object(root_value);
    unsigned int number_of_precincts = (int) json_object_get_number(root_object, "number_of_precincts");

    array = json_object_get_array(root_object, "precincts");
    if (array != NULL && json_array_get_count(array) == number_of_precincts) {
        JSON_Object *precinct_object = json_array_get_object(array, 0);
        JSON_Array *layers_array = json_object_get_array(precinct_object, "layers");
        return json_array_get_count(layers_array);
    } else {
    	return -1;
    }
}

// Load weights from json file
int load_weights_from_json_file(char *filename, long max_precincts, int max_quality_layers, long **weights) {
    JSON_Object *root_object;
    JSON_Array *array;
    JSON_Value *root_value = NULL;
    root_value = json_parse_file(filename);

    root_object = json_value_get_object(root_value);
    unsigned int number_of_precincts = (int) json_object_get_number(root_object, "number_of_precincts");

    array = json_object_get_array(root_object, "precincts");
    if (array != NULL && json_array_get_count(array) == number_of_precincts) {
        JSON_Object *precinct_object;
        JSON_Array *layers_array;
        int id, coord_x, coord_y;
        unsigned int p;
        
		int i = 0;
		int j = 0;

        for(p = 0; p < number_of_precincts; p++) {           
            precinct_object = json_array_get_object(array, p);
            layers_array = json_object_get_array(precinct_object, "layers");
            if (layers_array != NULL && json_array_get_count(layers_array) >= 1) {
                JSON_Object *layer_object;
                int bytes;
                unsigned l;

                for(l = 0; l < json_array_get_count(layers_array); l++) {
                    layer_object = json_array_get_object(layers_array, l);
                    bytes = (long) json_object_get_number(layer_object, "bytes");

                    weights[i][j++] = bytes;

                    if (j >= max_quality_layers) {
                    	j = 0;
                    	i++;
                    }
                }
                
            } else {
				return -1;
            }
        }
    } else {
        return -1;
    }

    json_value_free(root_value);
	return 1;
}

// Load profit from json file
int load_profit_from_json_file(char *filename, long max_precincts, int max_quality_layers, double **profit) {
    JSON_Object *root_object;
    JSON_Array *array;
    JSON_Value *root_value = NULL;
    root_value = json_parse_file(filename);

    root_object = json_value_get_object(root_value);
    unsigned int number_of_precincts = (int) json_object_get_number(root_object, "number_of_precincts");

    array = json_object_get_array(root_object, "precincts");
    if (array != NULL && json_array_get_count(array) == number_of_precincts) {
        JSON_Object *precinct_object;
        JSON_Array *layers_array;
        int id, coord_x, coord_y;
        unsigned int p;
        
		int i = 0;
		int j = 0;

        for(p = 0; p < number_of_precincts; p++) {           
            precinct_object = json_array_get_object(array, p);
            layers_array = json_object_get_array(precinct_object, "layers");
            if (layers_array != NULL && json_array_get_count(layers_array) >= 1) {
                JSON_Object *layer_object;
                int psnr;
                unsigned l;

                for(l = 0; l < json_array_get_count(layers_array); l++) {
                    layer_object = json_array_get_object(layers_array, l);
                    double psnr = (double) json_object_get_number(layer_object, "psnr");

                    profit[i][j++] = psnr;

                    if (j >= max_quality_layers) {
                    	j = 0;
                    	i++;
                    }
                }
                
            } else {
				return -1;
            }
        }
    } else {
        return -1;
    }

    json_value_free(root_value);
	return 1;
}

// Load weights from json file
int convert_woi_coords_to_precinct_id_from_json_file(char *image_info_filename, int coord_x, int coord_y) {
    JSON_Object *root_object;
    JSON_Array *array;
    JSON_Value *root_value = NULL;
    root_value = json_parse_file(image_info_filename);

    root_object = json_value_get_object(root_value);
    unsigned int number_of_precincts = (int) json_object_get_number(root_object, "number_of_precincts");

    array = json_object_get_array(root_object, "precincts");
    if (array != NULL && json_array_get_count(array) == number_of_precincts) {
        JSON_Object *precinct_object;
        JSON_Array *layers_array;
        int id, c_x, c_y;
        unsigned int p;
        
        for(p = 0; p < number_of_precincts; p++) {
            
            precinct_object = json_array_get_object(array, p);
            id = (int) json_object_get_number(precinct_object, "id");
            c_x = (int) json_object_get_number(precinct_object, "coord_x");
            c_y = (int) json_object_get_number(precinct_object, "coord_y");

            if ((coord_x == c_x) && (coord_y == c_y)) return id;
        }
    } else {
        return -1;
    }
    json_value_free(root_value);
	return 1;
}


// Read the ordered list of wois file given as input and load the array
int load_ordered_list_of_wois_file(char ordered_list_filename[], long *ne, long *ordered_list, char image_info_filename[]) {
	FILE *f = fopen(ordered_list_filename,"r");
	if (!f) return -1;

	int id;
	int coord_x, coord_y;
	*ne = 0;
	while(!feof(f)) {
		fscanf(f, "%d %d\n", &coord_x, &coord_y);
		id = convert_woi_coords_to_precinct_id_from_json_file(image_info_filename, coord_x, coord_y);
		if (DEBUG) printf("coord_x: %d \t coord_y: %d \t id: %d\n", coord_x, coord_y, id);
		if (id < 0) return -1;
		ordered_list[*ne] = id;
		*ne = *ne + 1;
	}
	if (DEBUG) printf("ne: %ld\n", *ne);
	fclose(f);
	return 1;
}
