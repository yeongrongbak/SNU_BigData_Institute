# 데이터 불러오기 (Encoding : UTF8)

setwd('C:/Users/user/Desktop/data_week_2')

library(data.table)  

library(dplyr)

skillcraft = read.csv('SkillCraft1_Dataset.csv', na.strings="?")

skillcraft<- skillcraft[which(skillcraft$TotalHours<10000),] # 이상치 제거거

# 기본 데이터 셋 파악

attach(skillcraft)

names(skillcraft) # 20개의 변수로 이루어져 있다.

str(skillcraft) # 8개의 값이 integer의 형태/ 나머지 12개의 변수들은 numeric형태

View(head(skillcraft))

# Grouping의 기준 변수 => LeagueIndex (Bronze~Pro, 1~8)

skillcraft$LeagueIndex <- as.factor(skillcraft$LeagueIndex)
table(skillcraft$LeagueIndex) # Gold ~ Master 구간에 많이 분포함
LI.table <- xtabs(~ skillcraft$LeagueIndex, data=skillcraft)
barplot(LI.table, xlab='LeagueIndex', ylab='Frequency')

# Age 변수

summary(skillcraft$Age) # 최소값 16 / 최대값 44 : 16부터 45까지 5단위로 범주화
skillcraft$Age[skillcraft$Age <= 20] <- "16~20"
skillcraft$Age[skillcraft$Age > 20 & skillcraft$Age <= 25] <- "21~25"
skillcraft$Age[skillcraft$Age > 25 & skillcraft$Age <= 30] <- "26~30"
skillcraft$Age[skillcraft$Age > 30 & skillcraft$Age <= 35] <- "31~35"
skillcraft$Age[skillcraft$Age > 35 & skillcraft$Age <= 40] <- "36~40"
skillcraft$Age[skillcraft$Age > 40 & skillcraft$Age <= 45] <- "41~45"

Age.table <- xtabs(~ skillcraft$Age, data=skillcraft)
barplot(Age.table, xlab='Age', ylab='Frequency')

# APM 변수에 대한 등급별 차이

skillcraft %>%
  group_by(LeagueIndex) %>%
  summarize(mean_APM = mean(APM, na.rm=TRUE),
            var_APM = var(APM, na.rm=TRUE),
            min_APM = min(APM),
            max_APM = max(APM),
            median_APM = median(APM)) -> test

View(test)

boxplot(skillcraft$APM~skillcraft$LeagueIndex)

# HoursPerWeek 변수에 대한 등급별 차이

skillcraft$HoursPerWeek <- as.numeric(HoursPerWeek)
skillcraft %>%
  group_by(LeagueIndex) %>%
  summarize(mean_HoursPerWeek = mean(HoursPerWeek, na.rm=TRUE),
            var_HoursPerWeek = var(HoursPerWeek, na.rm=TRUE),
            min_HoursPerWeek = min(HoursPerWeek, na.rm=TRUE),
            max_HoursPerWeek = max(HoursPerWeek, na.rm=TRUE),
            median_HoursPerWeek = median(HoursPerWeek, na.rm=TRUE)) -> hour
View(hour)
boxplot(skillcraft$HoursPerWeek~skillcraft$LeagueIndex)

# TotalHours 변수에 대한 등급별 차이

skillcraft$TotalHours <- as.numeric(skillcraft$TotalHours)
skillcraft %>%
  group_by(LeagueIndex) %>%
  summarize(mean_TotalHours = mean(TotalHours, na.rm=TRUE),
            var_TotalHours = var(TotalHours, na.rm=TRUE),
            min_TotalHours = min(TotalHours, na.rm=TRUE),
            max_TotalHours = max(TotalHours, na.rm=TRUE),
            median_TotalHours = median(TotalHours, na.rm=TRUE)) -> thour
View(thour)
boxplot(skillcraft$TotalHours~skillcraft$LeagueIndex)

# SelectByHotkeys 변수에 대한 등급별 차이

