#!/bin/bash


base_dir=$PWD



# Parámetros comunes
PICTURES=129

# Parámetros video
parametrosCIFx30 () {
	X_DIM=352
	Y_DIM=288
	FPS=30
	BLOCK_SIZE=152064
	DURATION=`echo "$PICTURES/$FPS" | bc -l` #segundos
}

parametros4CIFx30 () { 
	X_DIM=704
	Y_DIM=576
	FPS=30
	BLOCK_SIZE=608256
	DURATION=`echo "$PICTURES/$FPS" | bc -l`
}

parametros720px50 () { # 736 p
	X_DIM=1280
	Y_DIM=736
	FPS=50
	BLOCK_SIZE=1413120
	DURATION=`echo "$PICTURES/$FPS" | bc -l`
}

parametros1080px50 () { # 1088 p
	X_DIM=1920
	Y_DIM=1088
	FPS=50
	BLOCK_SIZE=3133440
	DURATION=`echo "$PICTURES/$FPS" | bc -l`
}

parametros1080px25 () { # 1088 p
	X_DIM=1920
	Y_DIM=1088
	FPS=25
	BLOCK_SIZE=3133440
	DURATION=`echo "$PICTURES/$FPS" | bc -l`
}


parametrosCIFx30
#parametros4CIFx30
#parametros720px50
#parametros1080px50
#parametros1080px25
VIDEO=urandom_352x288x30x420x300.yuv
carpeta="codestream_1/data-FD-MCJ2K-buscaRate_129-urandom_352x288x30x420x300.sh_44000.32.32.5.0.0.1.3"
carpeta2="codestream_1/data-FD-MCJ2K-buscaRate_129-urandom_352x288x30x420x1.sh_40000.32.32.1.0.0.1.3"

RMSE_anterior=0
kbps_anterior=0
##############################	##############################
#			FUNCIONES				#
##############################	##############################

