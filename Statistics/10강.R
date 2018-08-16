#p.19
A1 <- c(47,58,51,61,46); A2 <- c(51,62,31,46,49)
A3 <- c(50,38,47,27,23); A4 <- c(22,23,28,42,25)
A <- c(A1,A2,A3,A4)

group <- as.factor(rep(1:4,each=5))

fabric <- data.frame(A,group)

A_table <- cbind(A1,A2,A3,A4)

apply(A_table,2,mean) ; mean(A)

aov_fabric <- lm(A~group, data=fabric)
aov_fabric
anova(aov_fabric)

#p.23
M1 <- c(2,3,4,5); M2 <- c(4,5,6,4,3); M3 <- c(6,5,7,4,6,8)
M <- c(M1,M2,M3)
group_M <- as.factor(rep(1:3,times=c(4,5,6)))
mean(M1); mean(M2); mean(M3); mean(M)

mechanism <- data.frame(M,group_M)
aov_mechanism <- lm(M~group_M, data=mechanism)
anova(aov_mechanism)

#p.36
pres <- c(79,72,51,58,68,75,66,48,56,65,69,64,44,51,61,65,62,41,45,58)
coal <- factor(rep(1:5, 4))
tar <- factor(rep(1:4,each=5))
cokes <- data.frame(coal,tar,pres)
anova(lm(pres~coal+tar,data=cokes))

#p.52
machine <- factor(rep(1:3,each=6))
technician <- factor(rep(1:3,3,each=2))
quality <- c(9,14,14,16,19,22,13,16,18,26,14,18,11,12,11,17,15,16)
product <- data.frame(machine,technician,quality)
anova(lm(quality~machine*technician,data=product))