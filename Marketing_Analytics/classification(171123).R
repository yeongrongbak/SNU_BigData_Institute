
csoriginal = read.csv('C:/Users/user/OneDrive/서울대 아카데미/3학기/마케팅 애널리틱스(송인성)/classificiation_R코드예제/Clothing_Store')  # 이 부분은 본인 컴퓨터의 폴더 이름에 맞추어 변경


drops = c("HHKEY","ZIP_CODE","REC","PC_CALC20","STORELOY")
cs = csoriginal[,!(colnames(csoriginal) %in% drops)]   # 46 variables
cs$VALPHON = as.integer(cs$VALPHON == "Y")  # transform character into binary 

summary(cs$AVRG)
hist(cs$AVRG,col="lightblue", main="Average Spending per Visit",xlab="Spending", breaks=20)

summary(cs$GMP)
hist(cs$GMP,col="lightblue", main="Gross Margin Percentage",xlab="Gross Margin", breaks=20)

par(mfrow=c(2,1)) 
hist(cs$AVRG,col="lightblue", main="Average Spending ver Visit",xlab="Spending", breaks=20)
hist(cs$GMP,col="lightblue", main="Gross Margin Percentage",xlab="Gross Margin", breaks=20)
par(mfrow=c(1,1))

contmar = cs$AVRG*cs$GMP*0.5
summary(contmar)
hist(contmar,col="lightblue", main="Contribution Margin per Visit",xlab="Contribution Margin", breaks=20)


#
#  split data into training set and test set
#

tratio = 0.7   # portion of training data set

nobs = dim(cs)[1]
set.seed(0,kind=NULL)
tryes = runif(nobs)
tryes = (tryes < tratio)

cstrain = cs[tryes==T,]
cstest = cs[tryes==F,]


## a function that computes the hit ratio of prediction

pred.hit= function(predval,testdata,noprint=FALSE){
  
  r <- predval # variable1 in rows
  c <- testdata # variable2 in columns
  
  # run cross tabulation
  ctab <- xtabs(~r+c)
  
  # frequency table
  table_f <- ctab
  Total1 <- rowSums(ctab); table_f <- cbind(table_f, Total1)
  Total2 <- colSums(table_f); table_f <- rbind(table_f, Total2)
  
  # percentage table
  table_p <- prop.table(ctab)*100
  Total1 <- rowSums(table_p); table_p <- cbind(table_p, Total1)
  Total2 <- colSums(table_p); table_p <- rbind(table_p, Total2)
  
  # row percentage table
  table_r <- prop.table(ctab, 1)*100; sum <- rowSums(table_r);
  table_r <- cbind(table_r, sum)
  
  # col percentage table
  table_c <- prop.table(ctab, 2)*100; sum <- colSums(table_c);
  table_c <- rbind(table_c, sum);
  
  # print results
  if(!noprint){
    cat("Prediction (row) vs. Data (column) ", "\n")
    cat("* Frequency", "\n"); print(table_f); cat("\n")
    cat("* Percentage", "\n"); print(table_p, digits=3);cat("\n")
    cat("* Row Percentage: Distribution of Data for each value of Prediction", "\n"); print(table_r, digits=3); cat("\n")
    cat("* Column Percentage: Distribution of Prediction for each value of Data", "\n"); print(table_c, digits=3); cat("\n")
  }
  cat("Hit Ratio:", (sum(diag(table_p))-100), "\n")
  
  precision = ctab[2,2] /(ctab[2,1]+ctab[2,2])
  recall = ctab[2,2] /(ctab[2,2]+ctab[1,2])
  f1measure = 2*precision*recall/(precision+recall)
  cat("F1 measure", f1measure, "\n")
  
  if(!noprint) return(table_f)
}


##############################################
#
# linear discriminant analysis
#
##############################################

