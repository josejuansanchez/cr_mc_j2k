# Conditional Replenishment and Motion Compensation

J.J. Sánchez-Hernández, J.P. García-Ortiz, V. González-Ruiz

_Work in Progress_

## Índice
1. [Algoritmo](algorithm.html)
2. [Tools](tools.html)
3. [JPEG2000 Packet Structure](packets.html)
4. [Formato `.cache`](cacheformat.html)
5. [State of the art](stateoftheart.html)
6. [Changelog](changelog.html)
7. [TODOs](todos.html)
8. [Knapsack Algorithm](knapsack.html)

## Experimentos

* [Directorio](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments)
* [2014_01_17_tree_layers-8_levels-2_precincts-128-64-32_blk-32_me-128-0-0-4-2](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_01_17_tree_layers-8_levels-2_precincts-128-64-32_blk-32_me-128-0-0-4-2/html/report.html)
* [2014_01_20_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_me-128-0-0-4-2](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_01_20_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_me-128-0-0-4-2/html/report.html)
* [2014_01_20_tree_layers-8_levels-2_precincts-128-64-32_blk-32_me-128-0-0-4-2](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_01_20_tree_layers-8_levels-2_precincts-128-64-32_blk-32_me-128-0-0-4-2/html/report.html)
* [2014_01_22_tree_layers-8_levels-2_precincts-128-64-32_blk-32_me-128-0-0-4-2](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_01_22_tree_layers-8_levels-2_precincts-128-64-32_blk-32_me-128-0-0-4-2/html/report.html)
* [2014_01_23_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_me-128-0-0-4-2](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_01_23_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_me-128-0-0-4-2/html/report.html)
* [2014_01_24_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_me-128-0-0-4-2](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_01_24_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_me-128-0-0-4-2/html/report.html)
* [2014_02_03_stockholm_layers-8_levels-3_precincts-128-64-32-32_blk-32_me-128-0-0-4-2](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_02_03_stockholm_layers-8_levels-3_precincts-128-64-32-32_blk-32_me-128-0-0-4-2/html/report.html)
* [2014_02_04_stockholm_layers-8_levels-4_precincts-128-64-32-32-32_blk-32_me-128-0-0-4-2](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_02_04_stockholm_layers-8_levels-4_precincts-128-64-32-32-32_blk-32_me-128-0-0-4-2/html/report.html)
* [2014_02_05_bigbuckbunny_layers-8_levels-2_precincts-128-64-32_blk-32_me-128-0-0-4-2](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_02_05_bigbuckbunny_layers-8_levels-2_precincts-128-64-32_blk-32_me-128-0-0-4-2/html/report.html)
* [2014_02_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_without_me](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_02_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_without_me/html/report.html)
* [2014_02_13_stockholm_layers-8_levels-5_precincts-128-64-32-16_blk-32_without_me](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_02_13_stockholm_layers-8_levels-5_precincts-128-64-32-16_blk-32_without_me/html/report.html)
* [2014_04_09_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_without_me](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_04_09_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_without_me/html/report.html)
* [2014_04_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-8_without_me](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_04_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-8_without_me/html/report.html)
* [2014_04_23_stockholm_layers-8_levels-2_precincts-128-64-32_blk-8_without_me](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_04_23_stockholm_layers-8_levels-2_precincts-128-64-32_blk-8_without_me/html/report.html)
* [2014_04_23_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_without_me](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_04_23_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_without_me/html/report.html)
* [2014_04_23_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_without_me](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_04_23_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_without_me/html/report.html)
* [2014_04_25_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_with_me](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_04_25_stockholm_layers-8_levels-2_precincts-128-64-32_blk-32_with_me/html/report.html)
* [2014_04_28_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_04_28_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me/html/report.html)
* [2014_04_28_stockholm_layers-8_levels-2_precincts-128-64-32_blk-8_with_me](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_04_28_stockholm_layers-8_levels-2_precincts-128-64-32_blk-8_with_me/html/report.html)

### Estudio del comportamiento de `knapsack`
* [2014_06_05_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_1](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_06_05_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_1/html/report.html)
* [2014_06_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_2_1](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_06_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_2_1/html/report.html)
* [2014_06_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_2_2](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_06_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_2_2/html/report.html)
* [2014_06_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_2_3](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_06_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_2_3/html/report.html)
* [2014_06_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_2_4](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_06_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_2_4/html/report.html)
* [2014_06_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_2_5](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_06_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_2_5/html/report.html)
* [2014_06_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_2_6](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_06_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_2_6/html/report.html)
* [2014_06_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_2_7](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_06_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_2_7/html/report.html)
* [2014_06_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_2_8](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_06_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_2_8/html/report.html)
* [2014_06_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_auto](http://www.hpca.ual.es/~jjsanchez/cr_mc/experiments/2014_06_10_stockholm_layers-8_levels-2_precincts-128-64-32_blk-16_with_me_mode_auto/html/report.html)