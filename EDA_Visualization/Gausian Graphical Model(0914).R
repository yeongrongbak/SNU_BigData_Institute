library(MASS)

Omega  = matrix(c(1,0,0.5,
                  0,1,0.3,
                  0.5,0.3,1)
                ,3,3)

Sigma <- solve(Omega)
n = 100
pcor.vec <- rep(0,1000)
for ( i in 1:1000)
{
  rdata<-mvrnorm(n,mu = rep(0,3), Sigma)
  x = rdata[,1]
  y = rdata[,2]
  z = rdata[,3]
  
  x = x-mean(x)
  y = y-mean(y)
  z = z-mean(z)
  
  pcor.vec[i]<-cor(lm(x~z-1)$residual,lm(y~z-1)$residual)
  
}

boxplot(pcor.vec)



###

install.packages("igraph")
library(igraph)

Sigma  = matrix(c(1,0,0.5,
                  0,1,0.3,
                  0.5,0.3,1)
                ,3,3)
Sigma.cov <- Sigma
Sigma.cov[Sigma>0] <- 1
diag(Sigma.cov) <- 0
ed <- graph_from_adjacency_matrix(Sigma.cov, mode='undirected')
plot(ed)

adjm <- matrix(sample(0:1, 100, replace=TRUE, prob=c(0.9,0.1)), 10,10)
g1 <- graph_from_adjacency_matrix( adjm )
plot(g1)



Sigma  = matrix(c(1,0,0.5,0,
                  0,1,0.3,0.2,
                  0.5,0.3,1,0,
                  0,0.2,0,1)
                ,4,4)
Sigma11<- Sigma[1:2,1:2]
Sigma12<- Sigma[1:2,3:4]
Sigma21<- Sigma[3:4,1:2]
Sigma22<- Sigma[3:4,3:4]
tmp<-Sigma11 - Sigma12%*%solve(Sigma22)%*%Sigma21
tmp[1,2]/sqrt(tmp[1,1]*tmp[2,2])
solve(Sigma)



Omega  =matrix(c(1,0,0.5,0.1,
                 0,1,0.3,0.2,
                 0.5,0.3,1,0,
                 0.1,0.2,0,1)
               ,4,4)
Omega[Omega!=0] <- 1
diag(Omega) <- 0
ed <- graph_from_adjacency_matrix(Omega, mode='undirected')
plot(ed)


rm(list = ls())
library(dplyr)
library(arulesViz)
data("Groceries")
head(Groceries)
str(Groceries)
summary(Groceries)
rules <- apriori(Groceries, parameter=list(support=0.001, confidence=0.5))

?apriori

# transaction class
# list type
a_list <- list(
  c("a","b","c"),
  c("a","b"),
  c("a","b","d"),
  c("c","e"),
  c("a","b","d","e")
)

## set transaction names
names(a_list) <- paste("Tr",c(1:5), sep = "")
a_list
## coerce into transactions
## transaction class is defined by 'arulesViz'
trans1 <- as(a_list, "transactions")
summary(trans1)
str(trans1)
image(trans1)


# matrix type
a_matrix <- matrix(c(
  1,1,1,0,0,
  1,1,0,0,0,
  1,1,0,1,0,
  0,0,1,0,1,
  1,1,0,1,1
), ncol = 5)

## set dim names
dimnames(a_matrix) <- list(paste("Tr",c(1:5), sep = ""),
                           c("媛�","��","��","��","留�"))
a_matrix
trans2 <- as(a_matrix, "transactions")
trans2
rules <- apriori(trans2, parameter=list(support=0.001, confidence=0.01))
inspect(head(sort(rules, by ="lift"),3))

# see transactions-class{arules}

# apriori algorithm
rules <- apriori(Groceries, parameter=list(support=0.001, confidence=0.5))
inspect(head(arules::sort(rules, by ="lift"),3))
plot(rules, method = NULL, measure = "support", shading = "lift")
plot(rules, measure=c("support", "lift"), shading="confidence")
# �쐎rder,�� i.e., the number of items contained in the rule
plot(rules, shading="order", control=list(main = "Two-key plot"))

sel <- plot(rules, measure=c("support", "lift"), shading="confidence", interactive=TRUE)

rules%>%quality()


subrules <- head(sort(rules, by="lift"), 10)
plot(subrules2, method="graph",measure = 'lift',
     shading = 'confidence')

## graphical model 
install.packages("glasso")
library(glasso)
x<-matrix(rnorm(50*20),ncol=20)
s<- var(x)
a<-glasso(s, rho=.01)
str(a)
a$wi
aa<-glasso(s,rho=.02, w.init=a$w, wi.init=a$wi)
aa$wi
image(aa$wi) # 짙은 빨간색 부분이 0인 부분
