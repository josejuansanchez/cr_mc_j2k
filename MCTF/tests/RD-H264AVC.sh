#!/bin/bash

# Calcula un punto de la curva RD y lo envía a la salida estándar.

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
# JSVM Configuration File in AVC mode

#====================== GENERAL ================================================
AVCMode                 1          # must be one for AVC simulations
InputFile               $DATA/$VIDEO.yuv  # input file
OutputFile              stream.264 # bitstream file
ReconFile               rec.yuv    # reconstructed file
SourceWidth             $X_DIM     # input frame width
SourceHeight            $Y_DIM     # input frame height
FrameRate               $FPS       # frame rate [Hz]
FramesToBeEncoded       $PICTURES  # number of frames

#====================== CODING =================================================
SymbolMode              1          # 0=CAVLC, 1=CABAC
Enable8x8Transform      1          # 8x8 luma trafo (0:diabled, 1:enabled)
ConstrainedIntraPred    0          # constrained intra prediction (0:off, 1:on)
ScalingMatricesPresent  1          # scaling matrices (0:flat, 1:default)
BiPred8x8Disable        0          # disable bi-predicted blocks smaller than 8x8
MCBlocksLT8x8Disable    0          # blocks smaller than 8x8 are disabled
BasisQP                 $Q_SCALE   # Quantization parameters

#====================== STRUCTURE ==============================================
DPBSize                 16         # decoded picture buffer in frames
NumRefFrames            16         # maximum number of stored reference frames
Log2MaxFrameNum         11         # specifies max. value for frame_num (4..16)
Log2MaxPocLsb           7          # specifies coding of POC’s (4..15)
SequenceFormatString    A0L0*74{P3L0B1L1b0L2b2L2}*1{B1L1b0L2b2L2}
                                   # coding structure
DeltaLayer0Quant        0          # differential QP for layer 0
DeltaLayer1Quant        3          # differential QP for layer 1
DeltaLayer2Quant        4          # differential QP for layer 2
DeltaLayer3Quant        5          # differential QP for layer 3
DeltaLayer4Quant        6          # differential QP for layer 4
DeltaLayer5Quant        7          # differential QP for layer 5
MaxRefIdxActiveBL0      2          # active entries in ref list 0 for B slices
MaxRefIdxActiveBL1      2          # active entries in ref list 1 for B slices
MaxRefIdxActiveP        1          # active entries in ref list for P slices

#============================== MOTION SEARCH ==================================
SearchMode              4          # Search mode (0:BlockSearch, 4:FastSearch)
SearchFuncFullPel       3          # Search function full pel
                                   #   (0:SAD, 1:SSE, 2:HADAMARD, 3:SAD-YUV) 
SearchFuncSubPel        2          # Search function sub pel
                                   #   (0:SAD, 1:SSE, 2:HADAMARD) 
SearchRange             32         # Search range (Full Pel)
FastBiSearch            1          # Fast bi-directional search (0:off, 1:on)
BiPredIter              4          # Max iterations for bi-pred search
IterSearchRange         8          # Search range for iterations (0: normal)

#============================== LOOP FILTER ====================================
LoopFilterDisable       0          # Loop filter idc (0: on, 1: off, 2:
                                   #   on except for slice boundaries)
LoopFilterAlphaC0Offset 0          # AlphaOffset(-6..+6): valid range
LoopFilterBetaOffset    0          # BetaOffset (-6..+6): valid range

#============================== WEIGHTED PREDICTION ============================
WeightedPrediction      0          # Weighting IP Slice (0:disable, 1:enable)
WeightedBiprediction    0          # Weighting B  Slice (0:disable, 1:explicit,
                                                         2:implicit)

#=============================== HRD =====================================
EnableVclHRD            0          # Type I HRD  (default 0:Off, 1:on) 
EnableNalHRD            0          # Type II HRD (default 0:Off, 1:on)
EOF

(H264AVCEncoderLibTestStatic -pf main.cfg 1>&2)
echo "Q_SCALE=$Q_SCALE" >> trace
codestream_bytes=`wc -c < stream.264`
rm stream.264
rate=`echo "$codestream_bytes*8/$TIME/1000" | bc -l`
RMSE=`snr --file_A=$DATA/$VIDEO.yuv --file_B=rec.yuv 2> /dev/null | grep RMSE | cut -f 3`
rm rec.yuv
echo -e $rate'\t'$RMSE

set +x
