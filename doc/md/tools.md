Tools
=====

* [`cookcache`](#tool_cookcache)
* [`countsops`](#tool_countsops)
* [`decodefromcache`](#tool_decodefromcache)
* [`decorrelate`](#tool_decorrelate)
* [`differencesthumbnails`](#tool_differencesthumbnails)
* [`extractcache`](#tool_extractcache)
* [`get_header_size_j2c`](#tool_get_header_size_j2c)
* [`me`](#tool_motion_estimation)
* [`mogrify`](#tool_mogrify)
* [`snr`](#tool_snr)
* [`sortcache`](#tool_sortcache)
* [`woistocache`](#tool_woistocache)


### <a name="tool_cookcache"></a>cookcache
* **Descripción**:  
    Este programa recibe dos archivos con formato **`.cache`** y devuelve
    como salida otro archivo con formato **`.cache`** formado por los
    paquetes vacíos necesarios para completar los precintos que aparecen en
    el archivo `<response.j2c.cache>`.

* **Uso**:  

    ```
    cookcache <full.j2c.cache> <response.j2c.cache>
    ```

    * **Entrada:**

        -   `<full.j2c.cache>`: Este archivo contiene todo el codestream
            completo de una imagen.

        -   `<response.j2c.cache>`: Este archivo contiene la respuesta que nos
            envía el servidor, para una petición formada por una serie de WOIs
            (precintos) y un determinado bitrate. Lo normal es que esta
            respuesta contega solamente algunos de los paquetes que forman un
            precinto, por este motivo habrá que localizar cuáles son los
            paquetes que faltan para completar el precinto completo y crear
            paquetes vacíos en su lugar.

    * **Salida:**

        Este programa devuelve el archivo `emptypackets.j2c.cache` con todos los
        paquetes vacíos que son necesarios para completar todos los precinctos.

        La fusión de los archivos `<response.j2c.cache>` +
        `emptypackets.j2c.cache` contendrá el codestream necesario para poder
        realizar la fusión de dos imágenes en el dominio JPEG2000.


### <a name="tool_countsops"></a>countsops
* **Descripción**:  
    Esta utilidad devuelve el número de paquetes que contiene un archivo **`.j2c`**.

* **Uso**:  

    ```
    countsops <archivo.j2c>
    ```


### <a name="tool_decodefromcache"></a>decodefromcache
* **Descripción**:  
    Esta utilidad permite descomprimir un archivo con code-stream en formato **`.cache`**.
    Como salida puede devolver archivos con formato **`.pgm`** o **`.ppm`**.

* **Uso**:  

    ```
    decodefromcache <Caché> <Imagen OUT> <Ancho Img. Reconst> <Alto Img. Reconst>
    ```


### <a name="tool_decorrelate"></a>decorrelate 
* **Descripción**:  
  Genera una imagen predicción a partir de unos vectores de movimiento de entrada.

* **Uso**:  

    ```
    MCJ2K/bin/decorrelate -p 2 -x X -y Y -b B -s S -e odd_image -o odd_image -i motion -v V
    ```

    - `V`: Overlapping. Para difuminar los bordes de los bloques.


### <a name="tool_differencesthumbnails"></a>differencesthumbnails
* **Descripción**:  
  Calcula las diferencias entre dos thumbnails.

* **Uso**:  

    ```
    differencesthumbnails <in_filenameA> <in_filenameB> <out_filename_precincts_list.dat> <out_filename_precincts_list.txt> <w_precint_size> <h_precint_size> <w_offset> <h_offset>
    ```

    - `out_filename_precincts_list.dat`: Archivo de salida (formato binario) con la lista de coordenadas de precintos que han cambiado.

    - `out_filename_precincts_list.txt`: Archivo de salida (formato texto) con la lista de coordenadas de precintos que han cambiado.    

    - `w_precint_size`: Ancho del precinto del thumbnail. 

    - `h_precint_size`: Alto del precinto del thumbnail.

    - `w_offset`: Factor de escala que le hay que aplicarle a la coordenada X de los precintos para que se correpondan con las coordenadas de otros precintos de otra resolución.

    - `h_offset`: Factor de escala que le hay que aplicarle a la coordenada Y de los precintos para que se correpondan con las coordenadas de otros precintos de otra resolución.


### <a name="tool_extractcache"></a>extractcache
* **Descripción**:  
    Esta utilidad nos permite extraer los precintos de una imagen predicción **$PI$** que no
    están entre los precintos de otra imagen **$I$**. Como salida devuelve un archivo con
    formato **`.cache`**, con todos los precintos que no están en **$I$**.  
    Estamos calculando el complemento del conjunto de precintos **$I$**.    

    $I^{'} = \{ x \in PI | x \notin I \}$

    ![](images/complemento.png)

* **Uso**:  

    ```
    extractcache <archivo.cache WOIs> <archivo.cache BACKGROUND> <archivo.cache OUT>
    ```    


### <a name="tool_get_header_size_j2c"></a>get_header_size_j2c
* **Descripción**:  
    Esta utilidad nos permite conocer el número de bytes de la cabecera de un archivo **`.j2c`**.

* **Uso**:  

    ```
    get_header_size_j2c <archivo.j2c>
    ```    


### <a name="tool_motion_estimation"></a>me
* **Descripción**:  
  Calcula los vectores de movimiento entre dos imágenes.

* **Uso**: 

    ```
    MCJ2K/bin/me -p 2 -x X -y Y -b B -s S -e even_image -o odd_image -a A -d D
    ```

    - `X`: Ancho de la imagen.

    - `Y`: Alto de la imagen.

    - `B`: Tamaño de bloque $B \times B$.

    - `S`: Tamaño del área de búsqueda.

    - `even_image`: Imagen par, $I_i$.

    - `odd_image`: Imagen impar, $I_{i+1}$.

    - `A`: Precisión subpixel.

    - `D`: Tamaño del borde de los bloques.



### <a name="tool_mogrify"></a>mogrify
* **Descripción**:  
  Es una utilidad de [ImageMagick](http://www.imagemagick.org) que nos permite modificar
  el tamaño de una imagen. Puede econtrar más información sobre esta utilidad en la 
  [web oficial](http://www.imagemagick.org/script/mogrify.php).

* **Uso**:  

    ```
    mogrify -resize 160x96 prediction_thumb.pgm
    ```


### <a name="tool_snr"></a>snr
* **Descripción**:  
    Esta utilidad permite calcular el PSNR entre dos imágenes.

* **Uso**:  

    ```
    snr --type=uchar --peak=255 --file_A=<imageA> --file_B=<imageB>
    ```


### <a name="tool_sortcache"></a>sortcache
* **Descripción**:  
    Esta utilidad nos permite ordenar los paquetes del code-stream siguiendo una progresión **LRCP**.
    Como entrada recibe un archivo con formato **`.cache`** desordenado y como salida devuelve otro
    archivo con formato **`.cache`** pero ya ordenado.

* **Uso**:  

    ```
    sortcache <filename.cache>
    ```    


### <a name="tool_woistocache"></a>woistocache
* **Descripción**:  
    Esta utilidad simula una serie de peticiones al servidor para obtener los precintos que nos interesan de una imagen.
    Permite obtener los precintos de una imagen en función del *bitrate* especificado como parámetro de entrada.    

    Hemos modificado la utilidad `woistocache` para que sólo nos
    devuelva los precintos que coinciden con la WOI solicitada, ya que
    el código que estábamos utilizando basado en las librerías de Kakadu
    también seleccionaba algunos precintos que estaban junto a los
    bordes de la WOI solicitada.\
    La utilidad `woistocache` ahora tiene un nuevo parámetro de entrada
    que nos permite seleccionar el modo de selección de los precintos.

    -   `Precincts Selection Mode = 0`. Los precintos se seleccionan tal
        y como lo hace Kakadu.

    -   `Precincts Selection Mode = 1`. Los precintos se seleccionan
        sólo cuando coinciden con la WOI. (Este es el modo utilizado
        actualmente en nuestros experimentos).

    La utilidad `woistocache`, genera 4 archivos de salida:

    -   **`.j2c.cache`**  
        Devuelve un archivo con el code-stream JPEG2000 de los precintos
        solicitados.

    -   **`.j2c.lrcp`**  
        Devuelve una lista donde se indica las coordenadas LRCP y el
        tamaño en bytes para cada uno de los precintos de la lista de
        entrada.

    -   **`.j2c.lrcp.sort`**  
        Devuelve una lista **ordenada** donde se indica las coordenadas
        LRCP y el tamaño en bytes para cada uno de los precintos de la
        lista de entrada.\
        El orden de la lista puede ser de dos tipos:

        -   `Type 1`: Vamos cogiendo el primer paquete de cada precinto.

        -   `Type 2`: Vamos cogiendo todos los paquetes de una capa de
            calidad de cada precinto.

    -   **`.j2c.woi`**  
        Devuelve una lista donde se indican los precintos que se han
        podido transmitir teniendo en cuenta el valor del *bitrate*
        establecido.

* **Uso**:  

    ```
    woistocache <Imagen J2C> <Lista de WOIs .txt> <W Precinct size> <H Precinct size> <r> <l> <BitRate (Bytes)> <Precincts Selection Mode>
    ```

    - `Imagen J2C` 
    - `Lista de WOIs .txt` 
    - `W Precinct size`
    - `H Precinct size`
    - `r`
    - `l` 
    - `BitRate (Bytes)`
    - `Precincts Selection Mode`


**NOTA - 29/01/2014**:  
La funcionalidad del modo *Precincts Selection Mode = $1$*
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