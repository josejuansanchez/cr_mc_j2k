Experiment: 2015-03-05
======================

### Secuencia

- *speedway*
- Número de imágenes: **50**

### Información de la secuencia
* ~~Parámetros para la estimación de movimiento~~

* Parámetros de **kdu_compress**:

```
    CLAYERS=8
    CLEVELS=2
    CPRECINCTS="{64,64},{32,32},{16,16}"
    CBLK="{16,16}"
```

* Layer size (in bytes):

```
    Resolution level: 0
    Layer: 1     Size: 5,354
    Layer: 2     Size: 7,830
    Layer: 3     Size: 11,050
    Layer: 4     Size: 15,336
    Layer: 5     Size: 21,136
    Layer: 6     Size: 29,117
    Layer: 7     Size: 40,119
    Layer: 8     Size: 61,655
```

### Descripción

- Este experimento compara cómo sería la transmisión siguiendo el algoritmo
  **cr** frente a una transmisión Motion JPEG2000 (**mj2**). 
- La transmisión Motion JPEG2000 se simula truncando el *code-stream* a
  un determinado bitrate.
- La transmisión **cr** utiliza los siguientes parámetros:
    - WoisToCache: Modo 2 / Enviando 8 capas completas para precinto
    - Utiliza Knapsack: No
    - Utiliza **mc**: No
    - Bitrate estimado: De **1000 bytes** a **20000 bytes**

PSNR and SSIM
=============

### PSNR

![](assets/psnr-1k-5k.png)
![](assets/psnr-6k-10k.png)
![](assets/psnr-11k-15k.png)
![](assets/psnr-16k-20k.png)

### SSIM

![](assets/ssim-1k-5k.png)
![](assets/ssim-6k-10k.png)
![](assets/ssim-11k-15k.png)
![](assets/ssim-16k-20k.png)

### Average

| PSNR-SSIM \ Bytes | 1000            | 2000            | 3000            | 4000            | 5000           
| ----------------- | --------------- | --------------- | --------------- | --------------- | ---------------
| **PSNR(cr + mc)** | 36.4612818163   | 36.7993643673   | 39.1250042857   | 39.8848125714   | 40.9871622245
| **PSNR(mj2)**     | 10.5262652245   | 13.1635973469   | 27.9175590408   | 29.9916476327   | 33.1327761837
| **SSIM(cr + mc)** |  0.967343877551 |  0.968563265306 |  0.971506530612 |  0.974154285714 |  0.975247346939
| **SSIM(mj2)**     |  0.473184489796 |  0.626356530612 |  0.8153         |  0.853738571429 |  0.879016122449

| PSNR-SSIM \ Bytes | 6000            | 7000            | 8000            | 9000            | 10000           
| ----------------- | --------------- | --------------- | --------------- | --------------- | ---------------
| **PSNR(cr + mc)** | 41.6788293469   | 42.0334303469   | 42.5908187959   | 42.757084551    | 42.4919367347
| **PSNR(mj2)**     | 34.3394273265   | 35.1234068571   | 36.1656791837   | 36.572825       | 37.3778500408
| **SSIM(cr + mc)** |  0.976002244898 |  0.977707959184 |  0.978492653061 |  0.979666734694 |  0.979767755102
| **SSIM(mj2)**     |  0.897897142857 |  0.908718367347 |  0.916914897959 |  0.926124081633 |  0.93395122449

| PSNR-SSIM \ Bytes | 11000           | 12000           | 13000           | 14000           | 150000           
| ----------------- | --------------- | --------------- | --------------- | --------------- | ---------------
| **PSNR(cr + mc)** | 42.7549309388   | 43.1220593265   | 43.8178527959   | 43.7274807959   | 44.2633131429
| **PSNR(mj2)**     | 38.1124064286   | 38.5845199796   | 39.0220480408   | 39.6037279184   | 40.2838665918
| **SSIM(cr + mc)** |  0.980734081633 |  0.981108979592 |  0.98203244898  |  0.981871020408 |  0.983047959184
| **SSIM(mj2)**     |  0.936903265306 |  0.942567755102 |  0.947749795918 |  0.952361428571 |  0.954948163265

| PSNR-SSIM \ Bytes | 16000           | 17000           | 18000           | 19000           | 200000           
| ----------------- | --------------- | --------------- | --------------- | --------------- | ---------------
| **PSNR(cr + mc)** | 44.2365712653   | 44.4391850408   | 44.6702920204   | 44.8226579592   | 44.964832449
| **PSNR(mj2)**     | 40.6389352857   | 40.9386543061   | 41.2020153673   | 41.6128808163   | 42.0506404694
| **SSIM(cr + mc)** |  0.983545714286 |  0.983622857143 |  0.984446326531 |  0.984908979592 |  0.985111836735
| **SSIM(mj2)**     |  0.956982040816 |  0.959908367347 |  0.962758163265 |  0.965184693878 |  0.966841428571

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
* Bitrate: 11000 bytes. [gif](gif/all_11000.gif) | [ogv](ogv/all_11000.ogv)
* Bitrate: 12000 bytes. [gif](gif/all_12000.gif) | [ogv](ogv/all_12000.ogv)
* Bitrate: 13000 bytes. [gif](gif/all_13000.gif) | [ogv](ogv/all_13000.ogv)
* Bitrate: 14000 bytes. [gif](gif/all_14000.gif) | [ogv](ogv/all_14000.ogv)
* Bitrate: 15000 bytes. [gif](gif/all_15000.gif) | [ogv](ogv/all_15000.ogv)
* Bitrate: 16000 bytes. [gif](gif/all_16000.gif) | [ogv](ogv/all_16000.ogv)
* Bitrate: 17000 bytes. [gif](gif/all_17000.gif) | [ogv](ogv/all_17000.ogv)
* Bitrate: 18000 bytes. [gif](gif/all_18000.gif) | [ogv](ogv/all_18000.ogv)
* Bitrate: 19000 bytes. [gif](gif/all_19000.gif) | [ogv](ogv/all_19000.ogv)
* Bitrate: 20000 bytes. [gif](gif/all_20000.gif) | [ogv](ogv/all_20000.ogv)