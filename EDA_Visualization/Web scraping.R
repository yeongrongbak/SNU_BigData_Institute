library(rvest)
url_tvcast = 'http://tvcast.naver.com/jtbc.youth'
html_tvcast = read_html(x = url_tvcast, encoding = 'UTF-8')
html_tvcast %>% html_nodes(".title a") %>% html_text() %>% data.frame()


url_wiki <- "https://en.wikipedia.org/wiki/Student%27s_t-distribution"
html_wiki <- read_html(x=url_wiki, encoding = 'UFT-8')
html_wiki %>% html_nodes('.wikitable') %>% html_table() %>% data.frame()

url <- "http://www.baseball-reference.com/leagues/MLB/2017.shtml"
webpage <- read_html(url)

# div �쒓렇濡� �쒖옉 (#�� id�섎�, class �� .)
webpage %>% html_nodes('div#div_teams_standard_batting table') %>% 
  html_table()

# 湲곗긽泥�
url <-"http://www.kma.go.kr/weather/observation/currentweather.jsp?auto_man=m&type=t99&tm=2017.09.04.13%3A00&x=13&y=11"
webpage <- read_html(url)

# 湲곗긽泥�
library(rvest)
Sys.setlocale("LC_ALL","English")
url = "http://www.kma.go.kr/weather/observation/currentweather.jsp?auto_man=m&type=t99&tm=2017.09.06.13%3A00&x=19&y=3"
webpage <- read_html(url, encoding = "EUC-KR")
webpage %>% html_nodes("table.table_develop3")
tmp <- webpage %>% html_nodes("table.table_develop3") %>% 
  html_table(header = FALSE, fill=TRUE)%>%
  data.frame()
head(tmp)

for(i in 1:ncol(tmp))
{
  tmp[,i] = rvest::repair_encoding(tmp[,i])
}
head(tmp)



## 蹂대같�쒕┝
Sys.setlocale("LC_ALL", "English")
url = "http://www.bobaedream.co.kr/mycar/mycar_list.php?gubun=I&page=1"
webpage <- read_html(url)
tmp <- webpage %>% html_nodes("table.mycarlist")%>%
  html_table(header = F, fill=T)%>%
  data.frame()
tmp1<- matrix("", nrow(tmp), ncol(tmp))
for (i in 1:ncol(tmp)) tmp1[,i] <- tmp[,i]


tmp = XML::readHTMLTable(url, encoding = "EUC-KR")
tmp = tmp[[1]]
dim(tmp)
for(i in 1:ncol(tmp)) tmp[,i] = rvest::repair_encoding(tmp[,i])
tmp


library(httr)
library(rvest)
Sys.setlocale("LC_ALL", "English")
client_id = '';
client_secret = '';
# add header? (add information of id and password)
header = httr::add_headers('X-Naver-Client-Id' = client_id,
                           'X-Naver-Client-Secret' = client_secret)
query = '�덈땲踰꾪꽣移�'
# convert encoding 
query = iconv(query, to = 'UTF-8', toRaw = T)
query = paste0('%', paste(unlist(query), collapse = '%'))
query = toupper(query)
# make URL
end_num = 1000
display_num = 100
start_point = seq(1,end_num,display_num)
i = 1
url = paste0('https://openapi.naver.com/v1/search/blog.xml?query=',query,'&display=',display_num,'&start=',start_point[i],'&sort=sim')
url_body = read_xml(GET(url, header))

title = url_body %>% xml_nodes('item title') %>%
  xml_text()
bloggername = url_body %>% 
  xml_nodes('item bloggername') %>% xml_text()
postdate = url_body %>% xml_nodes('postdate') %>%
  xml_text()
link = url_body %>% xml_nodes('item link') %>%
  xml_text()
description = url_body %>% xml_nodes('item description') %>%
  html_text()


