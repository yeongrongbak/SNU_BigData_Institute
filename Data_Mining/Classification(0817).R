library(ISLR)

str(Smarket)

attach(Smarket)

plot(Volume)

plot(Today)

plot(Volume, Today)

boxplot(Volume~Year)


# Rogistic Regression

glm.fit=glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume,data=Smarket,family=binomial)

summary(glm.fit)

coef(glm.fit)

summary(glm.fit)$coef

glm.probs=predict(glm.fit,type="response")
glm.probs[1:10]

contrasts(Direction)

glm.pred=rep("Down",1250)

glm.pred[glm.probs>.5]="Up"

table(glm.pred,Direction)

(507+145)/1250

mean(glm.pred==Direction)

train=(Year<2005)

Smarket.2005=Smarket[!train,]

dim(Smarket.2005)

Direction.2005=Direction[!train]
glm.fit=glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume,data=Smarket,family=binomial,subset=train)
glm.probs=predict(glm.fit,Smarket.2005,type="response")
glm.pred=rep("Down",252)
glm.pred[glm.probs>.5]="Up"
table(glm.pred,Direction.2005)

mean(glm.pred==Direction.2005)

mean(glm.pred!=Direction.2005)

glm.fit=glm(Direction~Lag1+Lag2,data=Smarket,family=binomial,subset=train)
glm.probs=predict(glm.fit,Smarket.2005,type="response")
glm.pred=rep("Down",252)
glm.pred[glm.probs>.5]="Up"
table(glm.pred,Direction.2005)

mean(glm.pred==Direction.2005)

106/(106+76)

predict(glm.fit,newdata=data.frame(Lag1=c(1.2,1.5),Lag2=c(1.1,-0.8)),type="response")

# 선형 판별 분석

library(MASS)

lda.fit=lda(Direction~Lag1+Lag2,data=Smarket,subset=train)

lda.fit

plot(lda.fit)

lda.pred=predict(lda.fit, Smarket.2005)

names(lda.pred)

lda.class=lda.pred$class

table(lda.class,Direction.2005)

mean(lda.class==Direction.2005)

sum(lda.pred$posterior[,1]>=.5)

sum(lda.pred$posterior[,1]<.5)

lda.pred$posterior[1:20,1]

lda.class[1:20]

sum(lda.pred$posterior[,1]>.9)

# 이차 판별 분석

qda.fit=qda(Direction~Lag1+Lag2,data=Smarket,subset=train)
qda.fit

qda.class=predict(qda.fit,Smarket.2005)$class

table(qda.class,Direction.2005)

mean(qda.class==Direction.2005)

# 최근접이웃방법

library(class)
train.X=cbind(Lag1,Lag2)[train,]
test.X=cbind(Lag1,Lag2)[!train,]
train.Direction=Direction[train]
set.seed(1)
knn.pred=knn(train.X,test.X,train.Direction,k=1)
table(knn.pred,Direction.2005)

(83+43)/252

knn.pred=knn(train.X,test.X,train.Direction,k=3)
table(knn.pred,Direction.2005)

mean(knn.pred==Direction.2005)

