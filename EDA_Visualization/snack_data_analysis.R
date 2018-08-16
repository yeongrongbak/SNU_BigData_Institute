rm(list = ls())

library(httr)
library(rvest)
Sys.setlocale("LC_ALL", "Korean")
client_id = '7YkOVDACRTf5wRfPu0TB';
client_secret = 'GXrSBy_IWi';
# add header? (add information of id and password)
header = httr::add_headers('X-Naver-Client-Id' = client_id,
                           'X-Naver-Client-Secret' = client_secret)
query.n =  query = '허니버터칩'
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

# save.image("web_mining.rdata")
# trend analysis
#install.packages('pspline')

library(pspline)
tb <- table(final_dat$postdate)
x <- as.Date(names(tb), format = "%Y%m%d") # format 옵션으로 날짜 데이터의 형식을 지정해 주어야 한다.
y <- as.numeric(tb)
plot(x, y, pch = 19, cex = 0.5)

fit <- sm.spline(x = as.integer(x), y = y, cv = TRUE)
fit

plot(x, y, pch=19, cex=0.5)
lines(x=x, y=fit$ysmth, lty = 2, col = 'blue')

# zero frequecy
head(x,1)
as.integer(x[1])
as.Date(as.integer(x[1]), origin = "1970-01-01")
min(x)
max(x)

xx <- as.Date(as.integer(min(x)):as.integer(max(x)),
              origin = "1970-01-01")
yy <- rep(0, length(xx))
yy[xx%in%x] <-y
yy
plot(xx,yy, pch = 19, cex = 0.5)

# penalized spline function 
fit<-sm.spline(xx,yy,cv = TRUE)
points(fit$x, fit$ysmth, type = 'l', lty = 2, lwd = 1.5, col = 'blue')

# local polynomial function
xint <- as.integer(xx)
rdata = data.frame(y = yy, x = xint)
fit<-loess(y~x,data = rdata, span = 0.1, normalize = FALSE)
plot(fit, pch = 19, cex = 0.5)
points(fit$x,fit$fitted, type = 'l', lty = 2, lwd = 1.5, col = 'blue')

# K fold cross validation 

k.fold = 5
idx <-sample(1:5, length(xint), replace = TRUE)
idx
k = 1
rdata.tr <- rdata[idx != k, ]
rdata.va <- rdata[idx == k, ]

fit<-loess(y~x,data = rdata.tr, span = 0.1, normalize = FALSE)
fit.y<-predict(fit, newdata = rdata.va)
mean((fit.y-rdata.va$y)^2, na.rm = T)


# loop 
k = 2
rdata.tr <- rdata[idx != k, ]
rdata.va <- rdata[idx == k, ]
fit<-loess(y~x,data = rdata.tr, span = 0.1, normalize = FALSE)
fit.y<-predict(fit, newdata = rdata.va)
mean((fit.y-rdata.va$y)^2, na.rm = T)

valid.err <- c()
for (k in 1:k.fold)
{
  rdata.tr <- rdata[idx != k, ]
  rdata.va <- rdata[idx == k, ]
  fit<-loess(y~x,data = rdata.tr, 
             span = span.var[j], normalize = FALSE)
  fit.y<-predict(fit, newdata = rdata.va)
  valid.err[k] <- mean((fit.y-rdata.va$y)^2, na.rm = T)
}
valid.err

# loop 2
k.fold = 10
idx <-sample(1:k.fold, length(xint), replace = TRUE)
span.var <- seq(0.02, 0.5, by  = 0.01)
valid.mat <- NULL
for (j in 1:length(span.var))
{
  valid.err <- c()
  for (k in 1:k.fold)
  {
    rdata.tr <- rdata[idx != k, ]
    rdata.va <- rdata[idx == k, ]
    fit<-loess(y~x,data = rdata.tr, 
               span = span.var[j], normalize = FALSE)
    fit.y<-predict(fit, newdata = rdata.va)
    valid.err[k] <- mean((fit.y-rdata.va$y)^2, na.rm = T)
  }
  valid.mat <- cbind(valid.mat, valid.err)
}
colnames(valid.mat) <- span.var
boxplot(valid.mat, col='orange')
lines(colMeans(valid.mat), col = "blue", lty = 2, lwd = 2)

