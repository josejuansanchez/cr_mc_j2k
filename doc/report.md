% Conditional Replenishment and Motion Compensation\
  Internal report
% 
% 

Introducción
============

Algoritmo
=========   

1.  Se descargan las dos primeras imágenes de la secuencia, $I_i$
    ($even\_image$) y $I_{i+1}$ ($odd\_image$).

2.  Calculamos los **vectores de movimiento** entre las dos imágenes, 
    $I_i$ ($even\_image$) y $I_{i+1}$ ($odd\_image$).  
    Tool: [`me`](#tool_motion_estimation). 

3.  Generamos una **imagen predicción**, $PI_{i+2}$, a partir de la imagen $I_{i+1}$
    ($odd\_image$) y los vectores de movimiento calculados en el paso
    anterior.  
    Tool: [`decorrelate`](#decorrelate). 

4.  A partir de la imagen predicción $PI_{i+2}$, obtenemos el thumbnail 
    $Thumbnail(PI_{i+2})$.  
    Tool: [`mogrify`](#tool_mogrify). 

5.  Solicitamos al servidor el thumbnail de la siguiente imagen de la
    secuencia, $Thumbnail(I_{i+2})$.

6.  Calculamos las diferencias entre el thumbnail predicción, $Thumbnail(PI_{i+2})$, 
    y el thumbnail de la siguiente imagen, $Thumbnail(I_{i+2})$, y las ordenamos 
    de mayor a menor.  
    El resultado de este proceso nos devuelve la lista de `WOIs` que debemos
    solicitar al servidor, ordenadas de mayor a menor importancia.  
    Todo: [`differencesthumbnails`](#tool_differencesthumbnails).  

    **TODO**: No incluir en el listado aquellas `WOIs` donde no exista diferencia,
    para ahorrarnos tener que solicitarlas al servidor.

    **NOTA**: Podríamos cambiar el método que utilizamos para calcular las diferencias
    entre los dos thumbnails y hacer alguna prueba calculando el índice **SSIM** sobre
    pequeños bloques de ambas imágenes.

7.  Solicitamos al servidor los precintos/`WOIs` (1 precinto = 1 `WOI`) que nos interesan de la
    siguiente imagen, $I_{i+2}$, en función del $bitrate$ estimado. Actualmente el
    valor del $bitrate$ es un valor constante que se asigna al inicio de
    la ejecución del algoritmo.  
    Todo: [`woistocache`](#tool_woistocache).  
    
    **TODO**: Sería interesante hacer pruebas donde el valor del $bitrate$
    pueda ir variando durante la ejecución del algoritmo.

8.  Comprimimos la imagen predicción $PI_{i+2}$ (obtenida en el paso 3) con la
    utilidad `kdu_compress`, para convertir de **.pgm** a **.j2c**.  
    Los parámetros de compresión deben coincidir con los parámetros de
    compresión iniciales.  

    **NOTA**: Esta operación debe realizarse en el cliente y
    puede ser un poco lenta.

9.  Convertimos el archivo **.j2c** de la imagen predicción $PI_{i+2}$ a
    **.cache**.  
    Utilizamos la utilidad `woistocache` y una lista que contiene todos
    los precintos de la imagen. Hay que tener en cuenta que la división
    de los precintos para toda la imagen sea exacta. En este caso el
    parámetro `Precincts Selection Mode = 0` para que la selección de
    los precintos se realice tal y como lo hace Kakadu.  
    `woistocache prediction_temp.j2c precincts/xxx.todos.txt WIDTH_RECONS HEIGHT_RECONS ((CLEVELS+1)) CLAYERS 999999999 0`

10. Con la utilidad `extractcache` extraemos los precinctos de la imagen 
    predicción $PI_{i+2}$ que no están entre los precintos que hemos solicitado
    en el paso 7 para la imagen $I_{i+2}$. Los precintos que hemos extraído de la imagen
    predicción los guardamos en el archivo $temp\_aux.cache$.  
    `extractcache next_image_j2c_cache prediction_temp.j2c.cache temp_aux.cache`

11. Unimos los precintos que tenemos de la siguiente imagen $I_{i+2}$ con los precintos
    de la imagen predicción $PI_{i+2}$ que hemos extraído en el paso anterior y los
    ordenamos.

12. Al solicitar los precintos/`WOIs` de la siguiente imagen $I_{i+2}$ en función
    de un determinado $bitrate$, puede ocurrir que no se reciban los precintos completos
    y que solamente se reciban ciertos paquetes. Por este motivo tenemos que revisar
    entre todos los precintos que hemos recibido cuáles son los que se encuentran 
    incompletos y generar los paquetes vacíos necesarios para completarlos. 
    En este punto tendremos un archivo **.cache** que contiene:
    -  los precintos que hemos solicitado de la siguiente imagen $I_{i+2}$,
    -  los precintos que hemos extraído de la imagen predicción $PI_{i+2}$ que no
       están entre los nuevos precintos que hemos recibido,
    -  los paquetes vacíos que hemos ido generando para completar los precintos
       incompletos que hemos recibido de la siguiente imagen $I_{i+2}$.  
    
    Tool: [`cookcache`](#tool_cookcache).  

13. Descomprimimos el archivo **.cache** con el code-stream.  
    Tool: [`decodefromcache`](#tool_decodefromcache).  

Tools
=====

### <a name="tool_motion_estimation"></a>me

Uso: `MCJ2K/bin/me -p 2 -x X -y Y -b B -s S -e even_image -o odd_image -a A -d D`

-   $X$: Ancho de la imagen.

-   $Y$: Alto de la imagen.

-   $B$: Tamaño de bloque $B \times B$.

-   $S$: Tamaño del área de búsqueda.

-   $even\_image$: Imagen par, $I_i$.

-   $odd\_image$: Imagen impar, $I_{i+1}$.

-   $A$: Precisión subpixel.

-   $D$: Tamaño del borde de los bloques.


### <a name="tool_decorrelate"></a>decorrelate 

Uso: `MCJ2K/bin/decorrelate -p 2 -x X -y Y -b B -s S -e odd_image -o odd_image -i motion -v V`

-   $V$: Overlapping. Para difuminar los bordes de los bloques.


### <a name="tool_mogrify"></a>mogrify
TODO

### <a name="tool_differencesthumbnails"></a>differencesthumbnails
TODO

### <a name="tool_woistocache"></a>woistocache

Hemos modificado la utilidad `woistocache` para que sólo nos
devuelva los precintos que coinciden con la WOI solicitada, ya que
el código que estábamos utilizando basado en las librerías de Kakadu
también seleccionaba algunos precintos que estaban junto a los
bordes de la WOI solicitada.\
La utilidad `woistocache` ahora tiene un nuevo parámetro de entrada
que nos permite seleccionar el modo de selección de los precintos.

-   Precincts Selection Mode = $0$. Los precintos se seleccionan tal
    y como lo hace Kakadu.

-   Precincts Selection Mode = $1$. Los precintos se seleccionan
    sólo cuando coinciden con la WOI. (Este es el modo utilizado
    actualmente en nuestros experimentos).

**NOTA**: La funcionalidad del modo *Precincts Selection Mode = $1$*
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

La utilidad `woistocache`, genera 4 archivos de salida:

-   **xxx.j2c.cache**\
    Devuelve un archivo con el stream JPEG2000 de los precintos
    solicitados.

-   **xxx.j2c.lrcp**\
    Devuelve una lista donde se indica las coordenadas LRCP y el
    tamaño en bytes para cada uno de los precintos de la lista de
    entrada.

-   **xxx.j2c.lrcp.sort**\
    Devuelve una lista **ordenada** donde se indica las coordenadas
    LRCP y el tamaño en bytes para cada uno de los precintos de la
    lista de entrada.\
    El orden de la lista puede ser de dos tipos:

    -   Type 1: Vamos cogiendo el primer paquete de cada precinto.

    -   Type 2: Vamos cogiendo todos los paquetes de una capa de
        calidad de cada precinto.

-   **xxx.j2c.woi**\
    Devuelve una lista donde se indican los precintos que se han
    podido transmitir teniendo en cuenta el valor del BITRATE
    establecido.

### <a name="tool_get_header_size_j2c"></a>get_header_size_j2c
TODO

### <a name="tool_extractcache"></a>extractcache
TODO

### <a name="tool_decodefromcache"></a>decodefromcache
TODO

### <a name="tool_sortcache"></a>sortcache
TODO

### <a name="tool_snr"></a>snr
TODO

### <a name="tool_drawblocks_txt"></a>drawblocks_txt
TODO

### <a name="tool_countsops"></a>countsops
TODO

### <a name="tool_cookcache"></a>cookcache
TODO


Formato .j2c.cache
==================

Estamos utilizando un formato interno para trabajar con los
precintos/paquetes del codestream.

La estructura de los paquetes que se almacenan en los archivos
**.cache** es la siguiente:

    --------------------------------------------------------------------
    | precinct id (4 bytes) | l (4 bytes)  | r (4 bytes) | c (4 bytes) |
    --------------------------------------------------------------------
    | py (4 bytes)          | px (4 bytes) | packet length (4 bytes)   | 
    --------------------------------------------------------------------
    | packet                                                           |
    --------------------------------------------------------------------

Cookcache
=========

Este programa recibe dos archivos con formato **.j2c.cache** y devuelve
como salida otro archivo con formato **.j2c.cache** formado por los
paquetes vacíos necesarios para completar los precintos que aparecen en
el archivo `<response.j2c.cache>`.\

blue`cookcache <full.j2c.cache> <response.j2c.cache>`

**Entrada:**

-   `<full.j2c.cache>`: Este archivo contiene todo el codestream
    completo de una imagen.

-   `<response.j2c.cache>`: Este archivo contiene la respuesta que nos
    envía el servidor, para una petición formada por una serie de WOIs
    (precintos) y un determinado bitrate. Lo normal es que esta
    respuesta contega solamente algunos de los paquetes que forman un
    precinto, por este motivo habrá que localizar cuáles son los
    paquetes que faltan para completar el precinto completo y crear
    paquetes vacíos en su lugar.

**Salida:**

Este programa devuelve el archivo `emptypackets.j2c.cache` con todos los
paquetes vacíos que son necesarios para completar todos los precinctos.

La fusión de los archivos `<response.j2c.cache>` +
`emptypackets.j2c.cache` contendrá el codestream necesario para poder
realizar la fusión de dos imágenes en el dominio JPEG2000.

Paquetes vacíos
===============

Los paquetes vacíos que se han creado contienen 8 bytes y tienen el
siguiente formato:

     FF 91   00 04   XX XX   80 00
    \_____/ \_____/ \_____/ \_____/
      SOP    Lsop    Nsop    Packet Body

-   **SOP**: Start of packet.

-   **Lsop**: Length of marker segment in bytes (not including the
    marker).

-   **Nsop**: Packet id [0..65535].

-   **Packet Body**: Code-stream.

-   `FF_{(16)} = unsigned char sop_0 = 255_{(10)}`.

-   `91_{(16)} = unsigned char sop_1 = 145_{(10)}`.

-   `00_{(16)} = unsigned char lsop_0 = 0_{(10)}`.

-   `04_{(16)} = unsigned char lsop_1 = 4_{(10)}`.

-   `XX XX` se corresponde con el id del paquete.

-   `80_{(16)} = unsigned char body_0 = 128_{(10)}`.

-   `00_{(16)} = unsigned char body_1 = 0_{(10)}`.

Nuevo tamaño de bloque para la lectura de paquetes
==================================================

Se ha modificado el tamaño de la estructura que utilizábamos para leer
los paquetes de los archivos `.j2c` para luego almacenarlos en nuestro
formato interno `.j2c.cache`. Por ejemplo en la aplicación `woistocache`
los paquetes se leían en bloques de $500$ bytes utilizando la estructura
`kdu_byte data[500]`. De modo que para un paquete de $2214$ bytes
tendríamos $5$ bloques en nuestro archivo `.j2c.cache`.

    precinct.id = 176: 7 2 0 5 6: 500 bytes
    precinct.id = 176: 7 2 0 5 6: 500 bytes
    precinct.id = 176: 7 2 0 5 6: 500 bytes
    precinct.id = 176: 7 2 0 5 6: 500 bytes
    precinct.id = 176: 7 2 0 5 6: 214 bytes

Hemos aumentado el tamaño de bloque y ahora utilizamos la estructura
`kdu_byte data[524288]`. De este modo garatizamos que en nuestro archivo
`.j2c.cache` vamos a tener el paquete en un sólo bloque. (Tengo que
revisar cuál es el tamaño máximo que puede tener un paquete)

JPEG2000 Packet Structure
=========================

Ejemplo:  

```
 FF 91    00 04    04 EC    C0 00 ...
\-----/  \-----/  \-----/  \--------/
 16 bits  16 bits  16 bits   N bits
 
 SOP       Lsop     Nsop     Packet Body
```

**SOP**: Start Of Packet marker.  
**Lsop**: Length of marker segment in bytes (Not including the marker).  
**Nsop**: Packet number (Possible values are between 0 and 65535).  


Warning!: Parsing SOPs
======================

Hemos detectado un posible error a la hora de obtener los paquetes de un
code-stream JPEG2000 si lo hacemos buscando el marcador SOP.

* **SOP marker**  
Si solamente buscamos el valor ```0xFF91``` del marcador podemos obtener
una interpretación errónea de los paquetes.

    Ejemplo:  

    ```
    FF 91    00 04    00 FF    91 40 ...
    \-----/  \-----/  \-----/  \--------/
    16 bits  16 bits  16 bits   N bits

    SOP       Lsop     Nsop     Packet Body
    ```

    En este caso el último byte de **Nsop** y el primer byte de **Packet body**
    forman el valor ```0xFF91``` y nos podría causar un error a la hora de obtener
    los paquetes de este code-stream.

    En nuestros experimentos este caso era el que provocaba que nuestras utilidades
    "countsops" y "woistocache" obtuviesen un paquete de más.


* **EOC marker**  
Si solamente buscamos el valor ```0xFFD9``` del marcador podemos obtener
una interpretación errónea de los paquetes.

    Ejemplo:  

    ```
     FF 91    00 04    01 FF    D9 ...
    \-----/  \-----/  \-----/  \--------/
     16 bits  16 bits  16 bits   N bits
     
     SOP       Lsop     Nsop     Packet Body
    ```

    En nuestros experimentos este caso era el que provocaba que nuestras utilidades
    "countsops" y "woistocache" interpretasen que se había alcanzado el final
    del code-stream antes de tiempo.


Cambios en la utilidad: ```countsops```
=======================================

Hemos modificado la utilidad y ahora para detectar que ha encontrado un paquete
tiene que encontrar los siguientes 4 bytes seguidos.

```
 FF 91    00 04 
\-----/  \-----/
 16 bits  16 bits
 
 SOP       Lsop
```

Cambios en la librería ```jp2_area.cpp```
========================================

Hemos modificado el método ```void jp2_area::get_packet_data(FILE *f, packet_data& p)```
de la librería ```jp2_area.cpp``` para evitar el problema de los marcadores **SOP**.

Ahora para garantizar que se ha encontrado un paquete tenemos que encontrar los siguientes 
4 bytes seguidos.

```
 FF 91    00 04 
\-----/  \-----/
 16 bits  16 bits
 
 SOP       Lsop
```

También nos hemos encontrado con un caso que podría dar lugar a confusión, porque
se puede hacer una mala interpretación del marcador **FF D9** (End Of Code-stream).

```
 FF 91    00 04   01 FF    D9 ... ...
\-----/  \-----/ \-----/  \-----/
 16 bits 16 bits 16 bits
 
 SOP       Lsop   Nsop    Packet Body
```

Para solucionarlo hemos comprobado que después del marcador **FF D9** no hay más bytes.


Parámetros de configuración con Stockholm
=========================================

Estos son los parámetros de configuración que se están utilizando
actualmente para el experimento con la secuencia de Stockholm.

**Motion Estimation**

-   $X$: $1280$ (Ancho de la imagen).

-   $Y$: $768$ (Alto de la imagen).

-   $B$: $128$ (Tamaño de bloque $128 \times 128$).

-   $S$: $4$ (Tamaño del área de búsqueda).

-   $A$: $0$ (Precisión subpixel).

-   $D$: $0$ (Tamaño del borde de los bloques).

Experimento con Stockholm
=========================

![image](benchmark/01_type1/psnr_type1.pdf) PSNR. Type 1
[fig:image1]

![image](benchmark/02_type2/psnr_type2.pdf) PSNR. Type 2
[fig:image2]

![image](benchmark/03_type1_vs_type2/psnr_type1_vs_type2.pdf)
PSNR. Type1 vs Type 2 [fig:image3]


Parámetros de configuración con `tree`
======================================

Estos son los parámetros de configuración que se están utilizando
actualmente para el experimento con la secuencia `tree`.

**Motion Estimation**

-   $X$: $1280$ (Ancho de la imagen).

-   $Y$: $768$ (Alto de la imagen).

-   $B$: $128$ (Tamaño de bloque $128 \times 128$).

-   $S$: $4$ (Tamaño del área de búsqueda).

-   $A$: $0$ (Precisión subpixel).

-   $D$: $0$ (Tamaño del borde de los bloques).

Experimento con `tree`
======================

Test con código
---------------
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.cpp .numberLines}
bool jp2_area::woi_to_lrcp_modified(char filename_woi[], int w, int h, int r, int q)
{
    ...
    for (int l = 0; l < q; l++)
    {
      for (int resolution = 0; resolution < r; resolution++)
      {
        for (int c = 0; c < tile.get_num_components(); c++)
        {
          kdu_tile_comp comp = tile.access_component(c);
          kdu_resolution res = comp.access_resolution(resolution);

          kdu_dims pdims;
          res.get_valid_precincts(pdims);

          for (int py = pdims.pos.y; py < pdims.pos.y + pdims.size.y; py++)
          {
            for (int px = pdims.pos.x; px < pdims.pos.x + pdims.size.x; px++) 
            {    
               kdu_long pid = res.get_precinct_id(kdu_coords(px, py));
               ...
}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
