#!/usr/bin/env python3

import json


def main():
    result = dict()
    with open('2020_03_29.txt', 'r') as f:
        lines = f.readlines()
        for i in range(0, int(len(lines) / 8)):
            school = lines[i * 8].strip()
            if school == '合計':
                school = '總計'  # 名稱一致
            num = lines[i * 8 + 1].strip()
            result[school] = num

    print('var grade1 = ', json.dumps(result), ';')


if __name__ == '__main__':
    main()
'''
取得各校一年級人數
curl -s 'https://std.tn.edu.tw/sis/AnonyQuery/StatSchClsStdSum.aspx'
    | ~/go/bin/pup 'table#ContentPlaceHolder1_gvStat tr td text{}' > 2020_03_29.txt
'''
