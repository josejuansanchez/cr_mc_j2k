Experiment: 2014-02-10
======================

Secuencia
---------
- *stockholm*

Descripción
-----------

- Se ha simulado una transimisión de **400** imágenes de la secuencia *stockholm* de 1280x768.
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

PSNR and SSIM
=============

### PSNR

![](images/psnr.png)

### SSIM

![](images/ssim.png)