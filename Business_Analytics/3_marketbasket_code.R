rm(list=ls())
gc()
setwd("C:/Users/user/OneDrive/서울대 아카데미/3학기/비즈니스 분석(김용대)/실습/recommender1_실습자료")

#install.packages("dplyr")
#install.packages("tidyr")
#install.packages("glmnet")
#install.packages("xgboost")

#########################################
# Market Basket Regression              #
#########################################

# Practice 1: Card dataset

data <- read.csv("card.csv") #5027693 by 6
head(data)

# 고객 "P223597622"
data[data$CLNN=="P223597622" & data$APV_TS_D < 20140700,]
data[which(data$CLNN=="P223597622" & data$APV_TS_D > 20140700),]

library(dplyr)

#month 추출
data1 <- data %>% mutate(month=ifelse(APV_TS_D>20140700, 7, 6), 
                         month=ifelse(APV_TS_D<20140601, 5, month)) %>% select(-APV_TS_D)

#user정보 추출. 60879명
user <- data1 %>% select(CLNN, SEX_CCD, CLN_AGE, AVG_Y_INA) %>% 
  distinct(CLNN, .keep_all=TRUE)

#나이, 성별 더미
user <- user %>% mutate(age2 =ifelse( (CLN_AGE>=40 & CLN_AGE <60), 1, 0),
                        age3 =ifelse(CLN_AGE >=60, 1, 0)) %>% select(-CLN_AGE)
user$SEX_CCD <- ifelse(user$SEX_CCD =="F", 1, 0)

library(tidyr)

#5,6월 자료로 설명변수 만듦

input <- data1 %>% filter(month !=7) %>% group_by(CLNN, MCT_RY_NM) %>% 
  summarise(count=n()) %>% spread(MCT_RY_NM, count) %>% ungroup()
input <- input %>% inner_join(user, by="CLNN")
input[is.na(input)]=0
head(input)

#7월 자료로 종속변수 만듦

label <- data1 %>% filter(month==7) %>% group_by(CLNN, MCT_RY_NM) %>% summarise(label=1)%>% ungroup()
label <- label %>% group_by(CLNN) %>% spread(MCT_RY_NM, label) %>% ungroup()
label[is.na(label)]=0
head(label)

#고객 순서 똑같은지 check

sum(input$CLNN != label$CLNN)


#30% 는 평가자료로 사용하자.

set.seed(1001)

idx.ts = sample(1:nrow(input), round(nrow(input)*0.3))
idx.ts = sort(idx.ts)

train=input[-idx.ts,]; label.tr = label[-idx.ts,]
test=input[idx.ts,]; label.ts = label[idx.ts,]

#user index는 따로 저장

user.tr = train$CLNN; user.ts = test$CLNN
train = train[,-1]; test = test[,-1]
label.tr = label.tr[,-1]; label.ts = label.ts[,-1]

#구매횟수 많거나 적은 품목 추천

item.count=apply(train[,1:30], 2, sum)
item.count=sort(item.count, decreasing = T)
head(item.count)

#---------- 모형 1: 추천횟수 많은 품목 추천------------------------------------------------#

real.item=colSums(label.ts)

real.item #29: 할/슈, 28: 한식, 27: 편의점

real.item[29]/length(user.ts) #할인점/슈퍼마켓 추천
sum(real.item[c(29,28)])/(2*length(user.ts)) #할인점/슈퍼마켓, 한식 추천
sum(real.item[c(29,28,27)])/(3*length(user.ts)) #할인점/슈퍼마켓,한식, 편의점 추천
sum(real.item[c(25,9,21)])/(3*length(user.ts)) #커피전문점, 백화점, 제과점. 강의노트 틀림


#---------- 모형 2: 로지스틱 모형 ------------------------------------------------#
p.logis = label.ts #확률 저장할 table
library(glmnet)

for(i in 1:30){
  lm=glmnet(x=as.matrix(train), y=as.matrix(label.tr[,i]), family="binomial", alpha=0, lambda = 0.02)
  p.logis[,i]=predict(lm, as.matrix(test), type="response")
  rm(lm); gc()
}

#user별 첫번째, 두번째, 세번째 확률 높은 아이템 인덱스 추출
index1=apply(p.logis, 1, function(x) sort.int(t(x), index.return=TRUE, decreasing = T)$ix[1])
index2=apply(p.logis, 1, function(x) sort.int(t(x), index.return=TRUE, decreasing = T)$ix[2])
index3=apply(p.logis, 1, function(x) sort.int(t(x), index.return=TRUE, decreasing = T)$ix[3])