slopesVariables_aTRL(){

# ENTRADA SLOPES
	comentario(){
		slope_H1=$1
		#slope_L=$2
		slope_L=`echo "$1/$divisor" | bc`
	}

		slope_H1=$1
		slope_H2=`echo "$slope_H1/$divisor" | bc`
		slope_H3=`echo "$slope_H2/$divisor" | bc`
		slope_H4=`echo "$slope_H3/$divisor" | bc`
		slope_L=`echo "$slope_H4/$divisor" | bc`



# CARPETA 1: CODIFICACIÓN n SLOPES
	cd $base_dir/$carpeta
		comentario(){
		mcj2k texture_compress_hfb_j2k --file=high_1 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_H1 --subband=1 --temporal_levels=2 --spatial_levels=3
		mcj2k texture_compress_lfb_j2k --file=low_1 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_L --temporal_levels=2 --spatial_levels=3
		}
		
		mcj2k texture_compress_hfb_j2k --file=high_1 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_H1 --subband=1 --temporal_levels=5 --spatial_levels=3
		mcj2k texture_compress_hfb_j2k --file=high_2 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_H2 --subband=2 --temporal_levels=5 --spatial_levels=3
		mcj2k texture_compress_hfb_j2k --file=high_3 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_H3 --subband=3 --temporal_levels=5 --spatial_levels=3
		mcj2k texture_compress_hfb_j2k --file=high_4 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_H4 --subband=4 --temporal_levels=5 --spatial_levels=3
		mcj2k texture_compress_lfb_j2k --file=low_4 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_L --temporal_levels=5 --spatial_levels=3

		rm -rf tmp; mkdir tmp ; cp *.mjc *type* tmp/
		mkdir $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_H4.$slope_L ; cp *.mjc $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_H4.$slope_L
		cd tmp/

	# info = Calcula bit-kbps
		TotalBytes=0
		for Bytes in `ls -lR | grep -v ^d | awk '{print $5}'`; do
			let TotalBytes=$TotalBytes+$Bytes
		done
		kbps=`echo "scale=6;$TotalBytes*8/$DURATION/1000" | bc -l`


	# expand
		mcj2k expand --block_overlaping=0 --block_size=32 --block_size_min=32 --layers=10 --pictures=129 --temporal_levels=5 --pixels_in_x=352 --pixels_in_y=288 --subpixel_accuracy=0 --search_range=1 #> file 2>&1

	# RD
		RMSE=`snr --block_size=$BLOCK_SIZE --file_A=$DATA/VIDEOS/$VIDEO --file_B=low_0 2> /dev/null | grep RMSE | cut -f 3`
		

	# Resultado pesos_$2.dat:
		prop_1=`echo "scale=6;$slope_H1/$slope_H1" | bc -l`
		prop_2=`echo "scale=6;$slope_H1/$slope_H2" | bc -l`
		prop_3=`echo "scale=6;$slope_H2/$slope_H3" | bc -l`
		prop_4=`echo "scale=6;$slope_H3/$slope_H4" | bc -l`

		if [ $RMSE_anterior = 0 ] ; then
			pendiente=0
		else
			pendiente=`echo "scale=8;($RMSE_anterior-$RMSE)/($kbps-$kbps_anterior)" | bc -l`
		fi

		RMSE_anterior=$RMSE
		kbps_anterior=$kbps


		echo -e "SLOPES: $slope_H1 $slope_H2 $slope_H3 $slope_H4 $slope_L \t COEFICIENTES: $prop_1 $prop_2 $prop_3 $prop_4 1 \t PENDIENTE: $pendiente">> $base_dir/pesos_$subbanda.dat
		echo -e "SLOPES: $slope_H1 $slope_H2 $slope_H3 $slope_H4 $slope_L \t COEFICIENTES: $prop_1 $prop_2 $prop_3 $prop_4 1 \t PENDIENTE: $pendiente"> $base_dir/pantalla.dat
		echo -e "kbps= $kbps\tRMSE= $RMSE \t PENDIENTE: $pendiente">> $base_dir/pesos_$subbanda.dat

		cd $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_H4.$slope_L
		ls -l >> $base_dir/pesos_$subbanda.dat
		ls -l >> $base_dir/pantalla.dat

		# coge los pesos
		peso_high1mcj=`ls -l high_1.mjc | awk '{print $5}'`
		peso_high2mcj=`ls -l high_2.mjc | awk '{print $5}'`
		peso_high3mcj=`ls -l high_3.mjc | awk '{print $5}'`
		peso_high4mcj=`ls -l high_4.mjc | awk '{print $5}'`
		peso_lowmcj=`ls -l low_4.mjc | awk '{print $5}'`


		rm -rf $base_dir/tmps/tmp.$slope_H1.$slope_H2.$slope_H3.$slope_H4.$slope_L

# CARPETA 2: CODIFICACIÓN 1 SLOPES
	# 1 TRL para 1º frame
	cd $base_dir/$carpeta2
		mcj2k compress --block_overlaping=0 --block_size=32 --block_size_min=32 --slopes=$slope_L --pictures=1 --temporal_levels=1 --pixels_in_x=352 --pixels_in_y=288 --subpixel_accuracy=0 --search_range=1 --spatial_levels=3
		mcj2k texture_compress --pictures=1 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_L --temporal_levels=1 --spatial_levels=3
		mcj2k texture_compress_lfb_j2k --file=low_0 --pictures=1 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope_L --temporal_levels=1 --spatial_levels=3

		# calcula pesos y proporciones
		peso_Frame1=`ls -l low_0.mjc | awk '{print $5}'`
		peso_lowmcj_sinFrame1=`echo "scale=6;$peso_lowmcj-$peso_Frame1" | bc -l`
		prop_1=`echo "scale=6;$peso_high1mcj/$peso_high1mcj" | bc -l`
		prop_2=`echo "scale=6;$peso_high1mcj/$peso_high2mcj" | bc -l`
		prop_3=`echo "scale=6;$peso_high2mcj/$peso_high3mcj" | bc -l`
		prop_4=`echo "scale=6;$peso_high3mcj/$peso_high4mcj" | bc -l`	
}
		echo "PESOS: frame_1= $peso_Frame1  low.mcj_sin_frame_1= $peso_lowmcj_sinFrame1   PROPORCIONES= $prop_1 $prop_2 $prop_3 $prop_4" >> $base_dir/pesos_$subbanda.dat

	# Resultado coef_.dat:
		echo -e $slope_H1 $slope_H2 $slope_H3 $slope_H4 $slope_L'\t\t'$kbps'\t'$RMSE'\t\t'$prop_1 $prop_2 $prop_3 $prop_4 '\t\t' $pendiente >> $base_dir/coef_$subbanda.dat
		echo -e $slope_H1 $slope_H2 $slope_H3 $slope_H4 $slope_L'\t\t'$kbps'\t'$RMSE'\t\t'$prop_1 $prop_2 $prop_3 $prop_4 '\t\t' $pendiente >> $base_dir/pantalla.dat

	# Resultado separador:
	echo " " >> $base_dir/pesos_$subbanda.dat
	echo " " >> $base_dir/pesos_$subbanda.dat


	# Pantalla
	echo " "; echo " "; echo " "
	cat $base_dir/pantalla.dat
}



##############################	##############################
#			MAIN					#
##############################	##############################
# $1 slope_inicial
# $2 coeficiente
# $3 siguiente coeficiente...


# LIMPIA

#rm *.dat
#echo "======================================== ARCHIVO DE PESOS ===================================" > pesos_$2.dat
rm -rf tmps; mkdir tmps;


# LLAMADAS

#			H1		H2		H3		H4		L
#slopesVariables_aTRL	$1		$2		$3		$4		$5
#slopesVariables_aTRL	65535	65535	65535	65535	65535


