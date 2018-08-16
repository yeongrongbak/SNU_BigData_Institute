##이항분포
#이항분포 밀도함수
dbinom(3,size=5,prob=0.1);

#이항분포 밀도함수를 이용하여 이항분포 그래프 그리기
x<-0:6
fx<-dbinom(x,6,0.5)
plot(x,fx,main='density for binomial dist',type="h")

#이항분포 누적분포 함수
pbinom(5,size=20,prob=0.1)

1-pbinom(3,size=20,prob=0.1)
pbinom(3,size=20,prob=0.1,lower.tail=F)

#이항분포 분위수
qbinom(0.1875,size=5,prob=0.5)

#이항분포 난수
rbinom(3,size=5,prob=0.5)

##균일분포
#균일분포 밀도함수
dunif(1,min=0,max=2)

#균일분포 누적분포함수
punif(1,min=0,max=2)

#균일분포
qunif(0.5,min=0,max=2)

#균일분포 난수
runif(2,min=0,max=2)

##정규분포
#정규분포 밀도함수
dnorm(0,mean=0,sd=1)

#정규분포 밀도함수를 이용하여 그래프 그리기
x<-seq(from=-5,to=5,by=0.1)
fx<-dnorm(x,mean=0,sd=1)
plot(x,fx,type="l",main='pdf of standard normal dist')

#정규분포 누적분포함수
pnorm(2500,mean=2000,sd=200)

1-pnorm(1800,mean=2000,sd=200)
pnorm(1800,mean=2000,sd=200,lower.tail=F)

#정규분포 분위수 함수
qnorm(0.98,mean=100,sd=15)
qnorm(0.02,mean=100,sd=15,lower.tail=F)

#정규분포 난수 생성
rnorm(5,mean=5,sd=10)

