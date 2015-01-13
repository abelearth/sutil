find $1 -iname *.sh -o -iname *.exe -o -iname *.bat | xargs -I{} chmod -v +x {}

