#!/bin/bash

wget -q -O - http://odata.tn.edu.tw/schoolapi/api/getdata | ./json_conv.pl > schools.json

pdf2txt -t tag 105tainan.pdf > 105tainan.tag

echo "var t = [];" > "targets.json"

for i in {1..8}; do

	let j=i-1

	(echo "t[${j}] = {";

	grep -oP "\d{6}(|\-[A-Z])[^\w\d]+(小|校)\d{${i},${i}}" 105tainan.tag |
	perl -pe 's|[^0-9\-A-Z]+[0-9]*?([0-9])$| \1|' |
	grep -vP ' 0$' |
	awk '{print "\""$1"\" : "$2","}' ;

	echo '"" : 0};' ) >> "targets.json"

done
