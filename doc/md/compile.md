# Compiling instructions

## Step 0. Add images and Kakadu source code:

* Add the folder with the images in: 

```
cr_mc_j2k/data
```

* Add KaKadu software in:

```
cr_mc_j2k/src/Kakadu
```

## Step 1. Compile Kakadu

Example on Linux:

```
cr_mc_j2k/src/Kakadu/v6_4_1-00305L/make/make -f Makefile-Linux-x86-64-gcc
```

## Step 2. Compile all the tools

```
cr_mc_j2k/make/make
```