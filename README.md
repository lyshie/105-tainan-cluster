# 105-tainan-cluster
台南市105學年度國小教師甄選各校缺額分佈情形

## 1. 取得缺額表 PDF 檔案，並轉換格式
### a. 使用 pdf2text [(PDFMiner: Python PDF parser and analyzer)](http://www.unixuser.org/~euske/python/pdfminer/)
```
# pdf2txt -t tag 105tainan.pdf > 105tainan.tag
```
### b. 分析 Tagged PDF 格式的特徵
```
114601市立仁德國小20101000114602市立文賢國小11000000114603市立長興國小00000000114604市立依仁國小
```
特徵：學校代碼,學校名稱,各類科缺額數量(共8個類科)，並假設數量皆為個位數。
```
114601,市立仁德國小,20101000,114602,市立文賢國小,11000000,114603,市立長興國小,00000000,114604,市立依仁國小
```

## 2. 正規化資料，方便程式處理
### a. 取得「普通(1)」與「資訊(2)」缺額
正規表示式：
```
\d{6}: 6個數字
(|\-[A-Z]): 分校代碼可有-A，或無分校代碼
[^\w\d]+(小|校): 連續不是 alphabet 或 digit，最後一個字是「小」或「校」，這裡可以是中文校名
\d{1,1}: 只要一個數字
```

範例1：
```
# grep -oP "\d{6}(|\-[A-Z])[^\w\d]+(小|校)\d{1,1}" 105tainan.tag
213624市立石門國小1
213644-A漁光分校0
213626市立安順國小5
213627市立和順國小3
```

範例2：
```
# grep -oP "\d{6}(|\-[A-Z])[^\w\d]+(小|校)\d{2,2}" 105tainan.tag
213624市立石門國小10
213644-A漁光分校01
213626市立安順國小50
213627市立和順國小31
```

### b. 刪除中文校名，並取得最後一個欄位數字
正規表示式：
```
[^0-9\-A-Z]+: 學校代碼
[0-9]*?([0-9])$: 取得最後一個數字，所以前面用「[0-9]*?」的 non-greedy 比對，最後擷取「([0-9])$」一個數字
```

範例：
```
# [前處理] | perl -pe 's|[^0-9\-A-Z]+[0-9]*?([0-9])$| \1|'
213624 1
213644-A 0
213626 5
213627 3
```

### c. 過濾缺額數量為 0 的學校
範例：
```
# [前處理] | grep -vP ' 0$'
213624 1
213626 5
213627 3
```

### d. 轉為 JSON 格式 (非正規)
範例：
```
# [前處理] | awk '{print "\""$1"\" : "$2","}'
"213624" : 1,
"213641" : 3,
"213626" : 5,
```

完整 JSON 格式：
```json
var t = {
"213624" : 1,
"213641" : 3,
"213626" : 5,
"" : 0
};
```

## 3. 取得學校座標資料
透過「[台南市各級學校查詢 - 資料集 - 臺南市政府資料開放平台](http://data.tainan.gov.tw/dataset/school-queries)」，下載 JSON 檔案。
因為該資料是 Array 型式，不方便查詢。所以透過簡單程式轉換為 Hash (Associative Array)，並簡化資料量。

部份資料錯誤，需自行更正(如：「東區大同國小」與「善化區大同國小」座標皆相同)。
```
# wget -q -O - http://odata.tn.edu.tw/schoolapi/api/getdata | ./json_conv.pl > schools.json
```

## 4. 繪製 Marker Cluster 地圖
引用前處理過的兩份 JSON 資料，「缺額表」與「學校資訊」。
```html
<!-- 105年缺額表 -->
<script type="text/javascript" src="../targets.json"></script>
<!-- 台南市政府開放資料 - 學校座標資料 -->
<script type="text/javascript" src="../schools.json"></script>
```
使用 [Google Maps API](https://developers.google.com/maps/) 與 [Marker Clusterer](https://github.com/googlemaps/js-marker-clusterer) 繪製地圖。

## 5. 補充
資料來源：[臺南市政府資料開放平台](http://data.tainan.gov.tw/specification)

