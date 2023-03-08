#!/usr/bin/env python3

import json


def main():
    result = dict()
    with open('2023_03_08.txt', 'r') as f:
        lines = f.readlines()
        for i in range(0, int(len(lines) / 9)):
            district = lines[i * 9].strip()
            school   = lines[i * 9 + 1].strip()
            if district == '合計' or school == '合計':
                school = '總計'  # 名稱一致
            num = lines[i * 9 + 2].strip()
            result[school] = {'num': num, 'dist': district}

    print('var grade1 = ', json.dumps(result), ';')


if __name__ == '__main__':
    main()
'''
取得各校一年級人數
curl -k -s 'https://std.tn.edu.tw/sis/AnonyQuery/StatSchClsStdSum.aspx'
    | ~/go/bin/pup 'table#ContentPlaceHolder1_gvStat tr td text{}' > 2023_03_08.txt
'''
