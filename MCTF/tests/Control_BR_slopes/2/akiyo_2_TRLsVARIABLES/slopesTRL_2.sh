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
VIDEO=akiyo_352x288x30x420x300.yuv
carpeta="codestream_2/data-FD-MCJ2K-buscaRate_129-akiyo_352x288x30x420x300.sh_45000.32.32.2.0.0.1.3"
carpeta2="codestream_2/data-FD-MCJ2K-buscaRate_129-akiyo_352x288x30x420x1.sh_45000.32.32.1.0.0.1.3"


##############################	##############################
#			FUNCIONES				#
##############################	##############################


slopesVariables_aTRL(){

	cd $base_dir/$carpeta


		mcj2k analyze --block_overlaping=0 --block_size=32 --block_size_min=32 --border_size=0 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --search_range=1 --subpixel_accuracy=0 --temporal_levels=2 #> file 2>&1
		mcj2k motion_compress --block_size=32 --block_size_min=32 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --temporal_levels=2 #> file 2>&1

		mcj2k texture_compress_hfb_j2k --file=high_1 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$1 --subband=1 --temporal_levels=2 --spatial_levels=3
		slope=`echo "($1/$2)/1" | bc`
		mcj2k texture_compress_lfb_j2k --file=low_1 --pictures=129 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope --temporal_levels=2 --spatial_levels=3


		rm -rf tmp; mkdir tmp ; cp *.mjc *type* tmp/ ; cp -r tmp $base_dir/tmps/tmp.$1.*$2 ; cd tmp/

	# info = Calcula bit-rate
		TotalBytes=0
		for Bytes in `ls -lR | grep -v ^d | awk '{print $5}'`; do
			let TotalBytes=$TotalBytes+$Bytes
		done
		rate_mcj2k=`echo "$TotalBytes*8/$DURATION/1000" | bc -l`


	# expand
		mcj2k expand --block_overlaping=0 --block_size=32 --block_size_min=32 --layers=10 --pictures=129 --temporal_levels=2 --pixels_in_x=352 --pixels_in_y=288 --subpixel_accuracy=0 --search_range=1 #> file 2>&1

	# RD
		RMSE=`snr --block_size=$BLOCK_SIZE --file_A=$DATA/VIDEOS/$VIDEO --file_B=low_0 2> /dev/null | grep RMSE | cut -f 3`



		

	# Resultado pesos_$2.dat:
		echo -e "slope_1= $1  slope_2= $slope  coeficiente= $2 \t\tkbps= $rate_mcj2k \tRMSE= $RMSE">> $base_dir/pesos_$2.dat
		cd $base_dir/tmps/tmp.$1.*$2
		ls -l >> $base_dir/pesos_$2.dat
		
		# coge los pesos
		peso_low1mcj=`ls -l low_1.mjc | awk '{print $5}'`
		peso_high1mcj=`ls -l high_1.mjc | awk '{print $5}'`

		rm -rf $base_dir/tmps/tmp.$1.*$2


	# 1 TRL para 1º frame
	cd $base_dir/$carpeta2
		mcj2k compress --block_overlaping=0 --block_size=32 --block_size_min=32 --slopes=$slope --pictures=1 --temporal_levels=1 --pixels_in_x=352 --pixels_in_y=288 --subpixel_accuracy=0 --search_range=1 --spatial_levels=3
		mcj2k texture_compress --pictures=1 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope --temporal_levels=1 --spatial_levels=3
		mcj2k texture_compress_lfb_j2k --file=low_0 --pictures=1 --pixels_in_x=352 --pixels_in_y=288 --slopes=$slope --temporal_levels=1 --spatial_levels=3

		# calcula pesos y proporciones
		peso_Frame1=`ls -l low_0.mjc | awk '{print $5}'`
		peso_low1mcj_sinFrame1=`echo "$peso_low1mcj-$peso_Frame1" | bc -l`
		coeficiente_entrePesos=`echo "$peso_low1mcj_sinFrame1/$peso_high1mcj" | bc -l`
		echo "PESOS: frame_1= $peso_Frame1   low_1.mcj_sin_frame_1= $peso_low1mcj_sinFrame1   coeficiente_pesos= $coeficiente_entrePesos" >> $base_dir/pesos_$2.dat

	# Resultado coef_.dat:
		echo -e $1'\t\t'$rate_mcj2k'\t'$RMSE'\t'$coeficiente_entrePesos >> $base_dir/coef_$2_RD.dat


	# Resultado separador:
	echo " " >> $base_dir/pesos_$2.dat
	echo " " >> $base_dir/pesos_$2.dat

}



##############################	##############################
#			MAIN					#
##############################	##############################
# $1 slope_inicial
# $2 coeficiente
# $3 siguiente coeficiente...


# LIMPIA

#rm *.dat
#echo "========================================ARCHIVO DE PESOS===================================" > pesos.dat
rm -rf tmps; mkdir tmps;



# LLAMADAS

