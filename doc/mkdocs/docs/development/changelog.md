Changelog
=========

### 04/07/2014
* Modificación en la utilidad ```decodefromcache``` para aceptar como parámetro de entrada el número
del nivel de resolución con el que se quiere descomprimir la imagen. Si no se especifica ningún parámetro
de entrada entonces se supone que se quiere descomprimir la imagen con el máximo nivel de resolución (0).

### 04/06/2014

* Modificación en la utilidad ```woistocache``` para que el número de bytes leídos que se devuelve 
en el archivo ```bytes.readed``` no sea mayor que el parámetro de entrada ```bitrate```.
* Modificación en la utilidad ```woistocache``` para incluir los métodos 1 y 2 (Knapsack).

### 02/06/2014

Se ha completado toda la implementación del problema Knapsack.
Se han creado las siguientes utilidades:

- ```knapsack_info_files/create_all_info_files.sh```
- ```j2c_to_knapsack_files/create_knapsack_json_file.sh```
- ```j2c_to_knapsack_files/create_woi_list```
- ```knapsack/knapsack```

### 03/04/2014

Modificación en la creación de paquetes vacíos.

A la hora de crear paquetes vacíos creábamos paquetes con esta estructura:

```
FF 91 00 04 XX XX C0 00
```

donde: 

  * ```FF 91```: SOP Marker   
  * ```00 04```: Lenght of marker segment in bytes (not including the marker)  
  * ```XX XX```: Packet number  
  * ```C0 00```: Packet body  

Esta forma de crear un paquete vacío es errónea ya que el contenido del campo **Packet body** incluye información en su cabecera debido a que el primer bit es un 1 ```(C0 00 = 1010 0000)```.

Según la documentación de JPEG2000:

```
Zero Length Packet 
The first bit in the packet header indicates whether the packet has a length of zero. If this bit is 0, the length is zero. Otherwise, the value of 1 means the packet has a non-zero length.
```

### 03/02/2014

Modificaciones sobre el método:

```
bool jp2_area::woi_to_lrcp_modified(char filename_woi[], int w, int h, int r, int q)
```

Con este código podemos extraer información importante a partir del code-stream:  

* Dimensiones de la imagen.
* Número de niveles de resolución de la imagen.
* Dimensiones de cada nivel de resolución.
* Dimensiones de los precintos que forman cada nivel de resolución.
* Número de precintos que existen en cada nivel de resolución.

```
  // Obtenemos el número de precintos que hay en cada nivel de resolución  
  kdu_dims idims;
  codestream.apply_input_restrictions(0, 0, 0, 0, NULL);
  codestream.get_dims(0, idims);
  printf("\nImage dimension: %d - %d\n", idims.size.x, idims.size.y);

  kdu_dims roi, realroi;
  roi.pos = kdu_coords(0, 0);
  roi.size = kdu_coords(idims.size.x, idims.size.y);

  codestream.apply_input_restrictions(0, 0, 0, 0, NULL);
  codestream.map_region(0, roi, realroi);
  codestream.apply_input_restrictions(0, 0, 0, 0, &realroi);

  int numr = codestream.get_min_dwt_levels() + 1;
  kdu_tile tile = codestream.open_tile(kdu_coords(0, 0));
  kdu_tile_comp comp = tile.access_component(0);

  kdu_dims *precincts_in_each_resolution = new kdu_dims[numr];
  kdu_dims *resolution_size = new kdu_dims[numr];  
  kdu_dims *precincts_size_in_each_resolution = new kdu_dims[numr];

  for (int resolution = 0; resolution < numr; resolution++) {
    printf("Resolution: %d\n", resolution);

    kdu_resolution res = comp.access_resolution(resolution);

    kdu_dims rdims;
    res.get_dims(rdims);
    printf("\tDimension.\t x: %5d \t y: %5d\n", rdims.size.x, rdims.size.y);
    resolution_size[resolution] = rdims;

    kdu_dims pdims;
    res.get_valid_precincts(pdims);
    printf("\t# of precincts.\t x: %5d \t y: %5d\n", pdims.size.x, pdims.size.y);
    precincts_in_each_resolution[resolution] = pdims;

    precincts_size_in_each_resolution[resolution].size.x = rdims.size.x / pdims.size.x;
    precincts_size_in_each_resolution[resolution].size.y = rdims.size.y / pdims.size.y;
    printf("\tPrecincts size.\t x: %5d \t y: %5d\n", precincts_size_in_each_resolution[resolution].size.x, precincts_size_in_each_resolution[resolution].size.x);
  }
  tile.close();  
```

También hemos modificado la forma de detectar si un precinto coincide exactamente con la región de la WOI.
Para poder eliminar los precintos de los bordes que Kakadu puede añadir.

```
...
for (int resolution = 0; resolution < r; resolution++) {
   ...

   float scale_factor = pow(2,r - 1 - resolution);

   if (((int)((ww.x / scale_factor) / precincts_size_in_each_resolution[resolution].size.x) == px) &&
       ((int)((ww.y / scale_factor) / precincts_size_in_each_resolution[resolution].size.y) == py)) {
      fprintf(fc,"%d %d %d %d: %d %d %d %d %d: %ld\n", ww.x, ww.y, ww.w, ww.h, l, resolution, c, py, px, (long)pid);
   }
   ...
}
...
```

### 29/01/2014

La funcionalidad del modo *Precincts Selection Mode = 1*
está deshabilitada temporalmente porque no funciona como se espera
cuando las imágenes no tienen el mismo número de precintos en todos
los niveles de resolución. Por ejemplo:

```
CLEVELS=3
CPRECINCTS="{128,128},{64,64},{32,32},{32,32}"
```

En este caso tenemos:

* Resolution level *3*: 1280x768. 60 precintos de 128x128.
* Resolution level *2*: 640x384. 60 precintos de 64x64.
* Resolution level *1*: 320x192. 60 precintos de 32x32.
* Resolution level *0*: 160x96. 15 precintos de 32x32.