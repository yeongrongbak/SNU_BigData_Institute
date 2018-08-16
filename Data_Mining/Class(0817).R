library(ISLR)

str(Smarket)

attach(Smarket)

plot(Volume)

plot(Today)

plot(Volume, Today)

boxplot(Volume~Year)

train=(Year<2005)
Smarket.2005=Smarket[!train,]
dim(Smarket.2005)

Direction.2005=Direction[!train]

library(class)
train.X=cbind(Lag1,Lag2)[train,]
test.X=cbind(Lag1,Lag2)[!train,]
train.Direction=Direction[train]
set.seed(1)
knn.pred=knn(train=train.X, test=test.X, cl=train.Direction, k=3, prob=TRUE)
table(knn.pred,Direction.2005)
head(attributes(knn.pred)$prob)

knn.pred=knn(train.X, test.X, train.Direction, k=3)
table(knn.pred, Direction.2005)

mean(knn.pred==Direction.2005)
 
