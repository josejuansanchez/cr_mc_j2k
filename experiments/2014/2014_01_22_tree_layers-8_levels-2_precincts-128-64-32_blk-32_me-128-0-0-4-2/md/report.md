Experiment: 2014-01-22
======================

Secuencia
---------
- *tree*

Descripción
-----------

- Se ha simulado una transimisión de **491** imágenes de la secuencia *tree* de 1280x768.
- Este experimento compara cómo sería la transmisión siguiendo el algoritmo **cr+mc** frente a una transmisión LRCP.
- **cr+mc**: Para nuestro algoritmo sólo se transmite **la primera capa de calidad completa de cada precinto**.
- **trunc**: Se trunca el *code-stream* a un determinado bitrate para simular una transmisión LRCP.
- Parámetros de **kdu\_compress**:

```
        CLAYERS=8
        CLEVELS=2
        CPRECINCTS="{128,128},{64,64},{32,32}"
        CBLK="{32,32}"
```

- Parámetros de **me**:

```
        B=128   # block size
        A=0     # subpixel accuracy = sub-pixel accuracy of the motion estimation
        D=0     # border size = size of the border of the blocks in the motion estimation process
        S=4     # search range = size of the searching area of the motion estimation
        V=2     # overlapping
```

PSNR and SSIM
=============

### PSNR

![](images/psnr_type2.png)

### SSIM

![](images/ssim_type2.png)