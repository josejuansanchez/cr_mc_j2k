#!/bin/bash

# ESTE SCRIPT ENGANCHA CON EL TRANSCODE_ANTIGUO.PY

if [ -z $DATA ]; then echo "Hi! \$DATA undefined!"; exit; fi

set -x


data_dir=$PWD/data-${0##*/}

##############################	##############################
#                            VÍDEO                           #
##############################	##############################
#mobile_352x288x30x420x300.yuv
#coastguard_352x288x30x420x300.yuv
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

NAME=coastguard
RES_X=352
RES_Y=288
FPS=30
TOTAL_PICTURES=300

NAME=crowd_run
RES_X=3840
RES_Y=2160
FPS=50
TOTAL_PICTURES=500

NAME=oldTownCross
RES_X=1280
RES_Y=720
FPS=50
TOTAL_PICTURES=500

NAME=mobile
RES_X=352
RES_Y=288
FPS=30
TOTAL_PICTURES=300


##############################	##############################
#      		       PARÁMETROS ENTRADA  		     #
##############################	##############################
GOPs=1
TRLs=3
search_range=4
block_size=16
block_size_min=16
all_SRLs=17           # =16+1
discard_SRLs_Tex=0    # <-- DISCARD SRLs TEXTURES
discard_SRLs_Mot=0    # <-- DISCARD SRLs MOTIONS. (Parece que mejor siempre = 0)

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

block_size_snr=`echo "($RES_X*$RES_Y*1.5)/1" | bc` #block_size_snr=`echo "($RES_X*$RES_Y*1.5*$GOP_size)/1" | bc`
RES_X_transcode=`echo "$RES_X/(2^$discard_SRLs_Tex)" | bc`
RES_Y_transcode=`echo "$RES_Y/(2^$discard_SRLs_Tex)" | bc`
block_size_transcode=`echo "$block_size/(2^$discard_SRLs_Tex)" | bc`
block_size_min_transcode=`echo "$block_size_min/(2^$discard_SRLs_Tex)" | bc`
search_range_transcode=`echo "$search_range/(2^$discard_SRLs_Tex)" | bc`
SRLs=5 #`echo "$available_SRLs-$discard_SRLs_Tex" | bc` # Nº de planos de bits que se envian realmente (+ 1, el signo)

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

##############################	##############################
#      		      ELECCIÓN ÁNGULOS  		     #
##############################	##############################
unset _CEROS
unset _CAPAS
unset _COMBINATION
unset _CANDIDATO

unset cadena_clayers
unset rmse1D_antes
unset kbps_antes
unset rmse1D_candidato
unset kbps_candidato
unset radian_antes
unset z

declare -a _CEROS
declare -a _CAPAS
declare -a _COMBINATION
declare -a _CANDIDATO

export _CEROS
export _CAPAS
export _COMBINATION
export _CANDIDATO

export cadena_clayers
export rmse1D_antes
export kbps_antes
export rmse1D_candidato
export kbps_candidato
export radian_antes
export z

# Inicializa capas
for (( i=0;i<(($TRLs-1)*2)+1;i++)); do
    _CEROS[$i]=0
    _CAPAS[$i]=0
    _COMBINATION[$i]=0
    _CANDIDATO[$i]=0
done

# Print
#for (( i=0;i<${#_CAPAS[@]};i++)); do
#    echo ${_CAPAS[${i}]}
#done

# Ítems
unset H_max
unset M_max

export H_max=1 # _CAPAS[1] = es la primera capa de H
export M_max=$TRLs # _CAPAS[$TRLs] = es la primera capa de M



##############################	##############################
#      		           FUNCION: compress  		     #
##############################	##############################
MCSJ2K_COMPRESS () {

rm -rf $data_dir
mkdir $data_dir
ln -s $DATA/${VIDEO}.yuv $data_dir/low_0
cd $data_dir

# Con SLOPES manuales --clayers_motion = 0  // Con SLOPES automáticos --clayers_motion > 0
mcj2k compress --clayers_motion=$1 --quantization_motion=$2 --quantization_texture=$3 --GOPs=$GOPs --TRLs=$TRLs --SRLs=$SRLs --block_size=$block_size --block_size_min=$block_size_min --search_range=$search_range --pixels_in_x=$RES_X --pixels_in_y=$RES_Y


# INFO
echo -e "\n\n\n# "$1'\t'$2'\t'$3'\t'$VIDEO" -> "$RES_X_transcode"x"$RES_Y_transcode'('$discard_SRLs_Tex//$discard_SRLs_Mot')''\t'GOPs=$GOPs TRLs=$TRLs PICTURES=$PICTURES >> $INFO
echo -e "# "CLAYERS_TM'\t\t'kbps_MJC'\t'kbps_J2C'\t'KBPS'\t'RMSE_1D'\t'RMSE_2D'\t'RMSE_3D'\t'RADIAN >> $INFO
}


##############################	##############################
#      		           FUNCION: expand    		     #
##############################	##############################
MCSJ2K_EXPAND () {

cd $data_dir
rm -rf extract
rm -rf tmp
mkdir tmp


#############  #################
#         TRANSCODE            #
#############  #################
# Enviarle al transcode una lista clayerL, clayerH2, clayerH1, ...
mcj2k transcode --List_Clayers=$cadena_clayers --discard_SRLs_Tex=$discard_SRLs_Tex --discard_SRLs_Mot=$discard_SRLs_Mot --TRLs=$TRLs --GOPs=$GOPs


# distinto slope para cada subbanda. Aunque esto ultimo se suple haciendo muchas capas. (Ej: el mejor trozo es añadir otra vez de la última subbanda añadida)

#############  #################
#           ENVIO              #
#############  #################

# extract VECTORES
cd $data_dir
cp *.mjc extract

echo -e ${_COMBINATION[*]}

for (( i=0;i<${#_COMBINATION[@]};i++)); do
    if [ "0" -eq ${_COMBINATION[$i]} ]; then
	
	#read word ; echo "Pulsa enter para continuar..." #

	if [ 0 -eq $i ]; then
	    rm extract/low*
	fi

	if [ $i -lt $M_max ] && [ $i -ge $H_max ]; then # es H's
	    j=`echo "$TRLs-$i" | bc -l`
	    rm extract/high_$j*
	fi

	if [ $i -ge $M_max ]; then # es M's
	    aux=`echo "$i-($TRLs-1)" | bc -l`
	    j=`echo "$TRLs-$aux" | bc -l`
	    rm extract/motion_residue_$j*
	fi
    fi
done

#read word ; echo "Pulsa enter para continuar..." #


# TEXTURAS y FRAME_TYPES
#cp *.j2c *type* tmp # sin transcode
cp extract/*.j2c *type* tmp # con transcode
# VECTORES
cp extract/*.mjc tmp # con transcode


#############  #################
#     Calcula bit-rate         #
#############  #################
cd tmp

TotalBytes=0
for Bytes in `ls -l *.mjc | grep -v ^d | awk '{print $5}'`; do
    let TotalBytes=$TotalBytes+$Bytes
done
kbps_MJC=`echo "$TotalBytes*8/$DURATION/1000" | bc -l`

TotalBytes=0
for Bytes in `ls -l *.j2c | grep -v ^d | awk '{print $5}'`; do
    let TotalBytes=$TotalBytes+$Bytes
done
kbps_J2C=`echo "$TotalBytes*8/$DURATION/1000" | bc -l`

TotalBytes=0
for Bytes in `ls -l | grep -v ^d | awk '{print $5}'`; do
    let TotalBytes=$TotalBytes+$Bytes
done
kbps=`echo "$TotalBytes*8/$DURATION/1000" | bc -l`


#############  #################
#       DESCOMPRESION          #
#############  #################
mcj2k expand --GOPs=$GOPs --TRLs=$TRLs --SRLs=$SRLs --block_size=$block_size_transcode --block_size_min=$block_size_min_transcode --search_range=$search_range_transcode --pixels_in_x=$RES_X_transcode --pixels_in_y=$RES_Y_transcode --subpixel_accuracy=$discard_SRLs_Tex


# INFO # mcsj2k info --GOPs=$GOPs --TRLs=$TRLs
DownConvertStatic $RES_X_transcode $RES_Y_transcode low_0 $RES_X $RES_Y low_0_UP

rmse1D=`snr --file_A=$DATA/$VIDEO.yuv --file_B=$data_dir/tmp/low_0_UP 2> /dev/null | grep RMSE | cut -f 3`
rmse2D=`snr2D --block_size=$block_size_snr --dim_X=$RES_X --dim_Y=$RES_Y --file_A=$DATA/$VIDEO.yuv --file_B=$data_dir/tmp/low_0_UP --FFT 2>  /dev/null | grep RMSE | cut -f 3` # FFT en 3D
rmse3D=`snr3D --block_size=$block_size_snr --dim_X=$RES_X --dim_Y=$RES_Y --dim_Z=5 --file_A=$DATA/$VIDEO.yuv --file_B=$data_dir/tmp/low_0_UP --FFT 2> /dev/null | grep RMSE | cut -f 3` # FFT en 3D


### ###
# Incrementos KBPS y RMSE
### ###
echo "rmse1D_antes: "$rmse1D_antes
echo "kbps_antes: "$kbps_antes
echo "radian_antes: "$radian_antes

if [ "${_COMBINATION[*]}" == "${_CEROS[*]}" ]; then
    rmse1D_antes=$rmse1D
    kbps_antes=$kbps
else
    radian=`echo "a(( (sqrt(($rmse1D_antes-$rmse1D)^2)) / ($kbps-$kbps_antes) ))" | bc -l`
    if [ `echo "$radian > $radian_antes" | bc -l` -eq 1 ]; then
	rmse1D_candidato=$rmse1D
	kbps_candidato=$kbps
	radian_antes=$radian
	for (( i=0;i<${#_COMBINATION[@]};i++)); do _CANDIDATO[$i]=${_COMBINATION[$i]}; done
    fi
fi
#read word
echo -e ${_COMBINATION[*]}'\t'$kbps_MJC'\t'$kbps_J2C'\t'$kbps'\t'$rmse1D'\t'::$radian >> $INFO #echo -e ${_COMBINATION[*]}'\t'$kbps_MJC'\t'$kbps_J2C'\t'$kbps'\t'$rmse1D'\t'$rmse2D'\t'$rmse3D'\t'::$radian >> $INFO
#echo -e $1 $2 $3 $4 $5'\t'$kbps_MJC'\t'$kbps_J2C'\t'$kbps'\t'$rmse1D'\t'::$radian >> $INFO #echo -e ${_COMBINATION[*]}'\t'$kbps_MJC'\t'$kbps_J2C'\t'$kbps'\t'$rmse1D'\t'$rmse2D'\t'$rmse3D'\t'::$radian >> $INFO
}



arrayTOcadena () {
    
cadena_clayers=""
for i in "${_COMBINATION[@]}"; do
    if [ $i -eq 0 ]; then
	cadena_clayers=$cadena_clayers""1
    else
	cadena_clayers=$cadena_clayers$i
    fi

#    if [ $i -lt 10 ]; then
#	cadena_clayers=$cadena_clayers'0'$i
#    else
#	cadena_clayers=$cadena_clayers$i
#    fi
done
}


##############################	##############################
#      		             MAIN        		     #
##############################	##############################

# MCSJ2K_COMPRESS()   Q_clayers_motion_KAKADU   Q_clayers_motion   Q_motion   Q_texture  (la primera capa puede ser la nula, 65535. Extraida con clayer=1)
# MCSJ2K_EXPAND()     Clayer_Tl2   Clayer_Th2   Clayer_Th1   Clayer_Tm2   Clayer_Tm1 (0=nada, 1=cabecera+1ªcapa, 2=cabecera+1ªy2ªcapa)

Ncapas_T=8 # 0
Ncapas_M=1 # 0


#MCSJ2K_COMPRESS Ncapas_M 55000,50000,45000 45000,44750,44500,44250,44000,43750,43500,43250 # (8 capas de T y 8 de M)

####
MCSJ2K_COMPRESS 0 30000 45000,44750,44500,44250,44000,43750,43500,43250

comentario () {
_COMBINATION=(1 1 1 1 1 1 1 1 1 1 1 1 1) ; arrayTOcadena ; MCSJ2K_EXPAND ${_COMBINATION[*]}
_COMBINATION=(2 2 2 2 2 2 2 1 1 1 1 1 1) ; arrayTOcadena ; MCSJ2K_EXPAND ${_COMBINATION[*]}
_COMBINATION=(3 3 3 3 3 3 3 1 1 1 1 1 1) ; arrayTOcadena ; MCSJ2K_EXPAND ${_COMBINATION[*]}
_COMBINATION=(4 4 4 4 4 4 4 1 1 1 1 1 1) ; arrayTOcadena ; MCSJ2K_EXPAND ${_COMBINATION[*]}
_COMBINATION=(5 5 5 5 5 5 5 1 1 1 1 1 1) ; arrayTOcadena ; MCSJ2K_EXPAND ${_COMBINATION[*]}
_COMBINATION=(6 6 6 6 6 6 6 1 1 1 1 1 1) ; arrayTOcadena ; MCSJ2K_EXPAND ${_COMBINATION[*]}
_COMBINATION=(7 7 7 7 7 7 7 1 1 1 1 1 1) ; arrayTOcadena ; MCSJ2K_EXPAND ${_COMBINATION[*]}
_COMBINATION=(8 8 8 8 8 8 8 1 1 1 1 1 1) ; arrayTOcadena ; MCSJ2K_EXPAND ${_COMBINATION[*]}
}




comentario(){
#############  #################
#    COMBINATIONS AUTONOMO     #
#############  #################

#_CAPAS=(0 0 0 1 0) # echo "_CAPAS " ${_CAPAS[*]}

arrayTOcadena
MCSJ2K_EXPAND ${_COMBINATION[*]} # (0 .. 0)


while [ ${_CANDIDATO[$M_max-1]} -lt $Ncapas_T ]; do # H_min < Ncapas_T
    radian_antes=-99

    # actualiza _CAPAS
    for (( i=0;i<${#_CANDIDATO[@]};i++)); do _CAPAS[$i]=${_CANDIDATO[$i]}; done ; echo "_CAPAS inicial= " ${_CAPAS[*]} #; read word
    echo -e "-> "${_CAPAS[*]} >> $INFO; echo -e "" >> $INFO

    for (( z=0;z<${#_CAPAS[@]};z++)); do # recorre cada subbanda

	# inicializa _COMBINATION
	for (( i=0;i<${#_CAPAS[@]};i++)); do _COMBINATION[$i]=${_CAPAS[$i]}; done ; echo "_COMBINATION inicial= " ${_COMBINATION[*]} #; read word

	if [ $z -lt $M_max ] && [ ${_CAPAS[$z]} -lt $Ncapas_T ]; then # T available
	    if [ $z -gt $H_max ]; then # es H's
		if [ ${_CAPAS[$H_max]} -ne 0 ]; then 
		    _COMBINATION[$z]=`echo "${_CAPAS[$z]}+1" | bc`
		    echo "z="$z "H's:" ${_COMBINATION[*]} ; arrayTOcadena ; MCSJ2K_EXPAND ${_COMBINATION[*]}
		fi
	    else # es L o H_max
		_COMBINATION[$z]=`echo "${_CAPAS[$z]}+1" | bc`
		echo "z="$z "L o H_max:" ${_COMBINATION[*]} ; arrayTOcadena ; MCSJ2K_EXPAND ${_COMBINATION[*]}
	    fi
	fi

	if [ $z -ge $M_max ] && [ ${_CAPAS[$z]} -lt $Ncapas_M ]; then # M available
	    if [ $z -gt $M_max ]; then # es M's
		if [ ${_CAPAS[$M_max]} -ne 0 ]; then
		    _COMBINATION[$z]=`echo "${_CAPAS[$z]}+1" | bc`
		    echo "z="$z "M's:" ${_COMBINATION[*]} ; arrayTOcadena ; MCSJ2K_EXPAND ${_COMBINATION[*]}
		fi
	    else # es M_max
		_COMBINATION[$z]=`echo "${_CAPAS[$z]}+1" | bc`
		echo "z="$z "M_max:" ${_COMBINATION[*]} ; arrayTOcadena ; MCSJ2K_EXPAND ${_COMBINATION[*]}
	    fi
	fi
    done
    rmse1D_antes=$rmse1D_candidato
    kbps_antes=$kbps_candidato
    echo -e ${_CANDIDATO[*]}'\t'$kbps_candidato'\t'$rmse1D_candidato'\t'::$radian_antes >> $INFO""_plot
done

}




comentario(){

# 1 capa para M con cuantificación explicita. 8 para T.
MCSJ2K_COMPRESS 0 30000 45000,44750,44500,44250,44000,43750,43500,43250 # (8 capas)
MCSJ2K_EXPAND 1 1 1 1 1
MCSJ2K_EXPAND 2 2 2 1 1
MCSJ2K_EXPAND 3 3 3 1 1
MCSJ2K_EXPAND 4 4 4 1 1
MCSJ2K_EXPAND 5 5 5 1 1
MCSJ2K_EXPAND 6 6 6 1 1
MCSJ2K_EXPAND 7 7 7 1 1
MCSJ2K_EXPAND 8 8 8 1 1

# para ver valores: cabeceras + capa_nula
MCSJ2K_COMPRESS 0 65000 65000
MCSJ2K_EXPAND 1 1 1 1 1

}






# Al chocar por arriba: devuelve los mismos vectores. Al chocar por abajo: violación segmento.

##################### MPLAYER
echo "mplayer low_0 -demuxer rawvideo -rawvideo w=$RES_X_transcode:h=$RES_Y_transcode -loop 0"

##################### GNUPLOT
comentario(){

##############################################################################################
############################################################################################## svg
#### mobile

# 3 TRLs (correlaciones sí / dwt = 1)
gnuplot <<EOF
set terminal svg
set output "cif_3trls.svg"
set grid
set title "CIF Mobile (3 TRLs) -> T=0..8(Q's standard) & M=1 lossless"
set xlabel "Kbps"
set ylabel "RMSE"
plot "info_3TRLs_SubX=_SinCabeceras" using 8:9 title "MCJ2K Before" with linespoints, \
"info_3TRLs_99999999BRC_SinCabeceras" using 6:7 title "MCJ2K New" with linespoints, \
"svc_CGS_5images_Qespaciadas_sinCabeceras" using 3:4 title "SVC" with linespoints
EOF

# 5 TRLs (correlaciones sí / dwt = 1)
gnuplot <<EOF
set terminal svg
set output "cif_5trls.svg"
set grid
set title "CIF Mobile (5 TRLs) -> T=0..8(Q's standard) & M=1 lossless"
set xlabel "Kbps"
set ylabel "RMSE"
plot "info_5TRLs_SubX=_SinCabeceras" using 12:13 title "MCJ2K Before" with linespoints, \
"info_5TRLs_99999999BRC_SinCabeceras" using 10:11 title "MCJ2K New" with linespoints, \
"svc_CGS_17images_Qespaciadas_sinCabeceras" using 3:4 title "SVC" with linespoints
EOF

#### oldTown

# 3 TRLs
gnuplot <<EOF
set terminal svg
set output "full_3trls.svg"
set grid
set title "FULL-HD OldTownCross (3 TRLs) -> T=0..8(Q's standard) & M=1 lossless"
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
set title "FULL-HD OldTownCross (5 TRLs) -> T=0..8(Q's standard) & M=1 lossless"
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

# 3 TRLs (correlaciones sí / dwt = 1)
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

# 5 TRLs (correlaciones sí / dwt = 1)
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
unset _CEROS
unset _CAPAS
unset _COMBINATION
unset _CANDIDATO

unset rmse1D_antes
unset kbps_antes
unset rmse1D_candidato
unset kbps_candidato
unset radian_antes
unset z

unset H_max
unset M_max

set +x
