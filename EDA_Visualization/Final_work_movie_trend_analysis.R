### 탐색적 자료 분석 및 시각화 최종 과제
### 주제 : API 및 web scraping 을 이용한 박스오피스 TOP10 영화 매출액 및 관객수 분석


## Library Setting

library(httr)
library(rvest)
library(ggplot2)

## Data collection

# 2017/09/27 박스오피스 TOP10 영화 데이터

url = paste0("http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.xml?"
             ,"targetDt=",20170927,"&key=b17d61a4cf6ec47d72f7916238c2abb8")


url_get = GET(url)

url_xml = read_xml(url_get)
url_xml

rank_list = xml_nodes(url_xml, 'rank')
rank_list
rank = xml_text(rank_list)
rank

rankON_list = xml_nodes(url_xml, 'rankOldAndNew')
rankON_list
rankON = xml_text(rankON_list)
rankON

movie_list = xml_nodes(url_xml, 'movieNm')
movie_list
movieName = xml_text(movie_list)
movieName

Odt_list = xml_nodes(url_xml, 'openDt')
Odt_list
openDt = xml_text(Odt_list)
openDt

salesAmt_list = xml_nodes(url_xml, 'salesAmt')
salesAmt_list
salesAmt = xml_text(salesAmt_list)

salesInten_list = xml_nodes(url_xml, 'salesInten')
salesInten_list
salesInten = xml_text(salesInten_list)

salesChange_list = xml_nodes(url_xml, 'salesChange')
salesChange_list
salesChange = xml_text(salesChange_list)

salesAcc_list = xml_nodes(url_xml, 'salesAcc')
salesAcc_list
salesAcc = xml_text(salesAcc_list)

audiCnt_list = xml_nodes(url_xml, 'audiCnt')
audiCnt_list
audiCnt = xml_text(audiCnt_list)

audiInten_list = xml_nodes(url_xml, 'audiInten')
audiInten_list
audiInten = xml_text(audiInten_list)

audiChange_list = xml_nodes(url_xml, 'audiChange')
audiChange_list
audichange = xml_text(audiChange_list)

audiAcc_list = xml_nodes(url_xml, 'audiAcc')
audiAcc_list
audiAcc = xml_text(audiAcc_list)

scrnCnt_list = xml_nodes(url_xml, 'scrnCnt')
scrnCnt_list
scrnCnt = xml_text(scrncnt_list)

showCnt_list = xml_nodes(url_xml, 'showCnt')
showCnt_list
showCnt = xml_text(showCnt_list)

data_set1 = cbind(rank, rankON, movieName, openDt, salesAmt, salesInten, salesChange, salesAcc, audiCnt, audiInten, audichange, audiAcc, scrnCnt, showCnt)

data_set1 <- data.frame(data_set1, stringsAsFactors = F)

str(data_set1)
data_set1$salesAmt <- as.numeric(data_set1$salesAmt)
data_set1$salesInten <- as.numeric(data_set1$salesInten)
data_set1$salesChange <- as.numeric(data_set1$salesChange)
data_set1$salesAcc <- as.numeric(data_set1$salesAcc)
data_set1$audiCnt <- as.numeric(data_set1$audiCnt)
data_set1$audiInten <- as.numeric(data_set1$audiInten)
data_set1$audichange <- as.numeric(data_set1$audichange)
data_set1$audiAcc <- as.numeric(data_set1$audiAcc)
data_set1$scrnCnt <- as.numeric(data_set1$scrnCnt)
data_set1$showCnt <- as.numeric(data_set1$showCnt)

View(data_set1)

# 2017/09/28 박스오피스 TOP10 영화 데이터

url = paste0("http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.xml?"
             ,"targetDt=",20170928,"&key=b17d61a4cf6ec47d72f7916238c2abb8")


url_get = GET(url)

url_xml = read_xml(url_get)

rank_list = xml_nodes(url_xml, 'rank')
rank = xml_text(rank_list)


rankON_list = xml_nodes(url_xml, 'rankOldAndNew')
rankON = xml_text(rankON_list)


movie_list = xml_nodes(url_xml, 'movieNm')
movieName = xml_text(movie_list)


Odt_list = xml_nodes(url_xml, 'openDt')
openDt = xml_text(Odt_list)


salesAmt_list = xml_nodes(url_xml, 'salesAmt')
salesAmt = xml_text(salesAmt_list)

salesInten_list = xml_nodes(url_xml, 'salesInten')
salesInten = xml_text(salesInten_list)

salesChange_list = xml_nodes(url_xml, 'salesChange')
salesChange = xml_text(salesChange_list)

