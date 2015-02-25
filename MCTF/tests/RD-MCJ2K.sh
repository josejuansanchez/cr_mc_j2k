#!/bin/bash

VIDEO=mobile_352x288x30x420x300
GOPs=1 # Without including the first GOP (that has only a I image)
Y_DIM=288
X_DIM=352
FPS=30
Q_SCALES="45000,44000"
TRLs=5
# TRLs=1 GOP_SIZE=1
# TRLs=2 GOP_SIZE=2
# TRLs=3 GOP_SIZE=4
# TRLs=4 GOP_SIZE=8
# TRLs=5 GOP_SIZE=16
# TRLs=6 GOP_SIZE=32
IBS=16 # Initial block_size
FBS=16 # Final block size
SEARCH_RANGE=4

usage() {
    echo $0
    echo "  [-v video file name ($VIDEO)]"
    echo "  [-g number of GOPs to compress ($GOPs)]"
    echo "  [-x X dimension ($X_DIM)]"
    echo "  [-y Y dimension ($Y_DIM)]"
    echo "  [-f frames/second ($FPS)]"
    echo "  [-q quantization scales ($Q_SCALES)]"
    echo "  [-t temporal resolution levels ($TRLs)]"
    echo "  [-? (help)]"
}

(echo $0 $@ 1>&2)

while getopts "v:g:x:y:f:q:t:?" opt; do
    case ${opt} in
	v)
	    VIDEO="${OPTARG}"
	    ;;
	g)
	    GOPs="${OPTARG}"
	    ;;
	x)
	    X_DIM="${OPTARG}"
	    ;;
	y)
	    Y_DIM="${OPTARG}"
	    ;;
	f)
	    FPS="${OPTARG}"
	    ;;
	q)
	    Q_SCALES="${OPTARG}"
	    ;;
	t)
	    TRLs="${OPTARG}"
	    ;;
	?)
            usage
            exit 0
            ;;
        \?)
            echo "Invalid option: -${OPTARG}" >&2
            usage
            exit 1
            ;;
        :)
            echo "Option -${OPTARG} requires an argument." >&2
	    usage
            exit 1
            ;;
    esac
done

set -x

GOP_SIZE=$[2**(TRLs-1)]
PICTURES=$[(GOPs*GOP_SIZE)+1]
TIME=`echo "$PICTURES/$FPS" | bc -l`

rm *.j2c *.mjc *type*
(mcj2k compress --quantization_texture=$Q_SCALES --GOPs=$GOPs --TRLs=$TRLs --block_size=$IBS --block_size_min=$FBS --search_range=$SEARCH_RANGE --pixels_in_x=$X_DIM --pixels_in_y=$Y_DIM 1>&2)
rm -rf tmp; mkdir tmp; cp *.j2c *.mjc *type* tmp; cd tmp
(mcj2k expand --GOPs=$GOPs --TRLs=$TRLs --block_size=$IBS --block_size_min=$FBS --search_range=$search_range --pixels_in_x=$X_DIM --pixels_in_y=$Y_DIM 1>&2)
rate=`mcj2k info --GOPs=$GOPs --TRLs=$TRLs --pictures_per_second=$FPS | grep "Total average:" | cut -d " " -f 3`
RMSE=`snr --file_A=../low_0 --file_B=low_0 2> /dev/null | grep RMSE | cut -f 3`
echo -e $rate'\t'$RMSE
cd ..

set +x
