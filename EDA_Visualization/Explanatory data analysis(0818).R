if (!require(plotrix)) install.packages("plotrix")
if (!require(vioplot)) install.packages("vioplot")
if (!require(vcd)) install.packages("vcd")

## Frequency of univariate variable

# bar plot

counts = table(state.region)

counts

barplot(counts, main='simple bar chart', xlab = "region", ylab= "freq")

names(mtcars)

freq.cyl = table(mtcars$cyl)
cyl.name = c("4 cyl", "6 cyl", "8 cyl")

barplot(counts, main='Freq of cyl', names.arg = cyl.name, col = "skyblue")

# pie chart

cyl.names2 = paste0(cyl.name, "(", freq.cyl, "%)")
pie(freq.cyl, labels = cyl.names2, col= rainbow(length(freq.cyl)), main ="pie chart")
rainbow(10)

# 문자열 연결
paste0("a","b")         # paste0는 문자열 사이에 공백 삭제
paste("a","b", sep="_") # default는 sep = " " 이다.

paste0('4 cyl', "(", 30, "%)")
paste0(c('4 cyl','6 cyl'), "(", c(30,10), "%)") # 원소끼리 연결해주고, 길이가 모자랄 경우 재사용


# fan plot 범주의 레벨간 비교가 용이함

fan.plot(freq.cyl, labels = cyl.names2, mina="Fan plot")

## Frequency of multivariate variables

# Frequency table

library(vcd)
head(Arthritis, n=3)

my.table <-xtabs(~ Treatment + Improved, data =Arthritis)
my.table

my.table2 <-xtabs(~ Improved + Treatment, data= Arthritis)
my.table2

# bar plot
barplot(my.table, xlab="Improved", ylab="Treatment", legend.text=TRUE, col=c("green", "red"))

barplot(t(my.table), xlab="Treatment", ylab="Frequency",  legend.text=TRUE, col=c("green","red","orange"))

# bar plot 2
tmp = c("buckled", "unbuckled")
belt <- matrix(c(58, 2, 8, 16), ncol = 2, dimnames=list(parent=tmp, child=tmp))
belt

## continuous variables and visualization

# boxplot
x = rnorm(100)
boxplot(x, main ='boxplot', col='lightblue')

# histogram

x=faithful$waiting
hist(faithful$waiting, nclass=8,  xlab='waiting', ylab='probability')

hist(faithful$waiting, breaks = seq(min(x), max(x), length=10), probability=T)

hist(faithful$waiting, nclass=10, probability=T)     
lines(density(x), col = "red" , lwd=2)
density(x)

# violin plot
library(vioplot)
x = rpois(1000, lambda=3)
vioplot(x, col="lightblue")

## Visualization for multivariate variables

#multiple boxplot

attach(mtcars)
boxplot(mpg~cyl, data =mtcars, names= c('4cyl','6cyl','8cyl'), col='skyblue')

#multiple histogram

par(mfrow=c(3,1))
hist(mpg[cyl==4], xlab='MPG', main='MPG dist by cylilnder',
     xlim =c(5,40), ylim=c(0,10), col='lightblue',
     nclass=trunc(sqrt(length(mpg[cyl==4]))))
hist(mpg[cyl==6], xlab='MPG', main='MPG dist by cylilnder',
     xlim =c(5,40), ylim=c(0,10), col='orange',
     nclass=trunc(sqrt(length(mpg[cyl==6]))))
hist(mpg[cyl==8], xlab='MPG', main='MPG dist by cylilnder',
     xlim =c(5,40), ylim=c(0,10), col='red',
     nclass=trunc(sqrt(length(mpg[cyl==8]))))

par(mfrow=c(1,1))

