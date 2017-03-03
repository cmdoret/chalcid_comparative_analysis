
dataS <-data.frame(x=rnorm(n = 10000,10,5),y=rnorm(10000,mean(rpois(10000,15)),3))
dataA <- data.frame(x=rnorm(n = 10000,100,5),y=rpois(10000,15))

plot(ceiling(dataS$x),ceiling(dataS$y),pch = 16,col="salmon",xlim=c(-80,160),ylim=c(-10,40),
     main="Schematic representation of results",xlab="longitude",ylab="latitude")
points(ceiling(dataA$x),dataA$y,pch=15,col="steelblue")
abline(h=min(dataS$y),col="salmon",lty=2,lwd=2)
abline(h=min(dataA$y),col="steelblue",lty=2,lwd=2)
abline(h=max(dataS$y),col="salmon",lty=2,lwd=2)
abline(h=max(dataA$y),col="steelblue",lty=2,lwd=2)
abline(h=mean(dataS$y),col="salmon",lty=3,lwd=2)
abline(h=mean(dataA$y),col="steelblue",lty=2,lwd=2)
abline(h=0,lwd=4,lty=2)
text(x = -55,y=-2,"Equator")
legend("bottomright",legend=c("Sex","Asex"),fill=c("salmon","steelblue"))
text(x=c(-50,150),y=c(min(dataS$y)+2,min(dataA$y)+2),labels=c("Min sex","Min asex"),col=c("salmon","steelblue"))
text(x=c(-50,150),y=c(max(dataS$y)+2,max(dataA$y)+2),labels=c("Max sex","Max asex"),col=c("salmon","steelblue"))
text(x=c(-50,150),y=c(mean(dataS$y)+2,mean(dataA$y)+2),labels=c("Mean sex","Mean asex"),col=c("salmon","steelblue"))
