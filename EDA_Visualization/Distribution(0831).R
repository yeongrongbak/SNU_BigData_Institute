# 포아송 분포

x = seq(-1, 10, length = 100)
y <- ppois(x, lambda = 5)
plot(x,y, ylim=c(0,1), type = 's', lty=3)

# 중심극한정리

n = 1e+4
z = rexp(n)
hist(z)
sample(1:10, 3)

for(i in 1:n)
{ 
  idx = sample(1:n, 25)
  x[i] = mean(z[idx])}

hist(x)

# 감마 분포
?dgamma

a <- diag(c(1,1,2))

b <- diag(c(3,3,9))

a %*% b

a = c(1,2,3)
t(a)
a

t(a) %*% a 

mu.vec <- matrix( c(0,1,-1), 3,1)
Sigma.mat <- matrix(c(1, 0.5, 0,
                      0.5, 1, 0.3,
                      0, 0.3, 1)
                    ,3,3)
x = matrix( c(1,0,1/2), 3,1)
a = x-mu.vec
solve(Sigma.mat)
exp(-t(a)%*%solve(Sigma.mat)%*%a)
