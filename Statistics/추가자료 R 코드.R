########################################
########### Lecture 2 ##################
########################################


### page 8 ~ ###


# data.frame()


myFamilyNames = c("Dad","Mom","Sis","Bro","Dog")
myFamilyAges = c(43, 42, 12, 8, 5)
myFamilyGenders = c("Male","Female","Female","Male","Female")
myFamilyWeights = c(188,136,83,61,44)

myFamily <- data.frame(myFamilyNames, myFamilyAges, myFamilyGenders, myFamilyWeights)
myFamily


str(myFamily)

class(myFamilyGenders)

myFamilyStr <- data.frame(myFamilyNames, myFamilyAges,
                          myFamilyGenders,myFamilyWeights,stringsAsFactors=FALSE)

myFamily$myFamilyNames <- as.character(myFamily$myFamilyNames)
str(myFamily)


str(myFamilyStr)

summary(myFamily)


myFamily[2,]

myFamilyAges <- c(myFamilyAges, 11)
myFamilyAges

myFamily$myFamilyAges

myFamily$myFamilyAges<-c(myFamily$myFamilyAges, 11) ## Error

### page 20 ~

data()

iris # 내장 데이터
cars



head(iris)
head(iris,3)
str(iris)



#apply() 벡터, 행렬, 리스트, 데이터프레임 등에 임의의 함수를 적용한 결과를 얻기 위한 함수
#apply(행렬, 방향, 함수) 방향: 1= 행, 2= 열

apply(iris[,1:4], 2, sum) # column sum
apply(iris[,1:4], 1, sum) # row sum


?lapply # 벡터 또는 리스트에 특정 함수 적용. 결과 값은 리스트

l=lapply(iris[, 1:4], mean) # 각 열의 평균 구하기
l

l$Sepal.Length


s=sapply(iris[, 1:4], mean) # lapply와 비슷. 결과 값은 벡터 또는 행렬
s

s$Sepal.Length 

s[1]


y = sapply(iris[, 1:4], function(x){x >  3})  # 함수 부분에 직접 함수를 정의 할 수 있다.
head(y,3) # 위에서 부터 네 가지 값들에 대한 결과 출력

x= (1:5)*10
fac <- factor(rep(1:3, length = 5))

x ; fac

tapply(x, fac, sum) # 그룹별 처리를 위한 apply 함수(색인 : 데이터가 어느 그룹게 속하는지를 표현하기 위한 함수)

levels(iris$Species)

tapply(iris$Sepal.Length, iris$Species, mean)

#split(), subset()
#subset() : 전체를 부분으로 분리하는 함수

levels(iris$Species)
levels(iris$Sepal.Length) # NULL

tapply(iris$Sepal.Length , iris$Species , mean)

byspecies <- split(iris, iris$Species)
byspecies
str(byspecies)

setosa <- subset(iris, Species=="setosa")
head(setosa)

colsel <- subset(iris, select=c(Sepal.Length, Species))
head(colsel)

colsel <- subset(iris, select=-c(Sepal.Length, Species)) # 특정 열 제외
head(colsel)

s<- which(iris$Species=="setosa") # setosa에 해당하는 데이터들만 뽑아주는 것
iris[s,]

#sort()
x <- c(20, 11, 33, 50, 47)
sort(x) # 순서대로 정렬해주는 함수
sort(x, decreasing=TRUE)

order(x) # 인덱스 바뀌는게 싫기 때문에, 순서만 알고 싶은 경우 사용
order(x, decreasing=TRUE)

x[order(x)]
iris.ordered <- iris[order(iris$Sepal.Length), ] # iris를 Sepal.Length에 따라 정렬
head(iris.ordered)

head(iris[order(iris$Sepal.Length , iris$Petal.Length), ]) # Sepal.Length로 먼저 정렬, 같은 값의 경우 Petal.Length로 정렬

# 데이터 섞기
set.seed(2016) # same seed --> same output

sample (1:10 , 5) # 비복원 추출(중복 불허) 
sample(1:10, 5, replace=TRUE) #  복원 추출

NROW(iris)
NCOL(iris)

iris.resample <- iris[sample(NROW(iris), NROW(iris)),]

head(iris.resample,5)
head(iris,5)

# aggregate()

# aggregate(formula, data, FUNCTION)

aggregate(Sepal.Width  ~  Species,  iris, mean)



# with()

iris$Sepal.Length + iris$Sepal.Width
Sepal.Length + Sepal.Width

with(iris, { 
  Sepal.Length + Sepal.Width
}
)



print(mean(iris$Sepal.Length))
print(mean(iris$Sepal.Width))
print(mean(iris$Petal.Length))
print(mean(iris$Petal.Width))

with(iris, {
  print(mean(Sepal.Length))
  print(mean(Sepal.Width))
  print(mean(Petal.Length))
  print(mean(Petal.Width))
}
)




# attach(), detach()
attach(iris)
head(Sepal.Width)

detach(iris)
head(Sepal.Width)


