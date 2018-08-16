rm(list = ls())
library(httr)
library(rvest)
Sys.setlocale("LC_ALL", "Korean")
client_id = '';
client_secret = '';
# add header? (add information of id and password)
header = httr::add_headers('X-Naver-Client-Id' = client_id,
                           'X-Naver-Client-Secret' = client_secret)
query.n =  query = '�덈땲踰꾪꽣移�'
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

library(pspline)
tb <- table(final_dat$postdate)
x <-as.Date(names(tb), format = "%Y%m%d")
y <- as.numeric(tb)
plot(x, y, pch = 19, cex = 0.5)
fit <- sm.spline(x = as.integer(x), y = y, cv = TRUE)
lines(x=x, y=fit$ysmth, lty = 2, col = 'blue')

# zero frequecy
head(x,1)
as.integer(x[1])
as.Date(as.integer(x[1]), origin = "1970-01-01")
xx <- as.Date(as.integer(min(x)):as.integer(max(x)),
              origin = "1970-01-01")
yy <- rep(0, length(xx))
yy[xx%in%x] <-y
plot(xx,yy, pch = 19, cex = 0.5)
# penalized spline function 
fit<-sm.spline(xx,yy,cv = TRUE)
points(fit$x, fit$ysmth, type = 'l', lty = 2, lwd = 1.5, col = 'blue')

# local polynomial function
xint <- as.integer(xx)
rdata = data.frame(y = yy, x = xint)
fit<-loess(y~x,data = rdata, span = 0.5, normalize = FALSE)
plot(fit, pch = 19, cex = 0.5)
points(fit$x,fit$fitted, type = 'l', lty = 2, lwd = 1.5, col = 'blue')

# K fold cross validation 
k.fold = 5
idx <-sample(1:5, length(xint), replace = TRUE)

k = 1
rdata.tr <- rdata[idx != k, ]
rdata.va <- rdata[idx == k, ]
fit<-loess(y~x,data = rdata.tr, span = 0.1, normalize = FALSE)
fit.y<-predict(fit, newdata = rdata.va)
mean((fit.y-rdata.va$y)^2, na.rm = T)

# loop 

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

# check
boxplot(valid.mat)
lines(colMeans(valid.mat), col = "blue", lty = 2)

# model decision
span.par<- span.var[which.min(colMeans(valid.mat))]
fit<-loess(y~x,data = rdata, 
           span = span.par, normalize = FALSE)
plot(xx,yy,  pch = 19, cex = 0.5)
points(xx,fit$fitted, type = 'l', lty = 2, lwd = 1.5, col = 'blue')


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

library(tm)
# tm package is based on Eng. Addition option is required
text = dat_tmp[,5]
cps = Corpus(VectorSource(text))
dtm = tm::DocumentTermMatrix(cps, 
                             control = list(tokenize = extractNoun, 
                                            removeNumber = T,
                                            removePunctuation = T))

str(dtm)
dtm
# matrix class
rmat <- as.matrix(dtm)

# sparseMatrix
library(Matrix)
rmat <-spMatrix(dtm$nrow,dtm$ncol, i=dtm$i, j=dtm$j, x=dtm$v)
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
wordcloud(wname.rel,freq = wcount.rel, colors = pal)



dtm = as.matrix(dtm)
dim(dtm)
View(dtm)

bb <- rmat
bb.freq <- sort(colSums(bb), decreasing = T)
plot(bb.freq, pch = 19, type = 'l')

bb.freq <- bb.freq[bb.freq>quantile(bb.freq,0.99)]
idx <- match(names(bb.freq),  colnames(bb))
bb.r <- bb[,idx]
head(bb.r)
dim(bb.r)
bb.r <- as.matrix(bb.r)
cor.mat <- cor(bb.r)
image(cor.mat)
library(rgl)
persp3d(cor.mat, col = "yellow4")
sort(cor.mat[1,], decreasing = T)[1:10]



# clova speech synthesis
# description 
# https://developers.naver.com/docs/clova/api/#/CSS/API_Guide.md#Preparation

#install.packages("tuneR")
library(tuneR)
header = add_headers('X-Naver-Client-Id' = client_id,'X-Naver-Client-Secret' = client_secret)
url = paste0("https://openapi.naver.com/v1/voice/tts.bin")
speech = 'jinho'
encText = "�덈뀞�섏꽭��"
data = list(speaker = speech,
            speed = 0,
            text = encText)
url_post = POST(url,header, body = data, encode = 'form', write_disk('test.mp3',overwrite = T))
mp3 = readMP3('test.mp3')
play(mp3)


