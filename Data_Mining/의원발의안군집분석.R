################################################## read.data ##################################################
## Load Data
data2 <- read.table('data2.csv', header = TRUE, sep = ',', stringsAsFactors= T)

rowname = data2[,1]
data2 = data2[,-1]
row.names(data2) = rowname[]
str(data2)

# Convert data frame to matrix
data3 <- data.matrix(data2, rownames.force = NA)

# Divide by diag element
data4 <- data3/diag(data3)
# 행의 값들을 각 국회의원들의 개인 발의 건수로 나눈 이유는?
# a,b,c 의원이 존재. 
# c와 공동 발의 건수가 a, b 모두 동일하게 5인데
# a는 개인 발의 건수가 10이고 b는 개인 발의 건수가 1000이라면
# c와의 공동 발의 건수에 대해서 b보다 a가 더 큰 의미를 가진다.

## party data
party <- read.csv('party.csv', header=T, sep = ',')
party_name = party[,1]
rownames(party) = party_name


##############################################################################################################
############################################## 내용의 진행 순서 ##############################################
# 1. 데이터 특성 분석(많은 아웃라이어 발견)
# 2. 수업시간에 배운 군집분석 방법
#   2.1 Hierarchical agglomerative clustering : single linkage, complete linkage, average linkage
#   2.2 Partitioning clustering : 수업시간에 배운 k-means 대신 k-medoids = PAM(partitioning around medoids) 사용 > 주성분으로 더 디테일한 해석 + 정보획득 가능
# 3. 군집협업특성
# 4. 타당 의원과의 협업 정도에 따른 clustering
##############################################################################################################
##############################################################################################################


###############################################################################################################
############################################# 1. 데이터 특성 분석 #############################################

## 개인 발의 건수에 대한 boxplot
par(mfrow = c(1, 1), oma=c(0,0,0,0))
boxplot(diag(data3))
# 5명정도의 이상치 존재함을 확인 가능

## 전체 데이터중 이상치 비율
fp_out = c()
for (i in 1:dim(data3)[2])
{
  fp_out = c(fp_out,length(boxplot(data3[,i])$out))
}
sum(fp_out)/(dim(data3)[1]*dim(data3)[2]) 

# 이상치의 비율이 4%정도로 적지는 않다. 이상치를 처리해서 클러스터링해야할 필요가 있다.


###############################################################################################################
################################ 2.1 Hierarchical agglomerative clustering ####################################

##library setting
if(!require(cluster)){install.packages('cluster') ; library(cluster)}

## 유형별 계층적 클러스터링
hc.complete=hclust(dist(data4), method="complete")# 완전연결 ( 최대 클러스터간 비유사성)
hc.average=hclust(dist(data4), method="average")  # 평균연결 ( 평균 클러스터간 비유사성)
hc.single=hclust(dist(data4), method="single") # 단일연결 (최소 클러스터 간 비유사성)

# 각 의원들의 거리 계산
dist(data4[1:141,])

## 계층적 클러스터링 덴드로그램
# 단일연결 클러스터 덴드로그램
plot(hc.single, main = 'Single linkage Clustering') 
# single linkage clustering은 긴 시가모양의 군집이 만들어지는 경향이 있으며 이러한 현상을 chaining이라고 한다. 
# chaining은 유사하지 않은 관측치들의 중간 관측치들이 유사하기 때문에 하나의 군집으로 합쳐지는 것를 말한다. 

# 완전연결 클러스터 덴드로그램 
plot(hc.complete, main = 'Complete linkage Clustering') 
# complete linkage clustering은 거의 비슷한 직경을 갖는 compact cluster를 만드는 경향이 있으며 이상치에 민감한 것으로 알려져 있다. 

# 평균연결 클러스터 덴드로그램

# average linkage clustering은 두 가지 방법의 타협점이다. chaining결향이 덜하고 이상치에도 덜 민감하다. 
# 또한 분산이 적은 군집을 만드는 경향이 있다. 

### 각각의 덴드로그램을 비교해본 결과 평균연결 클러스터 덴드로그램이 가장 균형잡힌 모습을 보이고,
# 이상치에도 덜 민감한 방법이므로,  평균연결 클러스터링의 덴드로그램으로 클러스터를 구한다
x <- cutree(hc.average, 4) # 3개의 클로스터로 덴드로그램을 절단한다

names(x)[x==1] # cluster1의 국회의원
names(x)[x==2] # cluster2의 국회의원
names(x)[x==3] # cluster3의 국회의원
names(x)[x==4] # cluster3의 국회의원

