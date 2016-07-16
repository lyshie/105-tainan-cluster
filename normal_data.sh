#!/bin/bash

# 取得台南市政府開放資料，轉為 school_id 當索引的 Hash Table
wget -q -O - http://odata.tn.edu.tw/schoolapi/api/getdata | ./json_conv.pl > schools.json

# PDF 轉為機器方便處理的格式 (dnf install python-pdfminer)
# http://www.unixuser.org/~euske/python/pdfminer/
pdf2txt -t tag 105tainan.pdf > 105tainan.tag

# 正規化資料，並轉成 JSON 格式
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
