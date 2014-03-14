#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# info.py

import sys
import getopt
import os
from GOP import GOP
import display

class info(GOP):

    pictures = 33
    pictures_per_second = 30
    temporal_levels = 6

    def usage(self):
        print
        print "  Description:"
        print
        print "    Show the Kbps/GOP."
        print
        print "  Parameters:"
        print
        print "   -[-p]ictures=number of images to process (", self.pictures, ")"
        print "   -[-]p[i]ctures_per_second=frame rate (", self.pictures_per_second, ")"
        print "   -[-t]emporal_levels=number of iterations of the temporal transform + 1 (", self.temporal_levels, ")"
        print

    def open_codestream(self, codestream_namefile):
        pass

    def find_next_EOC_motion(self, file):
        pass

    def find_next_EOC_texture(self, file):
        pass

    def __init__(self):

        display.info(str(sys.argv[0:]) + '\n')

        try:
            opts, extraparams = getopt.getopt(sys.argv[1:],"p:t:i:h",
                                              ["pictures=",
                                               "temporal_levels=",
                                               "pictures_per_second=",
                                               "help"
                                               ])
        except getopt.GetoptError, exc:
            sys.stderr.write(sys.argv[0] + ": " + exc.msg + "\n")
            sys.exit(2)

        for o, a in opts:

            if o in ("-p","--pictures"):
                self.pictures = int(a)
                display.info(sys.argv[0] + ": pictures=" + str(self.pictures) + "\n")

            if o in ("-t", "--temporal_levels"):
                self.temporal_levels = int(a)
                display.info(sys.argv[0] + ": temporal_levels=" + str(self.temporal_levels) + "\n")

            if o in ("-i","--pictures_per_second"):
                self.pictures_per_second = float(a)
                display.info(sys.argv[0] + ": pictures_per_second=" + str(self.pictures_per_second) + "\n")

            if o in ("-h", "--help"):
                self.usage()
                sys.exit()

        GOP_size = GOP.get_size(self,self.temporal_levels)
        number_of_GOPs = self.pictures / GOP_size
        GOP_time = float(GOP_size) / self.pictures_per_second

        sys.stdout.write(sys.argv[0] + ": temporal_levels=" + str(self.temporal_levels) + "\n")
        sys.stdout.write(sys.argv[0] + ": pictures=" + str(self.pictures) + "\n")
        sys.stdout.write(sys.argv[0] + ": pictures_per_second=" + str(self.pictures_per_second) + "\n")
        sys.stdout.write(sys.argv[0] + ": GOP_size=" + str(GOP_size) + "\n")
        sys.stdout.write(sys.argv[0] + ": number_of_GOPs=" + str(number_of_GOPs) + "\n")
        sys.stdout.write(sys.argv[0] + ": GOP_time=" + str(GOP_time) + "\n")
        sys.stdout.write(sys.argv[0] + ": All the values are given in thousands of bits per second (Kbps).\n")

        # Primera línea (    TRL4 TRL3 TRL2 TRL1 TRL0)
        sys.stdout.write("\n     ");
        sys.stdout.write("    TRL" + str(self.temporal_levels-1))
        i = self.temporal_levels - 1
        while i>0:
            sys.stdout.write("           ")
            j = 0;
            while j<(2**(self.temporal_levels - 1 - i)):
                sys.stdout.write(" ")
                j += 1
            sys.stdout.write("TRL" + str(i-1))
            i -= 1
        sys.stdout.write("\n")

        # Segunda línea (GOP low_4 motion_4+high_4 motion_3+hight_3 motion_2+high2 motion_1+high_1 Total)
        sys.stdout.write("GOP#")
        sys.stdout.write("    low_" +  str(self.temporal_levels-1))

        i = self.temporal_levels - 1
        while i>0:
            j = 0;
            while j<(2**(self.temporal_levels - 1 - i)):
                sys.stdout.write(" ")
                j += 1
            sys.stdout.write("motion_" + str(i) + " high_" + str(i))
            i -= 1
        sys.stdout.write("    Total\n")

        # Tercera línea (-------- -------- ....)
        i = self.temporal_levels - 1
        sys.stdout.write("---- ")
        sys.stdout.write("-------- ")
        while i>0:
            j = 0;
            while j<(2**(self.temporal_levels - 1 - i)):
                sys.stdout.write("-")
                j += 1
            sys.stdout.write("-------------- ")
            i -= 1
        sys.stdout.write("--------\n")

        # Vamos a ir presentando el bit-rate de cada subband de cada
        # GOP. Por tanto, vamos a necesitar un vector de enteros que
        # almacen, para cada subbanda, el bit-rate del GOP
        # anterior. El bit-rate del GOP actual, para cada subbanda se
        # va a calcular restando el valor para el GOP anterior menos
        # el valor actual (recuérdese que los ficheros con los
        # code-stream se recorren secuencialmente y hay un fichero
        # para cada subbanda).
        M_prev_found = []
        H_prev_found = []
        subband = 0
        while subband <= self.temporal_levels:
            M_prev_found.append(int())
            H_prev_found.append(int())
            subband += 1

        # Inicializamos estos vectores.
        subband = 1
        while subband < self.temporal_levels:
            M_prev_found[subband] = 0
            H_prev_found[subband] = 0
            subband += 1

        # Creamos un entero para cada subband, con las medias.
        average_M = []
        average_H = []
        subband = 0
        while subband <= self.temporal_levels:
            average_M.append(int())
            average_H.append(int())
            subband += 1

        # Inicializamos las medias.
        average_L = 0
        subband = 1
        while subband <= self.temporal_levels:
            average_M[subband] = 0
            average_H[subband] = 0
            subband += 1
        average_total = 0

        # Abrimos los ficheros con las subbandas temporales y los
        # campos de movimiento.
        #L_file = open("low_" + str(self.temporal_levels - 1) + ".mjc", 'rb')
        L_file = self.open_codestream("low_" + str(self.temporal_levels - 1))
        H_file = []
        M_file = []
        T_file = []
        H_file.append(int())
        M_file.append(int())
        T_file.append(int())
        subband = 1
        while subband < self.temporal_levels:
            #H_file.append(open("high_" + str(subband) + ".mjc", 'rb'))
            H_file.append(self.open_codestream("high_" + str(subband)))
            M_file.append(open("motion_residue_" + str(subband) + ".mjc", 'rb'))
            T_file.append(open("frame_types_" + str(subband)))
            subband += 1

        # Comenzamos a calcular bit-rates ...

        # El primer GOP está formado por la primera imagen de
        # low_<temporal_levels-1>.
        sys.stdout.write("0000 ")
        L_prev_found = L_bytes = self.find_next_EOC_texture(L_file)
        L_kbps = float(L_bytes) * 8 / GOP_time / 1000.0
        total = L_kbps
        #average_L = L_kbps
        sys.stdout.write("%8d " % L_kbps)
        subband = self.temporal_levels - 1
        while subband > 0:
            j = 0;
            while j<(2**(self.temporal_levels - 1 - subband)):
                sys.stdout.write("-")
                j += 1
            sys.stdout.write("%7d " % 0)
            sys.stdout.write("%6d " % 0)
            subband -= 1
        sys.stdout.write("%8d\n" % total)
        #average_total += total

        # El resto de GOPs está formado por un determinado número de subbandas.
        GOP_number = 1
        while GOP_number <= number_of_GOPs:

            pics_in_GOP = 1

            # Número de GOP
            str_GOP_number = '%04d' % GOP_number
            sys.stdout.write("%3s " % str_GOP_number)

            # Total Kbps
            total = 0

            # Subbanda L (cada nueva imagen supone un nuevo GOP).
            x = self.find_next_EOC_texture(L_file)
            L_bytes = x - L_prev_found
            L_prev_found = x
            L_kbps = float(L_bytes) * 8 / GOP_time / 1000.0
            total += L_kbps
            average_L += L_kbps
            sys.stdout.write("%8d " % int(L_kbps))

            # Subbandas H (dependiendo del nivel de resolución
            # temporal, cada GOP genera un número de imágenes
            # diferente).
            subband = self.temporal_levels - 1
            while subband > 0:

                i = 1
                sys.stdout.write("%s" % T_file[subband].read(1))
                while i < pics_in_GOP:
                    sys.stdout.write("%s" % T_file[subband].read(1))
                    i += 1

                i = 1
                while i < pics_in_GOP:
                    self.find_next_EOC_motion(M_file[subband])
                    i += 1        
                x = self.find_next_EOC_motion(M_file[subband])
                M_bytes = x - M_prev_found[subband]
                M_prev_found[subband] = x
                M_kbps = float(M_bytes) * 8 / GOP_time / 1000.0
                total += M_kbps
                average_M[subband] += M_kbps
                sys.stdout.write("%7d " % int(M_kbps))

                i = 1
                while i < pics_in_GOP:
                    self.find_next_EOC_texture(H_file[subband])
                    i += 1
                x = self.find_next_EOC_texture(H_file[subband])
                H_bytes = x - H_prev_found[subband]
                H_prev_found[subband] = x
                H_kbps = float(H_bytes) * 8 / GOP_time / 1000.0
                total += H_kbps
                average_H[subband] += H_kbps
                sys.stdout.write("%6d " % int(H_kbps))

                subband -= 1
                pics_in_GOP *= 2

            sys.stdout.write("%8d\n" % total)
            average_total += total

            GOP_number += 1

        # Imprimimos las medias
        subband = self.temporal_levels - 1
        sys.stdout.write("---- ")
        sys.stdout.write("-------- ")
        while subband>0:
            j = 0;
            while j<(2**(self.temporal_levels - 1 - subband)):
                sys.stdout.write("-")
                j += 1
            sys.stdout.write("-------------- ")
            subband -= 1
        sys.stdout.write("--------\n")

        subband = self.temporal_levels - 1
        sys.stdout.write("Average")
        sys.stdout.write("%6d " % int(average_L/number_of_GOPs))
        while subband>0:
            j = 0;
            while j<(2**(self.temporal_levels - 1 - subband)):
                sys.stdout.write(" ")
                j += 1
            sys.stdout.write("%7d " % int(average_M[subband]/number_of_GOPs))
            sys.stdout.write("%6d " % int(average_H[subband]/number_of_GOPs))
            subband -= 1
        sys.stdout.write("%8d\n" % int(average_total/number_of_GOPs))

        sys.stdout.write("\nTotal average: " + str(average_total/number_of_GOPs) + " Kbps (notice that the first GOP is not included)\n")

#if(os.environ["MCTF_TEXTURE_CODEC"]=="j2k"):
#    os.system("python " + os.environ["MCTF"] + "/bin/info_j2k.py " + '')
#elif(os.environ["MCTF_TEXTURE_CODEC"]=="jpg"):
#    os.system("python info_jpg.py " + '')
    
