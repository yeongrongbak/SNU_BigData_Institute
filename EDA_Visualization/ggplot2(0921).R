## 상관 계수에 대한 내용

?cor

set.seed(1)
x1 <- 1:10
x2 <- rnorm(10)

cor(x1,x2)
cor(x1, exp(x2))

cor(x1,x2, method="kendall")
cor(x1, exp(2*x2), method="kendall") # 켄달의 타우를 사용하면 변수변환시에도 상관계수가 변화하지 않는다.

## geom_line

# presidential data

data(economics)
data(presidential)

str(economics)
str(presidential)
head(presidential)

ggplot(economics, aes(date,unemploy)) + geom_line()

presidential = subset(presidential, start > economics$date[1])
ggplot(economics) + geom_rect(aes(xmin=start, xmax = end, fill=party), 
                              ymin=-Inf, ymax=Inf, data = presidential)+ 
  geom_line(aes(date, unemploy), data=economics)

# airquality data

library(datasets)
data("airquality")

plot(airquality$Ozone, type='l')

str(airquality)

aq_trim <- airquality[which(airquality$Month== 7 |
                              airquality$Month == 8 |
                              airquality$Month == 9),]
aq_trim$Month <- factor(aq_trim$Month, labels=c("July", "August" , "September"))

ggplot(aq_trim, aes(x=Day, y=Ozone, size=Wind, fill=Temp))+ geom_point(shape=21) + 
  ggtitle('Air Quality in New York by Day')+
  labs(x='Day of the month', y='Ozone (ppb)')+
  scale_x_continuous(breaks=seq(1,31,5))

## geom_histogram

festival.data <- read.table(file='C:/Users/user/Desktop/data_week_6/DownloadFestival.dat', sep='\t', header=T)
head(festival.data)

Day1Histogram <- ggplot(data=festival.data, aes(x=day1))
Day1Histogram + geom_histogram()

Day1Histogram + geom_histogram(color='red', fill='black') # 히스토 그램 테두리 색과 막대 색을 칠할 수 있음

Day1Histogram + geom_histogram(color='royalblue1', fill='royalblue1', binwidth=0.1) # binwidth를 통해 구간의 길이를 결정할 수 있음

Day1Histogram + geom_histogram(binwidth=0.2, aes(y=..density..), # y = ..density.. 를 쓰게 되면 count가 아니라 밀도로 표현한다.
                               color='royalblue3', fill='yellow', bins=10)  #bins=10 은 막대 개수를 10개로 할때 설정.

Day1Histogram + geom_histogram(bidwidth=0.1, aes(y=..density..), 
                               color='black', fill='lightblue') + geom_density(alpha=.2, fill="#FF6666")

library(reshape2)

head(festival.data)

festival.data.stack <- melt(festival.data, id=c('ticknumb', 'gender')) # melt는 wide format을 long format으로 바꿔준다.(반대는 acast, dcast)

colnames(festival.data.stack)[3:4] <- c('day', 'score')

head(festival.data.stack)

Histogram.3day2 <- ggplot(data=festival.data.stack, aes(x=score))+
  geom_histogram(binwidth=0.4, color='black', fill='yellow')+
  labs(x='Score', y='Counts')
Histogram.3day2

Histogram.3day2 + facet_grid(~gender)

Histogram.3day2 + facet_grid(gender~day)

# 분포에 대한 비교를 하기 위해 y = ..density.. 를 넣어준다

Histogram.3day2 <- ggplot(data=festival.data.stack, aes(x=score, y=..density..))+
  geom_histogram(binwidth=0.4, color='black', fill='yellow')+
  labs(x='Score', y='Counts')
Histogram.3day2

Histogram.3day2 + facet_grid(~gender)

Histogram.3day2 + facet_grid(gender~day)

## geom_boxplot

Scatterplot <- ggplot(data=festival.data.stack, aes(x=gender, y=score,color=gender))+
  geom_point(position = 'jitter') + facet_grid(~day)
Scatterplot

Scatterplot + scale_color_manual(values=c('darkorange', 'darkorchid4'))

Scatterplot + geom_boxplot(alpha = 0.1, color='black', fill='orange')

## Storm data set

install.packages("maps")
library(maps)
load(file="C:/Users/user/Desktop/data_week_6/storms.RData")
wm = map_data("world")

str(wm)
wm[1:100,]

any(wm$region=='South Korea')

kr.map = wm[wm$region == 'South Korea',]
dim(kr.map)

library(dplyr)

substorms = storms %>% filter(Season %in% 1999:2010) %>%
  filter(!is.na(Season)) %>%
  filter(Name!="NOT NAMED")
substorms$ID = as.factor(paste(substorms$Name,
                               substorms$Season, sep="."))
substorms$Name = as.factor(substorms$Name)

map1 = ggplot(substorms,
              aes(x=Longitude, y=Latitude, group=ID))+
  geom_polygon(data=wm,
               aes(x=long, y=lat, group=group),
               fill="gray25", colour="gray10", size=0.2)+
  geom_path(data=substorms,
            aes(group=ID, colour=Wind.WMO.),
            alpha=0.5, size=0.8)+
  xlim(-138,-20)+ ylim(3,55)+
  labs(x="", y="", colour="Wind \n(knots)")

map1 + facet_wrap(~Month)

## Visualization on Map

library(maps)
library(mapdata)

par(mfrow =c(1,2))
map(database = 'usa')
map(database ='county')

map(database='world', region='South Korea')

# world2Hires에서 보다 자세한 map을 그릴 수 있음

map('world2Hires', 'South Korea')

wm <- ggplot2::map_data('world2Hires')
str(wm)

wm %>% filter(region == 'South Korea')

kr1 <- wm %>% filter(region == 'South Korea')

unique(kr1$subregion) # subregion이 별로 할당되지 않음을 확인할 수 있다.

# Georgia map

data(us.cities)
head(us.cities)

map("state", "GEORGIA")
map.cities(us.cities, country="GA")

# painting map

par(mfrow=c(1,1))
map('world', fill=TRUE, col= rainbow(30))

# unemployment rate map

data(unemp)
data(county.fips)
head(unemp,3)

head(county.fips, 3)

unemp$colorBuckets <- as.numeric(cut(unemp$unemp, c(0,2,4,6,8,10,100)))

colorsmatched <- unemp$colorBuckets[match(county.fips$fips, unemp$fips)]

colors = c("#F1EEF6","#D4B9DA", "#C994C7", "#DF65B0", "#DD1C77", "#980043")

par(mfrow=c(1,1))

map("county", col=colors[colorsmatched], fill=TRUE,
    resolution=0, lty=0)

library(mapproj)

map("county", col=colors[colorsmatched], fill=TRUE,
    resolution=0, lty=0, projection='polyconic')