#within()
x <- data.frame(val=c(1, 2, 3, 4, NA, 5, NA))
t(x)	#  transpose

x=within(x,{val=ifelse(is.na(val),median(val,na.rm=TRUE),val)})
t(x)


### page 40 ~

# file load
setwd("C:/Users/user/OneDrive/서울대 아카데미/1학기/통계와 최적화/R 실습 추가 자료")  #  '/'로 바꿔주기, Working Directory 설정
getwd # 현재 working directory 확인

x <- read.csv("a.csv") # working directory 를 설정하지 않고 파일명에 위치를 포함시켜도 된다.
x
str(x)

y <- read.csv("b.csv", header=FALSE) # 데이터 파일 첫 줄에 데이터 명이 없는 경우
y

z <- read.csv("a.csv", stringsAsFactors=FALSE) 
str(z)

w = read.csv(
  "http://www.mathstat.strath.ac.uk/outreach/nessie/datasets/whiskies.txt",
  row.names = 1,  stringsAsFactors = FALSE) # 웹에 있는 파일의 경우 URL을 지정하여 바로 불러올 수 있다.
str(w)

head(w)

setwd("C:/Users/user/Desktop/aaa") # change working directory

save(myFamily, file="family.RData")
write.csv(myFamily, file = "family.csv") # csv 파일로 저장
write.table(myFamily, file = "family.txt", sep="\t") # txt 파일로 저장


### page 48 ~


# for()

e=rnorm(100) # random number - noraml distribution
n=length(e) 
s=rep(0,n)

for  (i in 1:n){
  s[i]=sum(e[1:i])
}

t=1:n 

plot(t,s)


# while()

b=122 %% 2 # remainder
quot=122 %/% 2 # quotient

while(quot >0){
  b=c(quot%%2, b)
  quot=quot%/%2
}
b


# break
x <- 1:5

for (val in x) {
  if (val == 3){
    break
  }
  print(val)
}

# next
x <- 1:5

for (val in x) {
  if (val == 3){
    next
  }
  print(val)
}

# if & ifelse
x=3

if(x>1){
  y=1 
}else{
  y=-1
}
y

y=ifelse(x>1,1,-1)
y

x=runif(100); n=length(x); argm=1; m=x[1]

for  (i in 2: n){
  if(m<x[i]){
    m=x[i]
    argm=i
  }
}

c(argm,m)


########################################
########### Lecture 3 ##################
########################################

USstatePops <- read.csv(
  "http://www.census.gov/popest/data/state/totals/2011/tables/NST-EST2011-01.csv",
  header=T,skip=3,nrows=58 )
head(USstatePops, 3)

setClass("num.with.commas")
setAs("character", "num.with.commas",
      function(from) as.numeric(gsub(",", "", from) ) )

USstatePops <- read.csv(
  "http://www.census.gov/popest/data/state/totals/2011/tables/NST-EST2011-01.csv",
  header=T,skip=3,colClasses=c('factor','num.with.commas',
                               'num.with.commas','num.with.commas',
                               'num.with.commas'),nrows=58 )
head(USstatePops, 9)


USstatePops$X # 51 states

pops<-USstatePops$Census[6:56]

mean(pops)
median(pops)
mode(pops)
var(pops)
sd(pops)


hist(pops)
hist(pops,breaks=20)

hist(rnorm(51, mean(pops), sd(pops))) # normal distribution 


### page 28 ~

sample(pops,size=16,replace=TRUE)
mean(pops)
mean(sample(pops,size=16, replace=TRUE))

replicate(4, mean(sample(pops, size=16,replace=TRUE)), simplify=TRUE) # simplify=FALSE ?

mean(replicate(400, mean(sample(pops,size=16,replace=TRUE)), simplify=TRUE))
mean(replicate(4000, mean(sample(pops,size=16,replace=TRUE)), simplify=TRUE))
hist(replicate(4000, mean(sample(pops,size=16,replace=TRUE)), simplify=TRUE))
mean(pops)
mean(replicate(100, mean(sample(pops,size=51,replace=TRUE)),simplify=TRUE))
mean(replicate(100, mean(sample(pops,size=120,replace=TRUE)),simplify=TRUE))

SampleMeans = replicate(10000,mean(sample(pops,size=5,replace=TRUE)))

length(SampleMeans)
mean(SampleMeans)

summary(SampleMeans)
quantile(SampleMeans, probs=c(0.25,0.50,0.75))
quantile(SampleMeans, probs=c(0.025,0.975))

MysterySample <- c(3706690, 159358, 106405,55519, 53883)
mean(MysterySample)

quantile(SampleMeans, probs=c(0.005,0.995)) # two sides 0.5%
sd(SampleMeans)
sd(pops)/sqrt(5)

StdError<-sd(pops)/sqrt(5)
CutPoint975<-mean(pops)+(2 * StdError) # 97.5% upper limit
CutPoint975


# t-test
x <- rnorm (30)
t.test(x) # H_0: mu==0