salesAcc_list = xml_nodes(url_xml, 'salesAcc')
salesAcc = xml_text(salesAcc_list)

audiCnt_list = xml_nodes(url_xml, 'audiCnt')
audiCnt = xml_text(audiCnt_list)

audiInten_list = xml_nodes(url_xml, 'audiInten')
audiInten = xml_text(audiInten_list)

audiChange_list = xml_nodes(url_xml, 'audiChange')
audichange = xml_text(audiChange_list)

audiAcc_list = xml_nodes(url_xml, 'audiAcc')
audiAcc = xml_text(audiAcc_list)

scrnCnt_list = xml_nodes(url_xml, 'scrnCnt')
scrnCnt = xml_text(scrncnt_list)

showCnt_list = xml_nodes(url_xml, 'showCnt')
showCnt = xml_text(showCnt_list)

data_set2 = cbind(rank, rankON, movieName, openDt, salesAmt, salesInten, salesChange, salesAcc, audiCnt, audiInten, audichange, audiAcc, scrnCnt, showCnt)

data_set2 <- data.frame(data_set1, stringsAsFactors = F)

str(data_set2)
data_set2$salesAmt <- as.numeric(data_set2$salesAmt)
data_set2$salesInten <- as.numeric(data_set2$salesInten)
data_set2$salesChange <- as.numeric(data_set2$salesChange)
data_set2$salesAcc <- as.numeric(data_set2$salesAcc)
data_set2$audiCnt <- as.numeric(data_set2$audiCnt)
data_set2$audiInten <- as.numeric(data_set2$audiInten)
data_set2$audichange <- as.numeric(data_set2$audichange)
data_set2$audiAcc <- as.numeric(data_set2$audiAcc)
data_set2$scrnCnt <- as.numeric(data_set2$scrnCnt)
data_set2$showCnt <- as.numeric(data_set2$showCnt)

View(data_set2)

# 2017/09/29 박스오피스 TOP10 영화 데이터

url = paste0("http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.xml?"
             ,"targetDt=",20170929,"&key=b17d61a4cf6ec47d72f7916238c2abb8")


url_get = GET(url)

url_xml = read_xml(url_get)

rank_list = xml_nodes(url_xml, 'rank')
rank = xml_text(rank_list)

rankON_list = xml_nodes(url_xml, 'rankOldAndNew')
rankON = xml_text(rankON_list)


movie_list = xml_nodes(url_xml, 'movieNm')
movieName = xml_text(movie_list)


Odt_list = xml_nodes(url_xml, 'openDt')
openDt = xml_text(Odt_list)


salesAmt_list = xml_nodes(url_xml, 'salesAmt')
salesAmt = xml_text(salesAmt_list)

salesInten_list = xml_nodes(url_xml, 'salesInten')
salesInten = xml_text(salesInten_list)

salesChange_list = xml_nodes(url_xml, 'salesChange')
salesChange = xml_text(salesChange_list)

salesAcc_list = xml_nodes(url_xml, 'salesAcc')
salesAcc = xml_text(salesAcc_list)

audiCnt_list = xml_nodes(url_xml, 'audiCnt')
audiCnt = xml_text(audiCnt_list)

audiInten_list = xml_nodes(url_xml, 'audiInten')
audiInten = xml_text(audiInten_list)

audiChange_list = xml_nodes(url_xml, 'audiChange')
audichange = xml_text(audiChange_list)

audiAcc_list = xml_nodes(url_xml, 'audiAcc')
audiAcc = xml_text(audiAcc_list)

scrnCnt_list = xml_nodes(url_xml, 'scrnCnt')
scrnCnt = xml_text(scrncnt_list)

showCnt_list = xml_nodes(url_xml, 'showCnt')
showCnt = xml_text(showCnt_list)

data_set3 = cbind(rank, rankON, movieName, openDt, salesAmt, salesInten, salesChange, salesAcc, audiCnt, audiInten, audichange, audiAcc, scrnCnt, showCnt)

data_set3 <- data.frame(data_set3, stringsAsFactors = F)

str(data_set3)
data_set3$salesAmt <- as.numeric(data_set3$salesAmt)
data_set3$salesInten <- as.numeric(data_set3$salesInten)
data_set3$salesChange <- as.numeric(data_set3$salesChange)
data_set3$salesAcc <- as.numeric(data_set3$salesAcc)
data_set3$audiCnt <- as.numeric(data_set3$audiCnt)
data_set3$audiInten <- as.numeric(data_set3$audiInten)
data_set3$audichange <- as.numeric(data_set3$audichange)
data_set3$audiAcc <- as.numeric(data_set3$audiAcc)
data_set3$scrnCnt <- as.numeric(data_set3$scrnCnt)
data_set3$showCnt <- as.numeric(data_set3$showCnt)

