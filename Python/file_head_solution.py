import sys

n = int(sys.argv[1])

filename = sys.argv[2]

lines = open(filename,'r').readlines()

for i in range(n):
	print(lines[i].rstrip())