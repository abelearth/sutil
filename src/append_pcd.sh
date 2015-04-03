#!/bin/bash
#set -x

PCD_DATA_SPACE=65536
FLASH_SIZE=8388608
FILE_MAX_LEN=$(($FLASH_SIZE - $PCD_DATA_SPACE)) 

if [ $# -ne 2 ];then
    echo "Wrong usage."
    echo "$0 <product-bin-file> <pcd-file>"
    exit -2;
fi
FILE_PRODUCT=$1;
FILE_PCD=$2;

if [ -f $FILE_PRODUCT ]; then
    FILE_PRODUCT_LEN=$(ls -la $FILE_PRODUCT  | awk '{print $5;}');
    if [ $FILE_PRODUCT_LEN -gt $FILE_MAX_LEN ] ;then
        echo "File $FILE_PRODUCT is too large!";
        exit -1;
    fi 
else
    echo "File $FILE_PRODUCT does not exist!";
    exit -1;
fi

if [ -f $FILE_PCD ]; then
    FILE_PCD_LEN=$(ls -la $FILE_PCD | awk '{print $5;}');
    if [ $FILE_PCD_LEN -gt $PCD_DATA_SPACE ] ;then
        echo "File $FILE_PCD is too large!";
        exit -1;
    fi 
else
    echo "File $FILE_PCD does not exist!";
    exit -1;
fi 

#stuff product file with 0xFF if necessary
if [ $FILE_PRODUCT_LEN -lt $FILE_MAX_LEN ] ;then
    dd if=/dev/zero ibs=1 count=$(($FILE_MAX_LEN - $FILE_PRODUCT_LEN)) | tr "\000" "\377" >> $FILE_PRODUCT
fi

#append pcd
cat $FILE_PCD >> $FILE_PRODUCT;

#stuff target file with 0xFF if necessary
if [ $FILE_PCD_LEN -lt $PCD_DATA_SPACE ] ;then
    dd if=/dev/zero ibs=1 count=$(($PCD_DATA_SPACE - $FILE_PCD_LEN)) | tr "\000" "\377" >> $FILE_PRODUCT
fi

#check target file
FILE_PRODUCT_LEN=$(ls -la $FILE_PRODUCT  | awk '{print $5;}');
if [ $FILE_PRODUCT_LEN -ne $FLASH_SIZE ] ;then
    echo "!!!Failed to append $FILE_PCD to $FILE_PRODUCT!!!"
    exit -3;
fi
echo "Successed to append $FILE_PCD to the last block of flash image."
exit 0
