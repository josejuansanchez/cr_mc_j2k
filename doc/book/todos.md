TODOs
=====

* Mejorar la implementación del método `SetPacketList` del archivo `libcache.c`.
Cuando se lee la lista de paquetes vamos comprobando que el `id` del paquete está dentro del rango establecido.
Actualmente se realiza una comparación con una constante, pero este valor habría que calcularlo en tiempo de ejecución en función de los parámetros de la imagen con la que estamos trabajando.

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.cpp .numberLines}
int SetPacketList(packet *packetList, int *npa, char filename[]) {
	...
    if (packetId > MAX_ID_PACKET) {
    	...
    } else {
    	...
    }
	...	
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

* Buscar el tamaño mínimo de code-block y precinto para hacer un estudio del impacto de estos parámetros.
* Hacer experimentos *without motion compensation* y *with motion compensation*.
* El cliente decide qué precintos necesita y cuánto *bitrate* quiere recibir de cada uno.
* Study the [Lagrange multiplier method](http://www.hpca.ual.es/~jjsanchez/references/Generalized_Lagrange_multiplier_method_for_solving_problems_of_optimum_allocation_of_resources.pdf).
* Utilizar información de las predicciones (o información ya precalculada) como metadatos de las imágenes.
* Estudiar si es mejor enviar todos los metadatos de todas las imágenes de la secuencia antes de realizar el envío del *code-stream*, o enviar los metadatos de forma individual junto a cada imagen.
* Estudiar cómo varía el tamaño de los archivos según los parámetros de compresión utilizados y de qué manera esto nos puede afectar.
* Dejar los paquetes vacíos en 7 bytes (actualmente están en 8 bytes).