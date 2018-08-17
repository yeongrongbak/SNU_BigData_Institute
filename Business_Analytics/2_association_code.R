#R code
rm(list=ls())
gc()

setwd("C:/Users/user/OneDrive/서울대 아카데미/3학기/비즈니스 분석(김용대)/실습/recommender1_실습자료")
install.packages("arules")

#########################################
#Association Analysis                   #
#########################################

# Practice 1
# (1) data check 
tot1=read.csv("tot.csv", header = TRUE) #for 37284 ppl, 387 products

# need to load 'ref_data_ver2' file
load("ref_data_ver2.RData")
#ls() => tot.data, unq.itm, unq.itm.name, unq.user, usr.profile

tot=tot[,-1]
colnames(tot)=unq.itm
rownames(tot)=unq.usr
head(tot)

# (2)
#model fitting

library(arules)
colnames(tot)=unq.itm.name
rules=apriori(as.matrix(tot), parameter=list(supp=0.01, conf=0.5))
#minlen=?ּҹ?ǰ??(lhs+rhs), maxlen=?ִ빰ǰ??(lhs+rhs), smax=?ִ? ??????
print(rules)
rules.sorted=sort(rules, by="lift")
inspect(rules.sorted) #inspect()?Լ??? ??Ģ�� ???캼????��

#?????ִ? ?ܾ?(ũ??)?? ???Ե? ??????Ģ => subset
rules.sub = subset(rules, rhs %pin% c("ũ??"))  #?????ִ? item ã��???? in, ain�� ?????Ҽ???�� 
inspect(rules.sub)

#???ǳ?Ʈ?? appearance ??? ????
temp=apriori(as.matrix(tot), parameter=list(supp=0.01, conf=0.5), 
              appearance = list(lhs=c("??????/??��  ??��  ????��?? "), default="rhs"))
inspect(temp)


# Practice 2: ??�� ?غ?????!!
shopping=read.csv("shopping.csv", header = TRUE) #for 10000 ppl, 70 products