library(MASS)

Omega  = matrix(c(1,0,0.5,
                  0,1,0.3,
                  0.5,0.3,1)
                ,3,3)

Sigma <- solve(Omega)
n = 100
pcor.vec <- rep(0,1000)
for ( i in 1:1000)
{
  rdata<-mvrnorm(n,mu = rep(0,3), Sigma)
  x = rdata[,1]
  y = rdata[,2]
  z = rdata[,3]
  
  x = x-mean(x)
  y = y-mean(y)
  z = z-mean(z)
  
  pcor.vec[i]<-cor(lm(x~z-1)$residual,lm(y~z-1)$residual)
  
}

boxplot(pcor.vec)



###

install.packages("igraph")
library(igraph)

Sigma  = matrix(c(1,0,0.5,
                  0,1,0.3,
                  0.5,0.3,1)
                ,3,3)
Sigma.cov <- Sigma
Sigma.cov[Sigma>0] <- 1
diag(Sigma.cov) <- 0
ed <- graph_from_adjacency_matrix(Sigma.cov, mode='undirected')
plot(ed)

adjm <- matrix(sample(0:1, 100, replace=TRUE, prob=c(0.9,0.1)), 10,10)
g1 <- graph_from_adjacency_matrix( adjm )
plot(g1)



Sigma  = matrix(c(1,0,0.5,0,
                  0,1,0.3,0.2,
                  0.5,0.3,1,0,
                  0,0.2,0,1)
                ,4,4)
Sigma11<- Sigma[1:2,1:2]
Sigma12<- Sigma[1:2,3:4]
Sigma21<- Sigma[3:4,1:2]
Sigma22<- Sigma[3:4,3:4]
tmp<-Sigma11 - Sigma12%*%solve(Sigma22)%*%Sigma21
tmp[1,2]/sqrt(tmp[1,1]*tmp[2,2])
solve(Sigma)



Omega  =matrix(c(1,0,0.5,0.1,
                 0,1,0.3,0.2,
                 0.5,0.3,1,0,
                 0.1,0.2,0,1)
               ,4,4)
Omega[Omega!=0] <- 1
diag(Omega) <- 0
ed <- graph_from_adjacency_matrix(Omega, mode='undirected')
plot(ed)


rm(list = ls())
library(dplyr)
library(arulesViz)
data("Groceries")
head(Groceries)
str(Groceries)
summary(Groceries)
rules <- apriori(Groceries, parameter=list(support=0.001, confidence=0.5))

?apriori

# transaction class
# list type
a_list <- list(
  c("a","b","c"),
  c("a","b"),
  c("a","b","d"),
  c("c","e"),
  c("a","b","d","e")
)

## set transaction names
names(a_list) <- paste("Tr",c(1:5), sep = "")
a_list
## coerce into transactions
## transaction class is defined by 'arulesViz'
trans1 <- as(a_list, "transactions")
summary(trans1)
str(trans1)
image(trans1)


# matrix type
a_matrix <- matrix(c(
  1,1,1,0,0,
  1,1,0,0,0,
  1,1,0,1,0,
  0,0,1,0,1,
  1,1,0,1,1
), ncol = 5)

## set dim names
dimnames(a_matrix) <- list(paste("Tr",c(1:5), sep = ""),
                           c("媛�","��","��","��","留�"))
a_matrix
trans2 <- as(a_matrix, "transactions")
trans2
rules <- apriori(trans2, parameter=list(support=0.001, confidence=0.01))
inspect(head(sort(rules, by ="lift"),3))

# see transactions-class{arules}

# apriori algorithm
rules <- apriori(Groceries, parameter=list(support=0.001, confidence=0.5))
inspect(head(arules::sort(rules, by ="lift"),3))
plot(rules, method = NULL, measure = "support", shading = "lift")
plot(rules, measure=c("support", "lift"), shading="confidence")
# �쐎rder,�� i.e., the number of items contained in the rule
plot(rules, shading="order", control=list(main = "Two-key plot"))

sel <- plot(rules, measure=c("support", "lift"), shading="confidence", interactive=TRUE)

rules%>%quality()


subrules <- head(sort(rules, by="lift"), 10)
plot(subrules2, method="graph",measure = 'lift',
     shading = 'confidence')

## graphical model 
library(glasso)
x<-matrix(rnorm(50*20),ncol=20)
s<- var(x)
a<-glasso(s, rho=.01)
aa<-glasso(s,rho=.02, w.init=a$w, wi.init=a$wi)
aa$wi