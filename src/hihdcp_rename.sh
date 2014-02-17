for d in $*; do
    for f in $(ls $d/*hisi_encry_v0000001_key*.bin); do
	echo $f
	mv -v $f $d/"hie01_""$(echo $f | tail --bytes=12 | head -c 7)"".key"
    done
done
