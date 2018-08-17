rm(list=ls())
gc()

library(recommenderlab)

# Practice 2: MovieLense data
data("MovieLense")
#head(as(MovieLense,"matrix"))
dim(MovieLense)
head(getRatingMatrix(MovieLense))

#1-100 user, 1-100 movie ratings
image(MovieLense[1:100,1:100])

#30% 검증자료 생성
MovieLense <- as(MovieLense, "matrix")
n.user=nrow(MovieLense); n.item=ncol(MovieLense)
set.seed(123)
subset=sample.int(sum(!is.na(MovieLense)),sum(!is.na(MovieLense))*.3) #rating 된 점수중 30%만 추출
subset=sort(subset)
train = MovieLense; test =MovieLense
train[!is.na(train)][subset] = NA; test[!is.na(test)][-subset] = NA #rating 된 점수들 중 train, test 나눔

#----- User based Collaborative filtering -----#
rtrain = as(train,"realRatingMatrix") #rating matrix 만 함수의 input으로 가능
r=Recommender(rtrain, method="UBCF")

#RMSE
pr=predict(r, rtrain, type="ratings")
pr=as(pr, "matrix") #이미 평가한 자료의 경우 예측값을 주지 않는다
pr[1:10,1:10]

pr[pr>5]=5 #5보다 크면 5, 1보다 작으면 1로 예측하겠다.
pr[pr<1]=1
RMSE(test, pr)


#----- matrix factorization -----#
library(matfact)
mf = matfact(as(MovieLense,"matrix"), 0.2, 5, 100)
pred = mf$P %*% t(mf$Q)
colnames(pred)=colnames(MovieLense) ; rownames(pred)=rownames(MovieLense)
head(pred[,1:10])

pred[pred>5]=5 
pred[pred<1]=1
RMSE(test,pred)
RMSE(train,pred)


#----- Scale 보정 -----#
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
#cv.lm = cv.glmnet(dummy, dgmat$rating, type.measure = "deviance", alpha=0) # squared-error for gaussian madel
#cv.lm$lambda.min

lm = glmnet(dummy, dgmat$rating, family="gaussian", alpha=0, lambda=0.2)
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

scale.value=matrix(mu.0, nrow = n.user, ncol = n.item)
scale.value = apply(scale.value, 2, function(x) x+mu.u$coef )
scale.value = t(apply(scale.value, 1, function(x) x+mu.i$coef))

pr1.final =scale.value + pr1

#RMSE
pr1.final[pr1.final>5]=5 
pr1.final[pr1.final<1]=1
RMSE(test,pr1.final) #scale 보정한 결과가 더 좋ㅇ



#----- Scale 보정 + MF -----#
mat1=as(mat,"matrix")           #앞에서 scale 보정에 사용했던 mat 변수를 그대로 사용하면 된다.
mf1 = matfact(mat1)
pred1 = mf1$P %*% t(mf1$Q)

colnames(pred1)=item ; rownames(pred1)=user
pred1.final=pred1+scale.value       #앞에서와 같은 보정값을 더해주면 된다


pred1.final[pred1.final>5]=5 
pred1.final[pred1.final<1]=1
RMSE(test,pred1.final)
RMSE(train, pred1.final) #overfitting
