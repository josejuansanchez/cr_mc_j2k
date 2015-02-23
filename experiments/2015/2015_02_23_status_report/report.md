Experiment: 2015-02-23
======================

## Evaluación de los modos de `woistocache`

* Mode 0: Los precintos se transmiten como lo hace Kakadu por defecto.
* Mode 1: Se transmiten todas las capas de calidad de cada precinto.
* Mode Auto: Utilizamos nuestro algoritmo `knapsack` para buscar cuántas 
  capas de calidad enviamos para cada precinto.

### Mode 0

* 2015_01_27_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_with_me_mode_0

#### Average
* 11000 bytes
```
  * PSNR(cr + mc):       20.1807981099
  * PSNR(mj2):           13.061662967
  * SSIM(cr + mc):       0.628332527473
  * SSIM(mj2):           0.570969340659
```

* 21000 bytes
```
  * PSNR(cr + mc):       20.1710217033
  * PSNR(mj2):           16.8948524176
  * SSIM(cr + mc):       0.629037252747
  * SSIM(mj2):           0.807484945055
```

* 31000 bytes
```
  * PSNR(cr + mc):       20.3156510659
  * PSNR(mj2):           26.8995961209
  * SSIM(cr + mc):       0.638246813187
  * SSIM(mj2):           0.932562087912
```

* 41000 bytes
```
  * PSNR(cr + mc):       20.910728956
  * PSNR(mj2):           29.8907347253
  * SSIM(cr + mc):       0.682802417582
  * SSIM(mj2):           0.968058351648
```

* 51000 bytes
```
  * PSNR(cr + mc):       20.4145595495
  * PSNR(mj2):           31.6320104286
  * SSIM(cr + mc):       0.655141538462
  * SSIM(mj2):           0.97079
```

---

### Mode 1

* 2015_01_22_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_with_me_mode_1

#### Average
* 11000 bytes
```
  * PSNR(cr + mc):       23.3294398681
  * PSNR(mj2):           13.0596263407
  * SSIM(cr + mc):       0.808326923077
  * SSIM(mj2):           0.570657802198
```

* 21000 bytes
```
  * PSNR(cr + mc):       28.4533728791
  * PSNR(mj2):           17.3761723846
  * SSIM(cr + mc):       0.94003010989
  * SSIM(mj2):           0.818573186813
```

* 31000 bytes
```
  * PSNR(cr + mc):       30.7735468352
  * PSNR(mj2):           27.0167665385
  * SSIM(cr + mc):       0.963058131868
  * SSIM(mj2):           0.934957912088
```

* 41000 bytes
```
  * PSNR(cr + mc):       31.5043746374
  * PSNR(mj2):           30.0717948242
  * SSIM(cr + mc):       0.968264065934
  * SSIM(mj2):           0.968323516484
```

* 51000 bytes
```
  * PSNR(cr + mc):       31.9218378462
  * PSNR(mj2):           31.8785712637
  * SSIM(cr + mc):       0.971164505495
  * SSIM(mj2):           0.971140989011
```

---

### Mode AUTO

* 2015_01_27_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_with_me_mode_auto

#### Average
* 11000 bytes
```
  * PSNR(cr + mc):       23.408077978
  * PSNR(mj2):           13.0496273956
  * SSIM(cr + mc):       0.810807362637
  * SSIM(mj2):           0.569523516484
```

* 21000 bytes
```
  * PSNR(cr + mc):       28.2976046703
  * PSNR(mj2):           17.3508251978
  * SSIM(cr + mc):       0.937851868132
  * SSIM(mj2):           0.817878901099
```

* 31000 bytes
```
  * PSNR(cr + mc):       30.7735468352
  * PSNR(mj2):           27.0167665385
  * SSIM(cr + mc):       0.963058131868
  * SSIM(mj2):           0.934957912088
```

* 41000 bytes
```
  * PSNR(cr + mc):       31.5020725604
  * PSNR(mj2):           30.0675276374
  * SSIM(cr + mc):       0.96825021978
  * SSIM(mj2):           0.968317912088
```

* 51000 bytes
```
  * PSNR(cr + mc):       31.9217731758
  * PSNR(mj2):           31.8785712637
  * SSIM(cr + mc):       0.971164065934
  * SSIM(mj2):           0.971140989011
```

