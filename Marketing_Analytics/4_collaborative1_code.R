rm(list=ls())
gc()

setwd("D:/Dropbox/조교자료/고용노동부_추천_201710/recommender_실습자료")
#install.packages("recommenderlab")

#########################################
# Collaborative filtering               #
#########################################

# Practice 1: Jester5k 


#----- (4-1)UBCF ----------#
#jester5k data loading
library(recommenderlab)
data(Jester5k)
head(getRatingMatrix(Jester5k))
#head(as(Jester5k, "matrix")) 

image(Jester5k[1:80,])      #Jester5k user1~80까지만 추출해서 ratingmatrix를 확인

#30% 검증자료 생성
n.user=1000; n.item=ncol(Jester5k)
a <- as(Jester5k[1:n.user],"matrix") #1000 명의 user만 사용
set.seed(123)
subset=sample.int(sum(!is.na(a)),sum(!is.na(a))*.3) #rating 된 점수중 30%만 추출
subset=sort(subset)
train = a; test =a
train[!is.na(train)][subset] = NA; test[!is.na(test)][-subset] = NA #rating 된 점수들 중 train, test 나눔


#User based Collaborative filtering
rtrain = as(train,"realRatingMatrix") #rating matrix 만 함수의 input으로 가능
r=Recommender(rtrain, method="UBCF")  #method를 IBCF로하면 item-based CF
getModel(r)$method
getModel(r)$nn
pr=predict(r, rtrain[1:2,], type="ratings")
as(pr, "matrix") #이미 평가한 자료의 경우 예측값을 주지 않는다

#n을 통해 추천품목수를 조정 가능 
ptype=predict(r, rtrain[1:2,], n=5)
as(ptype, "list")

#RMSE
pr=predict(r, rtrain, type="ratings")
pr=as(pr, "matrix") #이미 평가한 자료의 경우 예측값을 주지 않는다

pr[pr>10]=10 #10보다 크면 10, -10보다 작으면 -10으로 예측하겠다.
pr[pr<(-10)]=-10
RMSE(test, pr)



#----- (4-2) 스케일 보정  ----------#
dgmat=cbind(train[1:(n.user*n.item)], as.data.frame(cbind(rep(rownames(train), n.item), 
                                                          rep(colnames(train), each=n.user))))  

#각 행은 하나의 평점에 대한 정보를 가짐
colnames(dgmat) <- c("rating","user","item")
user = unique(dgmat$user); item = unique(dgmat$item)
head(dgmat)
dgmat = dgmat[is.na(dgmat$rating)==F,]        #평점이 있는 정보만 사용
#making dummy variable
dummy = model.matrix(rating~user+item, dgmat) #user와 item에 대해 dummy variable 생성, 변수 1개 기준으로 999개
dummy = dummy[,-1] # coefficient term은 제외하자

library(glmnet)
set.seed(100)
cv.lm = cv.glmnet(dummy, dgmat$rating, type.measure = "deviance", alpha=0) # squared-error for gaussian madel
cv.lm$lambda.min

lm= glmnet(dummy, dgmat$rating, family="gaussian", lambda = cv.lm$lambda.min, alpha=0)
#lm= glmnet(dummy, dgmat$rating, family="gaussian", lambda = 0.2, alpha=0)
head(coef(lm))

#나머지 점수로 neighborhood method
dgmat$rating = dgmat$rating - (lm$a0 + dummy %*% lm$beta)
#각 row의 user(item)가 몇번째 user(item) 인지 확인
user.index = match(dgmat$user, user); item.index = match(dgmat$item, item) 
mat=sparseMatrix(i=user.index, j=item.index, x=dgmat$rating)
#dgmat$rating 값 중 0이 없음을 확인하고 NA를 넣음
mat=as.matrix(mat) ; sum(dgmat$rating==0,na.rm=T) ; mat[mat==0]=NA          
colnames(mat)=item; rownames(mat)=user
#Recommender 함수를 위해 다시 rating matrix로..
mat= as(mat, "realRatingMatrix")                                  


