auto = read.csv("Auto.csv", header=T, sep=",")
auto$horsepower = as.numeric(auto$horsepower)
head(auto)

library(ISLR)

# 검증자료방법을 이용한 다항회귀 차수 결정

set.seed(1)
train=sample(397,198)

lm.fit=lm(mpg~horsepower,data=auto,subset=train)
attach(auto)
mean((mpg-predict(lm.fit,auto))[-train]^2)

lm.fit2=lm(mpg~poly(horsepower,2),data=auto,subset=train)
mean((mpg-predict(lm.fit2,auto))[-train]^2)

lm.fit3=lm(mpg~poly(horsepower,3),data=auto,subset=train)
mean((mpg-predict(lm.fit3,auto))[-train]^2)

set.seed(2)
train=sample(397,198)
lm.fit=lm(mpg~horsepower,subset=train)
mean((mpg-predict(lm.fit,auto))[-train]^2)

lm.fit2=lm(mpg~poly(horsepower,2),data=auto,subset=train)
mean((mpg-predict(lm.fit2,auto))[-train]^2)

lm.fit3=lm(mpg~poly(horsepower,3),data=auto,subset=train)
mean((mpg-predict(lm.fit3,auto))[-train]^2)

# 하나 남기기 교차검증

glm.fit=glm(mpg~horsepower,data=auto)
coef(glm.fit)

lm.fit=lm(mpg~horsepower,data=auto)
coef(lm.fit)

library(boot)
glm.fit=glm(mpg~horsepower,data=auto)
cv.err=cv.glm(auto, glm.fit)
names(cv.err)

str(cv.err)

cv.error=rep(0,5) 

for (i in 1:5){ 
  glm.fit=glm(mpg~poly(horsepower,i),data=auto)
  cv.error[i]=cv.glm(auto,glm.fit)$delta[1] 
} 

cv.error

# k 겹 교차검증

set.seed(17)
cv.error.10=rep(0,10) 
for (i in 1:10){ 
  glm.fit=glm(mpg~poly(horsepower,i),data=auto)
  cv.error.10[i]=cv.glm(auto,glm.fit, K=10)$delta[1] 
}
cv.error.10

# 붓스트랩

alpha.fn=function(data,index){ 
  X=data$X[index]
  Y=data$Y[index]
return((var(Y)-cov(X,Y))/(var(X)+var(Y)-2*cov(X,Y))) 
  }

str(Portfolio)

alpha.fn(Portfolio,1:100)

set.seed(1)
alpha.fn(Portfolio, sample(100,100,replace=T))

boot(Portfolio, alpha.fn, R=1000)

# 붓스트랩을 이용해서 선형모형의 정확도 구하기

boot.fn=function(data,index)
  return(coef(lm(mpg~horsepower,data=data,subset=index)))
boot.fn(Auto,1:392)

set.seed(1)
boot.fn(Auto,sample(392,392,replace=T))

boot.fn(Auto,sample(392,392,replace=T))

boot(Auto,boot.fn,1000)

summary(lm(mpg~horsepower,data=Auto))$coef

boot.fn=function(data,index)
  coefficients(lm(mpg~horsepower+I(horsepower^2),data=data,subset=index))
set.seed(1)
boot(Auto,boot.fn,1000)

summary(lm(mpg~horsepower+I(horsepower^2),data=Auto))$coef

