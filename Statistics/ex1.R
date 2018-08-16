
############ 데이터 종류 ###############


logical (length = 0)
as.logical(x)
is.logical(x)

x= 5


class(5)
class(x)
mode(5)

############ 데이터 구조 ###############

x1 <- c(1,3,5,7,9)
x1

x2 = seq(1,9,2)
x2

x3 = rep(1,10)
x3

x4 = 1:10
x4

x5 <-c('1','2','3')
x5

x6 = c('A','B','C')
x6

x1^2+2*x2^2           # 계산은 각각의 성분에 대해서 이루어 진다.

x1+x3                 # 길이가 다르지만 한 쪽이 다른 한 쪽의 배수 인 경우 반복해서 더해진다.

# 리스트
myvector <- c(8, 6, 9, 10, 5)
mylist <- list(name="Fred", wife="Mary", myvector)
mylist

myvector[2]
mylist[[1]]  # 원소를 불러오기 위해서는 두 개 괄호
mylist[1]    # 하나 괄호를 할 경우에는 리스트 형태로 불러와 진다.
mylist$name  # 원소를 불러오는 또 다른 방법

# 테이블
mynames <- c("Mary", "John", "Ann", "Sinead", "Joe",
             "Mary", "Jim", "John", "Simon")
table(mynames)

mytable <- table(mynames)
mytable[[4]]
mytable[["John"]]
mytable[4]

# R 패키지 불러오기

install.packages("modeest")
library(modeest)

# R의 함수

mean(myvector) # 내장함수

myfunction <- function(x) {return(20+(x*x))} # 사용자 정의 함수
myfunction(10)

# 반복문과 제어문

x = c(1, -6, 3, -5, 9, 4, -7, 2, 15)
cs=x[1]
for(i in 2:length(x)){
  cs[i]=cs[i-1]+x[i]
}
cs

b = 122 %% 2
quot = 122 %/% 2
while(quot >0){
  b=c(quot%%2, b)
  quot=quot%/%2
}
b

x<- 1:5
for (val in x) {
  if (val == 3) {
    break
  }
  print(val)
}

x <- 1:5
for (val in x) {
  if (val ==3) {
    next
  }
  print(val)
}