View(data_set3)


# 2017/09/30 박스오피스 TOP10 영화 데이터

url = paste0("http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.xml?"
             ,"targetDt=",20170930,"&key=b17d61a4cf6ec47d72f7916238c2abb8")


url_get = GET(url)

url_xml = read_xml(url_get)
url_xml

rank_list = xml_nodes(url_xml, 'rank')
rank = xml_text(rank_list)

rankON_list = xml_nodes(url_xml, 'rankOldAndNew')
rankON = xml_text(rankON_list)

movie_list = xml_nodes(url_xml, 'movieNm')
movieName = xml_text(movie_list)

Odt_list = xml_nodes(url_xml, 'openDt')
openDt = xml_text(Odt_list)

salesAmt_list = xml_nodes(url_xml, 'salesAmt')
salesAmt = xml_text(salesAmt_list)

salesInten_list = xml_nodes(url_xml, 'salesInten')
salesInten = xml_text(salesInten_list)

salesChange_list = xml_nodes(url_xml, 'salesChange')
salesChange = xml_text(salesChange_list)

salesAcc_list = xml_nodes(url_xml, 'salesAcc')
salesAcc = xml_text(salesAcc_list)

audiCnt_list = xml_nodes(url_xml, 'audiCnt')
audiCnt = xml_text(audiCnt_list)

audiInten_list = xml_nodes(url_xml, 'audiInten')
audiInten = xml_text(audiInten_list)

audiChange_list = xml_nodes(url_xml, 'audiChange')
audichange = xml_text(audiChange_list)

audiAcc_list = xml_nodes(url_xml, 'audiAcc')
audiAcc = xml_text(audiAcc_list)

scrnCnt_list = xml_nodes(url_xml, 'scrnCnt')
scrnCnt = xml_text(scrncnt_list)

showCnt_list = xml_nodes(url_xml, 'showCnt')
showCnt = xml_text(showCnt_list)

data_set4 = cbind(rank, rankON, movieName, openDt, salesAmt, salesInten, salesChange, salesAcc, audiCnt, audiInten, audichange, audiAcc, scrnCnt, showCnt)

data_set4 <- data.frame(data_set4, stringsAsFactors = F)

str(data_set4)
data_set4$salesAmt <- as.numeric(data_set4$salesAmt)
data_set4$salesInten <- as.numeric(data_set4$salesInten)
data_set4$salesChange <- as.numeric(data_set4$salesChange)
data_set4$salesAcc <- as.numeric(data_set4$salesAcc)
data_set4$audiCnt <- as.numeric(data_set4$audiCnt)
data_set4$audiInten <- as.numeric(data_set4$audiInten)
data_set4$audichange <- as.numeric(data_set4$audichange)
data_set4$audiAcc <- as.numeric(data_set4$audiAcc)
data_set4$scrnCnt <- as.numeric(data_set4$scrnCnt)
data_set4$showCnt <- as.numeric(data_set4$showCnt)

View(data_set4)

# 2017/10/01 박스오피스 TOP10 영화 데이터

url = paste0("http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.xml?"
             ,"targetDt=",20171001,"&key=b17d61a4cf6ec47d72f7916238c2abb8")


url_get = GET(url)

url_xml = read_xml(url_get)

rank_list = xml_nodes(url_xml, 'rank')
rank = xml_text(rank_list)

rankON_list = xml_nodes(url_xml, 'rankOldAndNew')
rankON = xml_text(rankON_list)

movie_list = xml_nodes(url_xml, 'movieNm')
movieName = xml_text(movie_list)

Odt_list = xml_nodes(url_xml, 'openDt')
openDt = xml_text(Odt_list)

salesAmt_list = xml_nodes(url_xml, 'salesAmt')
salesAmt = xml_text(salesAmt_list)

salesInten_list = xml_nodes(url_xml, 'salesInten')
salesInten = xml_text(salesInten_list)

salesChange_list = xml_nodes(url_xml, 'salesChange')
salesChange = xml_text(salesChange_list)

salesAcc_list = xml_nodes(url_xml, 'salesAcc')
salesAcc = xml_text(salesAcc_list)

audiCnt_list = xml_nodes(url_xml, 'audiCnt')
audiCnt = xml_text(audiCnt_list)

