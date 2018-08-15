import sys

n = int(sys.argv[1])

file = sys.argv[2]

line = open(file,'r').readlines()

for i in range(-n, 0):
	print(line[i].rstrip())