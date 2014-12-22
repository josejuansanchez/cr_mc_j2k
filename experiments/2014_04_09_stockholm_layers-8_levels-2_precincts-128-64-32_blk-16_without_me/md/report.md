Experiment: 2014-04-09
======================

Secuencia
---------
- *stockholm*

Descripción
-----------

- Se ha simulado una transimisión de **200** imágenes de la secuencia *stockholm* de 1280x768.
- Este experimento compara cómo sería la transmisión siguiendo el algoritmo **cr** frente a una transmisión Motion JPEG2000.
- **cr**: Para nuestro algoritmo sólo se transmite **la primera capa de calidad completa de cada precinto**.
- En este experimento *no se ha utilizado mc*.
- **mj2**: Se trunca el *code-stream* a un determinado bitrate para simular una transmisión Motion JPEG2000.
- Parámetros de **kdu\_compress**:

```
        CLAYERS=8
		CLEVELS=2
		CPRECINCTS="{128,128},{64,64},{32,32}"        
        CBLK="{16,16}"
```

- Layer size (bytes):

```
		Layer 1: 53.359
        Layer 2: 76.016
        Layer 3: 107.469
        Layer 4: 151.807
        Layer 5: 213.581
        Layer 6: 300.711
        Layer 7: 423.215
        Layer 8: 622.867
```

PSNR and SSIM
=============

### PSNR

![](images/psnr.png)

### SSIM

![](images/ssim.png)