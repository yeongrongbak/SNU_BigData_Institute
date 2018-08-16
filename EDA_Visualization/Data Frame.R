kids <- c("Jack", "Jill") 
ages <- c(12, 10) 
d <- data.frame(kids, ages, stringsAsFactors = F) 
d

str(d)

# 접근하기

d$ages

class(d$ages)

names(d)

d[,1:2]

class(d[,1:2])

# 파일 읽기

read.table(file, header = FALSE, sep = "", stringsAsFactors= F)

A <-read.table("C:/Users/uos_stat/Documents/CO2.dat", header = TRUE, sep = " ", stringsAsFactors= F) 

head(A)

class(A$Plant)

A <-read.table("C:/Users/uos_stat/Documents/CO2.dat", header = TRUE, sep = " ", stringsAsFactors= T) 

head(A)

class(A$Plant)

# 파일 쓰기

head(USArrests)

class(A)

A <- write.table(USArrests , file = "C:/Users/uos_stat/Documents/US.csv", sep = ",",row.names = FALSE,col.names = TRUE)

# 데이터 프레임의 결합 (rbind, cbind)

A = data.frame(x1 = rep(0,10), x2 = rep('b',10)) 

B = data.frame(x3 = rep(1,10), x2 = rep('d',10))

AB = cbind(A,B)

head(AB)

# Merge

d1 = data.frame(kids = c("Jack", "Jill", "Jillian", "John"), states = c("CA", "MA", "MA", "HI"))

d2 <- data.frame(ages = c(10, 7, 12), kids = c("Jill", "Jillian", "Jack") ) 

d1

d2

d <-merge(d1, d2) 

d

d3 <- data.frame(ages = c(10, 7, 12), pals = c("Jill", "Jillian", "Jack") ) 

d <-merge(d1, d3, by.x = 'kids', by.y = "pals") # by.x 데이터를 합칠 때 기준 변수 설정

d

d <-merge(d1, d3, by.x = 'kids', by.y = "pals", all.x = TRUE) # all.x : 한쪽 변수가 완전히 출력

d