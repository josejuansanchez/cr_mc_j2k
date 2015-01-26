Experiment: 2015-01-22
======================

### Secuencia

- *stockholm*
- Número de imágenes: **90**

### Información de la secuencia

* Parámetros de **kdu_compress**:

```
    CLAYERS=8
    CLEVELS=2
    CPRECINCTS="{128,128},{64,64},{32,32}"
    CBLK="{32,32}"
```

* Layer size (in bytes):

```
    Resolution level: 0
    Layer: 1     Size: 51,228
    Layer: 2     Size: 73,148
    Layer: 3     Size: 103,591
    Layer: 4     Size: 146,006
    Layer: 5     Size: 205,071
    Layer: 6     Size: 289,281
    Layer: 7     Size: 406,765
    Layer: 8     Size: 587,788

    Resolution level: 1
    Layer: 1     Size: 40,280
    Layer: 2     Size: 63,850
    Layer: 3     Size: 85,723
    Layer: 4     Size: 123,096
    Layer: 5     Size: 155,624
    Layer: 6     Size: 231,730
    Layer: 7     Size: 314,835
    Layer: 8     Size: 433,559

    Resolution level: 2
    Layer: 1     Size: 23,642
    Layer: 2     Size: 52,444
    Layer: 3     Size: 80,622
    Layer: 4     Size: 104,102
    Layer: 5     Size: 148,911
    Layer: 6     Size: 213,263
    Layer: 7     Size: 295,114
    Layer: 8     Size: 407,245
```

### Descripción

- Este experimento compara cómo sería la transmisión siguiendo el algoritmo
  **cr** frente a una transmisión Motion JPEG2000 (**mj2**). 
- La transmisión Motion JPEG2000 se simula truncando el *code-stream* a
  un determinado bitrate.
- La transmisión **cr** utiliza los siguientes parámetros:
    - WoisToCache: Modo 1 (Se transmiten todas las capas de calidad de cada precinto)
    - Utiliza **mc**: Sí
    - Utiliza Knapsack: No
    - Bitrate estimado: De **11000 bytes** a **51000** para cada frame

PSNR and SSIM
=============

### PSNR

![assets/psnr_1000.txt](assets/psnr.png)

### SSIM

![assets/ssim_1000.txt](assets/ssim.png)

Codestream recibido para cada imagen
=============

![assets/bytes_1000.txt](assets/bytes.png)

Simulación de los resultados
=============

* Original:  
  ![](gifs/original.gif)

* Bitrate: 10.000 bytes
  * cr + mc:  
    ![](gifs/prediction_10000.gif)

  * blocks:  
    ![](gifs/blocks_10000.gif)

  * mj2:  
    ![](gifs/trunc_10000.gif)

* Bitrate: 20.000 bytes
  * cr + mc:  
    ![](gifs/prediction_20000.gif)

  * blocks:  
    ![](gifs/blocks_20000.gif)

  * mj2:  
    ![](gifs/trunc_20000.gif)

* Bitrate: 31.000 bytes
  * cr + mc:  
    ![](gifs/prediction_31000.gif)

  * blocks:  
    ![](gifs/blocks_31000.gif)

  * mj2:  
    ![](gifs/trunc_31000.gif)

* Bitrate: 41.000 bytes
  * cr + mc:  
    ![](gifs/prediction_41000.gif)

  * blocks:  
    ![](gifs/blocks_41000.gif)

  * mj2:  
    ![](gifs/trunc_41000.gif)