slopesVariables_aTRL	44700	1.01
slopesVariables_aTRL	44690	1.01
slopesVariables_aTRL	44680	1.01
slopesVariables_aTRL	44670	1.01
slopesVariables_aTRL	44660	1.01
slopesVariables_aTRL	44650	1.01
slopesVariables_aTRL	44640	1.01
slopesVariables_aTRL	44630	1.01
slopesVariables_aTRL	44620	1.01
slopesVariables_aTRL	44610	1.01
slopesVariables_aTRL	44600	1.01
slopesVariables_aTRL	44590	1.01
slopesVariables_aTRL	44580	1.01
slopesVariables_aTRL	44570	1.01
slopesVariables_aTRL	44560	1.01
slopesVariables_aTRL	44550	1.01
slopesVariables_aTRL	44540	1.01
slopesVariables_aTRL	44530	1.01
slopesVariables_aTRL	44520	1.01
slopesVariables_aTRL	44510	1.01
slopesVariables_aTRL	44500	1.01
slopesVariables_aTRL	44490	1.01
slopesVariables_aTRL	44480	1.01
slopesVariables_aTRL	44470	1.01
slopesVariables_aTRL	44460	1.01
slopesVariables_aTRL	44450	1.01
slopesVariables_aTRL	44440	1.01
slopesVariables_aTRL	44430	1.01
slopesVariables_aTRL	44420	1.01
slopesVariables_aTRL	44410	1.01
slopesVariables_aTRL	44400	1.01
slopesVariables_aTRL	44390	1.01
slopesVariables_aTRL	44380	1.01
slopesVariables_aTRL	44370	1.01
slopesVariables_aTRL	44360	1.01
slopesVariables_aTRL	44350	1.01
slopesVariables_aTRL	44340	1.01
slopesVariables_aTRL	44330	1.01
slopesVariables_aTRL	44320	1.01
slopesVariables_aTRL	44310	1.01
slopesVariables_aTRL	44300	1.01
slopesVariables_aTRL	44290	1.01
slopesVariables_aTRL	44280	1.01
slopesVariables_aTRL	44270	1.01
slopesVariables_aTRL	44260	1.01
slopesVariables_aTRL	44250	1.01
slopesVariables_aTRL	44240	1.01
slopesVariables_aTRL	44230	1.01
slopesVariables_aTRL	44220	1.01
slopesVariables_aTRL	44210	1.01
slopesVariables_aTRL	44200	1.01
slopesVariables_aTRL	44190	1.01
slopesVariables_aTRL	44180	1.01
slopesVariables_aTRL	44170	1.01
slopesVariables_aTRL	44160	1.01
slopesVariables_aTRL	44150	1.01
slopesVariables_aTRL	44140	1.01
slopesVariables_aTRL	44130	1.01
slopesVariables_aTRL	44120	1.01
slopesVariables_aTRL	44110	1.01
slopesVariables_aTRL	44100	1.01
slopesVariables_aTRL	44090	1.01
slopesVariables_aTRL	44080	1.01
slopesVariables_aTRL	44070	1.01
slopesVariables_aTRL	44060	1.01
slopesVariables_aTRL	44050	1.01
slopesVariables_aTRL	44040	1.01
slopesVariables_aTRL	44030	1.01
slopesVariables_aTRL	44020	1.01
slopesVariables_aTRL	44010	1.01
slopesVariables_aTRL	44000	1.01
slopesVariables_aTRL	43990	1.01
slopesVariables_aTRL	43980	1.01
slopesVariables_aTRL	43970	1.01
slopesVariables_aTRL	43960	1.01
slopesVariables_aTRL	43950	1.01
slopesVariables_aTRL	43940	1.01
slopesVariables_aTRL	43930	1.01
slopesVariables_aTRL	43920	1.01
slopesVariables_aTRL	43910	1.01
slopesVariables_aTRL	43900	1.01
slopesVariables_aTRL	43890	1.01
slopesVariables_aTRL	43880	1.01
slopesVariables_aTRL	43870	1.01
slopesVariables_aTRL	43860	1.01
slopesVariables_aTRL	43850	1.01
slopesVariables_aTRL	43840	1.01
slopesVariables_aTRL	43830	1.01
slopesVariables_aTRL	43820	1.01
slopesVariables_aTRL	43810	1.01
slopesVariables_aTRL	43800	1.01
slopesVariables_aTRL	43790	1.01
slopesVariables_aTRL	43780	1.01
slopesVariables_aTRL	43770	1.01
slopesVariables_aTRL	43760	1.01
slopesVariables_aTRL	43750	1.01
slopesVariables_aTRL	43740	1.01
slopesVariables_aTRL	43730	1.01
slopesVariables_aTRL	43720	1.01
slopesVariables_aTRL	43710	1.01
slopesVariables_aTRL	43700	1.01
slopesVariables_aTRL	43690	1.01
slopesVariables_aTRL	43680	1.01
slopesVariables_aTRL	43670	1.01
slopesVariables_aTRL	43660	1.01
slopesVariables_aTRL	43650	1.01
slopesVariables_aTRL	43640	1.01
slopesVariables_aTRL	43630	1.01
slopesVariables_aTRL	43620	1.01
slopesVariables_aTRL	43610	1.01
slopesVariables_aTRL	43600	1.01
slopesVariables_aTRL	43590	1.01
slopesVariables_aTRL	43580	1.01
slopesVariables_aTRL	43570	1.01
slopesVariables_aTRL	43560	1.01
slopesVariables_aTRL	43550	1.01
slopesVariables_aTRL	43540	1.01
slopesVariables_aTRL	43530	1.01
slopesVariables_aTRL	43520	1.01
slopesVariables_aTRL	43510	1.01
slopesVariables_aTRL	43500	1.01
slopesVariables_aTRL	43490	1.01
slopesVariables_aTRL	43480	1.01
slopesVariables_aTRL	43470	1.01
slopesVariables_aTRL	43460	1.01
slopesVariables_aTRL	43450	1.01
slopesVariables_aTRL	43440	1.01
slopesVariables_aTRL	43430	1.01
slopesVariables_aTRL	43420	1.01
slopesVariables_aTRL	43410	1.01
slopesVariables_aTRL	43400	1.01
slopesVariables_aTRL	43390	1.01
slopesVariables_aTRL	43380	1.01
slopesVariables_aTRL	43370	1.01
slopesVariables_aTRL	43360	1.01
slopesVariables_aTRL	43350	1.01
slopesVariables_aTRL	43340	1.01
slopesVariables_aTRL	43330	1.01
slopesVariables_aTRL	43320	1.01
slopesVariables_aTRL	43310	1.01
slopesVariables_aTRL	43300	1.01
slopesVariables_aTRL	43290	1.01
slopesVariables_aTRL	43280	1.01
slopesVariables_aTRL	43270	1.01
slopesVariables_aTRL	43260	1.01
slopesVariables_aTRL	43250	1.01
slopesVariables_aTRL	43240	1.01
slopesVariables_aTRL	43230	1.01
slopesVariables_aTRL	43220	1.01
slopesVariables_aTRL	43210	1.01
slopesVariables_aTRL	43200	1.01
slopesVariables_aTRL	43190	1.01
slopesVariables_aTRL	43180	1.01
slopesVariables_aTRL	43170	1.01
slopesVariables_aTRL	43160	1.01
slopesVariables_aTRL	43150	1.01
slopesVariables_aTRL	43140	1.01
slopesVariables_aTRL	43130	1.01
slopesVariables_aTRL	43120	1.01
slopesVariables_aTRL	43110	1.01
slopesVariables_aTRL	43100	1.01
slopesVariables_aTRL	43090	1.01
slopesVariables_aTRL	43080	1.01
slopesVariables_aTRL	43070	1.01
slopesVariables_aTRL	43060	1.01
slopesVariables_aTRL	43050	1.01
slopesVariables_aTRL	43040	1.01
slopesVariables_aTRL	43030	1.01
slopesVariables_aTRL	43020	1.01
slopesVariables_aTRL	43010	1.01
slopesVariables_aTRL	43000	1.01
slopesVariables_aTRL	42990	1.01
slopesVariables_aTRL	42980	1.01
slopesVariables_aTRL	42970	1.01
slopesVariables_aTRL	42960	1.01
slopesVariables_aTRL	42950	1.01
slopesVariables_aTRL	42940	1.01
slopesVariables_aTRL	42930	1.01
slopesVariables_aTRL	42920	1.01
slopesVariables_aTRL	42910	1.01
slopesVariables_aTRL	42900	1.01
slopesVariables_aTRL	42890	1.01
slopesVariables_aTRL	42880	1.01
slopesVariables_aTRL	42870	1.01
slopesVariables_aTRL	42860	1.01
slopesVariables_aTRL	42850	1.01
slopesVariables_aTRL	42840	1.01
slopesVariables_aTRL	42830	1.01
slopesVariables_aTRL	42820	1.01
slopesVariables_aTRL	42810	1.01
slopesVariables_aTRL	42800	1.01
slopesVariables_aTRL	42790	1.01
slopesVariables_aTRL	42780	1.01
slopesVariables_aTRL	42770	1.01
slopesVariables_aTRL	42760	1.01
slopesVariables_aTRL	42750	1.01
slopesVariables_aTRL	42740	1.01
slopesVariables_aTRL	42730	1.01
slopesVariables_aTRL	42720	1.01
slopesVariables_aTRL	42710	1.01
slopesVariables_aTRL	42700	1.01
slopesVariables_aTRL	42690	1.01
slopesVariables_aTRL	42680	1.01
slopesVariables_aTRL	42670	1.01
slopesVariables_aTRL	42660	1.01
slopesVariables_aTRL	42650	1.01
slopesVariables_aTRL	42640	1.01
slopesVariables_aTRL	42630	1.01
slopesVariables_aTRL	42620	1.01
slopesVariables_aTRL	42610	1.01
slopesVariables_aTRL	42600	1.01
slopesVariables_aTRL	42590	1.01
slopesVariables_aTRL	42580	1.01
slopesVariables_aTRL	42570	1.01
slopesVariables_aTRL	42560	1.01
slopesVariables_aTRL	42550	1.01
slopesVariables_aTRL	42540	1.01
slopesVariables_aTRL	42530	1.01
slopesVariables_aTRL	42520	1.01
slopesVariables_aTRL	42510	1.01
slopesVariables_aTRL	42500	1.01
slopesVariables_aTRL	42490	1.01
slopesVariables_aTRL	42480	1.01
slopesVariables_aTRL	42470	1.01
slopesVariables_aTRL	42460	1.01
slopesVariables_aTRL	42450	1.01
slopesVariables_aTRL	42440	1.01
slopesVariables_aTRL	42430	1.01
slopesVariables_aTRL	42420	1.01
slopesVariables_aTRL	42410	1.01
slopesVariables_aTRL	42400	1.01
slopesVariables_aTRL	42390	1.01
slopesVariables_aTRL	42380	1.01
slopesVariables_aTRL	42370	1.01
slopesVariables_aTRL	42360	1.01
slopesVariables_aTRL	42350	1.01
slopesVariables_aTRL	42340	1.01
slopesVariables_aTRL	42330	1.01
slopesVariables_aTRL	42320	1.01
slopesVariables_aTRL	42310	1.01
slopesVariables_aTRL	42300	1.01
slopesVariables_aTRL	42290	1.01
slopesVariables_aTRL	42280	1.01
slopesVariables_aTRL	42270	1.01
slopesVariables_aTRL	42260	1.01
slopesVariables_aTRL	42250	1.01
slopesVariables_aTRL	42240	1.01
slopesVariables_aTRL	42230	1.01
slopesVariables_aTRL	42220	1.01
slopesVariables_aTRL	42210	1.01
slopesVariables_aTRL	42200	1.01
slopesVariables_aTRL	42190	1.01
slopesVariables_aTRL	42180	1.01
slopesVariables_aTRL	42170	1.01
slopesVariables_aTRL	42160	1.01
slopesVariables_aTRL	42150	1.01
slopesVariables_aTRL	42140	1.01
slopesVariables_aTRL	42130	1.01
slopesVariables_aTRL	42120	1.01
slopesVariables_aTRL	42110	1.01
slopesVariables_aTRL	42100	1.01
slopesVariables_aTRL	42090	1.01
slopesVariables_aTRL	42080	1.01
slopesVariables_aTRL	42070	1.01
slopesVariables_aTRL	42060	1.01
slopesVariables_aTRL	42050	1.01
slopesVariables_aTRL	42040	1.01
slopesVariables_aTRL	42030	1.01
slopesVariables_aTRL	42020	1.01
slopesVariables_aTRL	42010	1.01
slopesVariables_aTRL	42000	1.01
slopesVariables_aTRL	41990	1.01
slopesVariables_aTRL	41980	1.01
slopesVariables_aTRL	41970	1.01
slopesVariables_aTRL	41960	1.01
slopesVariables_aTRL	41950	1.01
slopesVariables_aTRL	41940	1.01
slopesVariables_aTRL	41930	1.01
slopesVariables_aTRL	41920	1.01
slopesVariables_aTRL	41910	1.01
slopesVariables_aTRL	41900	1.01
slopesVariables_aTRL	41890	1.01
slopesVariables_aTRL	41880	1.01
slopesVariables_aTRL	41870	1.01
slopesVariables_aTRL	41860	1.01
slopesVariables_aTRL	41850	1.01
slopesVariables_aTRL	41840	1.01
slopesVariables_aTRL	41830	1.01
slopesVariables_aTRL	41820	1.01
slopesVariables_aTRL	41810	1.01
slopesVariables_aTRL	41800	1.01
slopesVariables_aTRL	41790	1.01
slopesVariables_aTRL	41780	1.01
slopesVariables_aTRL	41770	1.01
slopesVariables_aTRL	41760	1.01
slopesVariables_aTRL	41750	1.01
slopesVariables_aTRL	41740	1.01
slopesVariables_aTRL	41730	1.01
slopesVariables_aTRL	41720	1.01
slopesVariables_aTRL	41710	1.01
slopesVariables_aTRL	41700	1.01
slopesVariables_aTRL	41690	1.01
slopesVariables_aTRL	41680	1.01
slopesVariables_aTRL	41670	1.01
slopesVariables_aTRL	41660	1.01
slopesVariables_aTRL	41650	1.01
slopesVariables_aTRL	41640	1.01
slopesVariables_aTRL	41630	1.01
slopesVariables_aTRL	41620	1.01
slopesVariables_aTRL	41610	1.01
slopesVariables_aTRL	41600	1.01
slopesVariables_aTRL	41590	1.01
slopesVariables_aTRL	41580	1.01
slopesVariables_aTRL	41570	1.01
slopesVariables_aTRL	41560	1.01
slopesVariables_aTRL	41550	1.01
slopesVariables_aTRL	41540	1.01
slopesVariables_aTRL	41530	1.01
slopesVariables_aTRL	41520	1.01
slopesVariables_aTRL	41510	1.01
slopesVariables_aTRL	41500	1.01
slopesVariables_aTRL	41490	1.01
slopesVariables_aTRL	41480	1.01
slopesVariables_aTRL	41470	1.01
slopesVariables_aTRL	41460	1.01
slopesVariables_aTRL	41450	1.01
slopesVariables_aTRL	41440	1.01
slopesVariables_aTRL	41430	1.01
slopesVariables_aTRL	41420	1.01
slopesVariables_aTRL	41410	1.01
slopesVariables_aTRL	41400	1.01
slopesVariables_aTRL	41390	1.01
slopesVariables_aTRL	41380	1.01
slopesVariables_aTRL	41370	1.01
slopesVariables_aTRL	41360	1.01
slopesVariables_aTRL	41350	1.01
slopesVariables_aTRL	41340	1.01
slopesVariables_aTRL	41330	1.01
slopesVariables_aTRL	41320	1.01
slopesVariables_aTRL	41310	1.01
slopesVariables_aTRL	41300	1.01
slopesVariables_aTRL	41290	1.01
slopesVariables_aTRL	41280	1.01
slopesVariables_aTRL	41270	1.01
slopesVariables_aTRL	41260	1.01
slopesVariables_aTRL	41250	1.01
slopesVariables_aTRL	41240	1.01
slopesVariables_aTRL	41230	1.01
slopesVariables_aTRL	41220	1.01
slopesVariables_aTRL	41210	1.01
slopesVariables_aTRL	41200	1.01
slopesVariables_aTRL	41190	1.01
slopesVariables_aTRL	41180	1.01
slopesVariables_aTRL	41170	1.01
slopesVariables_aTRL	41160	1.01
slopesVariables_aTRL	41150	1.01
slopesVariables_aTRL	41140	1.01
slopesVariables_aTRL	41130	1.01
slopesVariables_aTRL	41120	1.01
slopesVariables_aTRL	41110	1.01
slopesVariables_aTRL	41100	1.01
slopesVariables_aTRL	41090	1.01
slopesVariables_aTRL	41080	1.01
slopesVariables_aTRL	41070	1.01
slopesVariables_aTRL	41060	1.01
slopesVariables_aTRL	41050	1.01
slopesVariables_aTRL	41040	1.01
slopesVariables_aTRL	41030	1.01
slopesVariables_aTRL	41020	1.01
slopesVariables_aTRL	41010	1.01
slopesVariables_aTRL	41000	1.01
slopesVariables_aTRL	40990	1.01
slopesVariables_aTRL	40980	1.01
slopesVariables_aTRL	40970	1.01
slopesVariables_aTRL	40960	1.01
slopesVariables_aTRL	40950	1.01
slopesVariables_aTRL	40940	1.01
slopesVariables_aTRL	40930	1.01
slopesVariables_aTRL	40920	1.01
slopesVariables_aTRL	40910	1.01
slopesVariables_aTRL	40900	1.01
slopesVariables_aTRL	40890	1.01
slopesVariables_aTRL	40880	1.01
slopesVariables_aTRL	40870	1.01
slopesVariables_aTRL	40860	1.01
slopesVariables_aTRL	40850	1.01
slopesVariables_aTRL	40840	1.01
slopesVariables_aTRL	40830	1.01
slopesVariables_aTRL	40820	1.01
slopesVariables_aTRL	40810	1.01
slopesVariables_aTRL	40800	1.01
slopesVariables_aTRL	40790	1.01
slopesVariables_aTRL	40780	1.01
slopesVariables_aTRL	40770	1.01
slopesVariables_aTRL	40760	1.01
slopesVariables_aTRL	40750	1.01
slopesVariables_aTRL	40740	1.01
slopesVariables_aTRL	40730	1.01
slopesVariables_aTRL	40720	1.01
slopesVariables_aTRL	40710	1.01
slopesVariables_aTRL	40700	1.01
slopesVariables_aTRL	40690	1.01
slopesVariables_aTRL	40680	1.01
slopesVariables_aTRL	40670	1.01
slopesVariables_aTRL	40660	1.01
slopesVariables_aTRL	40650	1.01
slopesVariables_aTRL	40640	1.01
slopesVariables_aTRL	40630	1.01
slopesVariables_aTRL	40620	1.01
slopesVariables_aTRL	40610	1.01
slopesVariables_aTRL	40600	1.01
slopesVariables_aTRL	40590	1.01
slopesVariables_aTRL	40580	1.01
slopesVariables_aTRL	40570	1.01
slopesVariables_aTRL	40560	1.01
slopesVariables_aTRL	40550	1.01
slopesVariables_aTRL	40540	1.01
slopesVariables_aTRL	40530	1.01
slopesVariables_aTRL	40520	1.01
slopesVariables_aTRL	40510	1.01
slopesVariables_aTRL	40500	1.01








