Experiment: 2015-07-10
======================

### Secuencia

- *speedway*
- Número de imágenes: **50**

### Información de la secuencia
* ~~Parámetros para la estimación de movimiento~~

* Parámetros de **kdu_compress**:

```
    CLAYERS=8
    CLEVELS=4
    CPRECINCTS="{128,128},{64,64},{32,32},{32,32},{32,32}"
    CBLK="{16,16}"
    CORDER=LRCP
```

* Layer size (in bytes):

Note: The resolution level 0 is the level with the bigger size of the image

```
Resolution level: 0
Layer: 1     Size: 5,224
Layer: 2     Size: 7,475
Layer: 3     Size: 10,483
Layer: 4     Size: 14,613
Layer: 5     Size: 20,269
Layer: 6     Size: 28,144
Layer: 7     Size: 39,156
Layer: 8     Size: 59,408

Resolution level: 1
Layer: 1     Size: 4,052
Layer: 2     Size: 6,740
Layer: 3     Size: 9,047
Layer: 4     Size: 13,100
Layer: 5     Size: 17,023
Layer: 6     Size: 23,653
Layer: 7     Size: 31,670
Layer: 8     Size: 40,987

Resolution level: 2
Layer: 1     Size: 2,676
Layer: 2     Size: 5,893
Layer: 3     Size: 8,131
Layer: 4     Size: 11,449
Layer: 5     Size: 15,249
Layer: 6     Size: 21,230
Layer: 7     Size: 28,547
Layer: 8     Size: 39,397

Resolution level: 3
Layer: 1     Size: 1,573
Layer: 2     Size: 5,375
Layer: 3     Size: 7,665
Layer: 4     Size: 10,737
Layer: 5     Size: 14,680
Layer: 6     Size: 20,384
Layer: 7     Size: 28,179
Layer: 8     Size: 39,202

Resolution level: 4
Layer: 1     Size: 928
Layer: 2     Size: 5,257
Layer: 3     Size: 7,482
Layer: 4     Size: 10,490
Layer: 5     Size: 14,620
Layer: 6     Size: 20,276
Layer: 7     Size: 28,151
Layer: 8     Size: 39,166
```


### Descripción

- Este experimento compara cómo sería la transmisión siguiendo el algoritmo
  **cr** frente a una transmisión Motion JPEG2000 (**mj2**). 
- La transmisión Motion JPEG2000 se simula truncando el *code-stream* a
  un determinado bitrate.
- La transmisión **cr** utiliza los siguientes parámetros:
    - WoisToCache: Modo 2 / Enviando 8 capas completas para precinto siguiendo una **LRCP**
    - Utiliza Knapsack: No
    - Utiliza **mc**: No
    - Bitrate estimado: De **1000 bytes** a **10000 bytes**

PSNR and SSIM
=============

### PSNR

![](assets/psnr-1k-5k.png)
![](assets/psnr-6k-10k.png)

### SSIM

![](assets/ssim-1k-5k.png)
![](assets/ssim-6k-10k.png)

### Average

| PSNR-SSIM \ Bytes | 1000            | 2000            | 3000            | 4000            | 5000           
| ----------------- | --------------- | --------------- | --------------- | --------------- | ---------------
| **PSNR(cr + mc)** |   |   |   |   | 
| **PSNR(mj2)**     |   |   |   |   | 
| **SSIM(cr + mc)** |   |   |   |   | 
| **SSIM(mj2)**     |   |   |   |   | 

| PSNR-SSIM \ Bytes | 6000            | 7000            | 8000            | 9000            | 10000           
| ----------------- | --------------- | --------------- | --------------- | --------------- | ---------------
| **PSNR(cr + mc)** |   |   |   |   | 
| **PSNR(mj2)**     |   |   |   |   | 
| **SSIM(cr + mc)** |   |   |   |   | 
| **SSIM(mj2)**     |   |   |   |   | 


Simulación de los resultados
=============

* Bitrate: 1000 bytes. [gif](gif/all_1000.gif) | [ogv](ogv/all_1000.ogv)
* Bitrate: 2000 bytes. [gif](gif/all_2000.gif) | [ogv](ogv/all_2000.ogv)
* Bitrate: 3000 bytes. [gif](gif/all_3000.gif) | [ogv](ogv/all_3000.ogv)
* Bitrate: 4000 bytes. [gif](gif/all_4000.gif) | [ogv](ogv/all_4000.ogv)
* Bitrate: 5000 bytes. [gif](gif/all_5000.gif) | [ogv](ogv/all_5000.ogv)
* Bitrate: 6000 bytes. [gif](gif/all_6000.gif) | [ogv](ogv/all_6000.ogv)
* Bitrate: 7000 bytes. [gif](gif/all_7000.gif) | [ogv](ogv/all_7000.ogv)
* Bitrate: 8000 bytes. [gif](gif/all_8000.gif) | [ogv](ogv/all_8000.ogv)
* Bitrate: 9000 bytes. [gif](gif/all_9000.gif) | [ogv](ogv/all_9000.ogv)
* Bitrate: 10000 bytes. [gif](gif/all_10000.gif) | [ogv](ogv/all_10000.ogv)