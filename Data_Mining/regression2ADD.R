
install.packages("glmnet")
library(glmnet)
credit=read.csv("Credit.csv")
head(credit)


  X  Income Limit Rating Cards Age Education Gender Student Married Ethnicity Balance
1 1  14.891  3606    283     2  34        11   Male      No     Yes Caucasian     333
2 2 106.025  6645    483     3  82        15 Female     Yes     Yes     Asian     903
3 3 104.593  7075    514     4  71        11   Male      No      No     Asian     580
4 4 148.924  9504    681     3  36        11 Female      No      No     Asian     964
5 5  55.882  4897    357     2  68        16   Male      No     Yes Caucasian     331
6 6  80.180  8047    569     4  77        10   Male      No      No Caucasian    1151

attach(credit)
Income=scale(Income)
Limit=scale(Limit)
Rating=scale(Rating)
grid=10^seq(10,-2,length=100)
x=cbind(Income,Limit,Rating,Student) 
y=Balance
# 400 * 4
ridge.mod=glmnet(x,y,alpha=0,lambda=grid)
dim(coef(ridge.mod))
coef(ridge.mod)[,50]
plot(log(grid),coef(ridge.mod)[2,],type="l",col="red",
ylim=c(min(coef(ridge.mod)),max(coef(ridge.mod)) ))
lines(log(grid),coef(ridge.mod)[3,],col="blue")


#
# Ridge lambda의 선택 
#
#

set.seed(1) 
cv.out=cv.glmnet(x,y,alpha=0,lambda=grid)
plot(cv.out)
bestlamb=cv.out$lambda.min 
bestlamb 
#
#bestlamb 
#[1] 1.149757
#

#
#
# LASSO -1 
#
#

lasso.mod=glmnet(x,y,alpha=1,lambda=grid)
plot(lasso.mod,label=T)
cv2.out=cv.glmnet(x,y,alpha=0,lambda=grid)
plot(cv2.out)

#
# TRY with Hitters Data as the data lab. 
#
#

library(ISLR)
Hitters=na.omit(Hitters)
dim(Hitters)

attach(Hitters)
x=model.matrix(Salary~.,Hitters)[,-1]
y=Hitters$Salary

grid=10^seq(4,-1,length=100)
set.seed(1) 
cv2.out=cv.glmnet(x,y,alpha=1,lambda=grid)
plot(cv2.out)
title("Hitters")
bestlamb2=cv2.out$lambda.min 
bestlamb2 
#
#> bestlamb2 
#[1] 2.915053
lasso.mod=glmnet(x,y,alpha=1,lambda=exp(bestlamb2))
lasso.est=coef(lasso.mod)


lasso.mod=glmnet(x,y,alpha=1)
plot(lasso.mod,label=T)
plot(lasso.mod,label=T,ylim=c(-5,5),xlim=c(0,20))
est=coef(lasso.mod)
est
lambda=lasso.mod$lambda
lambda 
lambda[29:30]

lasso.est=coef(lasso.mod)lasso.est

#
#> lambda[29:30]
#[1] 18.86719 17.19108
#

lasso.mod=glmnet(x,y,alpha=1,lambda=18)
lasso.est=coef(lasso.mod)
lasso.est

#
#20 x 1 sparse Matrix of class "dgCMatrix"
#                      s0
#(Intercept)   23.1333216
#AtBat          .        
#Hits           1.8561903
#HmRun          .        
#Runs           .        
#RBI            .        
#Walks          2.2048893
#Years          .        
#CAtBat         .        
#CHits          .        
#CHmRun         .        
#CRuns          0.2065596
#CRBI           0.4106113
#CWalks         .        
#LeagueN        .        
#DivisionW   -101.3119200
#PutOuts        0.2178163
#Assists        .        
#Errors         .        
#NewLeagueN     .        
#> 
