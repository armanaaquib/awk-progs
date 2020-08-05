#! /bin/bash

filename=$1
url="http://wow-accuracy.herokuapp.com/check_accuracy?result="
result=`sort -t'|' -k2 $filename | awk -F'|' '{moments=moments$1}END{print moments}'` 
user=$(whoami)
url_with_params="$url$result"
url_with_params="${url_with_params}&u=${user}"
new_url=`echo $url_with_params | sed 's/ //g'`
curl -X POST ${new_url}
