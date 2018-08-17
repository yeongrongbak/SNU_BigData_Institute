#R code
rm(list=ls())
gc()

setwd("D:/Dropbox/조교자료/고용노동부_추천_201710/recommender_실습자료")
#install.packages("arules")

#########################################
#Association Analysis                   #
#########################################

# Practice 1
# (1) data check 
tot1=read.csv("tot.csv", header = TRUE) #for 37284 ppl, 387 products

# need to load 'ref_data_ver2' file
load("ref_data_ver2.RData")
#ls() => tot.data, unq.itm, unq.itm.name, unq.user, usr.profile

tot=tot[,-1]
colnames(tot)=unq.itm
rownames(tot)=unq.usr
head(tot)

# (2)
#model fitting

library(arules)
colnames(tot)=unq.itm.name
rules=apriori(as.matrix(tot), parameter=list(supp=0.01, conf=0.5))
#minlen=최소물품수(lhs+rhs), maxlen=최대물품수(lhs+rhs), smax=최대 지지도
print(rules)
rules.sorted=sort(rules, by="lift")
inspect(rules.sorted) #inspect()함수로 규칙을 살펴볼수있음

#관심있는 단어(크림)가 포함된 연관규칙 => subset
rules.sub = subset(rules, rhs %pin% c("크림"))  #관심있는 item 찾을때는 in, ain을 사용할수있음 
inspect(rules.sub)

#강의노트의 appearance 어떻게 쓰나
temp=apriori(as.matrix(tot), parameter=list(supp=0.01, conf=0.5), 
              appearance = list(lhs=c("기저귀/분유  분유  매일유업 "), default="rhs"))
inspect(temp)


# Practice 2: 직접 해보세요!!
shopping=read.csv("shopping.csv", header = TRUE) #for 10000 ppl, 70 products





#-----------------------------------------------------------------------#

colnames(shopping) = c("customer", "goods", "times")
#length(unique(shopping$customer))
#length(unique(shopping$goods))
i <- shopping$customer
j <- shopping$goods
library(Matrix)
shopping.m=sparseMatrix(i,j,dims=c(max(i),max(j)),x=1) #x=1: 0/1로 넣겠다. default 는 true/false
image(shopping.m[1:100,]) # 고객 100명이 어떤 패턴으로 상품 구매사는지 보자.
shopping.m=as.matrix(shopping.m)

head(shopping.m)

rules2=apriori(shopping.m, parameter=list(supp=0.5, conf=0.5, minlen=2))
rules2.sorted=sort(rules2, by="lift")
inspect(rules2.sorted)

#위에서 말한 in, ain 사용해보자.

rules.sub2 = subset(rules2, lhs %in% c("27","11"))  #lhs에 상품 27 또는 11들어가는 규칙
inspect(rules.sub2)

rules.sub3 = subset(rules2, lhs %ain% c("27","11"))  #lhs에 상품 27, 11 동시에 들어가는 규칙 
inspect(rules.sub3)
