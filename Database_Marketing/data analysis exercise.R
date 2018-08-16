## Load data

mail_data <- read.csv('C:/Users/user/Desktop/mailorder.csv')

## View the data

dim(mail_order)
str(mail_order)
View(head(mail_order))

## Split training and validation

train <- mail_order[1:2000,]

valid <- mail_order[2001:4000,]

## Load packages

library(ROSE) # Random Over Sampling Example

library(rpart) # Recursive Partitioning and Regression Trees

library(caret) # Classification and REgression Training

library(ranger) # A Fast Implementation of Random Forests

## Calculate proportion of purchase

table(train$purchase)
table(valid$purchase)

prop.table(table(train$purchase))

## logistic reg

rs <- valid[sample(2000,500),]

View(rs)

View(table(rs$purchase))
prop.table(table(rs$purchase))


logis_train = glm(purchase~ .-id-duration , data=train, family=binomial)

summary(logis_train)

logis_pred = predict.glm(logis_train,newdata = valid,type="response")

logis_pred

# logis_pred  확률 값으로 sorting 해서 500명을 뽑아낸 뒤 예측률 계산

logis_pred2 <- sort(logis_pred, decreasing= TRUE)

logis_pred3 <- as.data.frame(logis_pred2)

#View(logis_pred3)

idx <-  merge(valid, logis_pred3, by='row.names')

idx2 <- idx[order(-idx[,9]),]

idx2

idx3 <- idx2[1:500,]

idx3

table(idx3$purchase)

prop.table(table(idx3$purchase))

## Decision Tree

tree_train = rpart(purchase ~ .-id ,data=train)

tree_pred <- predict(tree_train, newdata=valid, type="vector")

tree_pred2 <- sort(tree_pred, decreasing= TRUE)

tree_pred3 <- as.data.frame(tree_pred2)

idx <-  merge(valid, tree_pred3, by='row.names')

idx2 <- idx[order(-idx[,9]),]

idx3 <- idx2[1:500,]

prop.table(table(idx3$purchase))
