
for i in range(1,10):
	for j in range(1,10):
		print(i ,'*', j, '=', i * j)
		


i = 1
while i < 10:
	j = 1
	while j < 10:
		if j != 9:
			print('{} * {} ='.format(i, j), i*j, end = ' ')
		else:
			print('{} * {} ='.format(i, j), i*j)
		j += 1
	i += 1