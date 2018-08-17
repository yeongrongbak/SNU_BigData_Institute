rm(list=ls())
gc()

setwd("D:/Dropbox/조교자료/고용노동부_추천_201710/recommender_실습자료")

#install.packages("Matrix")
#install.packages("FactoRizationMachines")

#########################################
# Factorization machines                #
#########################################

# Practice 1
ml100k = read.csv("ml100k.csv")
colnames(ml100k) = c("user","item","rating","time")
head(ml100k)

library(Matrix)
user=ml100k[,1] #943명
items=ml100k[,2]+max(user) #1682개
wdays=(as.POSIXlt(ml100k[,4],origin="1970-01-01")$wday+1)+max(items) 
#POSIX 시간 또는 Unix 시간 (1970년 1월 1일 00:00:00 협정 세계시(UTC) 부터의 경과 시간을 초로 환산하여 정수로 나타냄)
#as.POSIXlt : POSIX 시간을 연도, 월, 일, 시, 분, 초로 바꿔주는 함수

data=sparseMatrix(i=rep(1:nrow(ml100k),3),j=c(user,items,wdays),giveCsparse=F)
target=ml100k[,3]

#100000개 자료중 20% 를 뽑음 
set.seed(123)
subset=sample.int(nrow(data),nrow(data)*.2)
subset=sort(subset)
data.train=data[-subset,]
data.test=data[subset,]
target.train=target[-subset]
target.test=target[subset]


# Predict ratings with second-order Factorization Machine
# with second-order 10 factors (default) and regularization
library(FactoRizationMachines)
set.seed(1)
#10은 second-order factor 갯수(K)
model=FM.train(data.train,target.train,regular=0.1, c(1,10), iter=200) 
model

# RMSE resulting from test data prediction
pre=predict(model,data.test)
summary(pre)
sqrt(mean((pre-target.test)^2)) #RMSE of test set
sqrt(mean((predict(model,data.train)-target.train)^2)) #RMSE of train set


# Practice 2 : RC data :Restaurant & consumer data Data Set
#https://archive.ics.uci.edu/ml/datasets/Restaurant+%26+consumer+data#
#직접 해보세요!
