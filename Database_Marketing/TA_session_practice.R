my_data <- data.frame(no=seq(1,10), name=rep(NA, 10), count=rep(0,10))

names(my_data)

head(my_data)

View(my_data)

names(my_data)

my_data$no

names(my_data[2])

colnames(my_data)

rownames(my_data)

colnames(my_data)[2]

rownames(my_data)[3]

rownames(my_data)[3] <- "3"
head(my_data)

my_data[1,2] <-"YC"

my_data

my_data[2,1] <- 12
my_data

my_data[2:4,2] <-"IH"
my_data[2,1]
my_data[1:3,3] <-c(2,4,6)
my_data[5,] <-c(2, "DS", 10)

my_data

my_data <- my_data[-(5:10),]

my_data <- my_data[,-3]

my_data[2,3] <- NA

my_data

na.omit(my_data)

my_data[is.na(my_data)] <- 99

my_data

tom <- data.frame(no=c(1:3), name=rep("Tom",3), weight=rep(70,3))
View(tom)

jerry <- data.frame(no=c(4:6), name=rep("Jerry",3), weight=rep(60,3))

rbind <- rbind(tom, jerry)
rbind

cbind <- cbind(tom, jerry)
cbind

# 함수 만들기

permute <- function(a,b){factorial(a)/factorial(a-b)}
permute(3,2)

comb <- function(a,b){factorial(a)/(factorial(b)*factorial(a-b))}
comb(20,3)

#

install.packages("RcmdrPlugin.IPSUR")

library(RcmdrPlugin.IPSUR)

RcmdrTestDrive

head(RcmdrTestDrive)

salary[1]

RcmdrTestDrive$salary[1]

attach(RcmdrTestDrive)

salary[1]

summary(RcmdrTestDrive)

table(race)

which.max(salary)

mean(salary[which(gender=="Male")])

?boxplot
  
boxplot(salary~gender)

?hist

hist(salary[which(gender=="Female")] )

install.packages("prob")
library(prob)