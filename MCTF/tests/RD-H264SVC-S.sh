#!/bin/bash

VIDEO=mobile_352x288x30x420x300
PICTURES=33
Y_DIM=288
X_DIM=352
FPS=30
Q_SCALE=20
GOP_SIZE=32
TIME=`echo "$PICTURES/$FPS" | bc -l`

usage() {
    echo $0
    echo "  [-v video file name ($VIDEO)]"
    echo "  [-p pictures to compress ($PICTURES)]"
    echo "  [-x X dimension ($X_DIM)]"
    echo "  [-y Y dimension ($Y_DIM)]"
    echo "  [-f frames/second ($FPS)]"
    echo "  [-q quantization scale ($Q_SCALE)]"
    echo "  [-g GOP size ($GOP_SIZE)]"
    echo "  [-? (help)]"
}

(echo $0 $@ 1>&2)

while getopts "v:p:x:y:f:q:g:?" opt; do
    case ${opt} in
	v)
	    VIDEO="${OPTARG}"
	    ;;
	p)
	    PICTURES="${OPTARG}"
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
	    Q_SCALE="${OPTARG}"
	    ;;
	g)
	    GOP_SIZE="${OPTARG}"
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

S_LEVELS=3 # At most 3 dependent dependency layers are supported in SVC
# 16 is the maximun GOP size

cat > main.cfg << EOF
# JSVM Main Configuration File

OutputFile              stream.264 # Bitstream file
FrameRate               $FPS       # Maximum frame rate [Hz]
FramesToBeEncoded       $PICTURES  # Number of frames (at input frame rate)
GOPSize                 16         # GOP Size (at maximum frame rate)
IntraPeriod             $GOP_SIZE  # Intra period
BaseLayerMode           2          # Base layer mode (0,1: AVC compatible,
                                   #                    2: AVC w subseq SEI)
SearchMode              4          # Search mode (0:BlockSearch, 4:FastSearch)
SearchRange             32         # Search range (Full Pel)
NumLayers               $S_LEVELS  # Number of layers
EOF

S=0
while [ $S -lt $S_LEVELS ]
do
    cat >> main.cfg << EOF
LayerCfg                layer_$S.cfg # Layer configuration file
EOF
    let S=S+1
done

S=$S_LEVELS
while [ $S -gt 0 ]
do
    cat > layer_$[S-1].cfg << EOF
# JSVM Layer Configuration File

InputFile            $DATA/$VIDEO.yuv # Input  file
SourceWidth          $[X_DIM/(2**(S_LEVELS-S))]  # Input  frame width
SourceHeight         $[Y_DIM/(2**(S_LEVELS-S))]  # Input  frame height
FrameRateIn          $FPS             # Input  frame rate [Hz]
FrameRateOut         $FPS             # Output frame rate [Hz]
EOF
    let S=S-1
done

echo -n "(H264AVCEncoderLibTestStatic -pf main.cfg" > call_encoder
S=0
while [ $S -lt $S_LEVELS ]
do
    echo -n " -lqp $S $Q_SCALE" >> call_encoder
    let S=S+1
done
echo " 1>&2)" >> call_encoder

chmod +x ./call_encoder
source ./call_encoder
cat ./call_encoder >> trace
codestream_bytes=`wc -c < stream.264`
#rm stream.264
rate=`echo "$codestream_bytes*8/$TIME/1000" | bc -l`
RMSE=`snr --file_A=$DATA/$VIDEO.yuv --file_B=rec.yuv 2> /dev/null | grep RMSE | cut -f 3`
rm rec.yuv
echo -e $rate'\t'$RMSE

set +x