library(MASS)
#ldafit = lda(RESP~.,cstrain)
#ldatrainfit = predict(ldafit)
#ldapred = predict(ldafit, cstest)
#cat("LDA prediction \n")
#ldaout=pred.hit(ldapred$class,cstest$RESP)
#cutoff=0.5
#boxplot(ldapred$posterior[,2]~cstest$RESP, col="lightblue", main="Prediction by Linear Discriminant", xlab="Response Data (Test)", ylab="Probability of Response")
#abline(h=cutoff)

# 그래프 작성시 boxplot 사용하였음. 


##############################################
#
# linear logistic regression 
#
##############################################

nf = table(cstrain$RESP)[1]  # number of False
lgfit = glm(RESP~., cstrain, family=binomial) 
tmpx = sort(lgfit$fitted.values,F)
cutoff = (tmpx[nf]+tmpx[nf+1])/2

lgpred = predict(lgfit, cstest, type="response")
boxplot(lgpred~cstest$RESP, col ='lightblue', main="prediction by Logistic Regression", xlab="Churn Date(Test)", ylab="Probability of churn")
abline(h=cutoff)
lgpredfit = lgpred > cutoff

# 컷오프 설정 주의


##############################################
#
# CART
#
##############################################


library(tree)
cartfit = tree(factor(RESP)~., cstrain)
plot(cartfit)
text(cartfit, all=T, cex=0.7)

title("CART Model Output")
cartfitval = predict(cartfit)
#plot(cartfitval[,2]~chdata$churn)  # need to check
cartpred = predict(cartfit,cstest)
cartpredclass = predict(cartfit,cstest,type="class")

cat("CART prediction  \n")
pred.hit(cartpredclass,cstest$RESP)

cutoff=0.5
plot(cartpred[,2]~cstest$RESP, col="lightblue", main="Prediction by CART", xlab="Regression Data (Test)", ylab="Probability of Response")
abline(h=cutoff)

##############################################
#
# Neural Nets 
#
##############################################

library(nnet)



iniwts = c(-14.189,0.5721987,-2.46693,14.14996,1.069072,8.218367,25.60334,-50.83269,-3.258344,8.945041,-3.098779,
           19.76139,-22.62285,-6.572795,25.81599,-37.81675,13.36847,-16.45772,-31.48462,-4.786692,1.823418,2.197832, 
           2.201936,2.290179,-0.5338952,0.2985827,-6.298235e-05,-0.06599293,6.012408,-1.560587,-0.4468282,0.03615387,
           26.36656,-0.5999836,0.7629284,3.073052,3.338232,-36.68484,-10.15628,-2.186835,12.91674,0.003426986,
           -0.1233861,6.175161,1.048332,-17.70584,-0.5017287,-2.380504)

nnfit1 = nnet(factor(RESP)~.,cstrain, size=1, decay =5e-4,maxit=1000, Wts=iniwts)
nnpred1 = factor(predict(nnfit1,cstest,type="class"))

iniwts2=c(nnfit1$wts[1:46],nnfit1$wts[1:46],nnfit1$wts[47:48],nnfit1$wts[48]) 
nnfit2 = nnet(factor(RESP)~.,cstrain, size=2, decay =5e-4,maxit=1000, Wts=iniwts2) # 히든 노드가 2개
nnpred2 = factor(predict(nnfit2,cstest,type="class"))

iniwts3=c(nnfit2$wts[1:92],nnfit2$wts[1:46],nnfit2$wts[93:95],nnfit2$wts[94])
nnfit3 = nnet(factor(RESP)~.,cstrain, size=3, decay =5e-4,maxit=1000, Wts=iniwts3)
nnpred3 = factor(predict(nnfit3,cstest,type="class"))

iniwts4=c(nnfit3$wts[1:138],nnfit3$wts[1:46],nnfit3$wts[139:142],nnfit3$wts[140])
nnfit4 = nnet(factor(RESP)~.,cstrain, size=4, decay =5e-4,maxit=1000, Wts=iniwts4)
nnpred4 = factor(predict(nnfit4,cstest,type="class"))

