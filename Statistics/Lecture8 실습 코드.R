##모비율 추정과 신뢰구간 p.6
n=500;x=79
phat=x/n
sehat=sqrt(phat*(1-phat)/n)

ci=c(phat-qnorm(0.975)*sehat,phat+qnorm(0.975)*sehat)
ci

##모비율 유의성 검정 p.11~
#n이 작은 경우
pbar=3/20
p0=0.05
n=20
alpha=0.05

p=pbinom(2,size=20,prob=0.05,lower.tail=F)

pbinom(2, size=20, prob=0.05, lower.tail=F)
1-pbinom(2, size=20, prob=0.05)

#n이 큰 경우
n=500;x=79
pbar=x/n
p0=0.2
alpha=0.01
z=(pbar-p0)/sqrt(p0*(1-p0)/n)

p=pnorm(z)#유의수준

prop.test(x=79,n=500,p=0.2,alternative = "less",conf.level=0.99,correct=F)
z^2

## 두 모비율의 비교 p.17,p.20
#p.17
n1=201229
n2=200745
x1=110
x2=33

p1.hat=x1/n1;p2.hat=x2/n2
diff.hat=p1.hat-p2.hat
se.hat=sqrt(p1.hat*(1-p1.hat)/n1+p2.hat*(1-p2.hat)/n2)

ci=c(diff.hat-qnorm(0.975)*se.hat,diff.hat+qnorm(0.975)*se.hat)#신뢰구간

#예시 1 p.20
p.hat=(x1+x2)/(n1+n2)#합동표본비율
z=diff.hat/sqrt(p.hat*(1-p.hat)*(1/n1+1/n2))#검정통계량
z.alpha=qnorm(0.95)

p=pnorm(z,lower.tail=F)#유의확률

prop.test(c(x1,x2),c(n1,n2),alternative="greater",correct=T)

#예시 2
prop.test(c(13,22),c(42,40),alternative="two.sided",correct=F)



##p.25 범주형 자료 예시
freq<-c(42,18,8,1)
some<-c(18,29,10,2)
none<-c(2,5,13,6)
TVexcer<-cbind(freq,some,none)
row.names(TVexcer)<-c("0~1","1~3","3~6","6~")
TVexcer

#범주형 자료 시각화
barplot(TVexcer)
mosaicplot(TVexcer)

##p.31 적합도 검정
chisq.test(c(47,30,23),p=c(0.42,0.33,0.25))


##p.37 동질성 검정
row1<-c(20,28,23,14,12)
row2<-c(14,34,21,14,12)
row3<-c(4,12,10,20,53)
hom<-rbind(row1,row2,row3)
dimnames(hom)=list(
"Region"=c("Region1", "Region2", "Region3"),
"Frequency"=c("Everyday", "Once a week","Once a month",
"Seldom", "Never"))
hom

#test
result<-chisq.test(hom)
result

#관측도수
result$observed
#기대도수
result$expected

##p.46 독립성 검정
row1<-c(6,27,19)
row2<-c(8,36,17)
row3<-c(21,45,33)
row4<-c(14,18,6)

ind<-rbind(row1,row2,row3,row4)
dimnames(ind)=
list("Car" = c("light car", "small car", "medium car", "large car"),
"Commute dist" = c("0 ~ 15", "15 ~ 30", "30 ~"))
ind

#test
result<-chisq.test(ind)
result

#관측도수
result$observed
#기대도수
result$expected

