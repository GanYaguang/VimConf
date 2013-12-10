#!/bin/bash

if [ $# != 3 ]; then
    echo "USAGE: $0 src_base_dir dest_base_dir com_dir"
    exit 1;
fi

cd $1

FILES=`find $3 -type f`

for file in $FILES
do
    if [ -e $file ] && [ -f $file ]; then
        md51=`md5sum $file | awk '{print $1}'`
        md52=`md5sum $2/$file | awk '{print $1}'`
        if [ "$md51" != "$md52" ]; then
            echo $file different !!!!!!!!!!  $md51 $md52
        fi
    else
        echo "FAIL: [ $file ] NOT EXIST!"
    fi
done

cd -