iniwts5=c(nnfit4$wts[1:184],nnfit4$wts[1:46],nnfit4$wts[185:189],nnfit4$wts[186])
nnfit5 = nnet(factor(RESP)~.,cstrain, size=5, decay =5e-4,maxit=1000, Wts=iniwts5)
nnpred5 = factor(predict(nnfit5,cstest,type="class"))

iniwts6=c(nnfit5$wts[1:230],nnfit5$wts[1:46],nnfit5$wts[231:236],nnfit5$wts[232]/100)
nnfit6 = nnet(factor(RESP)~.,cstrain, size=5, decay =5e-4,maxit=1000, Wts=iniwts5)
nnpred6 = factor(predict(nnfit6,cstest,type="class"))

# find the best model in terms of hit ratio

pred.hit(nnpred1,cstest$RESP,noprint=TRUE)
pred.hit(nnpred2,cstest$RESP,noprint=TRUE)
pred.hit(nnpred3,cstest$RESP,noprint=TRUE)
pred.hit(nnpred4,cstest$RESP,noprint=TRUE)
pred.hit(nnpred5,cstest$RESP,noprint=TRUE)
pred.hit(nnpred6,cstest$RESP,noprint=TRUE)


# compute hit result for the best model again, and to some boxplot for the results




##############################################
#
# Support Vector Machine ; takes too much time when nobs>10000
#
##############################################

library(e1071)



######################################
# 
# payoff 
#
######################################

profit = function(predout, cm, cost){
  xout = predout[2,3]*cost
  tmargin = predout[2,2]*cm
  fg = predout[1,2]*(cm-cost)
  cat("Number of DM: ", predout[2,3], "\n")
  cat("Number of Response: ", predout[2,2], "\n")
  cat("Net profit ", (tmargin-xout), "\n")
  cat("Forgone profit ", fg, "\n")
  return(tmargin-xout)
}

avcm = 31.59
dmcost= c(3:20)
nl = length(dmcost)
ldapf = rep(0.0,nl)
lgpf = rep(0.0,nl)
cartpf = rep(0.0,nl)
nnpf = rep(0.0,nl)
svmpf = rep(0.0,nl)
blindpf = rep(0.0,nl)
perfectpf=rep(0.0,nl)

for (kk in 1:nl){
  ldapf[kk] = profit(ldaout,avcm,dmcost[kk])
  lgpf[kk] = profit(lgout,avcm,dmcost[kk])
  cartpf[kk] = profit(cartout,avcm,dmcost[kk])
  nnpf[kk] = profit(nnout,avcm,dmcost[kk])
  svmpf[kk] = profit(svmout,avcm,dmcost[kk])
  blindpf[kk] = table(cstest$RESP)[2]*avcm - dmcost[kk]*dim(cstest)[1]
  perfectpf[kk]= table(cstest$RESP)[2]*(avcm-dmcost[kk])
}

pfout = cbind(dmcost, ldapf,lgpf,cartpf,nnpf,svmpf, blindpf, perfectpf)

colnames(pfout) = c("DM Cost","LDA","LR", "CART", "NN", "SVM", "Blind", "Perfect")

plot(pfout[,8]~pfout[,1], type="b", col="lightblue", lty=3, lwd=3, main="Profit of DM Marketing", xlab="DM Cost", ylab="Profit", ylim=c(-5000,35000))
abline(h=0.0)
points(pfout[,1], pfout[,2],col="blue", type="b", lty=1, lwd=3)
points(pfout[,1], pfout[,3],col="red", type="b", lty=2, lwd=3)
points(pfout[,1], pfout[,4],col="yellow", type="b", lty=2, lwd=3)
points(pfout[,1], pfout[,5],col="green", type="b", lty=4, lwd=3)
points(pfout[,1], pfout[,6],col="black", type="b", lty=4, lwd=3)
points(pfout[,1], pfout[,7],col="pink", type="b", lty=4, lwd=3)
pnames = colnames(pfout)[c(8,2,3,4,5,6,7)]
legend(x="topright", pnames, cex=0.8, col=c("lightblue","blue","red","yellow", "green","black","pink"),pch=21,lwd=3)