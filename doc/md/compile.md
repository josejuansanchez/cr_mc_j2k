# Compiling instructions

## Step 0. Include the Kakadu SDK in the project

[Kakadu SDK](http://kakadusoftware.com) is needed in order to compile
some tools used in this project.

KaKadu SDK has to be located in the next directory:

```
cr_mc_j2k/src/Kakadu
```

## Step 1. Compile Kakadu

Example on Linux (Kakadu version: v6_4_1-00305L):

```
cr_mc_j2k/src/Kakadu/v6_4_1-00305L/make/make -f Makefile-Linux-x86-64-gcc
```

## Step 2. Set the global variable *CR_MC_J2K_HOME*

```
export CR_MC_J2K_HOME=/home/josejuan/cr_mc_j2k
```

## Step 3. Compile all the tools of the project

```
cr_mc_j2k/make/make
```


# How to use

## Step 0. Add the folder with the images: 

The images have to be located in the next directory:

```
cr_mc_j2k/data
```

## Step 1. Create the Kanpsack files (JSON):

Example of how to create the Knapsack files for a sequence of images composed
by 900 frames (from frame 1 until frame 900):

```
cr_mc_j2k/knapsack/tools/create_all_kanpsack_files$ ./create_all_knapsack_files.sh 1 900
```

Note that you don't have to start in the frame 1, you can specify the number
of the first frame where you can to start.

## Step 2. Create temporary directories
```
/cr_mc_j2k/scripts$ ./create_temp_directories.sh 
```

## Step 3. Execute the scripts

```
/cr_mc_j2k/scripts$ ./cr_mc.sh 1 900 5000
```