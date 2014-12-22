# J2C to Knapsack files

Dentro del directorio `knapsack/j2c_to_knapsack_files` hay una utilidad para
generar los archivos que vamos a necesitar para poder ejecutar nuestro
algoritmo **Knapsack**.

Esta utilidad trabaja sobre el mayor nivel de resolución de una imagen y 
calcula el valor de PSNR obtenido para

Uso:

	./create_knapsack_json_file.sh <image.j2c> <woi_list.txt>

Esta utilidad recibe como parámetros de entrada:  

- una imagen **.j2c**  
- y la **lista de todas las WOIs** que queremos calcular su PSNR para cada una de las capas de calidad.

Como resultado devolverá un archivo **.json** con la siguiente información:


	{ "number_of_precincts": 60,
	"precincts": [
	{
	"id": 0,
	"coord_x": 0,
	"coord_y": 0,
	"layers": [
		{"ql": 1, "bytes": 361, "psnr": 26.164156},
		{"ql": 2, "bytes": 413, "psnr": 26.169536},
		{"ql": 3, "bytes": 506, "psnr": 26.188540},
		{"ql": 4, "bytes": 682, "psnr": 26.189242},
		{"ql": 5, "bytes": 1260, "psnr": 26.215151},
		{"ql": 6, "bytes": 2697, "psnr": 26.254272},
		{"ql": 7, "bytes": 5148, "psnr": 26.314133},
		{"ql": 8, "bytes": 8792, "psnr": 26.362179}
		]
	},
	{
	"id": 1,
	"coord_x": 128,
	"coord_y": 0,
	"layers": [
		{"ql": 1, "bytes": 255, "psnr": 26.394251},
		{"ql": 2, "bytes": 323, "psnr": 26.417979},
		{"ql": 3, "bytes": 365, "psnr": 26.420586},
		{"ql": 4, "bytes": 529, "psnr": 26.416698},
		{"ql": 5, "bytes": 1158, "psnr": 26.418165},
		{"ql": 6, "bytes": 2791, "psnr": 26.491142},
		{"ql": 7, "bytes": 5277, "psnr": 26.576988},
		{"ql": 8, "bytes": 8986, "psnr": 26.651710}
		]
	},
	...

**NOTA:** 

	Modos de funcionamiento

	1) Mode 0 (Kakadu Mode)
	echo -e "\nTest Mode 0 (Kakadu Mode)"
	check_psnr_mode 0 image.j2c wois.txt

	2) Mode 1 (Exact WOI)
	echo -e "\nTest Mode 1 (Exact WOI)"
	check_psnr_mode 1 image.j2c wois.txt


- Esta utilidad trabaja siempre con **Mode 1 (Exact WOI)**. De modo que como resultado se obtienen los valores de PSNR para cada WOI y para cada una de sus capas.
