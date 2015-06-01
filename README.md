cr_mc_j2k
=========

Conditional Replenishment and Motion Compensation based on JPEG2000.

**This is a work in progress.**

### Compiling instructions

#### 0) Include the Kakadu SDK in the project

[Kakadu SDK][1] is needed in order to compile some tools used in this project.

[KaKadu SDK][1] has to be located in the next directory:

```
cr_mc_j2k/src/Kakadu
```

#### 1) Compile Kakadu

Example of how to compile [Kakadu][1] (version: v6_4_1-00305L) on Linux:

```bash
$ cr_mc_j2k/src/Kakadu/v6_4_1-00305L/make/make -f Makefile-Linux-x86-64-gcc
```

#### 2) Set the global variable **CR_MC_J2K_HOME**

```bash
$ export CR_MC_J2K_HOME=/home/josejuan/cr_mc_j2k
```

#### 3) Compile all the tools of the project

You can compile all the tools of the project using the **Makefile** located in
the directory `$CR_MC_J2K_HOME/make/`.

```bash
$ cd $CR_MC_J2K_HOME/make/
$ make
```

### How to use

#### 0) Add the directory with the source images 

The source images (e.g. PGM) have to be located in the next directory:

```
$CR_MC_J2K_HOME/data/sequences
```

In the directory `cr_mc_j2k/data/scripts` there are some scripts that can be
useful in order to process the source images and prepare them for the
experiments.

The compressed JPEG2000 images (J2C) have to be located in the directory:

```
$CR_MC_J2K_HOME/data/j2c_and_thumbnails
```

#### 1) Create a config file for the sequence

Create a configuration file that includes all the parameters for running
scripts and store it in the directory:

```
$CR_MC_J2K_HOME/config/sequences
```

Once you have created the file you have to update the
`$CR_MC_J2K_HOME/config/cr_mc_config.sh` file to specify which configuration
file have to be used.

#### 2) Create the Kanpsack files (JSON)

Example of how to create the Knapsack files for a sequence of images composed
by 900 frames (from frame 1 until frame 900):

```bash
$ $CR_MC_J2K_HOME/knapsack/tools/create_all_kanpsack_files$ ./create_all_knapsack_files.sh 1 900
```

Note that you don't have to start in the frame 1, you can specify the number
of the first frame where you can to start.

#### 3) Create temporary directories
```bash
$ $CR_MC_J2K_HOME/scripts$ ./create_temp_directories.sh 
```

#### 4) Run the scripts!

Use the scripts located in the `$CR_MC_J2K_HOME/scripts` to perform a simulation. 

```bash
$ $CR_MC_J2K_HOME/scripts$ ./sequential.sh 1 900 5000
```

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/4.0/80x15.png" /></a><br />This work by <a xmlns:cc="http://creativecommons.org/ns#" href="http://josejuansanchez.org" property="cc:attributionName" rel="cc:attributionURL">José Juan Sánchez Hernández</a>, <a xmlns:cc="http://creativecommons.org/ns#" href="http://www.hpca.ual.es/~jportiz/" property="cc:attributionName" rel="cc:attributionURL">Juan Pablo García Ortiz</a> and <a xmlns:cc="http://creativecommons.org/ns#" href="http://www.ual.es/~vruiz" property="cc:attributionName" rel="cc:attributionURL">Vicente González Ruiz</a>
  is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.

[1]: http://kakadusoftware.com