# Experiment: 2019-03-07 - (64, 64, 64, 64, 64. cblk = 4)

## Image sequence

- *speedway*
- Number of frames: **50**

## Compression parameters used in `kdu_compress`

```
kdu_compress -i /vagrant/data/sequences/speedway_384x320/001.pgm -o /vagrant/data/j2c_and_thumbnails/001.j2c Cuse_sop=yes Corder=LRCP Clayers=8 Clevels=4 'Cprecincts={64,64},{64,64},{64,64},{64,64},{64,64}' 'Cblk={16,16}' Creversible=yes
```

```
CLAYERS=8
CLEVELS=4
CPRECINCTS="{64,64},{64,64},{64,64},{64,64},{64,64}"
CBLK="{16,16}"
CORDER=LRCP
```

```
Layer 1     Size: 4,948 bytes
Layer 2     Size: 7,141 bytes
Layer 3     Size: 10,096 bytes
Layer 4     Size: 14,171 bytes
Layer 5     Size: 19,719 bytes
Layer 6     Size: 27,503 bytes
Layer 7     Size: 38,479 bytes
Layer 8     Size: 58,041 bytes
```

## Motion estimation parameters

**Warning:** The block size (`B`) should be `64`, but the experiment has been carried out with a value of `16` by mistake.

```
X=384
Y=320

B=16    # block size  <--- Warning!!

A=0 	# subpixel accuracy = sub-pixel accuracy of the motion estimation
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