skillcraft %>%
  group_by(LeagueIndex) %>%
  summarize(mean_SelectByHotkeys = mean(SelectByHotkeys, na.rm=TRUE),
            var_SelectByHotkeys = var(SelectByHotkeys, na.rm=TRUE),
            min_SelectByHotkeys = min(SelectByHotkeys),
            max_SelectByHotkeys = max(SelectByHotkeys),
            median_SelectByHotkeys = median(SelectByHotkeys)) -> test2

View(test2)
boxplot(skillcraft$SelectByHotkeys~skillcraft$LeagueIndex)

# AssignToHotkeys 변수에 대한 등급별 차이

skillcraft %>%
  group_by(LeagueIndex) %>%
  summarize(mean_AssignToHotkeys = mean(AssignToHotkeys, na.rm=TRUE),
            var_AssignToHotkeys = var(AssignToHotkeys, na.rm=TRUE),
            min_AssignToHotkeys = min(AssignToHotkeys),
            max_AssignToHotkeys = max(AssignToHotkeys),
            median_AssignToHotkeys = median(AssignToHotkeys)) -> test3

View(test3)
boxplot(skillcraft$AssignToHotkeys~skillcraft$LeagueIndex)

# UniqueHotkeys 변수에 대한 등급별 차이

skillcraft %>%
  group_by(LeagueIndex) %>%
  summarize(mean_UniqueHotkeys = mean(UniqueHotkeys, na.rm=TRUE),
            var_UniqueHotkeys = var(UniqueHotkeys, na.rm=TRUE),
            min_UniqueHotkeys = min(UniqueHotkeys),
            max_UniqueHotkeys = max(UniqueHotkeys),
            median_UniqueHotkeys = median(UniqueHotkeys)) -> test4

View(test4)
boxplot(skillcraft$UniqueHotkeys~skillcraft$LeagueIndex)

# MinimapAttacks 변수에 대한 등급별 평균의 차이

skillcraft %>%
  group_by(LeagueIndex) %>%
  summarize(mean_MinimapAttacks = mean(MinimapAttacks, na.rm=TRUE),
            var_MinimapAttacks = var(MinimapAttacks, na.rm=TRUE),
            min_MinimapAttacks = min(MinimapAttacks),
            max_MinimapAttacks = max(MinimapAttacks),
            median_MinimapAttacks = median(MinimapAttacks)) -> test5
View(test5)
boxplot(skillcraft$MinimapAttacks~skillcraft$LeagueIndex)

# MinimapRightClicks 변수에 대한 등급별 차이

skillcraft %>%
  group_by(LeagueIndex) %>%
  summarize(mean = mean(MinimapRightClicks, na.rm=TRUE),
            var = var(MinimapRightClicks, na.rm=TRUE),
            min = min(MinimapRightClicks),
            max = max(MinimapRightClicks),
            median = median(MinimapRightClicks)) -> test6

View(test6)
boxplot(skillcraft$MinimapRightClicks~skillcraft$LeagueIndex)

# NumberOfPACs 변수에 대한 등급별 차이

skillcraft %>%
  group_by(LeagueIndex) %>%
  summarize(mean_NumberOfPACs = mean(NumberOfPACs, na.rm=TRUE),
            var_NumberOfPACs = var(NumberOfPACs, na.rm=TRUE),
            min_NumberOfPACs = min(NumberOfPACs),
            max_NumberOfPACs = max(NumberOfPACs),
            median_NumberOfPACs = median(NumberOfPACs)) -> test7

View(test7)
boxplot(skillcraft$NumberOfPACs~skillcraft$LeagueIndex)

# GapBetweenPACs 변수에 대한 등급별 차이

skillcraft %>%
  group_by(LeagueIndex) %>%
  summarize(mean_GapBetweenPACs = mean(GapBetweenPACs, na.rm=TRUE),
            var_GapBetweenPACs = var(GapBetweenPACs, na.rm=TRUE),
            min_GapBetweenPACs = min(GapBetweenPACs),
            max_GapBetweenPACs = max(GapBetweenPACs),
            median_GapBetweenPACs = median(GapBetweenPACs)) -> test8

View(test8)
boxplot(skillcraft$GapBetweenPACs~skillcraft$LeagueIndex)

# ActionLatency 변수에 대한 등급별 차이

