if [ -z "$MCTF" ]; then
    echo "The environment variable MCTF is undefined."
    echo 'MCTF must point to the MCTF directory (maybe you should run "export MCTF=$HOME/motriz2010/src/MCTF")'
    exit 1
fi
