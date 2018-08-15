# 사용자로부터 파일명을 입력받아 해당 파일의 내용을 읽고 대문자로 출력하는 file_upper.py 프로그램을 작성
# file_upper.py 프로그램과 동일한 작업을 수행하지만 이번에는 결과값을 출력하지 않고 새로운 파일로
# 생성하는 file_copy_upper.py 프로그램을 작성
# 새로운 파일의 이름은 UPPERbeatles2.txt

import sys

a = int(sys.argv[1])
file = sys.argv[2]

line = open(file, 'r').readlines()

for i in range(a) :
	print(line[i].upper().rstrip())


# fin_name = input('Enter a file name: ')

# fin = open(fin_name, 'r')

# print(fin.upper().rstrip())