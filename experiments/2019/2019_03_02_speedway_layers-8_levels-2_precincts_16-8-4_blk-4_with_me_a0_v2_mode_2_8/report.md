# Experiment: 2019-03-02 - (16, 8, 4. cblk = 4)

## Image sequence

- *speedway*
- Number of frames: **10**

## Compression parameters used in `kdu_compress`

```
kdu_compress -i 000.pgm -o 000.j2c Cuse_sop=yes Corder=LRCP Clayers=8 Clevels=2 Cprecincts="{16,16},{8,8},{4,4}" Cblk="{4,4}" Creversible=yes
```

```
CLAYERS=8
CLEVELS=2
CPRECINCTS="{16,16},{8,8},{4,4}"
CBLK="{4,4}"
CORDER=LRCP
```

```
Layer 1     Size: 10,558 bytes
Layer 2     Size: 20,877 bytes
Layer 3     Size: 31,214 bytes
Layer 4     Size: 41,667 bytes
Layer 5     Size: 52,262 bytes
Layer 6     Size: 63,069 bytes
Layer 7     Size: 74,181 bytes
Layer 8     Size: 157,188 bytes
```

## Motion estimation parameters

```
X=384
Y=320
B=16    # block size
A=0 	  # subpixel accuracy = sub-pixel accuracy of the motion estimation
D=0     # border size = size of the border of the blocks in the motion estimation process
S=4     # search range = size of the searching area of the motion estimation
V=2     # Overlapping. Para difuminar los bordes de los bloques.
```

## PSNR, SSIM and Transmitted bitrate per frame

![](curves/todo.png)

## Reconstructions

### Bitrate: 1000 bytes

[gif](gif/all_1000.gif) | [ogv](ogv/all_1000.ogv)

![1000 bytes](gif/all_1000.gif)

### Bitrate: 2000 bytes

[gif](gif/all_2000.gif) | [ogv](ogv/all_2000.ogv)

![2000 bytes](gif/all_2000.gif)

### Bitrate: 3000 bytes

[gif](gif/all_3000.gif) | [ogv](ogv/all_3000.ogv)

![3000 bytes](gif/all_3000.gif)

### Bitrate: 4000 bytes

[gif](gif/all_4000.gif) | [ogv](ogv/all_4000.ogv)

![4000 bytes](gif/all_4000.gif)

### Bitrate: 5000 bytes

[gif](gif/all_5000.gif) | [ogv](ogv/all_5000.ogv)

![5000 bytes](gif/all_5000.gif)

### Bitrate: 6000 bytes

[gif](gif/all_6000.gif) | [ogv](ogv/all_6000.ogv)

![6000 bytes](gif/all_6000.gif)

### Bitrate: 7000 bytes

[gif](gif/all_7000.gif) | [ogv](ogv/all_7000.ogv)

![7000 bytes](gif/all_7000.gif)

### Bitrate: 8000 bytes

[gif](gif/all_8000.gif) | [ogv](ogv/all_8000.ogv)

![8000 bytes](gif/all_8000.gif)

### Bitrate: 9000 bytes

[gif](gif/all_9000.gif) | [ogv](ogv/all_9000.ogv)

![9000 bytes](gif/all_9000.gif)

### Bitrate: 10000 bytes

[gif](gif/all_10000.gif) | [ogv](ogv/all_10000.ogv)

![10000 bytes](gif/all_10000.gif)