---

## Evaluamos el comportamiento sin estimación de movimiento

### Mode 0

* 2015_01_28_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_no_me_mode_1

#### Average
* 11000 bytes
```
  * PSNR(cr + mc):       21.0404876923
  * PSNR(mj2):           13.0651685165
  * SSIM(cr + mc):       0.657734725275
  * SSIM(mj2):           0.571348351648
```

* 21000 bytes
```
  * PSNR(cr + mc):       23.746198978
  * PSNR(mj2):           17.4173220769
  * SSIM(cr + mc):       0.808666483516
  * SSIM(mj2):           0.819394835165
```

* 31000 bytes
```
  * PSNR(cr + mc):       26.4745043626
  * PSNR(mj2):           27.0339986923
  * SSIM(cr + mc):       0.891442197802
  * SSIM(mj2):           0.935321208791
```

* 41000 bytes
```
  * PSNR(cr + mc):       29.5880607912
  * PSNR(mj2):           30.0754305604
  * SSIM(cr + mc):       0.943594505495
  * SSIM(mj2):           0.96833043956
```

* 51000 bytes
```
  * PSNR(cr + mc):       31.9219146154
  * PSNR(mj2):           31.8784933407
  * SSIM(cr + mc):       0.971153516484
  * SSIM(mj2):           0.971137912088
```

---

### Mode 1

* 2015_01_30_stockholm_layers-8_levels-5_precincts-128-64-32_blk-32_no_me_mode_0/report.md

### Average
* 11000 bytes
```
  * PSNR(cr + mc):       20.7201422778
  * PSNR(mj2):           23.4042310667
  * SSIM(cr + mc):       0.620415
  * SSIM(mj2):           0.788039777778
```

* 21000 bytes
```
  * PSNR(cr + mc):       20.7420413333
  * PSNR(mj2):           25.9801266
  * SSIM(cr + mc):       0.623215555556
  * SSIM(mj2):           0.913481333333
```

* 31000 bytes
```
  * PSNR(cr + mc):       20.7777223778
  * PSNR(mj2):           27.6014002111
  * SSIM(cr + mc):       0.627601333333
  * SSIM(mj2):           0.942152777778
```

* 41000 bytes
```
  * PSNR(cr + mc):       20.7049194778
  * PSNR(mj2):           30.2524051111
  * SSIM(cr + mc):       0.622497333333
  * SSIM(mj2):           0.968010555556
```

* 51000 bytes
```
  * PSNR(cr + mc):       20.7777452
  * PSNR(mj2):           31.9821113333
  * SSIM(cr + mc):       0.628713555556
  * SSIM(mj2):           0.970682555556
```

---

## Evaluamos el parámetro `a` (subpixel accuracy)

### a=1

* 2015_02_16_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_with_me_a_1_mode_auto

#### Average
* 11000 bytes
```
  * PSNR(cr + mc):      23.2753344615
  * PSNR(mj2):          13.0512711099
  * SSIM(cr + mc):      0.788621318681
  * SSIM(mj2):          0.56983956044
```

* 21000 bytes
```
  * PSNR(cr + mc):      29.4149247363
  * PSNR(mj2):          17.4108251099
  * SSIM(cr + mc):      0.951404945055
  * SSIM(mj2):          0.819297582418
```

* 31000 bytes
```
  * PSNR(cr + mc):      31.2719925714
  * PSNR(mj2):          27.0247673407
  * SSIM(cr + mc):      0.967167802198
  * SSIM(mj2):          0.935131428571
```

* 41000 bytes
```
  * PSNR(cr + mc):      31.6829163736
  * PSNR(mj2):          30.0681588571
  * SSIM(cr + mc):      0.969658901099
  * SSIM(mj2):          0.968319450549
```

* 51000 bytes
```
  * PSNR(cr + mc):      31.9321854286
  * PSNR(mj2):          31.8795217473
  * SSIM(cr + mc):      0.971258791209
  * SSIM(mj2):          0.971141538462
```

---

### a=2

* 2015_02_16_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_with_me_a_2_mode_auto

