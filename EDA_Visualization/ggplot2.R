library(ggplot2)

# 포유류의 체중과 수면시간의 관계에 대한 그래프 그리기

ggplot(data = msleep, aes(x=bodywt, y=sleep_total)) # 캔버스를 그려주는 역할

ggplot(data = msleep, aes(x=bodywt, y=sleep_total)) + geom_point() # geom_point()를 통해 캔버스에 점이 찍히게 된다.

can <- ggplot(data = msleep, aes(x=bodywt, y=sleep_total)) # 변수로 저장이 가능
can + geom_point() # 변수로 저장해 놓고 언제든지 불러와서 변형시킬 수 있어서 편리하다.

ggplot(data = msleep, aes(x=log(bodywt), y=sleep_total)) + geom_point() # x축에 대해서 log 변환을 해준다. (aes 안에서 수학연산을 해주면 된다)

scatterplot = ggplot(data=msleep,
                     aes(x = log(bodywt), y = sleep_total, col = vore, alpha = vore)) + geom_point() # vore에 따라서 다른 색깔을 입혀 산점도를 그려준다.
scatterplot

scatterplot1 = ggplot(data = msleep,
                      aes(x = log(bodywt), y= sleep_total, col = vore)) + geom_point() + facet_grid(~vore) # vore 별로 캔버스를 분할해 준다.
scatterplot1

Scatterplot <- scatterplot + geom_point(size = 5) + 
  xlab('Log Body Weight') + ylab("Total Hours Sleep") +
  ggtitle('Some Sleep Data')
Scatterplot # 이미 만들어진 객체에다가 point의 size를 변경해주거나 x축이름, y축이름, 그래프의 title을 설정해 줄 수 있다.

str(msleep)

# 포유 동물의 종류에 따른 수면시간 비교

ggplot(data=msleep, aes(x=vore, y=sleep_total, col=vore)) + geom_point() 

ggplot(data=msleep, aes(x=vore, y=sleep_total)) + geom_point() + geom_jitter() # 겹친 데이터 들을 비교하기 위해서 geom_jitter를 이용한다.

stripchart <- ggplot(msleep, aes(x=vore, y=sleep_total)) + geom_point()

stripchart

stripchart <- ggplot(msleep, aes(x=vore, y=sleep_total, col=vore)) + geom_jitter(position = position_jitter(width=0.2), size = 5, alpha =0.5)

stripchart

## geom_line

dane <- data.frame(mylevels=c(1,2,5,9), myvalues=c(2,5,3,4))
head(dane)

ggplot(dane, aes(x=factor(mylevels), y=myvalues)) + geom_line(group=1) + geom_point(size=3)
