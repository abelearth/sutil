#!/bin/bash
#set -x

PCD_DATA_SPACE=6536
FLASH_SIZE=8388608
FILE_MAX_LEN=($FLASH_SIZE - $PCD_DATA_SPACE)

if [ $# -ne 2 ];then
    echo "Wrong usage."
    echo "$0 <product-bin-file> <pcd-file>"
    exit -2;
fi
FILE_PRODUCT=$1;
FILE_PCD=$2;

if [ -f $FILE_PRODUCT ]; then
    FILE_LEN=$(ls -la $FILE_PRODUCT  | awk '{print $5;}');
    if [ $FILE_LEN -gt 800000 ] ;then
        echo "File $FILE_N is too large!";
        exit -1;
    fi 
else
    echo "File $FILE_PRODUCT is not exist!";
fi

if [ -f $FILE_PCD ]; then
    FILE_LEN=$(ls -la $FILE_PCD | awk '{print $5;}');
    if [ $FILE_LEN -gt $PCD_DATA_LEN ] ;then
        echo "File $FILE_PCD size error!";
        exit -1;
    fi 
else
    echo "File $FILE_PCD is not exist!";
fi 

truncate -c -s $FILE_MAX_LEN $FILE_PRODUCT;
cat $FILE_PCD >> $FILE_PRODUCT;
truncate -c -s $FLASH_SIZE $FILE_PRODUCT;

exit 0
