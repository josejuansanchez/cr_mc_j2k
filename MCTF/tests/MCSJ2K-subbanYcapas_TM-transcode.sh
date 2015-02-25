#!/bin/bash



if [ -z $DATA ]; then echo "Hi! \$DATA undefined!"; exit; fi

set -x

data_base=$PWD


##############################	##############################
#                            VÍDEO                           #
##############################	##############################
#mobile_352x288x30x420x300.yuv
#coastguard_352x288x30x420x300.yuv
#akiyo_352x288x30x420x300.yuv
#crowd_run_3840x2160x50x420x500.yuv
#ducks_3840x2160x50x420x500.yuv
#oldTownCross_1280x720x50x420x500.yuv
#oldTownCross_3840x2160x50x420x500.yuv
#parkJoy_3840x2160x50x420x500.yuv

NAME=oldTownCross
RES_X=3840
RES_Y=2160
FPS=50
TOTAL_PICTURES=500

NAME=oldTownCross
RES_X=1408
RES_Y=1152
FPS=50
TOTAL_PICTURES=500

NAME=oldTownCross
RES_X=1280
RES_Y=720
FPS=50
TOTAL_PICTURES=500

NAME=null
RES_X=352
RES_Y=288
FPS=30
TOTAL_PICTURES=300

NAME=crowd_run
RES_X=3840
RES_Y=2160
FPS=50
TOTAL_PICTURES=500

NAME=random
RES_X=352
RES_Y=288
FPS=30
TOTAL_PICTURES=300

NAME=crowd_run
RES_X=1920
RES_Y=1088
FPS=50
TOTAL_PICTURES=500

NAME=oldTownCross
RES_X=1920
RES_Y=1088
FPS=50
TOTAL_PICTURES=500

NAME=null
RES_X=1920
RES_Y=1088
FPS=50
TOTAL_PICTURES=500

NAME=sunflower
RES_X=1280
RES_Y=640
FPS=25
TOTAL_PICTURES=300

NAME=akiyo
RES_X=352
RES_Y=288
FPS=30
TOTAL_PICTURES=300

NAME=coastguard
RES_X=352
RES_Y=288
FPS=30
TOTAL_PICTURES=300

NAME=ducks
RES_X=1920
RES_Y=1088
FPS=50
TOTAL_PICTURES=500

NAME=parkrun
RES_X=1280
RES_Y=736
FPS=50
TOTAL_PICTURES=504

NAME=crew
RES_X=704
RES_Y=576
FPS=60
TOTAL_PICTURES=600

NAME=mobile
RES_X=352
RES_Y=288
FPS=30
TOTAL_PICTURES=300

##############################	##############################
#      		       PARÁMETROS ENTRADA  		     #
##############################	##############################
GOPs=1               # 10
TRLs=7               # 5
update_factor=0      # 0.25 # Con distinto de cero al enviar no enviar todos los gops comprimidos, la reconstrucción sale regular.
search_range=4
block_size=32        # CIF y 4CIF=32 # 720p=32 # FHD=64
block_overlaping=0   # 0
subpixel_accuracy=0  # 0

# # #
block_size_min=$block_size # Para ir decrementando los tamaños de bloques
all_SRLs=17                # =16+1
discard_SRLs_Tex=0         # <-- DISCARD SRLs TEXTURES. (subpixel_accuracy)
discard_SRLs_Mot=0         # <-- DISCARD SRLs MOTIONS. (Parece que mejor siempre = 0)


#############  #################
#    PARÁMETROS CALCULADOS     #
#############  #################
GOP_size=`echo "2^($TRLs-1)" | bc -l`
PICTURES=`echo "$GOPs*$GOP_size+1" | bc -l`
DURATION=`echo "$PICTURES/$FPS" | bc -l` #segundos

