import sys

a = int(sys.argv[1])

f = sys.argv[2]

file = open(f,'r').readlines()

for i in range(a):
	print(file[i].rstrip())