# 데이터 불러오기 (Encoding : UTF8)

setwd('C:/Users/user/Desktop/data_week_2')

library(data.table)  

library(dplyr)

wine_red = read.csv('winequality-red.csv', stringsAsFactors = T)

# 기본 데이터 셋 파악

names(wine_red) # 12개의 변수로 이루어져 있다.

str(wine_red) 

View(head(wine_red))

# Grouping의 기준 변수 => quality (3~8)

table(wine_red$quality)
wine_red$quality <- as.factor(wine_red$quality)
WR.table <- xtabs(~ wine_red$quality, data=wine_red)
barplot(WR.table, xlab='Quality', ylab='Frequency')

# fixed.acidity 변수에 대한 등급별 차이

wine_red %>%
  group_by(quality) %>%
  summarize(mean = mean(fixed.acidity),
            var = var(fixed.acidity),
            min = min(fixed.acidity),
            max = max(fixed.acidity),
            median = median(fixed.acidity)) -> test

View(test)
boxplot(wine_red$fixed.acidity~wine_red$quality)

# volatile.acidity 변수에 대한 등급별 차이

wine_red %>%
  group_by(quality) %>%
  summarize(mean = mean(volatile.acidity),
            var = var(volatile.acidity),
            min = min(volatile.acidity),
            max = max(volatile.acidity),
            median = median(volatile.acidity)) -> test2

View(test2)
boxplot(wine_red$volatile.acidity~wine_red$quality)

# citric.acid 변수에 대한 등급별 차이

wine_red %>%
  group_by(quality) %>%
  summarize(mean = mean(citric.acid),
            var = var(citric.acid),
            min = min(citric.acid),
            max = max(citric.acid),
            median = median(citric.acid)) -> test3

View(test3)
boxplot(wine_red$citric.acid~wine_red$quality)

# residual.sugar 변수에 대한 등급별 차이

wine_red %>%
  group_by(quality) %>%
  summarize(mean = mean(residual.sugar),
            var = var(residual.sugar),
            min = min(residual.sugar),
            max = max(residual.sugar),
            median = median(residual.sugar)) -> test4

View(test4)
boxplot(wine_red$residual.sugar~wine_red$quality)

# chlorides 변수에 대한 등급별 차이

wine_red %>%
  group_by(quality) %>%
  summarize(mean = mean(chlorides),
            var = var(chlorides),
            min = min(chlorides),
            max = max(chlorides),
            median = median(chlorides)) -> test5

View(test5)
boxplot(wine_red$chlorides~wine_red$quality)

# free.sulfur.dioxide 변수에 대한 등급별 차이

wine_red %>%
  group_by(quality) %>%
  summarize(mean = mean(free.sulfur.dioxide),
            var = var(free.sulfur.dioxide),
            min = min(free.sulfur.dioxide),
            max = max(free.sulfur.dioxide),
            median = median(free.sulfur.dioxide)) -> test6

View(test6)
boxplot(wine_red$free.sulfur.dioxide~wine_red$quality)

# total.sulfur.dioxide 변수에 대한 등급별 차이

wine_red %>%
  group_by(quality) %>%
  summarize(mean = mean(total.sulfur.dioxide),
            var = var(total.sulfur.dioxide),
            min = min(total.sulfur.dioxide),
            max = max(total.sulfur.dioxide),
            median = median(total.sulfur.dioxide)) -> test7

View(test7)
boxplot(wine_red$total.sulfur.dioxide~wine_red$quality)
# density 변수에 대한 등급별 차이

wine_red %>%
  group_by(quality) %>%
  summarize(mean = mean(density),
            var = var(density),
            min = min(density),
            max = max(density),
            median = median(density)) -> test8

View(test8)
boxplot(wine_red$density~wine_red$quality)

# pH 변수에 대한 등급별 차이

wine_red %>%
  group_by(quality) %>%
  summarize(mean = mean(pH),
            var = var(pH),
            min = min(pH),
            max = max(pH),
            median = median(pH)) -> test9

View(test9)
boxplot(wine_red$pH~wine_red$quality)

# sulphates 변수에 대한 등급별 차이

wine_red %>%
  group_by(quality) %>%
  summarize(mean = mean(sulphates),
            var = var(sulphates),
            min = min(sulphates),
            max = max(sulphates),
            median = median(sulphates)) -> test10

View(test10)
boxplot(wine_red$sulphates~wine_red$quality)

# alcohol 변수에 대한 등급별 차이

wine_red %>%
  group_by(quality) %>%
  summarize(mean = mean(alcohol),
            var = var(alcohol),
            min = min(alcohol),
            max = max(alcohol),
            median = median(alcohol)) -> test11

View(test11)
boxplot(wine_red$alcohol~wine_red$quality)
