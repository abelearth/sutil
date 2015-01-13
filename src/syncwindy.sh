if [ "$1"=="-i" ]; then
rsync -avz -e ssh $2 windy@192.168.1.2:/home/windy/$3
else
rsync -avz -e ssh windy@192.168.1.2:/home/windy/$1 $2
fi
