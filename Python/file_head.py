import sys

args = sys.argv[1:]

x = args[0]

f = args[1]

myfile = open(f, 'r').readline()

print(myfile)