if [[ $PICTURES -gt $TOTAL_PICTURES ]]; then
    echo "Insuficientes frames en el video original ($TOTAL_PICTURES) para --GOPs=$GOPs --TRLs=$TRLs ($PICTURES frames)."
    exit 0
fi

available_SRLs=`echo "l($search_range)+2" | bc -l`
available_SRLs=`echo "$available_SRLs/1" | bc` # Nº de planos de bits totales a resolución nativa
if [[ $discard_SRLs_Tex > $available_SRLs ]]; then
    discard_SRLs_Tex=$available_SRLs # Nº de planos de bits descartados o Nº de resoluciones que se downsamplean
fi

block_size_snr=`echo "($RES_X*$RES_Y*1.5)/1" | bc` # block_size_snr=`echo "($RES_X*$RES_Y*1.5*$GOP_size)/1" | bc`
RES_X_transcode=`echo "$RES_X/(2^$discard_SRLs_Tex)" | bc`
RES_Y_transcode=`echo "$RES_Y/(2^$discard_SRLs_Tex)" | bc`

block_size_transcode=`echo "$block_size/(2^$discard_SRLs_Tex)" | bc`
block_size_min_transcode=`echo "$block_size_min/(2^$discard_SRLs_Tex)" | bc`

block_size_transcode=`echo "$block_size*(2^$discard_SRLs_Mot)" | bc`
block_size_min_transcode=`echo "$block_size_min*(2^$discard_SRLs_Mot)" | bc`

search_range_transcode=`echo "$search_range/(2^$discard_SRLs_Tex)" | bc`
SRLs=`echo "$TRLs-1" | bc -l` #`echo "$available_SRLs-$discard_SRLs_Tex" | bc` # Nº de planos de bits que se envian realmente (+ 1, el signo)

VIDEO=$NAME'_'$RES_X'x'$RES_Y'x'$FPS'x420x'$TOTAL_PICTURES
VIDEOdown=$NAME'_'$RES_X_transcode'x'$RES_Y_transcode'x'$FPS'x420x'$TOTAL_PICTURES
INFO=$data_dir'/../info_'$discard_SRLs_Tex'_'$discard_SRLs_Mot'.dat'

#echo "available_SRLs: " $available_SRLs #
#read word ; echo "Pulsa enter para continuar..." #


#############  #################
#          DESCARGA            #
#############  #################
if [[ ! -e $DATA/$VIDEO.yuv ]]; then
    echo "no esta"
else
    echo "si esta"
#    current_dir=$PWD
#    cd $DATA
#    wget http://www.hpca.ual.es/~vruiz/videos/$VIDEO.avi
#    ffmpeg -i $VIDEO.avi $VIDEO.yuv
#    cd $current_dir
fi


##########################
# RESOLUTION SCALABILITY #
##########################
discard_SRLs="0,0,0,0,0,0,0"
#discard_SRLs=1,1,1,1,0,0,0 # reduce Textures
#discard_SRLs=0,0,0,0,1,1,1 # reduce Motion
#discard_SRLs=0,0,0,0,2,2,2 # reduce Motion
#discard_SRLs=1,1,1,1,1,1,1 # reduce Textures y Motion

#######################
# QUALITY SCALABILITY #
#######################
Ncapas_T=16  # 1 8 16
Ncapas_M=1   # 1

slope=42000 # 40000 46000

#while [ $slope -ge 41000 ]; do           # 1 slope X punto. 1/4

