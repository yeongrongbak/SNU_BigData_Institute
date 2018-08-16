plot(seq(-5,5,0.1), dt(seq(-5,5,0.1),20), col="seagreen", xlab="x", ylab="density", type="l")
lines(seq(-5,5,0.1), dt(seq(-5,5,0.1),6), col="blueviolet")
lines(seq(-5,5,0.1), dt(seq(-5,5,0.1),9), col="coral")
lines(seq(-5,5,0.1), dt(seq(-5,5,0.1),3))
lines(seq(-5,5,0.1), dnorm(seq(-5,5,0.1),col="blue"))

legend("topright", col=c("black", "blueviolet", "coral", "seagreen", "blue"), lty=c(1,1,1,1,1))

par(mfrow=c(1,3))
plot(seq(0,4,0.1), df(seq(0,4,0.1),3,20), col="seagreen", xlab="x", ylab="density", type="l", main="k1=3")
