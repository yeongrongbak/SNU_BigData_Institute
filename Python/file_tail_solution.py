import sys

n = int(sys.argv[1])

filename = sys.argv[2]

lines = open(filename, 'r').readlines()

for i in range(len(lines)-n , len(lines)):
	print(lines[i].rstrip())