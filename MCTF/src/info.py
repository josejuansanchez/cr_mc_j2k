#!/usr/bin/python
# -*- coding: iso-8859-15 -*-

# info.py

import os
import sys
import getopt
import display
import math
from GOP import GOP

class info(GOP):

    GOPs = 1
    pictures_per_second = 30
    TRLs = 5
    output_choice = 0 # rate_per_GOP

    def usage(self):
        print
        print "  Description:"
        print
        print "    Show the Kbps/GOP."
        print
        print "  Parameters:"
        print
        print "   { -[-]rate_per_i[m]age | -[-]rate_per_G[O]P }"
        print "   -[-G]OPs=number of GOPs to process (", self.GOPs, ")"
        print "   -[-]p[i]ctures_per_second=frame rate (", self.pictures_per_second, ")"
        print "   -[-t]emporal_levels=number of iterations of the temporal transform + 1 (", self.TRLs, ")"
        print

    def open_codestream(self, codestream_namefile):
        pass

    def find_next_EOC_motion(self, file):
        pass

    def find_next_EOC_texture(self, file):
        pass

    def __init__(self):

        try:
            opts, extraparams = getopt.getopt(sys.argv[1:],"mOG:T:i:h",
                                              ["rate_per_image",
                                               "rate_per_GOP",
                                               "GOPs=",
                                               "TRLs=",
                                               "pictures_per_second=",
                                               "help"
                                               ])
        except getopt.GetoptError, exc:
            display.warning(sys.argv[0] + ": " + exc.msg + "\n")

        for o, a in opts:
            if o in ("-m", "--rate_per_image"):
                self.output_choice = 1
            elif o in ("-G","--GOPs"):
                self.GOPs = int(a)
            elif o in ("-t", "--TRLs"):
                self.TRLs = int(a)
            elif o in ("-i","--pictures_per_second"):
                self.pictures_per_second = float(a)
            elif o in ("-h", "--help"):
                self.usage()
                sys.exit()
            else:
                assert False, "Unhandled option!"

        GOP_size = GOP.get_size(self,self.TRLs)
        #number_of_GOPs = int(math.ceil((self.pictures * 1.0)/ GOP_size))
        pictures = GOP_size*self.GOPs + 1
        GOP_time = float(GOP_size) / self.pictures_per_second

        if self.output_choice == 0:
            sys.stdout.write(sys.argv[0] + ": TRLs = " + str(self.TRLs) + "\n")
            sys.stdout.write(sys.argv[0] + ": pictures = " + str(pictures) + "\n")
            sys.stdout.write(sys.argv[0] + ": pictures per second = " + str(self.pictures_per_second) + "\n")
            sys.stdout.write(sys.argv[0] + ": GOP size = " + str(GOP_size) + "\n")
            sys.stdout.write(sys.argv[0] + ": number of GOPs = " + str(self.GOPs) + "\n")
            sys.stdout.write(sys.argv[0] + ": GOP time = " + str(GOP_time) + "\n")
            sys.stdout.write(sys.argv[0] + ": All the values are given in thousands of bits per second (Kbps).\n")

            # Primera línea (    TRL4 TRL3 TRL2 TRL1 TRL0)
            sys.stdout.write("\n     ");
            sys.stdout.write("    TRL" + str(self.TRLs-1))
            i = self.TRLs - 1
            while i>0:
                sys.stdout.write("           ")
                j = 0;
                while j<(2**(self.TRLs - 1 - i)):
                    sys.stdout.write(" ")
                    j += 1
                sys.stdout.write("TRL" + str(i-1))
                i -= 1
            sys.stdout.write("\n")

            # Segunda línea (GOP low_4 motion_4+high_4 motion_3+hight_3 motion_2+high2 motion_1+high_1 Total)
            sys.stdout.write("GOP#")
            sys.stdout.write("    low_" +  str(self.TRLs-1))

            i = self.TRLs - 1
            while i>0:
                j = 0;
                while j<(2**(self.TRLs - 1 - i)):
                    sys.stdout.write(" ")
                    j += 1
                sys.stdout.write("motion_" + str(i) + " high_" + str(i))
                i -= 1
            sys.stdout.write("    Total\n")

            # Tercera línea (-------- -------- ....)
            i = self.TRLs - 1
            sys.stdout.write("---- ")
            sys.stdout.write("-------- ")
            while i>0:
                j = 0;
                while j<(2**(self.TRLs - 1 - i)):
                    sys.stdout.write("-")
                    j += 1
                sys.stdout.write("-------------- ")
                i -= 1
            sys.stdout.write("--------\n")

        # Vamos a ir presentando el bit-rate de cada subband de cada
        # GOP. Por tanto, vamos a necesitar un vector de enteros que
        # almacene, para cada subbanda, el bit-rate del GOP
        # anterior. El bit-rate del GOP actual, para cada subbanda se
        # va a calcular restando el valor para el GOP anterior menos
        # el valor actual (recuérdese que los ficheros con los
        # code-streams se recorren secuencialmente y hay un fichero
        # para cada subbanda).
        M_prev_GOP = []
        H_prev_GOP = []
        M_prev_image = []
        H_prev_image = []
        subband = 0
        while subband <= self.TRLs:
            M_prev_GOP.append(int())
            H_prev_GOP.append(int())
            M_prev_image.append(int())
            H_prev_image.append(int())
            subband += 1

        # Inicializamos estos vectores.
        subband = 1
        while subband < self.TRLs:
            M_prev_GOP[subband] = 0
            H_prev_GOP[subband] = 0
            M_prev_image[subband] = 0
            H_prev_image[subband] = 0
            subband += 1

        # Creamos un entero para cada subband, con las medias.
        average_M = []
        average_H = []
        subband = 0
        while subband <= self.TRLs:
            average_M.append(int())
            average_H.append(int())
            subband += 1

        # Inicializamos las medias.
        average_L = 0
        subband = 1
        while subband <= self.TRLs:
            average_M[subband] = 0
            average_H[subband] = 0
            subband += 1
        average_total = 0

        # Abrimos los ficheros con las subbandas temporales y los
        # campos de movimiento.
        #L_file = open("low_" + str(self.TRLs - 1) + ".mjc", 'rb')
        L_file = self.open_codestream("low_" + str(self.TRLs - 1))
        H_file = []
        M_file = []
        T_file = []
        H_file.append(int())
        M_file.append(int())
        T_file.append(int())
        subband = 1
        while subband < self.TRLs:
            #H_file.append(open("high_" + str(subband) + ".mjc", 'rb'))
            H_file.append(self.open_codestream("high_" + str(subband)))
            M_file.append(open("motion_residue_" + str(subband) + ".mjc", 'rb'))
            T_file.append(open("frame_types_" + str(subband)))
            subband += 1

        # Comenzamos a calcular bit-rates ...

        # El primer GOP está formado por la primera imagen de
        # low_<TRLs-1>.
        if self.output_choice == 0:
            sys.stdout.write("0000 ")
        L_prev_GOP = L_bytes = self.find_next_EOC_texture(L_file)
        if self.output_choice == 1:
            print "GOP 0000", "L", self.TRLs-1, L_prev_GOP ##
        #L_kbps = float(L_bytes) * 8 / GOP_time / 1000.0
        L_kbps = float(L_bytes) * 8 / GOP_time / 1000.0 * self.pictures_per_second
        total = L_kbps
        average_L = L_kbps
        
        if self.output_choice == 0:
            sys.stdout.write("%8d " % L_kbps)

            subband = self.TRLs - 1
            while subband > 0:
                j = 0;
                while j<(2**(self.TRLs - 1 - subband)):
                    sys.stdout.write("-")
                    j += 1
                sys.stdout.write("%7d " % 0)
                sys.stdout.write("%6d " % 0)
                subband -= 1
            sys.stdout.write("%8d\n" % total)

        average_total += total

        # El resto de GOPs están formados por un determinado número de subbandas.
        GOP_number = 1
        L_next_GOP = 0
        while GOP_number <= self.GOPs:

            pics_in_GOP = 1

            if self.output_choice == 0:
                # Número de GOP
                str_GOP_number = '%04d' % GOP_number
                sys.stdout.write("%3s " % str_GOP_number)

            # Total Kbps
            total = 0

            # Subbanda L (cada nueva imagen supone un nuevo GOP).
            L_next_GOP = self.find_next_EOC_texture(L_file)
            L_bytes = L_next_GOP - L_prev_GOP

            if self.output_choice == 1:
                #str_output = '%04d' % (GOP_number*GOP_size)
                print "GOP", ('%04d' % GOP_number), "L", self.TRLs-1, L_bytes

            L_prev_GOP = L_next_GOP
            L_kbps = float(L_bytes) * 8 / GOP_time / 1000.0
            total += L_kbps
            average_L += L_kbps
            if self.output_choice == 0:
                sys.stdout.write("%8d " % int(L_kbps))

            # Subbandas H (dependiendo del nivel de resolución
            # temporal, cada GOP genera un número de imágenes
            # diferente).
            subband = self.TRLs - 1
            while subband > 0:

                if self.output_choice == 0:
                    i = 1
                    sys.stdout.write("%s" % T_file[subband].read(1))
                    while i < pics_in_GOP:
                        sys.stdout.write("%s" % T_file[subband].read(1))
                        i += 1

                i = 1
                M_next_image = 0
                while i < pics_in_GOP:
                    M_next_image = self.find_next_EOC_motion(M_file[subband])
                    if self.output_choice == 1:
                        print "GOP", ('%04d' % GOP_number), "M", subband, (M_next_image - M_prev_image[subband])
                    M_prev_image[subband] = M_next_image
                    i += 1        
                M_next_GOP = self.find_next_EOC_motion(M_file[subband])
                M_bytes = M_next_GOP - M_prev_GOP[subband]

                if self.output_choice == 1:
                    print "GOP", ('%04d' % GOP_number), "M", subband, M_bytes

                M_prev_GOP[subband] = M_next_GOP
                M_kbps = float(M_bytes) * 8 / GOP_time / 1000.0
                total += M_kbps
                average_M[subband] += M_kbps
                if self.output_choice == 0:
                    sys.stdout.write("%7d " % int(M_kbps))

                # 0 1 2 3 4 5 6 7 8
                # 0               8 L_3
                #         4         H_3
                #     2       6     H_2
                #   1   3   5   7   H_1

                i = 1
                H_next_image = 0
                while i < pics_in_GOP:
                    H_next_image = self.find_next_EOC_texture(H_file[subband])
                    if self.output_choice == 1:
                        print "GOP", ('%04d' % GOP_number), "H", subband, (H_next_image - H_prev_image[subband])
                    H_prev_image[subband] = H_next_image                    
                    i += 1

                H_next_GOP = self.find_next_EOC_texture(H_file[subband])
                H_bytes_per_GOP = H_next_GOP - H_prev_GOP[subband]

                if self.output_choice == 1:
                        print "GOP", ('%04d' % GOP_number), "H", subband, H_bytes_per_GOP

                H_prev_GOP[subband] = H_next_GOP
                H_kbps = float(H_bytes_per_GOP) * 8 / GOP_time / 1000.0
                total += H_kbps
                average_H[subband] += H_kbps
                if self.output_choice == 0:
                    sys.stdout.write("%6d " % int(H_kbps))

                subband -= 1
                pics_in_GOP *= 2

            if self.output_choice == 0:
                sys.stdout.write("%8d\n" % total)
            average_total += total

            GOP_number += 1

        if self.output_choice == 0:
            # Imprimimos las medias
            subband = self.TRLs - 1
            sys.stdout.write("---- ")
            sys.stdout.write("-------- ")
            while subband>0:
                j = 0;
                while j<(2**(self.TRLs - 1 - subband)):
                    sys.stdout.write("-")
                    j += 1
                sys.stdout.write("-------------- ")
                subband -= 1
            sys.stdout.write("--------\n")

            subband = self.TRLs - 1
            sys.stdout.write("Average")
#            sys.stdout.write("%6d " % int(average_L/(self.GOPs - 1)))
            sys.stdout.write("%6d " % int(average_L/(self.GOPs+1)))
            while subband>0:
                j = 0;
                while j<(2**(self.TRLs - 1 - subband)):
                    sys.stdout.write(" ")
                    j += 1
#                sys.stdout.write("%7d " % int(average_M[subband]/(self.GOPs - 1)))
                sys.stdout.write("%7d " % int(average_M[subband]/(self.GOPs)))
#                sys.stdout.write("%6d " % int(average_H[subband]/(self.GOPs - 1)))
                sys.stdout.write("%6d " % int(average_H[subband]/(self.GOPs)))
                subband -= 1
#            sys.stdout.write("%8d\n" % int(average_total/(self.GOPs - 1)))
            sys.stdout.write("%8d\n" % int(average_total/(self.GOPs+1)))

#            sys.stdout.write("\nTotal average: " \
#                             + str(average_total/(self.GOPs - 1)) \
#                             + " Kbps (notice that the first GOP is not included)\n")
            sys.stdout.write("\nTotal average: " \
                             + str(average_total/(self.GOPs+1)) \
                             + " Kbps\n")
