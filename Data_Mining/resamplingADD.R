
# Rcode 1: Caravan Insurance Data 

library(ISLR)
library(class)
dim(Caravan)
attach(Caravan)
summary (Purchase)
allX=scale(Caravan[,-86])
allY=Purchase 
n=length(allY)
#
# 6 fold cross-validation을 통하여 K를 정하는 R code 
#
#  n=5822, p=85 
#

misclass=matrix(0,20,6)

for(l in (1:20)){
	for(m in (1:6)){
		start=(m-1)*1000+1
		end=m*1000
		if(m==6){end=n}
		test.X=allX[start:end,]
		test.Y=allY[start:end]
		train.X=allX[-(start:end),]
		train.Y=allY[-(start:end)]
		set.seed (1)
    	knn.pred=knn(train.X,test.X,train.Y,k=l)
    	misclass[l,m]=sum(test.Y!=knn.pred)
    }
    cat("\n")
    cat(l)
}
 
err=apply(misclass,1,sum)/n 
plot(1:20,err,type="o")

detach(Caravan)

#
#
# R code 2:  Bootstrap function estimation - confidence band 
#
#

library(ISLR)
library(boot)
head(Auto)
attach(Auto)

mpg.fit=lm(mpg~poly(horsepower,5))
pred.x=data.frame(horsepower=seq(46,230,1))
mpg.pred=predict.lm(mpg.fit,newdata=pred.x,se.fit=T)
plot(seq(46,230,1),mpg.pred$fit,type="l",
  xlab="horsepower",ylab="mpg")

#
#
# Two ways of bootstrap/ naive and residual bootstrap 
# Here, residual bootstrap
#  
#

oresid=mpg.fit$resid 
ofit=mpg.fit$fitted 
betaest=mpg.fit$coefficients 
n=length(oresid)


B=1000
d=length(seq(46,230,1))
bootfit=matrix(0,B,d) 
bootsamp=bootresid=rep(0,n)

for(b in (1:B)){ 

	sampid=sample(n,n,replace=T)
	bmpg=ofit+oresid[sampid]
	bmpg.fit=lm(bmpg~poly(horsepower,5))
	bmpg.pred=predict.lm(bmpg.fit,newdata=pred.x,se.fit=T)
    bootfit[b,]=as.numeric(bmpg.pred$fit)
       cat("\n")
    cat(b)
}
	
bse.fit=sqrt(apply(bootfit,2,var))
ose.fit=mpg.pred$se.fit 
r=ose.fit/bse.fit 
plot(seq(46,230,1),r,type="l",ylim=c(0.5,2))
abline(h=1,col="blue")
title("ratio of standard errors: theory to bootstrap")


upper=mpg.pred$fit+1.96*bse.fit 
lower=mpg.pred$fit-1.96*bse.fit 

plot(seq(46,230,1),mpg.pred$fit,type="l",xlab="horsepower",
  ylab="mpg",ylim=c(5,40))
lines(seq(46,230,1),upper,col="blue")
lines(seq(46,230,1),lower,col="blue")
title("bootstrap confidence band (pointwise)")