#divisores=(1	1.0001	1.0002	1.0003	1.0004	1.0005	1.0006	1.0007	1.0008	1.0009	1.001	1.0011	1.0012	1.0013	1.0014	1.0015	1.0016	1.0017	1.0018	1.0019	1.002	1.0021	1.0022	1.0023	1.0024	1.0025	1.0026	1.0027	1.0028	1.0029	1.003	1.0031	1.0032	1.0033	1.0034	1.0035	1.0036	1.0037	1.0038	1.0039	1.004	1.0041	1.0042	1.0043	1.0044	1.0045	1.0046	1.0047	1.0048	1.0049	1.005	1.0051	1.0052	1.0053	1.0054	1.0055	1.0056	1.0057	1.0058	1.0059	1.006	1.0061	1.0062	1.0063	1.0064	1.0065	1.0066	1.0067	1.0068	1.0069	1.007	1.0071	1.0072	1.0073	1.0074	1.0075	1.0076	1.0077	1.0078	1.0079	1.008	1.0081	1.0082	1.0083	1.0084	1.0085	1.0086	1.0087	1.0088	1.0089	1.009	1.0091	1.0092	1.0093	1.0094	1.0095	1.0096	1.0097	1.0098	1.0099	1.01	1.0101	1.0102	1.0103	1.0104	1.0105	1.0106	1.0107	1.0108	1.0109	1.011	1.0111	1.0112	1.0113	1.0114	1.0115	1.0116	1.0117	1.0118	1.0119	1.012	1.0121	1.0122	1.0123	1.0124	1.0125	1.0126	1.0127	1.0128	1.0129	1.013	1.0131	1.0132	1.0133	1.0134	1.0135	1.0136	1.0137	1.0138	1.0139	1.014	1.0141	1.0142	1.0143	1.0144	1.0145	1.0146	1.0147	1.0148	1.0149	1.015	1.0151	1.0152	1.0153	1.0154	1.0155	1.0156	1.0157	1.0158	1.0159	1.016	1.0161	1.0162	1.0163	1.0164	1.0165	1.0166	1.0167	1.0168	1.0169	1.017	1.0171	1.0172	1.0173	1.0174	1.0175	1.0176	1.0177	1.0178	1.0179	1.018	1.0181	1.0182	1.0183	1.0184	1.0185	1.0186	1.0187	1.0188	1.0189	1.019	1.0191	1.0192	1.0193	1.0194	1.0195	1.0196	1.0197	1.0198	1.0199	1.02	1.0201	1.0202	1.0203	1.0204	1.0205	1.0206	1.0207	1.0208	1.0209	1.021	1.0211	1.0212	1.0213	1.0214	1.0215	1.0216	1.0217	1.0218	1.0219	1.022	1.0221	1.0222	1.0223	1.0224	1.0225)
divisores=(1	1.0001	1.0002	1.0003	1.0004	1.0005	1.0006	1.0007	1.0008	1.0009	1.001	1.0011	1.0012	1.0013	1.0014	1.0015	1.0016	1.0017	1.0018	1.0019	1.002	1.0021	1.0022	1.0023	1.0024	1.0025	1.0026	1.0027	1.0028	1.0029	1.003	1.0031	1.0032	1.0033	1.0034	1.0035	1.0036	1.0037	1.0038	1.0039	1.004	1.0041	1.0042	1.0043	1.0044	1.0045	1.0046	1.0047	1.0048	1.0049	1.005)
for divisor in "${divisores[@]}"; do 
	RMSE_anterior=0	
	kbps_anterior=0	
	subbanda=$divisor
	slopesVariables_aTRL	45000
	slopesVariables_aTRL	44900
	slopesVariables_aTRL	44800
	slopesVariables_aTRL	44700
	slopesVariables_aTRL	44600
	slopesVariables_aTRL	44500
	slopesVariables_aTRL	44400
	slopesVariables_aTRL	44300
	slopesVariables_aTRL	44200
	slopesVariables_aTRL	44100
	slopesVariables_aTRL	44000
	slopesVariables_aTRL	43900
	slopesVariables_aTRL	43800
	slopesVariables_aTRL	43700
	slopesVariables_aTRL	43600
	slopesVariables_aTRL	43500
	slopesVariables_aTRL	43400
	slopesVariables_aTRL	43300
	slopesVariables_aTRL	43200
	slopesVariables_aTRL	43100
	slopesVariables_aTRL	43000
	slopesVariables_aTRL	42900
	slopesVariables_aTRL	42800
	slopesVariables_aTRL	42700
	slopesVariables_aTRL	42600
	slopesVariables_aTRL	42500
	slopesVariables_aTRL	42400
	slopesVariables_aTRL	42300
	slopesVariables_aTRL	42200
	slopesVariables_aTRL	42100
	slopesVariables_aTRL	42000
	slopesVariables_aTRL	41900
	slopesVariables_aTRL	41800
	slopesVariables_aTRL	41700
	slopesVariables_aTRL	41600
	slopesVariables_aTRL	41500
	slopesVariables_aTRL	41400
	slopesVariables_aTRL	41300
	slopesVariables_aTRL	41200
	slopesVariables_aTRL	41100
	slopesVariables_aTRL	41000
done


