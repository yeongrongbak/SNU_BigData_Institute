from bs4 import BeautifulSoup
from splinter import Browser
import time

word_list = ['python', 'java', 'ruby', 'html', 'xml']

fout = open('dictionary_splinter.txt', 'w')

browser = Browser('chrome')

url = 'http://dictionary.cambridge.org/dictionary/english/'

try:
	for keyword in word_list:
		browser.visit(url)
		browser.fill('q', keyword)
		button = browser.find_by_xpath('//*[@class="cdo-search__button"]')
		button.click()
		time.sleep(2)
		web_page = BeautifulSoup(browser.html, 'html.parser')
		word = web_page.find(attrs = {'class': 'headword'})
		definition = web_page.find(attrs = {'class' : 'def'})
		fout.write(word.get_text() + ': ' + definition.get_text() + '\n')
except AttributeError as err:
	print('ERROR:', err)
finally:
	fout.close()
	browser.quit() 
