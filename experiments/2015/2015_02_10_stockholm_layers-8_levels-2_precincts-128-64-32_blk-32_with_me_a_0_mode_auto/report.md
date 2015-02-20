Experiment: 2015-02-10
======================

### Secuencia

- *stockholm*
- Número de imágenes: **90**

### Información de la secuencia
* Parámetros para la estimación de movimiento:
```
    X=1280
    Y=768
    B=128   # block size
    A=0     # subpixel accuracy = sub-pixel accuracy of the motion estimation
    D=0     # border size = size of the border of the blocks in the motion estimation process
    S=4     # search range = size of the searching area of the motion estimation
    V=0     # Overlapping (Para difuminar los bordes de los bloques)
```

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
    - WoisToCache: Modo AUTO (Utiliza Knapsack)
    - Utiliza Knapsack: Sí
    - Utiliza **mc**: Sí
    - Bitrate estimado: De **11000 bytes** a **51000** para cada frame

PSNR and SSIM
=============

### PSNR

![](assets/psnr.png)

* [Más información](md/psnr.md)

### SSIM

![](assets/ssim.png)

* [Más información](md/ssim.md)

### Average
* 11000 bytes
```
  * PSNR(cr + mc):      23.8791037765
  * PSNR(mj2):          13.0455741294
  * SSIM(cr + mc):      0.827482705882
  * SSIM(mj2):          0.570555647059
```

* 21000 bytes
```
  * PSNR(cr + mc):      29.1568982588
  * PSNR(mj2):          17.3572205529
  * SSIM(cr + mc):      0.948371529412
  * SSIM(mj2):          0.818358941176
```

* 31000 bytes
```
  * PSNR(cr + mc):      30.8798486
  * PSNR(mj2):          27.0357537765
  * SSIM(cr + mc):      0.963947647059
  * SSIM(mj2):          0.935187058824
```

* 41000 bytes
```
  * PSNR(cr + mc):      31.5154379647
  * PSNR(mj2):          30.0735392
  * SSIM(cr + mc):      0.968437294118
  * SSIM(mj2):          0.968274470588
```

* 51000 bytes
```
  * PSNR(cr + mc):      31.9224827882
  * PSNR(mj2):          31.8803870588
  * SSIM(cr + mc):      0.971114235294
  * SSIM(mj2):          0.97109
```

Codestream recibido para cada imagen
=============

![](assets/bytes.png)

* [Más información](md/bytes.md) 

Simulación de los resultados
=============

* Bitrate: 11.000 bytes. [gif](gif/all_11000.gif) | [ogv](ogv/all_11000.ogv)
* Bitrate: 21.000 bytes. [gif](gif/all_21000.gif) | [ogv](ogv/all_21000.ogv)
* Bitrate: 31.000 bytes. [gif](gif/all_31000.gif) | [ogv](ogv/all_31000.ogv)
* Bitrate: 41.000 bytes. [gif](gif/all_41000.gif) | [ogv](ogv/all_41000.ogv)
* Bitrate: 51.000 bytes. [gif](gif/all_51000.gif) | [ogv](ogv/all_51000.ogv)