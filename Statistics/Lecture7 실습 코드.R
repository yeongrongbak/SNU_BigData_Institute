
# histogram approximation(5장 추가 코드)
popn <- c(1,2,3,12)
pop.mean <- c()
par(mfrow=c(1,4))
for(i in 1:4){
  for(j in 1:50){
    pop.mean[j] <- mean(runif(popn[i],-6,6))
  }
  hist(pop.mean,freq=FALSE)
  lines(seq(-5,5,0.01),dnorm(seq(-5,5,0.01),sd=(12^2)/(12*popn[i])))
}

## 모평균의 구간추정
n = 64; sigma=5.083 ; xbar = 27.75 ; alpha=0.01 ;
qt(1-alpha/2, n-1) # t_(0.005)
c.i <- c(xbar - qt(1-alpha/2, n-1)*sigma/sqrt(n), 
         xbar + qt(1-alpha/2, n-1)*sigma/sqrt(n))
c.i

## 전구 예제
bulb <- c(2000, 1975, 1900, 2000, 1950, 1850, 1950, 2100, 1975)
mean(bulb)
sd(bulb)
qt(0.95,8) #기각역의 경계값
t.test(bulb, mu=1950, alternative="greater")

## 반도체 예제
sc_xbar <- 0.62
sc_s <- 0.11
(sc_xbar-0.6)/(sc_s/sqrt(120)) #검정통계량의 관측값
c(qt(0.025,119),qt(0.975,119)) #기각역의 경계값 
c(qnorm(0.025),qnorm(0.975)) #정규근사 확인
pt((sc_xbar-0.6)/(sc_s/sqrt(120)),119, lower.tail=FALSE)
 


## 진통제 예제
n = 6; sigma_d=0.443 ; dbar = 0.2 ; alpha=0.05 ;
qt(1-alpha/2, n-1) # t_(0.025)
c.i <- c(dbar - qt(1-alpha/2, n-1)*sigma_d/sqrt(n), 
         dbar + qt(1-alpha/2, n-1)*sigma_d/sqrt(n))
c.i
pk1 <- c(4.8,4,5.8,4.9,5.3,7.4)
pk2 <- c(4,4.2,5.2,4.9,5.6,7.1)
t.test(pk1,pk2,paired=TRUE)
# 강의노트의 2.660 : 오타

## 가축 예제
cow_dbar <- 13.82
cow_sd <- 8.173
(cow_dbar-0)/(cow_sd/sqrt(11)) #검정통계량의 관측값
qt(0.99,10) #기각역의 경계값 

pt((cow_dbar-0)/(cow_sd/sqrt(11)),10, lower.tail=FALSE)

x1 <- c(24.7, 46.1, 18.5, 29.5, 26.3, 33.9, 23.1, 20.7, 18.0, 19.3, 23.0)
x2 <- c(12.4, 14.1, 7.6, 9.5, 19.7, 10.6, 9.1, 11.5, 13.3, 8.3, 15.0)

t.test(x1, x2, alternative="greater", paired=TRUE)

## 마리화나 예제 
x_1 <- c(19.54, 14.47, 16.00, 24.83, 26.39, 11.49)
x_2 <- c(15.95,25.89,20.53,15.52,14.18,16.00)
# Pooled standard deviation
sqrt(((6-1)*var(x_1)+(6-1)*var(x_2))/(6+6-2)) 
t.test(x_1,x_2,var.equal=TRUE,conf.level=0.95) # t-test procedure

# 아래 F test 하고 나중에
var.test(x_1,x_2)

## 질산칼륨 예제
x_1 <- c(12.7,19.3,20.5,10.5,14.0,10.8,16.6,14.0,17.2)
x_2 <- c(18.2,32.9,10.0,14.3,16.2,27.6,15.7)
# t-test procedure
t.test(x_1,x_2,"less",var.equal=FALSE,conf.level=0.95) 

# 아래 F test 하고 나중에
var.test(x_1,x_2)

## 분산 검정
x <- c(226,228,226,225,232,228,227,229,225,230)
sdx <- sd(x); chisquare <-  (10-1)*(sdx^2)/(1.5^2)
chisquare
qchisq(0.95,9)
pchisq(chisquare,9,lower.tail=FALSE) # 유의확률
# 90% 신뢰구간
c((10-1)*(sdx^2)/(qchisq(0.95,9)),(10-1)*(sdx^2)/(qchisq(0.05,9))) 

#qqnorm(x); qqline(x)  정규분포 분위수대조표    
#(이 문제에서는 정규성이 가정되었으니 그리지 않아도 좋다.)



#강의노트 60-61p 오타 : F_0.05, F_0.95 -> F_0.025, F_0.975
qf(0.975,3,3)

## 분산비 검정
x1 <- c(1.75,2.12,2.05,1.97)
x2 <- c(1.77,1.59,1.70,1.69)
var.test(x1,x2)

