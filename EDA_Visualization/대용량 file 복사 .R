## 대용량 file 복사

# test file 저장 

rm(list=ls())
gc()

for (i in 1:2)
{
  lambda <- ㄴ
  save.image(paste0("result-",i,".Rdadta"))
}

# file로 일시키는 방법

rm(list = ls())
list.files()
source("test.R") 


rm(list = ls())
a <- readLines("test.R") # test.R에 저장했던 코드를 볼 수 있음 (test file을 R로 가져오기)
str(a)
a[1]                     # 저장한 코드를 한 줄 씩 보여준다.
a[2]
a[3]
a[4]
a[4] <- "for (i in 1:2)" # 수정하고 싶은 부분을 골라내서 수정한다. (필요한 부분 고치기)
a
cat(a, file = "test-1.R", sep = "\n") # 저장하기
