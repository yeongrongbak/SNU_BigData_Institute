import csv

data = []

with open('enrollments.csv') as f:

	lines = f.readlines()[1:]

	for line in lines:

		line = line.split(',')
		
		dic = {'account_key' : line[0], 'status': line[1], 'join_date' : line[2], 'cancel_date' : line[3], 'days_to_cancel' : line[4], 'is_udacity' : line[5], 'is_canceled' : line[6]}
		
		data.append(dic)
	
	f.close()


# features = ['account_key', 'status', 'join_date', 'cancel_date','days_to_cancel', 'is_udacity', 'is_canceled']

# l = ['448', 'canceled', '2014-11-10', '2015-01-14', '65', True, True]

# result = []

# l2 = {}

# for i in range(len(features)):

#	l2[features[i]] = l[i]

# result.append(l2)

# print(result)

