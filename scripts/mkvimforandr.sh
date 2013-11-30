#!/bin/bash                                                                
#file: mkcsdb
#function: make cscope database and ctags database for android source

ignore="( -name .git -o -name test -o -name tests ) -prune -o"
type="( -name *.java -o -name *.cpp -o -name *.[ch] -o -name
*.aidl )"

android=$ANDROID_SRC

path="$android/frameworks \
    $android/hardware \
    $android/kernel \
    $android/mediatek \
    $android/packages \
    $android/vendor"

cscopedb=$ANDROID_SRC/cscope

prepare()
{
    if [ ! -d $ANDROID_SRC ]; then
        echo "no ANDROID_SRC set"
        echo "please set ANDROID_SRC at your .bashrc file"
        exit 1
    else
        echo "ANDROID_SRC:$ANDROID_SRC"
        if [ -d $cscopedb ]; then
            echo "$cscopedb exist already"
            if [ -e $cscopedb/cscope.files ]; then
                echo "file $cscopedb/cscope.files exist"
                #rm $cscopedb/cscope.files
            fi
        else
            mkdir $cscopedb
            echo "make directory $cscopedb"
        fi
    fi
    all_source | sort > $cscopedb/cscope.files
    lines=$(wc -l $cscopedb/cscope.files | awk '{ printf $1 }')
    echo "find $lines files totaly"
}

all_source()
{
    for src in $path
    do
        find -L $src $ignore $type -print
    done
}

docscope()
{
    echo "Now begin build cscope cross-index file"
    start=`date +%s`
    cscope -b -k -q -i $cscopedb/cscope.files -f $cscopedb/cscope.out
    end=`date +%s`
    let "elapse=$end-$start"
    if [ $? -eq 0 ]; then
        echo "make cscope database file with total time ($elapse) seconds"
        size=$(du $cscopedb/cscope.out -h | awk '{ printf $1 }')
        echo "($cscopedb/cscope.out):$size"
    fi  
}

dotags()
{
    echo "Now begin build tags file"
    start=`date +%s`
    ctags --fields=+afiKlmnsSzt -L $cscopedb/cscope.files -f $cscopedb/tags
    end=`date +%s`
    let "elapse=$end-$start"
    if [ $? -eq 0 ]; then
        echo "make ctags database file with total time ($elapse) seconds"
        size=$(du $cscopedb/tags -h | awk '{ printf $1 }')
        echo "($cscopedb/tags):$size"
    fi  
}

dolookups()
{
    # generate tag file for lookupfile plugin
    echo "!_TAG_FILE_SORTED	2	/2=foldcase/" > $cscopedb/filenametags
    for src in $path
    do
        find -L $src $ignore $type      \
            -printf "%f\t%p\t1\n"       \
            | sort -f >> $cscopedb/filenametags
    done
}

usage() 
{
    echo "Usages:"
    echo "cscope  : make cscope database only"
    echo "tags    : make ctags database only"
    echo "lookup  : make lookup list only"
    echo "all     : make two databases and lookup list"
}

case $1 in
    "cscope")
        prepare
        docscope
        ;;

    "tags")
        prepare
        dotags
        ;;  

    "lookup")
        prepare
        dolookups
        ;;  

    "all")
        prepare
        docscope
        dotags
        dolookups
        ;;
    "")
        usage
        ;;
esac
