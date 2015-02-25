if [ -z "$DATA" ]; then
    echo "The environment variable DATA is undefined."
    echo 'DATA must point to the video repository (maybe you should run "export DATA=$HOME/motriz2010/data")'
    exit 1
fi