##구해진 클러스터와, 각 국회의원의 정당 정보를 결합한다.
data5 <- cbind(data.frame(x), party) 

data5$party[which(data5$x==1)] # 1번 cluster의 국회의원 정당 정보
data5$party[which(data5$x==2)] # 2번 cluster의 국회의원 정당 정보
data5$party[which(data5$x==3)] # 3번 cluster의 국회의원 정당 정보
data5$party[which(data5$x==4)] # 4번 cluster의 국회의원 정당 정보


## table을 이용하여 각 cluster마다 정당의 수 확인
table(data5$party[which(data5$x==1)])
table(data5$party[which(data5$x==2)])
table(data5$party[which(data5$x==3)])
table(data5$party[which(data5$x==4)])

# cluster1은 바른정당 7명과 자유한국당 41명이 포함되어있다.
# cluster2은 국민의당 2명과 더불어민주당 64명, 무소속 1명, 정의당 1명이 포함되어있다.
# cluster3은 국민의당 22명이 포함되어있다.
# cluster4은 더불어민주당 3명이 포함되어있다.

# 3개의 클러스터로 나누면 크게 (바른정당, 자유한국당), (더불어민주당,국민의당,정의당,무소속)의 집단으로 나뉜다.
# 4개 이상의 클러스터로 나누게 되면  (바른정당, 자유한국당), (더불어민주당,정의당, 무소속), (국민의당)으로 분리된다.

if(!require(flexclust)){install.packages('flexclust') ; library(flexclust)}
if(!require(NbClust)){install.packages('NbClust') ; library(NbClust)}

data(nutrient,package="flexclust")

devAskNewPage(ask=TRUE)
nc=NbClust(data4, min.nc=2, max.nc=7, method="complete")

################################################################################################################
################################### 2.2 Partitioning clustering (K-Medoids) ####################################
# 수업시간에 배운 K-means말고 K-medoids를 사용하였다.
# K-medoids는 주어진 데이터를 k개의 클러스터로 묶는 알고리즘으로 K-means와 비슷한 방법이다.
# K-means와의 차이점은 cluster centers를 K-means는 mean으로 정하는데 K-medoid는 medoid으로 정한다.
# 따라서 이상치에 대해서 덜 민감하게 정해진다.(robust하다)

## install.packages
if(!require(ggfortify)){install.packages('ggfortify') ; library(ggfortify)}

## K-Medoids Clustering
a <- pam(data4, 4) 
# k = 3으로 하면 Average linkage Clustering와 비슷한 결과가 나옴
# (자유한국당, 바른정당, 더불어민주당, 국민의당, 무소속, 정의당) 총 6개의 정당이 있어서 이번에는 k = 6으로 클러스터링해봄
a

## 각 cluster에 속하는 값들을 알기 위한 과정

## data set 만들기

a$clustering # 각각 어느 군집에 속하는지 파악

data.frame(a$clustering) # data.frame 으로 변환

newdata <- cbind(data.frame(a$clustering), party) # 의원들의 정당 정보와 결합
head(newdata)

## 각 군집에 속하는 의원들의 정당 분포

newdata$party[which(newdata$a.clustering==1)]
newdata$party[which(newdata$a.clustering==2)]
newdata$party[which(newdata$a.clustering==3)]
newdata$party[which(newdata$a.clustering==4)]
newdata$party[which(newdata$a.clustering==5)]
newdata$party[which(newdata$a.clustering==6)]

## table을 이용하여 각 cluster마다 정당의 수 확인
table(newdata$party[which(newdata$a.clustering==1)])
table(newdata$party[which(newdata$a.clustering==2)])
table(newdata$party[which(newdata$a.clustering==3)])
table(newdata$party[which(newdata$a.clustering==4)])
table(newdata$party[which(newdata$a.clustering==5)])
table(newdata$party[which(newdata$a.clustering==6)])
# 여전히 (바른정당, 자유한국당), (더불어민주당), (국민의당)의 집단으로 나뉘는 경향을 보인다.

# 군집 6에 속하는 의원들의 번호 확인
newdata[which(newdata$a.clustering==6),]

## clustering plot 
b = autoplot(pam(data4, 4), frame = TRUE, frame.type = 'norm') # 군집의 수를 3~6으로 늘려가면서 관측하자
b
# 왼쪽 위의 cluster1,5는 자유한국당과 바른정당
# 오른쪽 위의 cluster2,3(무소속,정의당포함),6은 더불어민주당
# 가운데 아래쪽의 cluster4는 국민의당


################################################################################################################
################################################ 3 군집협업특성 ################################################

