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
* Usar SSIM como métrica de distorsión a la hora de calcular los vectores de movimiento.
* La utilidad ```woistocache``` no envía las capas de calidad completas. 
  Por ejemplo, en este caso puede ocurrir que si tenemos un ```bitrate``` de entrada de 1762, estaríamos enviando la segunda
  capa de calidad incompleta (faltaría 1 2 0 2 7).

```
896 256 128 128: 0 0 0 2 7: 27
ID:    27 Offset: 10806 Length:   524

896 256 128 128: 0 1 0 2 7: 87
ID:    87 Offset: 33092 Length:   547

896 256 128 128: 0 2 0 2 7: 147
ID:   147 Offset: 47378 Length:   351

896 256 128 128: 1 0 0 2 7: 27
ID:    27 Offset: 54178 Length:    26

896 256 128 128: 1 1 0 2 7: 87
ID:    87 Offset: 59782 Length:   314
```
* Crear un archivo de configuración .JSON que sea común para todos los scripts.