# loop code
final_dat = NULL
for(i in 1:length(start_point))
{
  # request xml format
  url = paste0('https://openapi.naver.com/v1/search/blog.xml?query=',query,'&display=',display_num,'&start=',start_point[i],'&sort=sim')
  #option header
  url_body = read_xml(GET(url, header), encoding = "UTF-8")
  title = url_body %>% xml_nodes('item title') %>% xml_text()
  bloggername = url_body %>% xml_nodes('item bloggername') %>% xml_text()
  postdate = url_body %>% xml_nodes('postdate') %>% xml_text()
  link = url_body %>% xml_nodes('item link') %>% xml_text()
  description = url_body %>% xml_nodes('item description') %>% html_text()
  temp_dat = cbind(title, bloggername, postdate, link, description)
  final_dat = rbind(final_dat, temp_dat)
  cat(i, '\n')
}
final_dat = data.frame(final_dat, stringsAsFactors = F)






# trend analysis
library(pspline)
tb <- table(final_dat[,3])
x <-as.Date(names(tb), format = "%Y%m%d")
plot(x, tb, pch = 19, cex = 0.5)
fit<-sm.spline(x = x, y = tb, cv = T)
fit<-smooth.spline(x = x, y = tb, df = 15)
points(fit, type = 'l', lty = 2, lwd = 1.5, col = 'blue', add = T)



