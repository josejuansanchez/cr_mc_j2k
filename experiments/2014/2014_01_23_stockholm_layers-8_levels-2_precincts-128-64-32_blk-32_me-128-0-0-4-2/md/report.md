Experiment: 2014-01-22
======================

Secuencia
---------
- *stockholm*

Nota
----

- Hemos vuelto a repetir el experimento para un bitrate de 21K para comprobar 
  qué le ocurre a la versión *trunc* a partir de la imagen 160 aproximadamente.

- Después de repetir el experimento pensamos que lo que está ocurriendo para el 
  caso de 21K es que para las primeras imágenes de la secuencia tenemos suficiente 
  bitrate para recibir la imagen completa, pero conforme vamos avanzando en la 
  secuencia este bitrate no es suficiente y empezamos a tener algunas zonas de 
  color gris (que suponemos que son las que nos provocan esos valores tan bajos de PSNR).

A continuación se muestran dos reconstrucciones de ejemplo:

- Frame: 100. En este caso obtenemos un PSNR de 27.974694  
![](images/100.trunc.png)

- Frame: 400. En este caso obtenemos un PSNR de 15.882816  
![](images/400.trunc.png)


Descripción
-----------

- Se ha simulado una transimisión de **491** imágenes de la secuencia *stockholm* de 1280x768.
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

![](images/psnr_21000.png)

### SSIM

![](images/ssim_21000.png)