############ 비율척도로 변환 ################
frame<- data2
nndata = NULL
for ( i in 1:141){
  for ( j in 1:141){
    if(data2[i,j] != data2[i,i]){
      nndata = data2[i,j]/sum(data2[i,-i])
      frame[i,j] = nndata
    }
  }
}

#자기 자신에 해당하는 부분은 0으로 변환
frame1=frame
for ( i in 1:141){
  frame1[i,i]=0
}

#매트릭스화
matrix1 <- data.matrix(frame1, rownames.force = NA)

#행렬전치
tmp = NULL
for (i in 1:141)
{
  tmp = cbind(tmp, matrix1[i,])
}

colnames(tmp) = rownames(tmp)

#당이름으로된 열 추가
tmp = cbind(party, tmp)
tmp = tmp[,-1] #id열 제거

################클러스터링#####################3
tmp2 <- tmp[,-1] #당 제거한 tmp2생
c = pam(tmp2, 6) # 6개의 군집으로 나눴을 때 처음 시도한 군집분석과 군집이 다소 다르게 나타난다.


#군집별 의원명 할당
c1 = c$clustering[c$clustering == 1]
c2 = c$clustering[c$clustering == 2]
c3 = c$clustering[c$clustering == 3]
c4 = c$clustering[c$clustering == 4]
c5 = c$clustering[c$clustering == 5]
c6 = c$clustering[c$clustering == 6]


###################특정 군집 내 개별 의원들의 당 협업 정도, 특정 군집 내 종합적인 당 협업 정도###################

#함수로 제작
library(ggplot2)

partyFreq = function(data, cluster)
{
  outPut = NULL
  for (i in 1:length(cluster))
  {
    partySum = c()
    g = sum(data[,colnames(data) == names(cluster[i])][which(data$party == '국민의당')])
    d = sum(data[,colnames(data) == names(cluster[i])][which(data$party == '더불어민주당')])
    f = sum(data[,colnames(data) == names(cluster[i])][which(data$party == '자유한국당')])
    b = sum(data[,colnames(data) == names(cluster[i])][which(data$party == '바른정당')])
    j = sum(data[,colnames(data) == names(cluster[i])][which(data$party == '정의당')])
    m = sum(data[,colnames(data) == names(cluster[i])][which(data$party == '무소속')])
    partySum = c(g, d, f, b, j, m) 
    names(partySum) = c('국민의당', '더불어민주당', '자유한국당', '바른정당', '정의당', '무소속')
    
    outPut = rbind(outPut, partySum)
    rownames(outPut)[i] = names(cluster[i])
  }
  print('아래는 각 의원의 정당별 협업 정도 데이터프레임')
  print(outPut)
  result = colSums(outPut)/length(cluster)
  result2 = transform(result)
  result2 = cbind(rownames(result2), result2)
  colnames(result2) = c('Party', 'Proposition')
  pie<- ggplot(result2, aes(x='', y=Proposition, fill=Party))+
    geom_bar(width = 1, stat = "identity") + coord_polar("y", start = 0)
  plot(pie)
  return(result)
}
if(!require(factoextra)){install.packages('factoextra') ; library(factoextra)}
fviz_cluster(c, frame.alpha = 0.2, frame.level = 0.9)

partyFreq(tmp, c1) #클러스터 1의 당 협업 정도
partyFreq(tmp, c2) #클러스터 2의 당 협업 정도
partyFreq(tmp, c3) #클러스터 3의 당 협업 정도
partyFreq(tmp, c4) #클러스터 4의 당 협업 정도
partyFreq(tmp, c5) #클러스터 5의 당 협업 정도
partyFreq(tmp, c6) #클러스터 6의 당 협업 정도

###########당에 의원 할당#####################

#당에 따라 의원 charactor를 분류하여 할당
fp = party[party$party=="자유한국당",]$id
bp = party[party$party=="바른정당",]$id
gp = party[party$party=="국민의당",]$id
dp = party[party$party=="더불어민주당",]$id
jp = party[party$party=="정의당",]$id
mp = party[party$party=="무소속",]$id
party = list(fp, bp, gp, dp, jp, mp) #당에 따른 의원 list에 할당
party
party_name = c('자유한국당', '바른정당', '국민의당', '더불어민주당', '정의당', '무소속')
party = setNames(party, party_name) #party 리스트이름 지정


