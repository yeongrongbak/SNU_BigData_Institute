
############ ������ ���� ###############


logical (length = 0)
as.logical(x)
is.logical(x)

x= 5


class(5)
class(x)
mode(5)

############ ������ ���� ###############

x1 <- c(1,3,5,7,9)
x1

x2 = seq(1,9,2)
x2

x3 = rep(1,10)
x3

x4 = 1:10
x4

x5 <-c('1','2','3')
x5

x6 = c('A','B','C')
x6

x1^2+2*x2^2           # ����� ������ ���п� ���ؼ� �̷�� ����.

x1+x3                 # ���̰� �ٸ����� �� ���� �ٸ� �� ���� ��� �� ��� �ݺ��ؼ� ��������.

# ����Ʈ
myvector <- c(8, 6, 9, 10, 5)
mylist <- list(name="Fred", wife="Mary", myvector)
mylist

myvector[2]
mylist[[1]]  # ���Ҹ� �ҷ����� ���ؼ��� �� �� ��ȣ
mylist[1]    # �ϳ� ��ȣ�� �� ��쿡�� ����Ʈ ���·� �ҷ��� ����.
mylist$name  # ���Ҹ� �ҷ����� �� �ٸ� ���

# ���̺�
mynames <- c("Mary", "John", "Ann", "Sinead", "Joe",
             "Mary", "Jim", "John", "Simon")
table(mynames)

mytable <- table(mynames)
mytable[[4]]
mytable[["John"]]
mytable[4]

# R ��Ű�� �ҷ�����

install.packages("modeest")
library(modeest)

# R�� �Լ�

mean(myvector) # �����Լ�

myfunction <- function(x) {return(20+(x*x))} # ����� ���� �Լ�
myfunction(10)

# �ݺ����� ���

x = c(1, -6, 3, -5, 9, 4, -7, 2, 15)
cs=x[1]
for(i in 2:length(x)){
  cs[i]=cs[i-1]+x[i]
}
cs

b = 122 %% 2
quot = 122 %/% 2
while(quot >0){
  b=c(quot%%2, b)
  quot=quot%/%2
}
b

x<- 1:5
for (val in x) {
  if (val == 3) {
    break
  }
  print(val)
}

x <- 1:5
for (val in x) {
  if (val ==3) {
    next
  }
  print(val)
}