`#install.packages("KoNLP")
library(KoNLP)
final_dat[10,5]
# deletion tag

extractNoun(a, autoSpacing = T)
MorphAnalyzer(a)
SimplePos22(a)

library(tm)
# tm package is based on Eng. Addition option is required
text = final_dat[,5]
cps = Corpus(VectorSource(text))
dtm = tm::DocumentTermMatrix(cps, control = list(tokenize = extractNoun, 
                                                 removeNumber = T,
                                                 removePunctuation = T))

str(dtm)
colSum(dtm)

# fit<-SimplePos09(a)
# b <- fit[[10]]
# extractNoun(a)
# bb <- unlist(strsplit(b, split = "+", fixed = TRUE))
# library(stringr)
# idx1 <-str_detect(bb, "[N]|[P]")
# idx2 <-str_detect(bb, "[P]")

dtm = as.matrix(dtm)
dim(dtm)
View(dtm)

bb <-as.matrix(dtm)
colnames(bb) = repair_encoding(colnames(bb))

bb.freq <- sort(colSums(bb), decreasing = T)
plot(bb.freq, pch = 19, type = 'l')
quantile(bb.freq,0.99)
bb.freq <- bb.freq[bb.freq>23]
idx <- match(names(bb.freq),  colnames(bb))
bb.r <- bb[,idx]
head(bb.r)
dim(bb.r)
cor.mat <- cor(bb.r)
image(cor.mat)
library(rgl)
persp3d(cor.mat, col = "yellow4")
sort(cor.mat[1,], decreasing = T)[1:10]





word_list <- list()
for (i in 1:nrow(final_dat))
{
  a<- gsub( "<.*?>", "", final_dat[i,5])  
  word_list<-extractNoun(a, autoSpacing = T)
}



#https://cran.r-project.org/web/packages/KoNLP/vignettes/KoNLP-API.html
# Back up the current dictionary
useSejongDic()
# add dictionary
mergeUserDic()

# clova speech synthesis
# description 
# https://developers.naver.com/docs/clova/api/#/CSS/API_Guide.md#Preparation

#install.packages("tuneR")
library(tuneR)
header = add_headers('X-Naver-Client-Id' = client_id,'X-Naver-Client-Secret' = client_secret)
url = paste0("https://openapi.naver.com/v1/voice/tts.bin")
speech = 'jinho'
encText = "ì•ˆë…•í•˜ì„¸ìš”"
data = list(speaker = speech,
            speed = 0,
            text = encText)
url_post = POST(url,header, body = data, encode = 'form', write_disk('test.mp3',overwrite = T))
mp3 = readMP3('test.mp3')
play(mp3)






tb <- webpage %>% html_nodes(xpath = '//*[@id="teams_standard_batting"]') %>% html_table()
webpage %>% html_nodes('.sortable stats_table now_sortable')
%>% html_table()
//*[@id="all_teams_standard_batting"]
//*[@id="teams_standard_batting"]
webpage %>% html_nodes(css = ".class div_teams_standard_pitching")

URL <- read_html("http://www.racingpost.com/greyhounds/result_home.sd#resultDay=2015-12-26&meetingId=18&isFullMeeting=true")
nodes<-html_nodes(URL, ".black") 


URL <- read_html("http://www.army-technology.com/news/16")
URL %>% html_nodes(css = ".faux-link ") %>% html_text()
URL %>% html_nodes(css = ".top ") %>% html_attr(name ='time')


rm(list = ls())
gc(reset = T)

library(rvest)
library(stringr)
library(httr)

## army data refine
# army = read.csv('armynews.csv', stringsAsFactors = F)
# id = nrow(army):1
# army = army[id,]
# army$title = str_trim(army$title)
# army$contents = str_trim(army$contents)
# army$time = str_trim(army$time)
# write.csv(army, 'armynews.csv', row.names = F)

### function start
setwd('C:\\Users\\Statistics\\Dropbox\\tech-demand\\newscrawling\\army')
n_last = 4000
army = function(n_last)
{
  out = read.csv('armynews.csv', skip = n_last - 1, stringsAsFactors = F)
  lastline = nrow(out)
  recent_title = out[lastline,1]
  url = 'http://www.army-technology.com/search/?d=4294878164-45262'
  update_news = html(url) %>% html_nodes('div.article-top div.kgi-search-box a')
  update_link = paste0('www.army-technology.com',html_attr(update_news,'href'))
  update_g = GET(update_link[1])
  body = html(update_g) %>% html_nodes('div.content-row')
  title = body %>% html_nodes('div.article-top h1') %>% html_text() %>% str_trim()
  if(recent_title != title)
  {
    finaldata = NULL
    i = 1
    while(1)
    {
      update_g = GET(update_link[i])
      body = html(update_g) %>% html_nodes('div.content-row')
      title = body %>% html_nodes('div.article-top h1') %>% html_text() %>% str_trim()
      if(recent_title == title) break;
      contents = paste(body %>% html_nodes('div.kgi-common-text p') %>% html_text(),collapse = ' ') %>% str_trim()
      time = body %>% html_nodes('div.unit time') %>% html_text()
      tempdata = cbind(title, contents, time)
      finaldata = rbind(tempdata, finaldata)
      i = i + 1
    }
    write.csv(finaldata,'temp_dat.csv', row.names = F)
    temp_out = scan('temp_dat.csv', sep='\n', what = 'char(0)', skip = 1)
    for(i in 1:length(temp_out))
    {
      write(temp_out[i], file = 'armynews.csv', append = T)
    }
    return(length(temp_out))
  }
}

## 
while(1)
{
  n = army(n_last)
  n_last = n_last + n
}


# rm(list = ls())
gc(reset = T)

library(rjson)
library(httr)
library(rvest)

url = 'https://jcr.incites.thomsonreuters.com/CategoriesDataJson.action?_dc=1493030052077&edition=&journals=&categories=&page=1&start=0&limit=300&sort=%5B%7B%22property%22%3A%22numberOfJournals%22%2C%22direction%22%3A%22DESC%22%7D%5D'
url_body = html(GET(url)) %>% html_nodes('p') %>% html_text()
category = fromJSON(url_body)

dat = do.call('rbind', category$data)
dat = dat[,c('categoryId','categoryName','edition')]
dat = data.frame(dat)a
final_dat = NULL
for(i in 1:nrow(dat))
{
  temp_category = dat[i,]
  temp_url = paste0('https://jcr.irm(list= ls()) 
                    
                    # load packages
                    library(httr) ## GET function
                    library(rvest) ## xml function
                    library(rjson) ## from json function
                    
                    # set variables we need
                    client_id = 'xxxxxx' ## put your client ID
                    client_secret = 'xxxxx' ## put your cliend secret 
                    display = 10 ## ê²€ìƒ‰ ê²°ê³¼ ì¶œë ¥ ê±´ìˆ˜ ì§€ì • : 10(defualt), 100(maximum) 
                    start = 1  ## ê²€ìƒ‰ ì‹œìž‘ ìœ„ì¹˜ : 1(defualt), 1000(maximum) 
                    query = toupper(paste0('%',unlist(iconv(query, to = 'UTF-8', toRaw = T)),collapse = ''))
                    ## ê²€ìƒ‰ì„ ì›í•œëŠ” ë¬¸ìžì—´, encoding to UTF-8
                    ######  xml format #####
                    naver_news_xml = function(query, display, client_id, client_secret )
                    {
                    news = NULL
                    for(start in 1:10) 
                    {
                    url = paste0('https://openapi.naver.com/v1/search/news.xml?query=',query,'&display=',display,'&start=',start,'&sort=sim')
                    # HTTP í—¤ë”ì— í´ë¼ì´ì–¸íŠ¸ ì•„ì´ë””/ì‹œí¬ë¦¿ ê°’ í¬í•¨í•´ì„œ í˜¸ì¶œ
                    url_g = GET(url, add_headers('X-Naver-Client-Id'= client_id, 'X-Naver-Client-Secret' = client_secret)) 
                    
                    item = xml(url_g) %>% xml_nodes('item') 
                    ## In item tag, there are all tags which we need ; title, originallink, description, pubDate
                    
                    title = item %>% xml_nodes('title') %>% xml_text() 
                    title = gsub('<.*?>','',title)
                    
                    link = item %>% xml_nodes('originallink') %>% xml_text()
                    
                    description = item %>% xml_nodes('description ') %>% xml_text()
                    description = gsub('<.*?>','',description)
                    
                    date = item %>% xml_nodes('pubDate') %>% xml_text()
                    date = substr(date,1,16)
                    
                    temp = cbind(link, title, date, description)
                    news = rbind(news, temp)
                    }
                    return(news)
                    }
                    
                    naver_news_xml = naver_news_xml(query, display, client_id , client_secret)
                    
                    ##### json format #####
                    
                    naver_news_json = function(query, display, client_id, client_secret)
                    {
                    news_json = NULL
                    for(start in 1:10)
                    {
                    url = paste0('https://openapi.naver.com/v1/search/news.json?query=',query,'&display=',display,'&start=',start,'&sort=',sort)
                    url_g = GET(url, add_headers('X-Naver-Client-Id'= client_id, 'X-Naver-Client-Secret' = client_secret))
                    
                    url_raise = content(url_g, as = 'text') ## work befor using fromJSON function
                    url_j = fromJSON(url_raise) ## load data as json format
                    
                    title = lapply(url_j$items, function(x) x$title) %>% unlist()
                    title = gsub('<.*?>','',title)
                    
                    date = lapply(url_j$items, function(x) x$pubDate) %>% unlist()
                    date = substr(date, 1,16)
                    
                    description = lapply(url_j$items, function(x) x$description) %>% unlist()
                    description = gsub('<.*?>','',description)
                    
                    link = lapply(url_j$items, function(x) x$originallink) %>% unlist()
                    
                    temp_json = cbind(link, title, date, description)
                    news_json = rbind(news_json, temp_json)
                    }
                    return(news_json)
                    }
                    naver_news_json = naver_news_json(query, display, client_id, client_secret)ncites.thomsonreuters.com/JournalHomeGridJson.action?_dc=1493031842203&jcrYear=2015&edition=',
                    temp_category$edition,
                    '&categoryIds=',temp_category$categoryId,
                    '&subjectCategoryScheme=WoS&jifQuartile=&impactFactorRangeFrom=&impactFactorRangeTo=&averageJifPercentileRangeFrom=&averageJifPercentileRangeTo=&OAFlag=N&page=1&start=0&limit=1000&sort=%5B%7B%22property%22%3A%22journalImpactFactor%22%2C%22direction%22%3A%22DESC%22%7D%5D')
  temp_body = html(GET(temp_url)) %>% html_nodes('p') %>% html_text()
  temp_body = fromJSON(temp_body)
  category_dat = data.frame(do.call('rbind', temp_body$data))
  category_dat = cbind(temp_category, category_dat)
  final_dat = rbind(final_dat, category_dat)
  if( i %% 100 == 0 ) cat(i,'\n')
}

final_dat = data.frame(final_dat, stringsAsFactors = F)
write.csv( final_dat , 'journal_dat.csv', row.names = F)

library(data.table)
fwrite(final_dat, 'journal_dat.csv')

final_dat = read.csv('journal_dat.csv',stringsAsFactors = F)
head(final_dat)

