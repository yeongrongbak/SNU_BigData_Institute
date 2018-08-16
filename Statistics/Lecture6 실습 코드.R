#10 페이지
n = 49; sigma=30 ; xbar = 157.02 ; alpha=0.05 ; d=5
qnorm(1-alpha/2) # Z_(0.025)
c.i <- c(xbar - qnorm(1-alpha/2)*sigma/sqrt(n), 
         xbar + qnorm(1-alpha/2)*sigma/sqrt(n))
c.i #신뢰구간
min_n = (qnorm(1-alpha/2)*sigma/d)^2
ceiling(min_n)

