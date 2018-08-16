# 3장 기술통계

# 막대그래프

data()
VADeaths <- data(VADeaths)
data(VADeaths)
View(VADeaths)

par(cex=1.3)
barplot(VADeaths, beside = TRUE,
        col = c("lightblue", "mistyrose", "lightcyan",
                "lavender", "cornsilk"),
        legend = rownames(VADeaths), ylim = c(0,100))
title(main = "Death Rates in Virginia", font.main = 4)

# 파이그래프

par(cex=1.3)
pie.sales <- c(0.12, 0.3, 0.26, 0.16, 0.04, 0.12)

names(pie.sales) <- c("Blueberry", "Cherry", "Apple", "Boston Cream", "Other", "Vanilla Cream")
pie.sales

pie(pie.sales)
title(main = "Sales", font.main=4)

# 히스토그램

data("faithful") ; x<-faithful$eruptions
View(faithful)

edge1 <- seq(from=1, to=6, by=0.4)
hist(x, breaks=edge1, freq=F, xlim=c(0,6), ylim=c(0,0.6), main="h=0.4")

edge2 <- seq(from=1, to=6, by=1)
hist(x, breaks=edge2, freq=F, xlim=c(0,6), ylim=c(0,0.6), main="h=1")

edge1
edge2

par(mfrow=c(1,2))
edge1 <- seq(from=1, to=6, by=0.4)
hist(x, breaks=edge1, freq=F, xlim=c(0,6), ylim=c(0,0.6), main="h=0.4")

edge2 <- seq(from=1, to=6, by=1)
hist(x, breaks=edge2, freq=F, xlim=c(0,6), ylim=c(0,0.6), main="h=1")  # 구간 길이에 따른 차이

par(mfrow=c(1,2))
edge3 <- seq(from=1, to= 6, by=0.5) ; edge4 <- seq(from=1.3, to=6, by=0.5)
hist(x, breaks=edge3, freq=F, xlim=c(0,6), ylim=c(0,0.6))
hist(x, breaks=edge4, freq=F, xlim=c(0,6), ylim=c(0,0.6)) # 시작점에 따른 차이

par(mfrow=c(1,2))
hist(x, breaks=edge3, freq=F, xlim=c(0,6), ylim=c(0,0.6), main="")
hist(x, breaks=edge3, freq=F, xlim=c(0,6), ylim=c(0,0.6), right=F, main="") # 경계 설정에 따른 차이

# 줄기 잎 그림

stem(faithful$eruptions)

# 산점도

par(mfrow=c(1,1))
plot(faithful$eruptions, faithful$waiting, xlab='Eruptions', ylab='Waiting', cex.lab=2, cex.axis=2, col="red")

View(iris)
plot(iris$Petal.Length, iris$Petal.Width, xlab='Petal.Length',
     ylab='Petal.Width', cex.lab=2, cex.axis=2, type='n', cex=2)

# 자료 요약

length(faithful$waiting)
mean(faithful$waiting)
summary(faithful$wating)

x<- faithful$waiting
tabulate(x)
freq = tabulate(x)
max(freq)

which.max(freq)