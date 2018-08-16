x <- 0:6
fx<-dbinom(x, 6, 0.5)
plot(x, fx, main='density for binomial dist', type="h")

pbinom(5, size=20, prob=0.1)
sum(dbinom(0:5, 20, 0.1))

1-pbinom(3, size=20, prob=0.1)
pbinom(3, size=20, prob=0.1, lower.tail=F)

qbinom(0.1876, size=5 ,prob=0.5)
qbinom(0.1875, size=5 ,prob=0.5)

dbinom(0, size=5, prob=0.5)
dbinom(1, size=5, prob=0.5)

dunif(1.5, min=0, max=2)
punif(1.5, min=0, max=2)
qunif(0.5, min=0, max=2)
runif(2, min=0, max=2)

# d = density : P(X=x)의 확률 값을 구하는 함수
# p = culmulative probability : P(X<=x), 즉 누적확률을 구하는 함수
# q = quatile : 백분위수를 구하는 함수
# r = random variable : 난수를 생성해주는 함수
# 이러한 명령어들 뒤에 binom, unif, norm 등 분포의 이름을 넣어주면 된다.

dnorm(0, mean=0, sd=1)
x<-seq(from=-5, to=5, by=0.1)
fx<-dnorm(x, mean=0, sd=1)
plot(x, fx, type="l", main='pdf of standard normal dist')

pnorm(2500, mean=2000, sd=200)

1-pnorm(1800, mean=2000, sd=200)
pnorm(1800, mean=2000, sd=200, lower.tail=F)

qnorm(0.98, mean=100, sd=15)
qnorm(0.02, mean=100, sd=15, lower.tail=F)

rnorm(5, mean=5, sd=10)

seed.num = 2
set.seed(seed.num)
rnorm(5)

seed.num = seed.num + 3
set.seed(seed.num)
rnorm(5)