# 협업/협업sum 비율척도로 바꾸기
frame<- data2
nndata = NULL
for ( i in 1:141){
  for ( j in 1:141){
    if(data2[i,j] != data2[i,i]){
      nndata = data2[i,j]/sum(data2[i,-i])
      frame[i,j] = nndata
    }
  }
}
#자기 자신에 해당하는 부분은 0으로 변환
frame1=frame
for ( i in 1:141){
  frame1[i,i]=0
}
sum(frame1[1,]) #첫번째 의원 col의 값을 다 더하면 1이므로, '타의원협업/총협업'으로 나눠진 것이 맞음
#매트릭스화
matrix1 <- data.matrix(frame1, rownames.force = NA)


# Divide by diag element
data4 <- matrix1
fp_data = data4[rownames(data4) %in% fp,!(colnames(data4) %in% fp)]
bp_data = data4[rownames(data4) %in% bp,!(colnames(data4) %in% bp)]
gp_data = data4[rownames(data4) %in% gp,!(colnames(data4) %in% gp)]
dp_data = data4[rownames(data4) %in% dp,!(colnames(data4) %in% dp)]
jp_data = data4[rownames(data4) %in% jp,!(colnames(data4) %in% jp)]
mp_data = data4[rownames(data4) %in% mp,!(colnames(data4) %in% mp)]


###########자유한국당#########################
library('factoextra')
library("ggfortify")
library("cluster")

fp_out = c()
for (i in 1:dim(fp_data)[2])
{
  fp_out = c(fp_out,length(boxplot(fp_data[,i])$out))
}
sum(fp_out)/(dim(fp_data)[1]*dim(fp_data)[2]) #전체 데이터중 이상치 비율


fp_pam = pam(fp_data, 2)
fviz_cluster(fp_pam, frame.alpha = 0.2, frame.level = 0.9)
str(fp_pam)

#군집별 의원
fp_c1 = fp_pam$clustering[fp_pam$clustering == 1]
fp_c2 = fp_pam$clustering[fp_pam$clustering == 2]


topSeclect = function(data, cluster)
{
  outPut = c()
  for (i in 1:length(cluster))
  {
    allCong = data[rownames(data) == names(cluster[i]),]
    topThree = head(sort(allCong, decreasing = T), 3)
    print(topThree)
    outPut = c(outPut, names(topThree))
  }
  print(table(outPut))
  
}

topSeclect(fp_data, fp_c1)
topSeclect(fp_data, fp_c2)


###########더불어민주당#########################
dp_out = c()
for (i in 1:dim(dp_data)[2])
{
  dp_out = c(dp_out,length(boxplot(dp_data[,i])$out))
}
sum(dp_out)/(dim(dp_data)[1]*dim(dp_data)[2]) #전체 데이터중 이상치 비율


dp_pam = pam(dp_data, 2)
fviz_cluster(dp_pam, frame.alpha = 0.2, frame.level = 0.9)


#군집별 의원
dp_c1 = dp_pam$clustering[dp_pam$clustering == 1]
dp_c2 = dp_pam$clustering[dp_pam$clustering == 2]

topSeclect(dp_data, dp_c1)
topSeclect(dp_data, dp_c2)


##################국민의당#########################
gp_out = c()
for (i in 1:dim(gp_data)[2])
{
  gp_out = c(gp_out,length(boxplot(gp_data[,i])$out))
}
sum(gp_out)/(dim(gp_data)[1]*dim(gp_data)[2]) #전체 데이터중 이상치 비율


gp_pam = pam(gp_data, 2)
fviz_cluster(gp_pam, frame.alpha = 0.2, frame.level = 0.9)

#군집별 의원
gp_c1 = gp_pam$clustering[gp_pam$clustering == 1]
gp_c2 = gp_pam$clustering[gp_pam$clustering == 2]

topSeclect(gp_data, gp_c1)
topSeclect(gp_data, gp_c2)


#################바른정당#########################
bp_out = c()
for (i in 1:dim(bp_data)[2])
{
  bp_out = c(bp_out,length(boxplot(bp_data[,i])$out))
}
sum(bp_out)/(dim(bp_data)[1]*dim(bp_data)[2]) #전체 데이터중 이상치 비율


bp_pam = pam(bp_data, 2)
fviz_cluster(bp_pam, frame.alpha = 0.2, frame.level = 0.9)

#군집별 의원
bp_c1 = bp_pam$clustering[bp_pam$clustering == 1]
bp_c2 = bp_pam$clustering[bp_pam$clustering == 2]

topSeclect(bp_data, bp_c1)
topSeclect(bp_data, bp_c2)


##########정의당과 무소속은 한 명이라 클러스터링 불가########
head(sort(jp_data, decreasing = T), 3)
head(sort(mp_data, decreasing = T), 3)


#########클러스터별 당 협업 정도 ##################


