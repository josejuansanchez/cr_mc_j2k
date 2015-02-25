# -*- coding: iso-8859-15 -*-

# Calcula el tamaño del GOP en función del número de niveles
# temporales.

class GOP:

    def get_size(self, temporal_levels):
        return 2**(temporal_levels - 1)
