rm(list=ls())
gc()
if (!require(dplyr)){install.packages("dplyr")
  library(dplyr)}

setwd("C:/Users/user/Desktop/data_week_2")

surveys <- read.csv(file='surveys.csv')

names(surveys)

match(c("plot_id", "species_id", "weight"), names(surveys))

surveys[, match(c("plot_id", 'species_id', 'weight'), names(surveys))]

surveys[c("plot_id", "species_id", "weight")]

surveys$year == 1995

head(surveys[(surveys$year >= 1995) & (surveys$year < 2000)  ,])

idx <- (surveys$year >= 1995) & (surveys$year < 2000)
surveys[idx,] # 새로 변수를 지정해서 논리 연산을 저장해 놓는 것이 보기에 더 편하다.

a<-surveys[surveys$weight<5, c('species_id', 'sex', 'weight')]
b<-surveys[which(surveys$weight<5), c('species_id', 'sex', 'weight')] # which를 사용해서 NA를 처리해준다.

surveys_ex <- surveys # surveys와 똑같은 데이터셋 surveys_ex를 생성한다.
surveys_ex$weight_kg <- surveys_ex$weight/1000 # weight_kg 열을 추가해준다.
surveys_ex <- surveys_ex[!is.na(surveys_ex$weight_kg),] # NA가 아닌 것들을 골라낸다.

u = unique(surveys$sex) # 해당 팩터가 가진 유일한 값들을 출력해준다.
unique(surveys$sex)
length(u)
class(surveys$sex) 
levels(surveys$sex)

x<-rnorm(10000)
factor(x)
xx <-factor(x) # factor를 잘못 쓰면 의미가 없어 질 수도 있으므로 조심히 써야 한다.

mean(surveys$weight[surveys$sex == u[1]], na.rm = T) # male에 대해서 평균을 구한다.
mean(surveys$weight[surveys$sex == u[2]], na.rm = T) # female에 대해서 평균을 구한다.
mean(surveys$weight[surveys$sex == u[3]], na.rm = T) # blank에 대해서 평균을 구한다.

a<- by(data = surveys$weight, INDICES = surveys$sex, FUN=mean, na.rm=TRUE, trim=0.1)
a
class(a)
a<-unclass(a)
class(a)
a[1]
a

?mean

aggregate(formula = weight~sex, data=surveys, FUN=median, na.rm=TRUE)

aggregate(formula = weight~sex + species_id, data=surveys, FUN=mean, na.rm=TRUE)

# 유용한 cut 함수
x<-rnorm(100) #숫자 100개 랜덤 생성
x
cut(x,breaks=c(-Inf, -0.3, 0.3, Inf)) # 4개 범주로 나누어 준다
as.integer(x) # 각 범주를 int형태로 바꾸어 준다.

#table 함수

table(surveys$sex)
table(surveys$sex, surveys$plot_id)

## Rdplyr

if(!require(dplyr)){install.packages("dplyr") ; library(dplyr)}

select(.data = surveys, plot_id, species_id, weight)

head(select(surveys, plot_id, species_id, weight))
select(.data = surveys, plot_id, species_id, weight) %>% head() # 데이터 처리를 하고 head function에 넘겨준다.

filter(.data=surveys, year == 1995) %>% head()

surveys %>%
filter(year == 1995) %>%
  head()

filter(.data=surveys, year >=1995 & weight >20) %>% head()
filter(.data=surveys, year >=1995, weight >20) %>% head()

surveys %>%
  filter(!is.na(weight)) %>%
  filter(weight <5) %>%
  select(species_id, sex, weight) %>% head()

surveys_ex <- surveys %>% filter(!is.na(surveys$weight)) %>%
  mutate(weight_kg= weight/1000)

surveys %>%
  group_by(sex) %>%
  summarize(mean_weight = mean(weight, na.rm= TRUE),
            sd_weight= sd(weight, na.rm=TRUE))

surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight, na.rm= TRUE))

surveys %>%
  group_by(sex) %>%
  tally()

surveys %>% arrange(month, plot_id) %>% head()
surveys %>% arrange(desc(month), plot_id) %>% head()

## reshape

rm(list=ls())
gc()
if(!require(reshape2)){install.packages("reshape2"); library(reshape2)}
if(!require(dplyr)){install.packages("dplyr"); library(dplyr)}
  
airquality
str(airquality)
names(airquality) <- tolower(names(airquality))

aql <- melt(airquality)

aql <- melt(airquality, id.vars=c("month","day"))
head(aql)

str(airquality)