#Hit ratio (Precision)
sum(as.matrix(label.ts)[cbind(1:nrow(label.ts),index1)])/length(user.ts)
(sum(as.matrix(label.ts)[cbind(1:nrow(label.ts),index1)]) + sum(as.matrix(label.ts)[cbind(1:nrow(label.ts),index2)]))/
  (2*length(user.ts))
(sum(as.matrix(label.ts)[cbind(1:nrow(label.ts),index1)]) + sum(as.matrix(label.ts)[cbind(1:nrow(label.ts),index2)])+ 
    sum(as.matrix(label.ts)[cbind(1:nrow(label.ts),index3)]))/
  (3*length(user.ts))

#추천 품목수
length(unique(index1))
length(unique(index2))
length(unique(index3))


#품목별로 구매가능성 높은 일부 고객에게 추천

#커피전문점, 백화점, 제과점
colnames(p.logis)[25]; colnames(p.logis)[9]; colnames(p.logis)[21]
sum(label.ts[,25]); sum(label.ts[,9]); sum(label.ts[,21])

#품목별 구매가능성 높은 고객700명에게 추천
(sum(label.ts[sort.int(t(p.logis[,25]), index.return=TRUE, decreasing = T)$ix[1:7000],25]) +
    sum(label.ts[sort.int(t(p.logis[,9]), index.return=TRUE, decreasing = T)$ix[1:7000],9]) +
    sum(label.ts[sort.int(t(p.logis[,21]), index.return=TRUE, decreasing = T)$ix[1:7000],21])) / (7000*3)



#---------- 모형 3: boosting 모형 ------------------------------------------------#

p.boost = label.ts #확률 저장할 table
library(xgboost)

for(i in 1:30){
  X=xgb.DMatrix(as.matrix(train), label=as.matrix(label.tr)[,i])
  model <- xgboost(X, max_depth=3, eta=0.1, nrounds = 200, objective="binary:logistic", verbose = F)
  p.boost[,i]=predict(model, as.matrix(test), type="response")
  rm(model);gc()
}

#user별 첫번째, 두번째, 세번째 확률 높은 아이템 인덱스 추출
ind1=apply(p.boost, 1, function(x) sort.int(t(x), index.return=TRUE, decreasing = T)$ix[1])
ind2=apply(p.boost, 1, function(x) sort.int(t(x), index.return=TRUE, decreasing = T)$ix[2])
ind3=apply(p.boost, 1, function(x) sort.int(t(x), index.return=TRUE, decreasing = T)$ix[3])

sum(as.matrix(label.ts)[cbind(1:nrow(label.ts),ind1)])/length(user.ts)
(sum(as.matrix(label.ts)[cbind(1:nrow(label.ts),ind1)]) + sum(as.matrix(label.ts)[cbind(1:nrow(label.ts),index2)]))/
  (2*length(user.ts))
(sum(as.matrix(label.ts)[cbind(1:nrow(label.ts),ind1)]) + sum(as.matrix(label.ts)[cbind(1:nrow(label.ts),index2)])+ 
    sum(as.matrix(label.ts)[cbind(1:nrow(label.ts),ind3)]))/
  (3*length(user.ts))

length(unique(ind1))
length(unique(ind2))
length(unique(ind3))


#품목별로 구매가능성 높은 일부 고객에게 추천

#커피전문점, 백화점, 제과점
(sum(label.ts[sort.int(t(p.boost[,25]), index.return=TRUE, decreasing = T)$ix[1:7000],25]) +
    sum(label.ts[sort.int(t(p.boost[,9]), index.return=TRUE, decreasing = T)$ix[1:7000],9]) +
    sum(label.ts[sort.int(t(p.boost[,21]), index.return=TRUE, decreasing = T)$ix[1:7000],21])) / (7000*3)

#실제 구매 고객수
sum(label.ts[,25], na.rm=T)
sum(label.ts[,9], na.rm=T)
sum(label.ts[,21], na.rm=T)




# Practice 2: 직접 해보세요!!
rm(list=ls())
gc()

insta <- read.csv("instacart.csv")

set.seed(1001)

idx.ts = sample(1:nrow(insta), round(nrow(insta)*0.3))
idx.ts = sort(idx.ts)

train=is[-idx.ts,]; tr.mat = label[-idx.ts,]
test=input[idx.ts,]; ts.mat = label[idx.ts,]



colnames(tr.mat)

X <- xgb.DMatrix(as.matrix(tr.mat[,-c(1,2,37)]), label = tr.mat$reordered)
model <- xgboost(dadta = X, max_depth=5, eta=0.1, nrounds = 200, objective="binary:logistic")

importance <- xgb.importance(colnames(X), model = model)
xgb.ggplot.importance(importance)