# check
boxplot(valid.mat, col="orange")
lines(colMeans(valid.mat), col = "blue", lty = 2)

# model decision
span.par<- span.var[which.min(colMeans(valid.mat))]

fit<-loess(y~x,data = rdata, 
           span = span.par, normalize = FALSE)

plot(xx,yy,  pch = 19, cex = 0.5)
points(xx,fit$fitted, type = 'l', lty = 2, lwd = 1.5, col = 'blue')

## 단어 빈도 분석

#install.packages("KoNLP")
#install.packages("KoNLP")
library(KoNLP)
final_dat[10,5]
a <- gsub(pattern = "<[/?A-Za-z]*>", 
          replace = "", final_dat[10,5])
a

# deletion tag
extractNoun(a, autoSpacing = T)
dat_tmp <- final_dat
for (i in 1:nrow(final_dat))
{
  dat_tmp[i,5]<-   gsub(pattern = "<[/|A-Za-z]*>", 
                        replace = "", final_dat[i,5])
}

#install.packages('tm')
library(tm)

# tm package is based on Eng. Addition option is required
text = dat_tmp[,5]
cps = Corpus(VectorSource(text)) # 말뭉치로 텍스트를 변환해준다.
dtm = tm::DocumentTermMatrix(cps, 
                             control = list(tokenize = extractNoun,  # extractNoun을 이용해서 분해한다. 
                                            removeNumber = T,
                                            removePunctuation = T))

str(dtm) # 리스트의 형태로 출력이 된다.
dtm

# matrix class
rmat <- as.matrix(dtm) # 대부분의 셀이 0이고 값들이 있는 경우에만 행렬에 입력이 된다.
# 1000만개 중 2만개정도만 값이 있다. -> 메모리의 활용의 비효율 발생

# 위의 문제를 해결하기 위해 쓰는 방법
# sparseMatrix 
library(rvest)
library(Matrix)
rmat <-spMatrix(dtm$nrow,dtm$ncol, i=dtm$i, j=dtm$j, x=dtm$v) # 값이 0인 원소에 대해서 아예 표시를 하지 않는다. i행 j열에 x값들을 집어 넣는다. 
wcount<-colSums(rmat)
wname <- dtm$dimnames$Terms
wname <- repair_encoding(dtm$dimnames$Terms)
colnames(rmat)<- wname

sort.var <- sort(wcount,decreasing = T)[100]
idx <- !( grepl(query.n, wname)| (wcount<=sort.var) ) 
wname.rel <- wname[idx]
wcount.rel <- wcount[idx]

library(wordcloud)
wordcloud(wname.rel,freq = wcount.rel)
pal <- brewer.pal(9, "Set1")
wordcloud(wname.rel,freq = wcount.rel, colors = pal, min.freq=10)



dtm = as.matrix(dtm)
dim(dtm)
View(dtm)

bb <- rmat
bb.freq <- sort(colSums(bb), decreasing = T)
plot(bb.freq, pch = 19, type = 'l')


bb <- rmat
bb.freq <- sort(colSums(bb), decreasing = T)
plot(log(bb.freq), pch = 19, type = 'l')



bb.freq <- bb.freq[bb.freq>quantile(bb.freq,0.99)]
idx <- match(names(bb.freq),  colnames(bb))
bb.r <- bb[,idx]
head(bb.r)
dim(bb.r)

bb.r <- as.matrix(bb.r)
cor.mat <- cor(bb.r)
image(cor.mat, col=terrain.colors(100))
cor.mat

sort(cor.mat[1,], decreasing = T)[1:10]

cor.mat[1:10,1:10]