audiInten_list = xml_nodes(url_xml, 'audiInten')
audiInten = xml_text(audiInten_list)

audiChange_list = xml_nodes(url_xml, 'audiChange')
audichange = xml_text(audiChange_list)

audiAcc_list = xml_nodes(url_xml, 'audiAcc')
audiAcc = xml_text(audiAcc_list)

scrnCnt_list = xml_nodes(url_xml, 'scrnCnt')
scrnCnt = xml_text(scrncnt_list)

showCnt_list = xml_nodes(url_xml, 'showCnt')
showCnt = xml_text(showCnt_list)

data_set5 = cbind(rank, rankON, movieName, openDt, salesAmt, salesInten, salesChange, salesAcc, audiCnt, audiInten, audichange, audiAcc, scrnCnt, showCnt)

data_set5 <- data.frame(data_set5, stringsAsFactors = F)

str(data_set5)
data_set5$salesAmt <- as.numeric(data_set5$salesAmt)
data_set5$salesInten <- as.numeric(data_set5$salesInten)
data_set5$salesChange <- as.numeric(data_set5$salesChange)
data_set5$salesAcc <- as.numeric(data_set5$salesAcc)
data_set5$audiCnt <- as.numeric(data_set5$audiCnt)
data_set5$audiInten <- as.numeric(data_set5$audiInten)
data_set5$audichange <- as.numeric(data_set5$audichange)
data_set5$audiAcc <- as.numeric(data_set5$audiAcc)
data_set5$scrnCnt <- as.numeric(data_set5$scrnCnt)
data_set5$showCnt <- as.numeric(data_set5$showCnt)

View(data_set5)


# 2017/10/02 박스오피스 TOP10 영화 데이터

url = paste0("http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.xml?"
             ,"targetDt=",20171002,"&key=b17d61a4cf6ec47d72f7916238c2abb8")


url_get = GET(url)

url_xml = read_xml(url_get)

rank_list = xml_nodes(url_xml, 'rank')
rank = xml_text(rank_list)

rankON_list = xml_nodes(url_xml, 'rankOldAndNew')
rankON = xml_text(rankON_list)

movie_list = xml_nodes(url_xml, 'movieNm')
movieName = xml_text(movie_list)

Odt_list = xml_nodes(url_xml, 'openDt')
openDt = xml_text(Odt_list)

salesAmt_list = xml_nodes(url_xml, 'salesAmt')
salesAmt = xml_text(salesAmt_list)

salesInten_list = xml_nodes(url_xml, 'salesInten')
salesInten = xml_text(salesInten_list)

salesChange_list = xml_nodes(url_xml, 'salesChange')
salesChange = xml_text(salesChange_list)

salesAcc_list = xml_nodes(url_xml, 'salesAcc')
salesAcc = xml_text(salesAcc_list)

audiCnt_list = xml_nodes(url_xml, 'audiCnt')
audiCnt = xml_text(audiCnt_list)

audiInten_list = xml_nodes(url_xml, 'audiInten')
audiInten = xml_text(audiInten_list)

audiChange_list = xml_nodes(url_xml, 'audiChange')
audichange = xml_text(audiChange_list)

audiAcc_list = xml_nodes(url_xml, 'audiAcc')
audiAcc = xml_text(audiAcc_list)

scrnCnt_list = xml_nodes(url_xml, 'scrnCnt')
scrnCnt = xml_text(scrncnt_list)

showCnt_list = xml_nodes(url_xml, 'showCnt')
showCnt = xml_text(showCnt_list)

data_set6 = cbind(rank, rankON, movieName, openDt, salesAmt, salesInten, salesChange, salesAcc, audiCnt, audiInten, audichange, audiAcc, scrnCnt, showCnt)

data_set6 <- data.frame(data_set6, stringsAsFactors = F)

str(data_set6)
data_set6$salesAmt <- as.numeric(data_set6$salesAmt)
data_set6$salesInten <- as.numeric(data_set6$salesInten)
data_set6$salesChange <- as.numeric(data_set6$salesChange)
data_set6$salesAcc <- as.numeric(data_set6$salesAcc)
data_set6$audiCnt <- as.numeric(data_set6$audiCnt)
data_set6$audiInten <- as.numeric(data_set6$audiInten)
data_set6$audichange <- as.numeric(data_set6$audichange)
data_set6$audiAcc <- as.numeric(data_set6$audiAcc)
data_set6$scrnCnt <- as.numeric(data_set6$scrnCnt)
data_set6$showCnt <- as.numeric(data_set6$showCnt)

View(data_set6)

## "택시 운전사"

