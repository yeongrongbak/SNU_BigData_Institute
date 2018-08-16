## 일반적인 수학함수

2 + 4 * 5 # Order of operations 
log (10) # Natural logarithm with base e=2.7182 
log10(5) # Common logarithm with base 10 
5^2 # 5 raised to the second power 
5/8 # Division 
sqrt (16) # Square root 
abs (3-7) # Absolute value 
pi # 3.14 
exp(2) # Exponential function 
round(pi,0) # Round pi to a whole number 
round(pi,1) # Round pi to 1 decimal place 
round(pi,4) # Round pi to 4 decimal places
ﬂoor(15.9) # Rounds down 
ceiling(15.1) # Rounds up 
cos(.5) # Cosine Function 
sin(.5) # Sine Function 
tan(.5) # Tangent Function 
acos(0.8775826) # Inverse Cosine 
asin(0.4794255) # Inverse Sine 
atan(0.5463025) # Inverse Tangen

## 특수한 수학 함수

# 감마함수

jfun= function(x,a) 
  {
  v = x^{a-1}*exp(-x) 
  v 
  } 
jfun(2.2,3)

fit = integrate(jfun,lower = 10e-4, upper = 1000, a = 3) 
names(fit)

fit$value

fit$abs.error

gamma(3)

gamma(3.1)

digamma(3)

digamma(3.1)

pgamma(3, 2, 3)