##############
# DIRECTORIO #
##############
data_dir=$data_base/data-${0##*/}.$NAME.$TRLs""trl_$Ncapas_T"_"$slope"_"$GOPs"GOPs_upfactor"$upF""_
cd $data_base
rm -rf $data_dir
mkdir $data_dir
ln -s $DATA/${VIDEO}.yuv $data_dir/low_0
cd $data_dir


##############################	##############################
#      		             MAIN        		     #
##############################	##############################

    ############
    # COMPRESS #
    ############
    # Motion con SLOPES manuales    --clayers_motion = 0
    # Motion con SLOPES automáticos --clayers_motion > 0
    mcj2k compress --update_factor=$update_factor --nLayers=$Ncapas_T --quantization_texture=$slope --GOPs=$GOPs --TRLs=$TRLs --SRLs=$SRLs --block_size=$block_size --block_size_min=$block_size_min --search_range=$search_range --pixels_in_x=$RES_X --pixels_in_y=$RES_Y

    exit 0

    #############
    # TRANSCODE #
    #############
    #mcj2k transcode --update_factor=$update_factor --GOPs=$GOPs --TRLs=$TRLs --SRLs=$SRLs --FPS=$FPS --BRC=500000 --discard_SRLs=$discard_SRLs --pixels_in_x=$RES_X --pixels_in_y=$RES_Y --block_size=$block_size --search_range=$search_range --nLayers=$Ncapas_T
    #exit 0                                # 1 slope X punto. 2/4

    ###################
    # 1 slope X punto #
    ################### INICIO

    ########
    # INFO #
    rate=`mcj2k info --GOPs=$GOPs --TRLs=$TRLs --pictures_per_second=$FPS | grep "average_total" | cut -f2`


    #########
    # ENVIO #
    mkdir tmp; cp *.j2c *.mjc *type* tmp; cd tmp

    ##########
    # EXPAND #
    ##########
    mcj2k expand --update_factor=$update_factor --GOPs=$GOPs --TRLs=$TRLs --SRLs=$SRLs --block_size=$block_size --block_size_min=$block_size_min --search_range=$search_range --pixels_in_x=$RES_X --pixels_in_y=$RES_Y --subpixel_accuracy=$discard_SRLs_Tex

    ########
    # RMSE #
    rmse=`snr --file_A=low_0 --file_B=../low_0 2> /dev/null | grep RMSE | cut -f3`
    #rmse=`snr --file_A=low_0 --file_B=../low_0 --block_size=152064` # bytes de cada frame

#    echo -e $rate'\t'$rmse'\t'$slope >> $data_base/info.$NAME.$TRLs""trl_$Ncapas_T"_"$GOPs"GOPs_upfactor"$upF""_
#    let slope=slope-256                   # 1 slope X punto. 3/4
#done                                      # 1 slope X punto. 4/4

    ###################
    # 1 slope X punto #
    ################### FIN


exit 0






# kdu_compress -i imagen.raw -o imagen.bits Sprecision=8 Ssigned=yes -slope 44000 Sdims='{'352,288'}'

comentario(){
##############################################################################################
############################################################################################## svg
#### mobile


# 5 TRLs analisis_BRC
gnuplot <<EOF
set terminal svg
set output "cif_5trls_multcomp_MOBILE.svg"
set grid
set logscale x
set title "MCJ2K CIF Mobile (5 TRLs) (16 ó 1 quality layers)"
set xlabel "Kbps"
set ylabel "RMSE"
plot "mobile_BRC.creversibleNO_slope40._1byte" using 33:37 ps 0.3 lw 0.2 title "BRC 1byte"          with linespoints, \
"mobile_45._36._xRaiz2_sinROUND"               using 34:38 ps 0.3 lw 0.2 title "xRaiz2 (sin round)" with linespoints, \
"mobile_45._36._xRaiz2"                        using 33:37 ps 0.3 lw 0.2 title "xRaiz2"             with linespoints, \
"mobile_45._37._x4"                            using 33:37 ps 0.3 lw 0.2 title "x4"                 with linespoints, \
"mobile_45._37._x3"                            using 33:37 ps 0.3 lw 0.2 title "x3"                 with linespoints, \
"mobile_45._36._x2"                            using 33:37 ps 0.3 lw 0.2 title "x2"                 with linespoints, \
"mobile_45._36._x1"                            using 33:37 ps 0.3 lw 0.2 title "sin multiplicar"    with linespoints, \
"mobile_45._36._xCOEF"                         using 33:37 ps 0.3 lw 0.2 title "COEF"               with linespoints, \
"mobile_45000_8capas_5trl_DobleCadaSub"        using 33:37 ps 0.3 lw 0.2 title "DobleCadaSub"       with linespoints, \
"mobile_SUBINDEP_Raiz2"                        using 33:37 ps 0.3 lw 0.2 title "SUBINDEP_Raiz2"     with linespoints, \
"mobile_SUBINDEP_x2"                           using 33:37 ps 0.3 lw 0.2 title "SUBINDEP_x2"        with linespoints, \
"mobile_SUBINDEP_sinPond"                      using 33:37 ps 0.3 lw 0.2 title "SUBINDEP_sinPond"   with linespoints, \
"mobile_SUBINDEP_xCOEF"                        using 33:37 ps 0.3 lw 0.2 title "SUBINDEP_xCOEF"     with linespoints
EOF


# 5 TRLs analisis_BRC
gnuplot <<EOF
set terminal svg
set output "cif_5trls_multcomp_MOBILE_slope40000.svg"
set grid
set logscale x
set title "MCJ2K CIF Mobile (5 TRLs) (16 ó 1 quality layers)"
set xlabel "Kbps"
set ylabel "RMSE"
plot "mobile_BRC.creversibleNO_slope40._1byte" using 33:37 ps 0.2 lw 1   title "BRC 1byte"                   with linespoints, \
"mobile_SUBINDEP_40._Ptanterior_xRaiz2"        using 33:37 ps 0.2 lw 0.2 title "raiz2_SUBINDEP_Ptanterior"   with linespoints, \
"mobile_SUBINDEP_40._Ptanterior_x2"            using 33:37 ps 0.2 lw 0.2 title "2_SUBINDEP_Ptanterior"       with linespoints, \
"mobile_SUBINDEP_40._Ptanterior_sinPond"       using 33:37 ps 0.2 lw 0.2 title "sinPond_SUBINDEP_Ptanterior" with linespoints, \
"mobile_SUBINDEP_40._Ptanterior_xCOEF"         using 33:37 ps 0.2 lw 0.2 title "Coef_SUBINDEP_Ptanterior"    with linespoints, \
"mobile_mosqueteras"                           using 33:37 ps 0.2 lw 0.2 title "Mosqueteras"                 with linespoints
EOF

"mobile_45._36._x2"                            using 33:37 ps 0.2 lw 0.2 title "x2"                          with linespoints, \

"mobile_SUBINDEP_40._Ptinicial_xRaiz2"         using 33:37 ps 0.2 lw 0.2 title "raiz2_SUBINDEP_Ptinicial"    with linespoints, \
"mobile_SUBINDEP_40._Ptinicial_x2"             using 33:37 ps 0.2 lw 0.2 title "2_SUBINDEP_Ptinicial"        with linespoints, \
"mobile_SUBINDEP_40._Ptinicial_sinPond"        using 33:37 ps 0.2 lw 0.2 title "sinPond_SUBINDEP_Ptinicial"  with linespoints, \
"mobile_SUBINDEP_40._Ptinicial_xCOEF"          using 33:37 ps 0.2 lw 0.2 title "Coef_SUBINDEP_Ptinicial"     with linespoints


gnuplot <<EOF
set terminal svg
set output "cif_5trls_multcomp_AKIYO.svg"
set grid
set logscale x
set title "MCJ2K CIF AKIYO (5 TRLs) (16 ó 1 quality layers)"
set xlabel "Kbps"
set ylabel "RMSE"
plot "akiyo_BRC_1byte" using 33:37 ps 0.3 title "BRC_1byte" with linespoints, \
"akiyo_45._36._xRaiz2" using 33:37 ps 0.3 title "xRaiz2" with linespoints, \
"akiyo_45._36._x2"     using 33:37 ps 0.3 title "x2" with linespoints, \
"akiyo_45._36._x1"     using 33:37 ps 0.3 title "sin multiplicar" with linespoints, \
"akiyo_45._36._xCOEF"  using 33:37 ps 0.3 title "COEF" with linespoints
EOF


gnuplot <<EOF
set terminal svg
set output "fullhd_5trls_multcomp_OLDTOWNCROSS.svg"
set grid
set logscale x
set title "MCJ2K FULLHD OLDTOWNCROSS (5 TRLs) (16 ó 1 quality layers)"
set xlabel "Kbps"
set ylabel "RMSE"
plot "oldTownCross_45._36._xRaiz2" using 33:37 ps 0.3 title "xRaiz2" with linespoints, \
"oldTownCross_45._36._xCOEF"  using 33:37 ps 0.3 title "COEF" with linespoints, \
"oldTownCross_45._36._x2"     using 33:37 ps 0.3 title "x2" with linespoints
EOF







set terminal wxt


gnuplot <<EOF
set terminal x11
set output
set grid
set title "MCJ2K CIF Mobile (5 TRLs) (16 quality layers)"
set xlabel "Kbps"
set ylabel "RMSE"
plot "BRC" using 24:37 title "L (imagen del GOP)" with linespoints, \
"BRC" using 22:37 title "M" with linespoints, \
"BRC" using 26:37 title "H4" with linespoints, \
"BRC" using 27:37 title "H3" with linespoints, \
"BRC" using 28:37 title "H2" with linespoints, \
"BRC" using 29:37 title "H1" with linespoints
EOF
##############################################################################################

# 3 TRLs
gnuplot <<EOF
set terminal svg
set output "cif_3trls.svg"
set grid
set title "CIF Mobile (3 TRLs) (8 quality layers)"
set xlabel "Kbps"
set ylabel "RMSE"
plot "info_3TRLs_SubX=_SinCabeceras" using 8:9 title "MCJ2K Before" with linespoints, \
"info_3TRLs_99999999BRC_SinCabeceras" using 6:7 title "MCJ2K New" with linespoints, \
"svc_CGS_5images_Qespaciadas_sinCabeceras" using 3:4 title "SVC" with linespoints
EOF

# 5 TRLs
gnuplot <<EOF
set terminal svg
set output "cif_5trls.svg"
set grid
set title "MCJ2K CIF Mobile (5 TRLs) (8 quality layers)"
set xlabel "Kbps"
set ylabel "RMSE"
plot "info_5_50000_888881111*000001111" using 21:22 title "000001111" with linespoints, \
"info_5_50000_888881111*000001110" using 21:22 title "000001110" with linespoints, \
"info_5_50000_888881111*000000000" using 21:22 title "000000000" with linespoints
EOF


gnuplot <<EOF
set terminal svg
set output "cif_5trls.svg"
set grid
set title "MCJ2K CIF Mobile (5 TRLs) (8 quality layers)"
set xlabel "Kbps"
set ylabel "RMSE"
plot "info_5_50000_888881111*000000000_ReducesManual" using 21:22 title "000000000-reduces manual" with linespoints lw 0.2, \
"info_5_50000_888881111*000001110" using 21:22 title "000001110" with linespoints lw 0.2, \
"info_5_50000_888881111*000000000" using 21:22 title "000000000" with linespoints lw 0.2
EOF

#### oldTown

# 3 TRLs
gnuplot <<EOF
set terminal svg
set output "full_3trls.svg"
set grid
set title "FULL-HD OldTownCross (3 TRLs) (8 quality layers)"
set xlabel "Kbps"
set ylabel "RMSE"
plot "info_3TRLs_SubX=_SinCabeceras" using 8:9 title "MCJ2K Before" with linespoints, \
"info_3TRLs_sinCabeceras" using 6:7 title "MCJ2K New" with linespoints, \
"svc_3TRLs_sinCGS_sinCabeceras" using 2:3 title "SVC x3 cortes" with linespoints, \
"svc_3TRLs_sinCabeceras_4puntos" using 2:3 title "SVC x4 cortes" with linespoints
EOF

# 5 TRLs
gnuplot <<EOF
set terminal svg
set output "full_5trls.svg"
set grid
set title "FULL-HD OldTownCross (5 TRLs) (8 quality layers)"
set xlabel "Kbps"
set ylabel "RMSE"
plot "info_5TRLs_SubX=_SinCabeceras" using 12:13 title "MCJ2K Before" with linespoints, \
"info_5TRLs_sinCabeceras" using 10:11 title "MCJ2K New" with linespoints, \
"svc_5TRLs_sinCGS_sinCabeceras" using 2:3 title "SVC x3 cortes" with linespoints, \
"svc_5TRLs_sinCabeceras_4puntos" using 2:3 title "SVC x4 cortes" with linespoints
EOF

##############################################################################################
############################################################################################## fig
#### mobile

# 3 TRLs
gnuplot <<EOF
set terminal fig color
set output "cif_3trls.fig"
set logscale x
set grid
set title "CIF Mobile (3 TRLs) (8 quality layers)"
set xlabel "Kbps"
set ylabel "RMSE"
plot "info_3TRLs_SubX=_SinCabeceras" using 8:9 title "MCJ2K without BRC" with linespoints, \
"info_3TRLs_99999999BRC_SinCabeceras" using 6:7 title "MCJ2K with BRC" with linespoints, \
"svc_CGS_5images_Qespaciadas_sinCabeceras" using 3:4 title "SVC" with linespoints
EOF

# 5 TRLs
gnuplot <<EOF
set terminal fig color
set output "cif_5trls.fig"
set logscale x
set grid
set title "CIF Mobile (5 TRLs) (8 quality layers)"
set xlabel "Kbps"
set ylabel "RMSE"
plot "info_5TRLs_SubX=_SinCabeceras" using 12:13 title "MCJ2K without BRC" with linespoints, \
"info_5TRLs_99999999BRC_SinCabeceras" using 10:11 title "MCJ2K with BRC" with linespoints, \
"svc_CGS_17images_Qespaciadas_sinCabeceras" using 3:4 title "SVC" with linespoints
EOF

#### oldTown

# 3 TRLs
gnuplot <<EOF
set terminal fig color
set output "full_3trls.fig"
set logscale x
set grid
set title "FULL-HD OldTownCross (3 TRLs) (8 quality layers)"
set xlabel "Kbps"
set ylabel "RMSE"
plot "info_3TRLs_SubX=_SinCabeceras" using 8:9 title "MCJ2K without BRC" with linespoints, \
"info_3TRLs_sinCabeceras" using 6:7 title "MCJ2K with BRC" with linespoints, \
"svc_3TRLs_sinCGS_sinCabeceras" using 2:3 title "SVC x3 layers" with linespoints, \
"svc_3TRLs_sinCabeceras_4puntos" using 2:3 title "SVC x4 layers" with linespoints
EOF

# 5 TRLs
gnuplot <<EOF
set terminal fig color
set output "full_5trls.fig"
set logscale x
set grid
set title "FULL-HD OldTownCross (5 TRLs) (8 quality layers)"
set xlabel "Kbps"
set ylabel "RMSE"
plot "info_5TRLs_SubX=_SinCabeceras" using 12:13 title "MCJ2K without BRC" with linespoints, \
"info_5TRLs_sinCabeceras" using 10:11 title "MCJ2K with BRC" with linespoints, \
"svc_5TRLs_sinCGS_sinCabeceras" using 2:3 title "SVC x3 layers" with linespoints, \
"svc_5TRLs_sinCabeceras_4puntos" using 2:3 title "SVC x4 layers" with linespoints
EOF

}




set +x
