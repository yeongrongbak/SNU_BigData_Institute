# 데이터 불러오기 (Encoding : UTF8)

setwd('C:/Users/user/Desktop/data_week_2')

library(data.table)  

library(dplyr)

wine_white = read.csv('winequality-white.csv', sep=";",  stringsAsFactors = T)

# 기본 데이터 셋 파악

names(wine_white) # 12개의 변수로 이루어져 있다.

str(wine_white) 

View(head(wine_white))

# Grouping의 기준 변수 => quality (3~9)

table(wine_white$quality)
wine_white$quality <- as.factor(wine_white$quality)
WR.table <- xtabs(~ wine_white$quality, data=wine_white)
barplot(WR.table, xlab='Quality', ylab='Frequency')

# fixed.acidity 변수에 대한 등급별 차이

wine_white %>%
  group_by(quality) %>%
  summarize(mean = mean(fixed.acidity),
            var = var(fixed.acidity),
            min = min(fixed.acidity),
            max = max(fixed.acidity),
            median = median(fixed.acidity)) -> test

View(test)
boxplot(wine_white$fixed.acidity~wine_white$quality)

# volatile.acidity 변수에 대한 등급별 차이

wine_white %>%
  group_by(quality) %>%
  summarize(mean = mean(volatile.acidity),
            var = var(volatile.acidity),
            min = min(volatile.acidity),
            max = max(volatile.acidity),
            median = median(volatile.acidity)) -> test2

View(test2)
boxplot(wine_white$volatile.acidity~wine_white$quality)

# citric.acid 변수에 대한 등급별 차이

wine_white %>%
  group_by(quality) %>%
  summarize(mean = mean(citric.acid),
            var = var(citric.acid),
            min = min(citric.acid),
            max = max(citric.acid),
            median = median(citric.acid)) -> test3

View(test3)
boxplot(wine_white$citric.acid~wine_white$quality)

# residual.sugar 변수에 대한 등급별 차이

wine_white %>%
  group_by(quality) %>%
  summarize(mean = mean(residual.sugar),
            var = var(residual.sugar),
            min = min(residual.sugar),
            max = max(residual.sugar),
            median = median(residual.sugar)) -> test4

View(test4)
boxplot(wine_white$residual.sugar~wine_white$quality)

# chlorides 변수에 대한 등급별 차이

wine_white %>%
  group_by(quality) %>%
  summarize(mean = mean(chlorides),
            var = var(chlorides),
            min = min(chlorides),
            max = max(chlorides),
            median = median(chlorides)) -> test5

View(test5)
boxplot(wine_white$chlorides~wine_white$quality)

# free.sulfur.dioxide 변수에 대한 등급별 차이

wine_white %>%
  group_by(quality) %>%
  summarize(mean = mean(free.sulfur.dioxide),
            var = var(free.sulfur.dioxide),
            min = min(free.sulfur.dioxide),
            max = max(free.sulfur.dioxide),
            median = median(free.sulfur.dioxide)) -> test6

View(test6)
boxplot(wine_white$free.sulfur.dioxide~wine_white$quality)

# total.sulfur.dioxide 변수에 대한 등급별 차이

wine_white %>%
  group_by(quality) %>%
  summarize(mean = mean(total.sulfur.dioxide),
            var = var(total.sulfur.dioxide),
            min = min(total.sulfur.dioxide),
            max = max(total.sulfur.dioxide),
            median = median(total.sulfur.dioxide)) -> test7

View(test7)
boxplot(wine_white$total.sulfur.dioxide~wine_white$quality)
# density 변수에 대한 등급별 차이

wine_white %>%
  group_by(quality) %>%
  summarize(mean = mean(density),
            var = var(density),
            min = min(density),
            max = max(density),
            median = median(density)) -> test8

View(test8)
boxplot(wine_white$density~wine_white$quality)

# pH 변수에 대한 등급별 차이

wine_white %>%
  group_by(quality) %>%
  summarize(mean = mean(pH),
            var = var(pH),
            min = min(pH),
            max = max(pH),
            median = median(pH)) -> test9

View(test9)
boxplot(wine_white$pH~wine_white$quality)

# sulphates 변수에 대한 등급별 차이

wine_white %>%
  group_by(quality) %>%
  summarize(mean = mean(sulphates),
            var = var(sulphates),
            min = min(sulphates),
            max = max(sulphates),
            median = median(sulphates)) -> test10

View(test10)
boxplot(wine_white$sulphates~wine_white$quality)

# alcohol 변수에 대한 등급별 차이

wine_white %>%
  group_by(quality) %>%
  summarize(mean = mean(alcohol),
            var = var(alcohol),
            min = min(alcohol),
            max = max(alcohol),
            median = median(alcohol)) -> test11

View(test11)
boxplot(wine_white$alcohol~wine_white$quality)
