Experiment: 2014-04-23
======================

Secuencia
---------
- *stockholm*

Descripción
-----------

- Se ha simulado una transimisión de **100** imágenes de la secuencia *stockholm* de 1280x768.
- Este experimento compara cómo sería la transmisión siguiendo el algoritmo **cr** frente a una transmisión Motion JPEG2000.
- **cr**: Para nuestro algoritmo sólo se transmite **la primera capa de calidad completa de cada precinto**.
- En este experimento *no se ha utilizado mc*.
- **mj2**: Se trunca el *code-stream* a un determinado bitrate para simular una transmisión Motion JPEG2000.
- Parámetros de **kdu\_compress**:

```
        CLAYERS=8
        CLEVELS=2
        CPRECINCTS="{128,128},{64,64},{32,32}"        
        CBLK="{32,32}"
```

- Layer size (bytes):

```
        Layer 1: 51.084
        Layer 2: 72.961
        Layer 3: 103.362
        Layer 4: 145.697
        Layer 5: 205.006
        Layer 6: 288.457
        Layer 7: 406.313
        Layer 8: 587.540
```

PSNR and SSIM
=============

### PSNR

![](images/psnr.png)

### SSIM

![](images/ssim.png)