#### Average
* 11000 bytes
```
  * PSNR(cr + mc):      23.1193885934
  * PSNR(mj2):          13.0546890989
  * SSIM(cr + mc):      0.778791208791
  * SSIM(mj2):          0.57033956044
```

* 21000 bytes
```
  * PSNR(cr + mc):      29.360664044
  * PSNR(mj2):          17.3992271978          
  * SSIM(cr + mc):      0.950699120879      
  * SSIM(mj2):          0.819059450549          
```

* 31000 bytes
```
  * PSNR(cr + mc):      31.4223481758   
  * PSNR(mj2):          27.0209734396 
  * SSIM(cr + mc):      0.967954835165
  * SSIM(mj2):          0.935057802198
```

* 41000 bytes
```
  * PSNR(cr + mc):      31.8418766374   
  * PSNR(mj2):          30.0692897033
  * SSIM(cr + mc):      0.970698131868
  * SSIM(mj2):          0.96832043956
```

* 51000 bytes
```
  * PSNR(cr + mc):      31.9766005934
  * PSNR(mj2):          31.8801156484
  * SSIM(cr + mc):      0.971514835165
  * SSIM(mj2):          0.971141538462
```

---

## Evaluamos el uso del parámetro `v`

### a=1, v=2

* 2015_02_17_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_with_me_a_1_v_2_mode_auto

#### Average
* 11000 bytes
```
  * PSNR(cr + mc):      23.2079984066
  * PSNR(mj2):          13.0614295165
  * SSIM(cr + mc):      0.784451428571
  * SSIM(mj2):          0.570829230769
```

* 21000 bytes
```
  * PSNR(cr + mc):      29.8026954725     
  * PSNR(mj2):          17.4211498132
  * SSIM(cr + mc):      0.95509 
  * SSIM(mj2):          0.819554615385
```

* 31000 bytes
```
  * PSNR(cr + mc):      31.2668247582      
  * PSNR(mj2):          27.024445956
  * SSIM(cr + mc):      0.967023296703
  * SSIM(mj2):          0.935117472527
```

* 41000 bytes
```
  * PSNR(cr + mc):      31.657833022      
  * PSNR(mj2):          30.0729656923
  * SSIM(cr + mc):      0.969475824176 
  * SSIM(mj2):          0.968324725275    
```

* 51000 bytes
```
  * PSNR(cr + mc):      31.9321218242
  * PSNR(mj2):          31.8792146154
  * SSIM(cr + mc):      0.971258351648
  * SSIM(mj2):          0.971141208791
```

---

### a=2, v=2

* 2015_02_17_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_with_me_a_2_v_2_mode_auto

#### Average
* 11000 bytes
```
  * PSNR(cr + mc):      23.3650149231
  * PSNR(mj2):          13.041338044
  * SSIM(cr + mc):      0.787991428571
  * SSIM(mj2):          0.568899450549
```

* 21000 bytes
```
  * PSNR(cr + mc):      29.6868541209   
  * PSNR(mj2):          17.3824017033
  * SSIM(cr + mc):      0.953959340659
  * SSIM(mj2):          0.818643406593
```

* 31000 bytes
```
  * PSNR(cr + mc):      31.4322884176   
  * PSNR(mj2):          27.0241441538
  * SSIM(cr + mc):      0.96808989011
  * SSIM(mj2):          0.935102307692
```

* 41000 bytes
```
  * PSNR(cr + mc):      31.8052250989
  * PSNR(mj2):          30.0648868242
  * SSIM(cr + mc):      0.970484615385
  * SSIM(mj2):          0.968305824176
```

* 51000 bytes
```
  * PSNR(cr + mc):      31.9787271648
  * PSNR(mj2):          31.878085033
  * SSIM(cr + mc):      0.971471758242
  * SSIM(mj2):          0.971138791209
```

---

## Evaluación utiliznado tamaños de precintos pequeños

* 2015_02_18_stockholm_layers-8_levels-2_precincts-32-16-8_blk-8_with_me_a_0_v_0_mode_1

#### Average
* 11000 bytes
```
  * PSNR(cr + mc):      23.3650149231
  * PSNR(mj2):          13.041338044
  * SSIM(cr + mc):      0.787991428571
  * SSIM(mj2):          0.568899450549
```