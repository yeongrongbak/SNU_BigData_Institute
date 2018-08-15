from bs4 import BeautifulSoup
from urllib.request import urlopen

url = 'http://www.imdb.com/title/tt0110912/reviews?ref_=tt_urv'

web = urlopen(url)

source = BeautifulSoup(web, 'html.parser')

table = source.find("div", {"id":"tn15content"})

m = table.find_all('p')

for par in m :

	if('This review may contain spoilers' not in par) and ('Add another review' not in par):
		print(par.get_text().replace('\n', ' ').replace('\r', ' '))
		break
