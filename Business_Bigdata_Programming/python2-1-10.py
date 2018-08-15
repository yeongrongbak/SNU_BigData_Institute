Dict = {'John' : 30000 ,'Jane' : 50000, 'Paul' : 45000, 'Elizabeth' : 70000, 'Seth' : 10000}

keys = Dict.keys()

for key in keys:
	if Dict[key] >= 50000:
		print('{}\'s salary is: '.format(key), Dict[key])