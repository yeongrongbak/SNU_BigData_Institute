def sort_score(a1,a2,a3,a4,a5):
	scores = [a1, a2, a3, a4, a5]
	scores.sort()  # scores.sort(reverse=True)
	for s in scores:
		print(s)

sort_score(5,2,3,1,4)