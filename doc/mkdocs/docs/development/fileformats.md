## Formato .cache

Estamos utilizando un formato interno para trabajar con los
precintos/paquetes del codestream.

La estructura de los paquetes que se almacenan en los archivos
**.cache** es la siguiente:

    --------------------------------------------------------------------
    | precinct id (4 bytes) | l (4 bytes)  | r (4 bytes) | c (4 bytes) |
    --------------------------------------------------------------------
    | py (4 bytes)          | px (4 bytes) | packet length (4 bytes)   | 
    --------------------------------------------------------------------
    | packet                                                           |
    --------------------------------------------------------------------

## Format .lrcp

TODO


## Format .sort

TODO


## Format .woi

TODO