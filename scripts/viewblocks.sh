#!/bin/bash

if [ $# -ne 2 ]; then
	echo -e "\nUso: $0 <first_image> <last_image>\n"
	exit 1
fi

i=$1
while [ $i -le $2 ]; do

	index=`printf %03d $i`

	list="$list blocks/$index.blocks.pgm "

	i=$(($i+1))
done

animate $list