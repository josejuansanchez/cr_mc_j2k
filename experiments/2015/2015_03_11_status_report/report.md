## `LRCP` vs `RLCP`

A nuestro algoritmo no le importa si las imágenes se han comprimido siguiendo
una progresión `LRCP` o `RLCP`, porque la utilidad `woistocache` es la que se
encarga de ir seleccionando los paquetes de la forma más óptima.

Obivamente cuando realizamos el truncado de las imágenes a un determinado
bitrate vamos a obtener valores diferentes para los dos tipos de progresión.
Esto es lo que ocurre en los resultados de los experimentos cuando comparamos
nuestro algoritmo con una posible transmisión de una secuencia `mj2`.

Estos dos experimentos realizan una comparación del comportamiento de nuestro
algoritmo utilizando una progresión `LRCP` o `RLCP`.

* [LRCP](https://github.com/josejuansanchez/cr_mc_j2k/blob/master/experiments/2015/2015_03_05_speedway_layers-8_levels-2_precincts_64-32-16_blk-16_no_me_mode_2)
* [RLCP](https://github.com/josejuansanchez/cr_mc_j2k/blob/master/experiments/2015/2015_03_11_speedway_layers-8_levels-2_precincts_64-32-16_blk-16_no_me_mode_3_rlcp)

### Observaciones:
* Parece que `RLCP` ofrece mejores resultados en los rangos de [1000 - 15000] bytes.
* También hay que observar el cambio que se produce en tamaño de las capas.
```
    Layer size (in bytes):
    Resolution level: 0 (RLCP)
    Layer: 1     Size: 23,292
    Layer: 2     Size: 24,170
    Layer: 3     Size: 25,490
    Layer: 4     Size: 27,373
    Layer: 5     Size: 30,387
    Layer: 6     Size: 34,313
    Layer: 7     Size: 42,533
    Layer: 8     Size: 61,461

    --------------------------

    Resolution level: 0 (LRCP)
    Layer: 1     Size: 5,354
    Layer: 2     Size: 7,830
    Layer: 3     Size: 11,050
    Layer: 4     Size: 15,336
    Layer: 5     Size: 21,136
    Layer: 6     Size: 29,117
    Layer: 7     Size: 40,119
    Layer: 8     Size: 61,655
```

---

## `woistocache`: Mode 2 vs Mode Auto

Actualmente el **Mode Auto** puede producir resultados que no son los más
óptimos, porque en la implementación actual tiende a traer nuevos precintos
pero éstos pueden contener pocas capas de calidad. Esto puede que no sea lo
más interesante en situaciones donde sería mucho mejor reutilizar precintos
de la imagen actual (que pueden contener hasta todas las capas de calidad), en
lugar de traer muchos precintos de la siguiente imagen pero con muy pocas de
calidad.

*TODO: Incluir una imagen o un vídeo que muestre lo que ocurre en cada caso.*

### `knapsack`

```
The best solution is the method: 2 with: 4 quality layer with a profit of: 1851.821281
 ** NOTE: The number of the quality layer is zero based **
{"solution":
    {"method": 2,
    "ql": 5,
    "max_profit": 1851.821281},
"method_1": 
    {"sum_bytes": 9947, "sum_profit": 1851.821281},
"method_2": [
    {"ql": 1, "sum_bytes": 674, "sum_profit": 317.340410},
    {"ql": 2, "sum_bytes": 2012, "sum_profit": 662.353508},
    {"ql": 3, "sum_bytes": 4008, "sum_profit": 1025.782469},
    {"ql": 4, "sum_bytes": 6692, "sum_profit": 1431.338709},
    {"ql": 5, "sum_bytes": 9947, "sum_profit": 1851.821281},
    {"ql": 6, "sum_bytes": 9916, "sum_profit": 1514.134473},
    {"ql": 7, "sum_bytes": 9957, "sum_profit": 1368.563311},
    {"ql": 8, "sum_bytes": 9992, "sum_profit": 1287.596368},
    {"ql": 9, "sum_bytes": 9857, "sum_profit": 1221.732988},
    {"ql": 10, "sum_bytes": 9781, "sum_profit": 1186.806616},
    {"ql": 11, "sum_bytes": 9884, "sum_profit": 1174.876432},
    {"ql": 12, "sum_bytes": 9959, "sum_profit": 1149.859706},
    {"ql": 13, "sum_bytes": 9881, "sum_profit": 1111.906358},
    {"ql": 14, "sum_bytes": 9776, "sum_profit": 1052.156283},
    {"ql": 15, "sum_bytes": 9990, "sum_profit": 961.119667},
    {"ql": 16, "sum_bytes": 9892, "sum_profit": 829.970344},
    {"ql": 17, "sum_bytes": 9439, "sum_profit": 618.596283},
    {"ql": 18, "sum_bytes": 9616, "sum_profit": 596.868432},
    {"ql": 19, "sum_bytes": 9843, "sum_profit": 528.806092},
    {"ql": 20, "sum_bytes": 8559, "sum_profit": 378.517158}]
}
```

### `differencesthumbnails`

```
Precint:     0. CountDiff: 7.449219 OffsetX:   80. OffsetY:   48
Precint:     1. CountDiff: 6.460938 OffsetX:   64. OffsetY:   48
Precint:     2. CountDiff: 0.636719 OffsetX:   64. OffsetY:   32
Precint:     3. CountDiff: 0.421875 OffsetX:    0. OffsetY:   48
Precint:     4. CountDiff: 0.410156 OffsetX:   48. OffsetY:   32
Precint:     5. CountDiff: 0.406250 OffsetX:   48. OffsetY:   16
Precint:     6. CountDiff: 0.402344 OffsetX:   16. OffsetY:   32
Precint:     7. CountDiff: 0.378906 OffsetX:   16. OffsetY:   48
Precint:     8. CountDiff: 0.367188 OffsetX:   64. OffsetY:    0
Precint:     9. CountDiff: 0.363281 OffsetX:   32. OffsetY:   32
Precint:    10. CountDiff: 0.359375 OffsetX:   32. OffsetY:    0
Precint:    11. CountDiff: 0.347656 OffsetX:   32. OffsetY:   16
Precint:    12. CountDiff: 0.339844 OffsetX:   48. OffsetY:    0
Precint:    13. CountDiff: 0.339844 OffsetX:   32. OffsetY:   48
Precint:    14. CountDiff: 0.339844 OffsetX:   48. OffsetY:   48
Precint:    15. CountDiff: 0.300781 OffsetX:   80. OffsetY:   32
Precint:    16. CountDiff: 0.285156 OffsetX:   16. OffsetY:   16
Precint:    17. CountDiff: 0.281250 OffsetX:   48. OffsetY:   64
Precint:    18. CountDiff: 0.277344 OffsetX:   64. OffsetY:   64
Precint:    19. CountDiff: 0.257812 OffsetX:   32. OffsetY:   64
Precint:    20. CountDiff: 0.257812 OffsetX:   80. OffsetY:   64
Precint:    21. CountDiff: 0.230469 OffsetX:   64. OffsetY:   16
Precint:    22. CountDiff: 0.226562 OffsetX:   16. OffsetY:   64
Precint:    23. CountDiff: 0.222656 OffsetX:   80. OffsetY:    0
Precint:    24. CountDiff: 0.210938 OffsetX:   16. OffsetY:    0
Precint:    25. CountDiff: 0.207031 OffsetX:    0. OffsetY:   32
Precint:    26. CountDiff: 0.183594 OffsetX:    0. OffsetY:   64
Precint:    27. CountDiff: 0.132812 OffsetX:   80. OffsetY:   16
Precint:    28. CountDiff: 0.109375 OffsetX:    0. OffsetY:   16
Precint:    29. CountDiff: 0.105469 OffsetX:    0. OffsetY:    0
```