# 매출액 추이

salesamount_taxi <- c()
for(i in 1:50){
  data = get(paste0('data_set', i))
  salesamount_taxi = c(salesamount_taxi,data$salesAmt[which(data$movieName=="택시운전사")])
}

str(salesamount_taxi)

# 관객수 추이

audiCnt_taxi <- c()
for(i in 1:50){
  data = get(paste0('data_set', i))
  audiCnt_taxi = c(audiCnt_taxi,data$audiCnt[which(data$movieName=="택시운전사")])
}

date <- c("2017-08-02","2017-08-03","2017-08-04","2017-08-05","2017-08-06",
          "2017-08-07","2017-08-08","2017-08-09","2017-08-10","2017-08-11",
          "2017-08-12","2017-08-13","2017-08-14","2017-08-15","2017-08-16",
          "2017-08-17","2017-08-18","2017-08-19","2017-08-20","2017-08-21",
          "2017-08-22","2017-08-23","2017-08-24","2017-08-25","2017-08-26",
          "2017-08-27","2017-08-28","2017-08-29","2017-08-30","2017-08-31",
          "2017-09-01","2017-09-02","2017-09-03","2017-09-04","2017-09-05",
          "2017-09-06","2017-09-07","2017-09-08","2017-09-09","2017-09-10",
          "2017-09-11","2017-09-12","2017-09-13","2017-09-14","2017-09-15",
          "2017-09-16","2017-09-17","2017-09-18","2017-09-19","2017-09-20")

date <- c(1:50)


a <- cbind(salesamount_taxi, audiCnt_taxi, date)
a <- data.frame(a, stringsAsFactors = F)

str(a)
a$salesamount_taxi <- as.numeric(a$salesamount_taxi)
a$audiCnt_taxi <- as.numeric(a$audiCnt_taxi)


ggplot(a, aes(x=date, y= salesamount_taxi, group=1))+
  geom_line(lwd=1, col="blue")+
  geom_point(shape=1, col="blue")+ 
  xlab("개봉 후 경과일") + ylab("매출액")+
  ggtitle("택시운전사 매출액 추이")+
  theme(plot.title=element_text(face='bold',size=20, vjust=2))


ggplot(a, aes(x=date, y= audiCnt_taxi, group=1))+
  geom_line(lwd=1, col="blue")+
  geom_point(shape=1, col="blue")+ 
  xlab("개봉 후 경과일") + ylab("관객 수")+
  ggtitle("택시운전사 관객 수 추이")+
  theme(plot.title=element_text(face='bold',size=20, vjust=2))


audiCnt_ship <- c()
for(i in 1:50){
  data = get(paste0('data_set', i))
  audiCnt_ship = c(audiCnt_ship,data$audiCnt[which(data$movieName=="군함도")])
}

b <- cbind(audiCnt_ship, date[1:20])
b
ggplot(b, aes(x=date[1:20], y= audiCnt_ship, group=1)) +
  geom_line(lwd=1, col="red")+
  geom_point(shape=1,col="red")+
  xlab("개봉 후 경과일") + ylab("관객 수")+
  ggtitle("군함도 관객 수 추이")+
  theme(plot.title=element_text(face='bold',size=20, vjust=2))


audiCnt_pol <- c()
for(i in 1:50){
  data = get(paste0('data_set', i))
  audiCnt_pol = c(audiCnt_pol,data$audiCnt[which(data$movieName=="청년경찰")])
}

c <- cbind(audiCnt_ship, date[1:40])
c
ggplot(c, aes(x=date[1:40], y= audiCnt_ship, group=1)) +
  geom_line(lwd=1, col="green")+
  geom_point(shape=1,col="green")+
  xlab("개봉 후 경과일") + ylab("관객 수")+
  ggtitle("청년경찰 관객 수 추이")+
  theme(plot.title=element_text(face='bold',size=20, vjust=2))


audiCnt_kill <- c()
for(i in 1:50){
  data = get(paste0('data_set', i))
  audiCnt_kill = c(audiCnt_kill,data$audiCnt[which(data$movieName=="살인자의 기억법")])
}

d <- cbind(audiCnt_kill, date[1:15])
d
ggplot(d, aes(x=date[1:15], y= audiCnt_kill, group=1)) +
  geom_line(lwd=1, col="orange")+
  geom_point(shape=1,col="green")+
  xlab("개봉 후 경과일") + ylab("관객 수")+
  ggtitle("살인자의 기억법 관객 수 추이")+
  theme(plot.title=element_text(face='bold',size=20, vjust=2))

