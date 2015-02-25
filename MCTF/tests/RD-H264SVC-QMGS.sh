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

cat > main.cfg << EOF
# JSVM Main Configuration File

OutputFile              stream.264 # Bitstream file
FrameRate               $FPS       # Maximum frame rate [Hz]
FramesToBeEncoded       $PICTURES  # Number of frames (at input frame rate)
GOPSize                 16  # GOP Size (at maximum frame rate)
IntraPeriod             $GOP_SIZE  # Intra period
BaseLayerMode           2          # Base layer mode (0,1: AVC compatible,
                                   #                    2: AVC w subseq SEI)
CgsSnrRefinement        1          # SNR refinement as 1: MGS; 0: CGS
EncodeKeyPictures       1          # Key pics at T=0 (0:none, 1:MGS, 2:all)
MGSControl              2          # ME/MC for non-key pictures in MGS layers
                                   # (0:std, 1:ME with EL, 2:ME+MC with EL)
SearchMode              4          # Search mode (0:BlockSearch, 4:FastSearch)
SearchRange             32         # Search range (Full Pel)
NumLayers               2          # Number of layers
LayerCfg                layer0.cfg # Layer configuration file
LayerCfg                layer1.cfg # Layer configuration file
EOF

cat > layer0.cfg << EOF
# JSVM Layer Configuration File

InputFile            $DATA/$VIDEO.yuv # Input  file
SourceWidth          $X_DIM           # Input  frame width
SourceHeight         $Y_DIM           # Input  frame height
FrameRateIn          $FPS             # Input  frame rate [Hz]
FrameRateOut         $FPS             # Output frame rate [Hz]
EOF

# At most 16 quality layers are supported in SVC

cat > layer1.cfg << EOF
# JSVM Layer Configuration File

InputFile            $DATA/$VIDEO.yuv # Input  file
SourceWidth          $X_DIM           # Input  frame width
SourceHeight         $Y_DIM           # Input  frame height
FrameRateIn          $FPS             # Input  frame rate [Hz]
FrameRateOut         $FPS             # Output frame rate [Hz]
InterLayerPred       1                # Inter-layer Prediction (0: no, 1: yes, 2:adaptive)
MGSVectorMode        1                # MGS vector usage selection
MGSVector0           1                # Specifies 0th position of the vector 
MGSVector1           1                # Specifies 1st position of the vector
MGSVector2           1                # Specifies 2nd position of the vectorEOF
MGSVector3           1                # Specifies 3nd position of the vectorEOF
MGSVector4           1                # Specifies 4nd position of the vectorEOF
MGSVector5           1                # Specifies 5nd position of the vectorEOF
MGSVector6           1                # Specifies 6nd position of the vectorEOF
MGSVector7           1                # Specifies 7nd position of the vectorEOF
MGSVector8           1                # Specifies 8nd position of the vectorEOF
MGSVector9           1                # Specifies 9nd position of the vectorEOF
MGSVector10          1                # Specifies 10nd position of the vectorEOF
MGSVector11          1                # Specifies 11nd position of the vectorEOF
MGSVector12          1                # Specifies 12nd position of the vectorEOF
MGSVector13          1                # Specifies 13nd position of the vectorEOF
MGSVector14          1                # Specifies 14nd position of the vectorEOF
MGSVector15          1                # Specifies 15nd position of the vectorEOF
EOF

echo "H264AVCEncoderLibTestStatic -pf main.cfg -lqp $0 $Q_SCALE -rqp 0 $[Q_SCALE+2]  -lqp $1 $Q_SCALE -rqp 1 $[Q_SCALE+2]" >> trace
(H264AVCEncoderLibTestStatic -pf main.cfg -lqp $0 $Q_SCALE -rqp 0 $[Q_SCALE+2]  -lqp $1 $Q_SCALE -rqp 1 $[Q_SCALE+2] 1>&2)
codestream_bytes=`wc -c < stream.264`
#rm stream.264
rate=`echo "$codestream_bytes*8/$TIME/1000" | bc -l`
RMSE=`snr --file_A=$DATA/$VIDEO.yuv --file_B=rec.yuv 2> /dev/null | grep RMSE | cut -f 3`
rm rec.yuv
echo -e $rate'\t'$RMSE

set +x
