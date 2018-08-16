
## ----corr, comment=NA, size='scriptsize'---------------------------------
kor <- c(42,38,51,53,40,37,41,29,52,39,45,34,47,35,44,48,47,30,29,34)
eng <- c(30,25,34,35,31,29,33,23,36,30,32,29,34,30,28,29,33,24,30,30) 

plot(kor,eng)
cor(kor,eng) # 표본상관계수
cor.test(kor,eng) # 상관분석

## 단순선형회귀
lm(eng~kor)

cars
plot(cars)
lm(dist~speed, data=cars)

## ----antb, comment=NA, size='scriptsize'---------------------------------
lm(eng~kor)
asd <- cbind(kor, eng)
lm(kor~eng, data=asd) # 행렬의 형태로는 할 수 없음
asd <- as.data.frame(asd) # 데이터 프레임으로 변환해줘야 가능하다.
lm(kor~eng, data=asd)

linear.fit <- lm(eng~kor)
summary(linear.fit)
anova(linear.fit)

## ----regcoets, comment=NA, size='scriptsize'-----------------------------
year <- c(1,1.5,2,2,3,3,3.2,4,4.5,5,5,5.5)
price <- c(4.5,4,3.2,3.4,2.5,2.3,2.3,1.6,1.5,1,0.8,0.4)
car_lm <- lm(price~year); summary(car_lm )


## ----regcoets2, comment=NA, size='scriptsize'----------------------------

sxx <- sum(year^2) - 12*(mean(year)^2)
t0 <- (car_lm$coefficients[2]-(-0.8))/(sqrt(anova(car_lm)["Residuals","Mean Sq"]/sxx))
t0; t0 <= qt(0.05,10) # 통계량이 기각역에 들어가지 못한다.

car_lm$coefficients[2]
anova(car_lm)["Residuals","Mean Sq"]
sxx

confint(car_lm)

## ----prdint, comment=NA, size='scriptsize'-------------------------------
predict(car_lm, newdata = data.frame("year"=2.5), interval="confidence")


## ----respl1, comment=NA, size='scriptsize'-------------------------------
plot(rstandard(car_lm)) # 스튜던트화 잔차도
abline(h=0) # 수평선


## ----regdif, comment=NA, size='scriptsize'-------------------------------
x1 <- c(10,8,13,9,11,14,6,4,12,7,5)
y1 <- c(8.04,6.95,7.58,8.81,8.33,9.96,7.24,4.26,10.84,4.82,5.68)

x2 <- c(10,8,13,9,11,14,6,4,12,7,5)
y2 <- c(9.14,8.14,8.74,8.77,9.26,8.1,6.13,3.1,9.13,7.26,4.74)

lm1 <- lm(y1~x1); lm2 <- lm(y2~x2)
lm1$coefficients ;summary(lm1)$r.squared;anova(lm1)$F[1]
lm2$coefficients ;summary(lm2)$r.squared;anova(lm2)$F[1]
anova(lm2)$F[1]

## ----regdif2, comment=NA, size='scriptsize'------------------------------
par(mfrow=c(1,2))
plot(x1,y1)
abline(lm1$coefficients[1], lm1$coefficients[2], col="red")
plot(x2,y2)
abline(lm2$coefficients[1], lm2$coefficients[2], col="red")

plot(rstudent(lm1), main="residual plot of data A")
abline(h=0, col="rosybrown")
plot(rstudent(lm2), main="residual plot of data B")
abline(h=0, col="rosybrown")

## ----iris1, comment=NA, size='scriptsize'--------------------------------
str(iris)
View(iris)

## ----iris2, comment=NA, size='tiny'--------------------------------------
 iris_lm <- lm(Sepal.Width~Petal.Length+Sepal.Length+Petal.Width, data=iris)
 summary(iris_lm)

## ----iris3, comment=NA, size='tiny'--------------------------------------
 par(mfrow=c(2,2))
 plot(iris_lm)

## ----iriscat1, comment=NA, size='tiny'-----------------------------------
 iris_lm2 <- lm(Sepal.Width~., data=iris) # 모든 설명변수를 입력
 summary(iris_lm2)

## ----iriscat2, comment=NA, size='tiny'-----------------------------------
 plot(iris$Petal.Width, iris$Sepal.Width, cex=0.7, pch=as.numeric(iris$Species))
 iris_rm <- lm(Sepal.Width ~ Petal.Width + Species, data=iris)
 abline(coef(iris_rm)[1], coef(iris_rm)[2], lty=1)
 abline(sum(coef(iris_rm)[c(1,3)]), coef(iris_rm)[2], lty=2)
 abline(sum(coef(iris_rm)[c(1,4)]), coef(iris_rm)[2], lty=3)
 legend("topright", levels(iris$Species), pch=1:3)

## ----boston1, comment=NA, size='scriptsize'------------------------------
library(MASS); data(Boston); str(Boston)

## ----boston2, comment=NA, size='scriptsize'------------------------------
 Boston_fm <- lm(medv~., data=Boston)
 Boston_rm <- step(Boston_fm, direction="backward")


## ----boston3, comment=NA, size='tiny'------------------------------------
summary(Boston_rm)


