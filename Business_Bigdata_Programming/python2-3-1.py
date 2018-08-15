from bs4 import BeautifulSoup
from urllib.request import urlopen

url = 'http://www.imdb.com/title/tt0110912/?ref_=nv_sr_1'

web = urlopen(url)

source = BeautifulSoup(web, 'html.parser')

m = source.find(attrs={'class': 'title_block'})

name = m.find('h1')

print('Movie: ' , name.get_text())

d = source.find(attrs={'class':'credit_summary_item'})

name2 = d.find('span')

print('Director: ', name2.get_text())