## 팩터와 레벨

x <- c(5, 12, 13, 12) 
xf <- factor(x) 
xf   

# 팩터 내에 고유한 값을 레벨이라 한다.

str(xf)

unclass(xf)

as.numeric(xf)

# 팩터에 레벨 추가

xff <- factor(x, levels = c(5, 12, 13, 88)) 
xff

## Table

# table 함수는 자료의 빈 분석을 제공한다.

x1 <- c(4,2,3,3,2,2) 
table(x1)

x2 <- c("a","b","a","a","b","b") 
table(x2)

x3 = data.frame(x1 = x1, x2 = x2) 
table(x3)