r1= Recommender(mat, method="UBCF")
pr1=predict(r1, mat, type="ratings")
pr1 = as(pr1, "matrix")
#user를 ""로바꾸는 function
rownames(lm$beta) = gsub('user','', rownames(lm$beta)); rownames(lm$beta) = gsub('item', '', rownames(lm$beta)) 
item=as.character(item); user=as.character(user)

# 추정된 값들을 따로 저장
tmp.cf=data.frame(as.matrix(rownames(lm$beta)), as.matrix(lm$beta))
mu.0=lm$a0
mu.u=data.frame(user)
mu.i=data.frame(item)

library(dplyr)
colnames(tmp.cf) =c("user", "coef"); mu.u <- mu.u %>% left_join(tmp.cf, by="user")
colnames(tmp.cf) =c("item", "coef"); mu.i <- mu.i %>% left_join(tmp.cf, by="item")
mu.u[is.na(mu.u$coef),]$coef = 0 ; mu.i[is.na(mu.i$coef),]$coef = 0

scale.value=matrix(mu.0, nrow = length(user), ncol = length(item))
scale.value = apply(scale.value, 2, function(x) x+mu.u$coef )
scale.value = t(apply(scale.value, 1, function(x) x+mu.i$coef))

pr1.final =scale.value + pr1

#pr1.final
sort(pr1.final[1,], decreasing=T) #user1에 대해 예상평점이 높은 순으로 정렬
sort(pr1.final[2,], decreasing=T)


#RMSE
pr1.final[pr1.final>10]=10 #10보다 크면 10, -10보다 작으면 -10으로 예측하겠다.
pr1.final[pr1.final<(-10)]=-10
RMSE(test,pr1.final)


# Practice 2: MovieLense data
data("MovieLense")

#위 과정을 따라서 해보세요!


################################################
# Matrix factorization                         #
################################################

# Practice 1: Jester5k
#----- (5-1) MF  ----------#

#install library
library(matfact)

mf = matfact(train)
#mf = matfact(as(Jester5k,"matrix")[1:1000,], 0.2, 5, 100)
pred = mf$P %*% t(mf$Q)

colnames(pred)=item ; rownames(pred)=user
head(pred[,1:10])

#prediction
i1 = is.na(train[1,])     #사용자 1,2가 평점을 내리지 않은 상품들을 추출
i2 = is.na(train[2,])
pred[1,i1==T] ; pred[2,i2==T]         #평점을 내리지 않은 상품들에 대해서만 예상평점을 관찰
sort(pred[1,i1==T],decreasing=T)
sort(pred[2,i2==T],decreasing=T)

pred[pred>10]=10 #10보다 크면 10, -10보다 작으면 -10으로 예측하겠다.
pred[pred<(-10)]=-10
RMSE(test,pred)
RMSE(train,pred)


#----- (5-2) scale 보정 ----------#
mat1=as(mat,"matrix")           #앞에서 scale 보정에 사용했던 mat 변수를 그대로 사용하면 된다.
mf1 = matfact(mat1)
pred1 = mf1$P %*% t(mf1$Q)

colnames(pred1)=item ; rownames(pred1)=user
pred1.final=pred1+scale.value       #앞에서와 같은 보정값을 더해주면 된다
pred1.final[1,i1==T] ; pred1.final[2,i2==T]       #matrix factorization을 통한 user1,2의 예상별점
#별점 순으로 정렬
sort(pred1.final[1,i1==T],decreasing=T); sort(pred1.final[2,i2==T],decreasing=T)    


pred1.final[pred1.final>10]=10 #10보다 크면 10, -10보다 작으면 -10으로 예측하겠다.
pred1.final[pred1.final<(-10)]=-10
RMSE(test,pred1.final)
RMSE(train, pred1.final)


# Practice 2: MovieLense data
#위 과정을 따라서 해보세요!