skillcraft %>%
  group_by(LeagueIndex) %>%
  summarize(mean_ActionLatency = mean(ActionLatency, na.rm=TRUE),
            var_ActionLatency = var(ActionLatency, na.rm=TRUE),
            min_ActionLatency = min(ActionLatency),
            max_ActionLatency = max(ActionLatency),
            median_ActionLatency = median(ActionLatency)) -> test9

View(test9)
boxplot(skillcraft$ActionLatency~skillcraft$LeagueIndex)

# ActionsInPAC 변수에 대한 등급별 차이

skillcraft %>%
  group_by(LeagueIndex) %>%
  summarize(mean_ActionsInPAC = mean(ActionsInPAC, na.rm=TRUE),
            var_ActionsInPAC = var(ActionsInPAC, na.rm=TRUE),
            min_ActionsInPAC = min(ActionsInPAC),
            max_ActionsInPAC = max(ActionsInPAC),
            median_ActionsInPAC = median(ActionsInPAC)) -> test10

View(test10)
boxplot(skillcraft$ActionsInPAC~skillcraft$LeagueIndex)

# TotalMapExplored 변수에 대한 등급별 차이

skillcraft %>%
  group_by(LeagueIndex) %>%
  summarize(mean_TotalMapExplored = mean(TotalMapExplored, na.rm=TRUE),
            var_TotalMapExplored = var(TotalMapExplored, na.rm=TRUE),
            min_TotalMapExplored = min(TotalMapExplored),
            max_TotalMapExplored = max(TotalMapExplored),
            median_TotalMapExplored = median(TotalMapExplored)) ->test11
View(test11)
boxplot(skillcraft$TotalMapExplored~skillcraft$LeagueIndex)

# WorkersMade 변수에 대한 등급별 차이

skillcraft %>%
  group_by(LeagueIndex) %>%
  summarize(mean_WorkersMade = mean(WorkersMade, na.rm=TRUE),
            var_WorkersMade = var(WorkersMade, na.rm=TRUE),
            min_WorkersMade = min(WorkersMade),
            max_WorkersMade = max(WorkersMade),
            median_WorkersMade = median(WorkersMade)) -> test12

View(test12)
boxplot(skillcraft$WorkersMade~skillcraft$LeagueIndex)

# UniqueUnitsMade 변수에 대한 등급별 차이

skillcraft %>%
  group_by(LeagueIndex) %>%
  summarize(mean_UniqueUnitsMade = mean(UniqueUnitsMade, na.rm=TRUE),
            var_UniqueUnitsMade = var(UniqueUnitsMade, na.rm=TRUE),
            min_UniqueUnitsMade = min(UniqueUnitsMade),
            max_UniqueUnitsMade = max(UniqueUnitsMade),
            median_UniqueUnitsMade = median(UniqueUnitsMade)) -> test13

View(test13)
boxplot(skillcraft$UniqueUnitsMade~skillcraft$LeagueIndex)

# ComplexUnitsMade 변수에 대한 등급별 차이

skillcraft %>%
  group_by(LeagueIndex) %>%
  summarize(mean_ComplexUnitsMade = mean(ComplexUnitsMade, na.rm=TRUE),
            var_ComplexUnitsMade = var(ComplexUnitsMade, na.rm=TRUE),
            min_ComplexUnitsMade = min(ComplexUnitsMade),
            max_ComplexUnitsMade = max(ComplexUnitsMade),
            median_ComplexUnitsMade = median(ComplexUnitsMade)) -> test14

View(test14)
boxplot(skillcraft$ComplexUnitsMade~skillcraft$LeagueIndex)

# ComplexAbilitiesUsed 변수에 대한 등급별 차이

skillcraft %>%
  group_by(LeagueIndex) %>%
  summarize(mean = mean(ComplexAbilitiesUsed, na.rm=TRUE),
            var = var(ComplexAbilitiesUsed, na.rm=TRUE),
            min = min(ComplexAbilitiesUsed),
            max = max(ComplexAbilitiesUsed),
            median = median(ComplexAbilitiesUsed)) ->test15
View(test15)
boxplot(skillcraft$ComplexAbilitiesUsed~skillcraft$LeagueIndex)
