## 행렬 만들기

y <- matrix( c(1,2,3,4), nrow = 2, ncol=2)
y

y <- matrix( c(1,2,3,4), nrow=2, ncol=2, byrow =T)
y

## 행렬에서 원소 골라내기

y <- matrix(c(1,3,4,5,1,3,4,1), 4,2) # 4행 2열
y
y[1, 1]
y[, 1]
y[1,]
y[2:3,]

## 행렬관련 함수

attributes(y) # 행과 열의 수를 반환

class(y)

dim(y)

ncol(y)

nrow(y)

## 행렬의 연산

A <- matrix(c(1, 0, -1, 2, 1, 0, 1, 1, 3), 3,3)
B <- matrix(rep(c(1,2,3), each=3),3,3)

A+B

(2.1)*A # 각 원소에 대해서 적용이 된다.

A%*%B # 행렬의 곱 연산

solve(A) # 역행렬

det(A) # 행렬식(determinent) 정의

svd(A) # 특이값 분해

## 행렬 연산 예제

install.packages("pixmap")
library(pixmap)
mtrush1 <- read.pnm('C:/Users/user/Desktop/mtrush1.pgm')
mtrush1

plot(mtrush1)
str(mtrush1)

# 원하는 위치출력

locator()
x <- mtrush1
x@grey[20:80 , 20:80] <- 1
plot(x)

# noise 추가
x <- mtrush1
y1 <- x@grey[21:80, 21:80]
t <- 0.8
x@grey[21:80, 21:80] <-
  t*y1 + (1-t) * matrix(runif(length(y1)),nrow(y1), ncol(y1))
plot(x)

## 행렬의 필터링

x <- matrix(c(1,2,3,2,3,4),3,2)
x

x[x[,2]>=3,]

x[,2]>=3 # 2번째 열에서 원소가 3보다 큰지 비교

x[c(FALSE, TRUE, TRUE),]

# 논리 연산자

z <- 4

z == 4

z >= 4

z < 4

z != 4 

## 행과 열 추가 및 제거하기

# 행 및 열 추가

one <- rep(1,4)
z <- matrix(c(1:4, rep(1,4), rep(0,4)), 4, 3)
z

cbind(one, z) # 열 병합

z <- cbind(1, z)
z

z <- rbind(2, z) # 행 병합
z

# 행 및 열 제거

z[-2,]
z[,-1]
z[-(1:2),]

## 벡터와 행렬

z <- matrix(1:8, 4, 2)
z

length(z)

class(z)

attributes(x)

## 의도치 않은 차원 축소 피하기

z
class(z)

z1 <- z[,-1] # 그냥 제거하면 matrix 형태가 유지되지 않음
class(z1)

z2 <- z[,-1, drop = F] # drop 옵션을 통해 matrix 형태 유지 가능
class(z2)

## 벡터에서 행렬로 class 변경

z1 = as.matrix(z1)
class(z1)