slopesVariables_aTRL	44700	1.015
slopesVariables_aTRL	44690	1.015
slopesVariables_aTRL	44680	1.015
slopesVariables_aTRL	44670	1.015
slopesVariables_aTRL	44660	1.015
slopesVariables_aTRL	44650	1.015
slopesVariables_aTRL	44640	1.015
slopesVariables_aTRL	44630	1.015
slopesVariables_aTRL	44620	1.015
slopesVariables_aTRL	44610	1.015
slopesVariables_aTRL	44600	1.015
slopesVariables_aTRL	44590	1.015
slopesVariables_aTRL	44580	1.015
slopesVariables_aTRL	44570	1.015
slopesVariables_aTRL	44560	1.015
slopesVariables_aTRL	44550	1.015
slopesVariables_aTRL	44540	1.015
slopesVariables_aTRL	44530	1.015
slopesVariables_aTRL	44520	1.015
slopesVariables_aTRL	44510	1.015
slopesVariables_aTRL	44500	1.015
slopesVariables_aTRL	44490	1.015
slopesVariables_aTRL	44480	1.015
slopesVariables_aTRL	44470	1.015
slopesVariables_aTRL	44460	1.015
slopesVariables_aTRL	44450	1.015
slopesVariables_aTRL	44440	1.015
slopesVariables_aTRL	44430	1.015
slopesVariables_aTRL	44420	1.015
slopesVariables_aTRL	44410	1.015
slopesVariables_aTRL	44400	1.015
slopesVariables_aTRL	44390	1.015
slopesVariables_aTRL	44380	1.015
slopesVariables_aTRL	44370	1.015
slopesVariables_aTRL	44360	1.015
slopesVariables_aTRL	44350	1.015
slopesVariables_aTRL	44340	1.015
slopesVariables_aTRL	44330	1.015
slopesVariables_aTRL	44320	1.015
slopesVariables_aTRL	44310	1.015
slopesVariables_aTRL	44300	1.015
slopesVariables_aTRL	44290	1.015
slopesVariables_aTRL	44280	1.015
slopesVariables_aTRL	44270	1.015
slopesVariables_aTRL	44260	1.015
slopesVariables_aTRL	44250	1.015
slopesVariables_aTRL	44240	1.015
slopesVariables_aTRL	44230	1.015
slopesVariables_aTRL	44220	1.015
slopesVariables_aTRL	44210	1.015
slopesVariables_aTRL	44200	1.015
slopesVariables_aTRL	44190	1.015
slopesVariables_aTRL	44180	1.015
slopesVariables_aTRL	44170	1.015
slopesVariables_aTRL	44160	1.015
slopesVariables_aTRL	44150	1.015
slopesVariables_aTRL	44140	1.015
slopesVariables_aTRL	44130	1.015
slopesVariables_aTRL	44120	1.015
slopesVariables_aTRL	44110	1.015
slopesVariables_aTRL	44100	1.015
slopesVariables_aTRL	44090	1.015
slopesVariables_aTRL	44080	1.015
slopesVariables_aTRL	44070	1.015
slopesVariables_aTRL	44060	1.015
slopesVariables_aTRL	44050	1.015
slopesVariables_aTRL	44040	1.015
slopesVariables_aTRL	44030	1.015
slopesVariables_aTRL	44020	1.015
slopesVariables_aTRL	44010	1.015
slopesVariables_aTRL	44000	1.015
slopesVariables_aTRL	43990	1.015
slopesVariables_aTRL	43980	1.015
slopesVariables_aTRL	43970	1.015
slopesVariables_aTRL	43960	1.015
slopesVariables_aTRL	43950	1.015
slopesVariables_aTRL	43940	1.015
slopesVariables_aTRL	43930	1.015
slopesVariables_aTRL	43920	1.015
slopesVariables_aTRL	43910	1.015
slopesVariables_aTRL	43900	1.015
slopesVariables_aTRL	43890	1.015
slopesVariables_aTRL	43880	1.015
slopesVariables_aTRL	43870	1.015
slopesVariables_aTRL	43860	1.015
slopesVariables_aTRL	43850	1.015
slopesVariables_aTRL	43840	1.015
slopesVariables_aTRL	43830	1.015
slopesVariables_aTRL	43820	1.015
slopesVariables_aTRL	43810	1.015
slopesVariables_aTRL	43800	1.015
slopesVariables_aTRL	43790	1.015
slopesVariables_aTRL	43780	1.015
slopesVariables_aTRL	43770	1.015
slopesVariables_aTRL	43760	1.015
slopesVariables_aTRL	43750	1.015
slopesVariables_aTRL	43740	1.015
slopesVariables_aTRL	43730	1.015
slopesVariables_aTRL	43720	1.015
slopesVariables_aTRL	43710	1.015
slopesVariables_aTRL	43700	1.015
slopesVariables_aTRL	43690	1.015
slopesVariables_aTRL	43680	1.015
slopesVariables_aTRL	43670	1.015
slopesVariables_aTRL	43660	1.015
slopesVariables_aTRL	43650	1.015
slopesVariables_aTRL	43640	1.015
slopesVariables_aTRL	43630	1.015
slopesVariables_aTRL	43620	1.015
slopesVariables_aTRL	43610	1.015
slopesVariables_aTRL	43600	1.015
slopesVariables_aTRL	43590	1.015
slopesVariables_aTRL	43580	1.015
slopesVariables_aTRL	43570	1.015
slopesVariables_aTRL	43560	1.015
slopesVariables_aTRL	43550	1.015
slopesVariables_aTRL	43540	1.015
slopesVariables_aTRL	43530	1.015
slopesVariables_aTRL	43520	1.015
slopesVariables_aTRL	43510	1.015
slopesVariables_aTRL	43500	1.015
slopesVariables_aTRL	43490	1.015
slopesVariables_aTRL	43480	1.015
slopesVariables_aTRL	43470	1.015
slopesVariables_aTRL	43460	1.015
slopesVariables_aTRL	43450	1.015
slopesVariables_aTRL	43440	1.015
slopesVariables_aTRL	43430	1.015
slopesVariables_aTRL	43420	1.015
slopesVariables_aTRL	43410	1.015
slopesVariables_aTRL	43400	1.015
slopesVariables_aTRL	43390	1.015
slopesVariables_aTRL	43380	1.015
slopesVariables_aTRL	43370	1.015
slopesVariables_aTRL	43360	1.015
slopesVariables_aTRL	43350	1.015
slopesVariables_aTRL	43340	1.015
slopesVariables_aTRL	43330	1.015
slopesVariables_aTRL	43320	1.015
slopesVariables_aTRL	43310	1.015
slopesVariables_aTRL	43300	1.015
slopesVariables_aTRL	43290	1.015
slopesVariables_aTRL	43280	1.015
slopesVariables_aTRL	43270	1.015
slopesVariables_aTRL	43260	1.015
slopesVariables_aTRL	43250	1.015
slopesVariables_aTRL	43240	1.015
slopesVariables_aTRL	43230	1.015
slopesVariables_aTRL	43220	1.015
slopesVariables_aTRL	43210	1.015
slopesVariables_aTRL	43200	1.015
slopesVariables_aTRL	43190	1.015
slopesVariables_aTRL	43180	1.015
slopesVariables_aTRL	43170	1.015
slopesVariables_aTRL	43160	1.015
slopesVariables_aTRL	43150	1.015
slopesVariables_aTRL	43140	1.015
slopesVariables_aTRL	43130	1.015
slopesVariables_aTRL	43120	1.015
slopesVariables_aTRL	43110	1.015
slopesVariables_aTRL	43100	1.015
slopesVariables_aTRL	43090	1.015
slopesVariables_aTRL	43080	1.015
slopesVariables_aTRL	43070	1.015
slopesVariables_aTRL	43060	1.015
slopesVariables_aTRL	43050	1.015
slopesVariables_aTRL	43040	1.015
slopesVariables_aTRL	43030	1.015
slopesVariables_aTRL	43020	1.015
slopesVariables_aTRL	43010	1.015
slopesVariables_aTRL	43000	1.015
slopesVariables_aTRL	42990	1.015
slopesVariables_aTRL	42980	1.015
slopesVariables_aTRL	42970	1.015
slopesVariables_aTRL	42960	1.015
slopesVariables_aTRL	42950	1.015
slopesVariables_aTRL	42940	1.015
slopesVariables_aTRL	42930	1.015
slopesVariables_aTRL	42920	1.015
slopesVariables_aTRL	42910	1.015
slopesVariables_aTRL	42900	1.015
slopesVariables_aTRL	42890	1.015
slopesVariables_aTRL	42880	1.015
slopesVariables_aTRL	42870	1.015
slopesVariables_aTRL	42860	1.015
slopesVariables_aTRL	42850	1.015
slopesVariables_aTRL	42840	1.015
slopesVariables_aTRL	42830	1.015
slopesVariables_aTRL	42820	1.015
slopesVariables_aTRL	42810	1.015
slopesVariables_aTRL	42800	1.015
slopesVariables_aTRL	42790	1.015
slopesVariables_aTRL	42780	1.015
slopesVariables_aTRL	42770	1.015
slopesVariables_aTRL	42760	1.015
slopesVariables_aTRL	42750	1.015
slopesVariables_aTRL	42740	1.015
slopesVariables_aTRL	42730	1.015
slopesVariables_aTRL	42720	1.015
slopesVariables_aTRL	42710	1.015
slopesVariables_aTRL	42700	1.015
slopesVariables_aTRL	42690	1.015
slopesVariables_aTRL	42680	1.015
slopesVariables_aTRL	42670	1.015
slopesVariables_aTRL	42660	1.015
slopesVariables_aTRL	42650	1.015
slopesVariables_aTRL	42640	1.015
slopesVariables_aTRL	42630	1.015
slopesVariables_aTRL	42620	1.015
slopesVariables_aTRL	42610	1.015
slopesVariables_aTRL	42600	1.015
slopesVariables_aTRL	42590	1.015
slopesVariables_aTRL	42580	1.015
slopesVariables_aTRL	42570	1.015
slopesVariables_aTRL	42560	1.015
slopesVariables_aTRL	42550	1.015
slopesVariables_aTRL	42540	1.015
slopesVariables_aTRL	42530	1.015
slopesVariables_aTRL	42520	1.015
slopesVariables_aTRL	42510	1.015
slopesVariables_aTRL	42500	1.015
slopesVariables_aTRL	42490	1.015
slopesVariables_aTRL	42480	1.015
slopesVariables_aTRL	42470	1.015
slopesVariables_aTRL	42460	1.015
slopesVariables_aTRL	42450	1.015
slopesVariables_aTRL	42440	1.015
slopesVariables_aTRL	42430	1.015
slopesVariables_aTRL	42420	1.015
slopesVariables_aTRL	42410	1.015
slopesVariables_aTRL	42400	1.015
slopesVariables_aTRL	42390	1.015
slopesVariables_aTRL	42380	1.015
slopesVariables_aTRL	42370	1.015
slopesVariables_aTRL	42360	1.015
slopesVariables_aTRL	42350	1.015
slopesVariables_aTRL	42340	1.015
slopesVariables_aTRL	42330	1.015
slopesVariables_aTRL	42320	1.015
slopesVariables_aTRL	42310	1.015
slopesVariables_aTRL	42300	1.015
slopesVariables_aTRL	42290	1.015
slopesVariables_aTRL	42280	1.015
slopesVariables_aTRL	42270	1.015
slopesVariables_aTRL	42260	1.015
slopesVariables_aTRL	42250	1.015
slopesVariables_aTRL	42240	1.015
slopesVariables_aTRL	42230	1.015
slopesVariables_aTRL	42220	1.015
slopesVariables_aTRL	42210	1.015
slopesVariables_aTRL	42200	1.015
slopesVariables_aTRL	42190	1.015
slopesVariables_aTRL	42180	1.015
slopesVariables_aTRL	42170	1.015
slopesVariables_aTRL	42160	1.015
slopesVariables_aTRL	42150	1.015
slopesVariables_aTRL	42140	1.015
slopesVariables_aTRL	42130	1.015
slopesVariables_aTRL	42120	1.015
slopesVariables_aTRL	42110	1.015
slopesVariables_aTRL	42100	1.015
slopesVariables_aTRL	42090	1.015
slopesVariables_aTRL	42080	1.015
slopesVariables_aTRL	42070	1.015
slopesVariables_aTRL	42060	1.015
slopesVariables_aTRL	42050	1.015
slopesVariables_aTRL	42040	1.015
slopesVariables_aTRL	42030	1.015
slopesVariables_aTRL	42020	1.015
slopesVariables_aTRL	42010	1.015
slopesVariables_aTRL	42000	1.015
slopesVariables_aTRL	41990	1.015
slopesVariables_aTRL	41980	1.015
slopesVariables_aTRL	41970	1.015
slopesVariables_aTRL	41960	1.015
slopesVariables_aTRL	41950	1.015
slopesVariables_aTRL	41940	1.015
slopesVariables_aTRL	41930	1.015
slopesVariables_aTRL	41920	1.015
slopesVariables_aTRL	41910	1.015
slopesVariables_aTRL	41900	1.015
slopesVariables_aTRL	41890	1.015
slopesVariables_aTRL	41880	1.015
slopesVariables_aTRL	41870	1.015
slopesVariables_aTRL	41860	1.015
slopesVariables_aTRL	41850	1.015
slopesVariables_aTRL	41840	1.015
slopesVariables_aTRL	41830	1.015
slopesVariables_aTRL	41820	1.015
slopesVariables_aTRL	41810	1.015
slopesVariables_aTRL	41800	1.015
slopesVariables_aTRL	41790	1.015
slopesVariables_aTRL	41780	1.015
slopesVariables_aTRL	41770	1.015
slopesVariables_aTRL	41760	1.015
slopesVariables_aTRL	41750	1.015
slopesVariables_aTRL	41740	1.015
slopesVariables_aTRL	41730	1.015
slopesVariables_aTRL	41720	1.015
slopesVariables_aTRL	41710	1.015
slopesVariables_aTRL	41700	1.015
slopesVariables_aTRL	41690	1.015
slopesVariables_aTRL	41680	1.015
slopesVariables_aTRL	41670	1.015
slopesVariables_aTRL	41660	1.015
slopesVariables_aTRL	41650	1.015
slopesVariables_aTRL	41640	1.015
slopesVariables_aTRL	41630	1.015
slopesVariables_aTRL	41620	1.015
slopesVariables_aTRL	41610	1.015
slopesVariables_aTRL	41600	1.015
slopesVariables_aTRL	41590	1.015
slopesVariables_aTRL	41580	1.015
slopesVariables_aTRL	41570	1.015
slopesVariables_aTRL	41560	1.015
slopesVariables_aTRL	41550	1.015
slopesVariables_aTRL	41540	1.015
slopesVariables_aTRL	41530	1.015
slopesVariables_aTRL	41520	1.015
slopesVariables_aTRL	41510	1.015
slopesVariables_aTRL	41500	1.015
slopesVariables_aTRL	41490	1.015
slopesVariables_aTRL	41480	1.015
slopesVariables_aTRL	41470	1.015
slopesVariables_aTRL	41460	1.015
slopesVariables_aTRL	41450	1.015
slopesVariables_aTRL	41440	1.015
slopesVariables_aTRL	41430	1.015
slopesVariables_aTRL	41420	1.015
slopesVariables_aTRL	41410	1.015
slopesVariables_aTRL	41400	1.015
slopesVariables_aTRL	41390	1.015
slopesVariables_aTRL	41380	1.015
slopesVariables_aTRL	41370	1.015
slopesVariables_aTRL	41360	1.015
slopesVariables_aTRL	41350	1.015
slopesVariables_aTRL	41340	1.015
slopesVariables_aTRL	41330	1.015
slopesVariables_aTRL	41320	1.015
slopesVariables_aTRL	41310	1.015
slopesVariables_aTRL	41300	1.015
slopesVariables_aTRL	41290	1.015
slopesVariables_aTRL	41280	1.015
slopesVariables_aTRL	41270	1.015
slopesVariables_aTRL	41260	1.015
slopesVariables_aTRL	41250	1.015
slopesVariables_aTRL	41240	1.015
slopesVariables_aTRL	41230	1.015
slopesVariables_aTRL	41220	1.015
slopesVariables_aTRL	41210	1.015
slopesVariables_aTRL	41200	1.015
slopesVariables_aTRL	41190	1.015
slopesVariables_aTRL	41180	1.015
slopesVariables_aTRL	41170	1.015
slopesVariables_aTRL	41160	1.015
slopesVariables_aTRL	41150	1.015
slopesVariables_aTRL	41140	1.015
slopesVariables_aTRL	41130	1.015
slopesVariables_aTRL	41120	1.015
slopesVariables_aTRL	41110	1.015
slopesVariables_aTRL	41100	1.015
slopesVariables_aTRL	41090	1.015
slopesVariables_aTRL	41080	1.015
slopesVariables_aTRL	41070	1.015
slopesVariables_aTRL	41060	1.015
slopesVariables_aTRL	41050	1.015
slopesVariables_aTRL	41040	1.015
slopesVariables_aTRL	41030	1.015
slopesVariables_aTRL	41020	1.015
slopesVariables_aTRL	41010	1.015
slopesVariables_aTRL	41000	1.015
slopesVariables_aTRL	40990	1.015
slopesVariables_aTRL	40980	1.015
slopesVariables_aTRL	40970	1.015
slopesVariables_aTRL	40960	1.015
slopesVariables_aTRL	40950	1.015
slopesVariables_aTRL	40940	1.015
slopesVariables_aTRL	40930	1.015
slopesVariables_aTRL	40920	1.015
slopesVariables_aTRL	40910	1.015
slopesVariables_aTRL	40900	1.015
slopesVariables_aTRL	40890	1.015
slopesVariables_aTRL	40880	1.015
slopesVariables_aTRL	40870	1.015
slopesVariables_aTRL	40860	1.015
slopesVariables_aTRL	40850	1.015
slopesVariables_aTRL	40840	1.015
slopesVariables_aTRL	40830	1.015
slopesVariables_aTRL	40820	1.015
slopesVariables_aTRL	40810	1.015
slopesVariables_aTRL	40800	1.015
slopesVariables_aTRL	40790	1.015
slopesVariables_aTRL	40780	1.015
slopesVariables_aTRL	40770	1.015
slopesVariables_aTRL	40760	1.015
slopesVariables_aTRL	40750	1.015
slopesVariables_aTRL	40740	1.015
slopesVariables_aTRL	40730	1.015
slopesVariables_aTRL	40720	1.015
slopesVariables_aTRL	40710	1.015
slopesVariables_aTRL	40700	1.015
slopesVariables_aTRL	40690	1.015
slopesVariables_aTRL	40680	1.015
slopesVariables_aTRL	40670	1.015
slopesVariables_aTRL	40660	1.015
slopesVariables_aTRL	40650	1.015
slopesVariables_aTRL	40640	1.015
slopesVariables_aTRL	40630	1.015
slopesVariables_aTRL	40620	1.015
slopesVariables_aTRL	40610	1.015
slopesVariables_aTRL	40600	1.015
slopesVariables_aTRL	40590	1.015
slopesVariables_aTRL	40580	1.015
slopesVariables_aTRL	40570	1.015
slopesVariables_aTRL	40560	1.015
slopesVariables_aTRL	40550	1.015
slopesVariables_aTRL	40540	1.015
slopesVariables_aTRL	40530	1.015
slopesVariables_aTRL	40520	1.015
slopesVariables_aTRL	40510	1.015
slopesVariables_aTRL	40500	1.015



