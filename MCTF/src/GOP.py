# -*- coding: iso-8859-15 -*-

# Calcula el tama�o del GOP en funci�n del n�mero de niveles
# temporales.

class GOP:

    def get_size(self, temporal_levels):
        return 2**(temporal_levels - 1)
