l = [1,2,3]
e1 = 2
e2 = 10

def search_element(x,y):
	if y in x:
		return x.index(y) # 이 부분에 대해서 제대로 작성하지 못함
	else:
		return False

print(search_element(l,e1))

print(search_element(l,e2))