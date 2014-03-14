Experiment: 2014-01-17
======================

Secuencia
---------
- *tree*

Descripción
-----------

* Se ha simulado una transimisión de las **10** primeras imágenes de la secuencia *tree* de 1280x768.
* Este experimento compara cómo sería la transmisión siguiendo el algoritmo **cr+me** frente a una transmisión LRCP.
* **cr+me**: Para nuestro algoritmo sólo se transmite **la primera capa de calidad completa de cada precinto**.
* **trunc**: Se trunca el *code-stream* a un determinado bitrate para simular una transmisión LRCP.
* Parámetros de **kdu_compress**:

```
    CLAYERS=8
    CLEVELS=2
    CPRECINCTS="{128,128},{64,64},{32,32}"
    CBLK="{32,32}"
```

* Parámetros de **me**:

```
    B=128   # block size
    A=0 	# subpixel accuracy = sub-pixel accuracy of the motion estimation
    D=0     # border size = size of the border of the blocks in the motion estimation process
    S=4     # search range = size of the searching area of the motion estimation
    V=2     # overlapping
```

## Reconstructed images

<table border="1">
    <tr>
    	<td>bytes</td>
        <td>cr+me</td>
        <td>trunc</td>
    </tr>
    <tr>
    	<td>1K</td>
        <td>![cr+me 1K](images/blocks.1000.png)</td>
        <td>![trunc 1K](images/trunc.1000.png)</td>
    </tr>
    <tr>
    	<td>11K</td>    	
        <td>![cr+me 11K](images/blocks.11000.png)</td>
        <td>![trunc 11K](images/trunc.11000.png)</td>
    </tr>
    <tr>
    	<td>21K</td>    	
        <td>![cr+me 11K](images/blocks.21000.png)</td>
        <td>![trunc 11K](images/trunc.21000.png)</td>
    </tr>    
    <tr>
    	<td>31K</td>    	
        <td>![cr+me 1K](images/blocks.31000.png)</td>
        <td>![trunc 1K](images/trunc.31000.png)</td>
    </tr>
    <tr>
    	<td>41K</td>    	
        <td>![cr+me 1K](images/blocks.41000.png)</td>
        <td>![trunc 1K](images/trunc.41000.png)</td>
    </tr>    
    <tr>
    	<td>51K</td>    	
        <td>![cr+me 1K](images/blocks.51000.png)</td>
        <td>![trunc 1K](images/trunc.51000.png)</td>
    </tr>
</table>


PSNR and SSIM
=============

### PSNR
![](images/psnr_type2.png)

A partir de 51K ya se ha transmitido la primera capa de calidad completa de todos los precintos, por eso a partir de este punto ya no seguimos evaluando porque ya no estaríamos reutilizando los datos que tenemos de la imagen anterior.

### SSIM
![](images/ssim_type2.png)

A partir de 21K ya empezamos a tener valores muy similares de SSIM.

Structural SIMilarity (SSIM)
============================

* [The SSIM Index for Image Quality Assessment](http://www.cns.nyu.edu/~lcv/ssim/).
* [Image Quality Assessment: From Error Visibility to Structural Similarity](http://www.cns.nyu.edu/pub/eero/wang03-reprint.pdf). IEEE Transactions on Image Processing, vol. 13, no. 4, Apr. 2004.
* [Mean squared error: love it or leave it? - A new look at signal fidelity measures](https://ece.uwaterloo.ca/~z70wang/publications/SPM09.pdf). IEEE Signal Processing Magazine, vol. 26, no. 1, pp. 98-117, Jan. 2009.