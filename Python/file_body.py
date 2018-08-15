import sys

start = int(sys.argv[1]) - 1
end = int(sys.argv[2])

filename = sys.argv[3]

lines = open(filename, 'r').readlines()

if start < 0 : start = 0
if end > len(lines) : end = len(lines)

for i in range(start, end):
	print(lines[i].rstrip())