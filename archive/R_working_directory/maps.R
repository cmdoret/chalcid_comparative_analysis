manual_processed <-read.table("/home/cyril/Documents/Internship/Data/R_working_directory/manual/manual_processed_data.csv", header = T, sep= ",")

library(ks)
testgen = "Trichogramma"

Xa=cbind(manual_processed$lon_median[manual_processed$mode=='asex' & manual_processed$genus==testgen & manual_processed$pair!=0],
         manual_processed$lat_median[manual_processed$mode=='asex' & manual_processed$genus==testgen& manual_processed$pair!=0])
Xs=cbind(manual_processed$lon_median[manual_processed$mode=='sex' & manual_processed$genus==testgen & manual_processed$pair!=0],
         manual_processed$lat_median[manual_processed$mode=='sex' & manual_processed$genus==testgen & manual_processed$pair!=0])
Xa<-Xa[!is.na(Xa[,1]),]
Xs<-Xs[!is.na(Xs[,1]),]
Hpia = Hpi(verbose = F,x = Xa)
DXa=kde(x = Xa, H = Hpia)
Hpis = Hpi(x = Xs)
DXs=kde(x = Xs, H = Hpis)
library(maps)
map("world",mar = c(0,0,0,0),resolution = 0)
#Without correction
plot(DXa,add=TRUE,col="red")
points(Xa,cex=1,col="red",pch=15)
       #pch = manual_processed$pair[manual_processed$mode=='asex' & manual_processed$genus==testgen & manual_processed$pair!=0]
plot(DXs,add=TRUE,col="blue")
points(Xs,cex=1,col="blue",pch=16)
       #pch = manual_processed$pair[manual_processed$mode=='sex' & manual_processed$genus==testgen & manual_processed$pair!=0]




Ya=rbind(cbind(Xa[,1],Xa[,2]),cbind(Xa[,1]+360,Xa[,2]),
        cbind(Xa[,1]-360,Xa[,2]),cbind(Xa[,1],Xa[,2]+180),
        cbind(Xa[,1]+360,Xa[,2]+180),cbind(Xa[,1]-360,Xa[,2]+180),
        cbind(Xa[,1],Xa[,2]-180),cbind(Xa[,1]+360,
                                     Xa[,2]-180),cbind(Xa[,1]-360,Xa[,2]-180))
Ys=rbind(cbind(Xs[,1],Xs[,2]),cbind(Xs[,1]+360,Xs[,2]),
        cbind(Xs[,1]-360,Xs[,2]),cbind(Xs[,1],Xs[,2]+180),
        cbind(Xs[,1]+360,Xs[,2]+180),cbind(Xs[,1]-360,Xs[,2]+180),
        cbind(Xs[,1],Xs[,2]-180),cbind(Xs[,1]+360,
                                     Xs[,2]-180),cbind(Xs[,1]-360,Xs[,2]-180))
DYa=kde(x = Ya, H = Hpia)
DYs=kde(x = Ys, H = Hpis)
library(maps)
#with correction
plot(DYa,add=TRUE,col="red")
plot(DYs,add=TRUE,col="blue")



auto_processed <-read.table("/home/cyril/Documents/Internship/Data/R_working_directory/auto/auto_processed_data.csv", header = T, sep= ",")
library(ks)
Xa=cbind(auto_processed$lon_median[auto_processed$mode=='asex' & auto_processed$genus==testgen],
         auto_processed$lat_median[auto_processed$mode=='asex' & auto_processed$genus==testgen])
Xs=cbind(auto_processed$lon_median[auto_processed$mode=='sex' & auto_processed$genus==testgen],
         auto_processed$lat_median[auto_processed$mode=='sex' & auto_processed$genus==testgen])
Xa<-Xa[!is.na(Xa[,1]),]
Xs<-Xs[!is.na(Xs[,1]),]
Hpia = Hpi(x = Xa)
DXa=kde(x = Xa, H = Hpia)
Hpis = Hpi(x = Xs)
DXs=kde(x = Xs, H = Hpis)
library(maps)
map("world",mar = c(0,0,0,0),resolution = 0)
#Without correction
#plot(DXa,add=TRUE,col="red")
points(Xa,cex=.8,col="red",pch=15)
#plot(DXs,add=TRUE,col="blue")
points(Xs,cex=.8,col="blue",pch=17)
legend(x=-180,y=-49,fill = c("red","blue"),title = testgen,legend = c("Asex","Sex"))


Ya=rbind(cbind(Xa[,1],Xa[,2]),cbind(Xa[,1]+360,Xa[,2]),
         cbind(Xa[,1]-360,Xa[,2]),cbind(Xa[,1],Xa[,2]+180),
         cbind(Xa[,1]+360,Xa[,2]+180),cbind(Xa[,1]-360,Xa[,2]+180),
         cbind(Xa[,1],Xa[,2]-180),cbind(Xa[,1]+360,
                                        Xa[,2]-180),cbind(Xa[,1]-360,Xa[,2]-180))
Ys=rbind(cbind(Xs[,1],Xs[,2]),cbind(Xs[,1]+360,Xs[,2]),
         cbind(Xs[,1]-360,Xs[,2]),cbind(Xs[,1],Xs[,2]+180),
         cbind(Xs[,1]+360,Xs[,2]+180),cbind(Xs[,1]-360,Xs[,2]+180),
         cbind(Xs[,1],Xs[,2]-180),cbind(Xs[,1]+360,
                                        Xs[,2]-180),cbind(Xs[,1]-360,Xs[,2]-180))
DYa=kde(x = Ya, H = Hpia)
DYs=kde(x = Ys, H = Hpis)
library(maps)
#with correction
plot(DYa,add=TRUE,col="red")
plot(DYs,add=TRUE,col="blue")



# ggmap version

library(ggmap)
library(ggplot2)
library(maptools)
library(maps)

wholemap <- ggplot() + borders("world", colour="gray50", fill="gray50")
pointsmap <- wholemap + geom_point(aes(x=Xs[,1], y=Xs[,2]) ,color="blue", size=3) + 
  geom_point(aes(x=Xa[,1], y=Xa[,2]) ,color="red",pch=15, size=3)
pointsmap

densimap <- wholemap  +   geom_density2d(data = auto_processed[auto_processed$mode=='sex' & auto_processed$genus==testgen,],
                                         aes(x = lon_median, y = lat_median)) +
  stat_density2d(data = auto_processed[auto_processed$mode=='sex' & auto_processed$genus==testgen,], 
                 aes(x = lon_median, y = lat_median,  fill = ..level.., alpha = ..level..),
                     size = 0.01, bins = 16, geom = 'polygon') +
  scale_fill_gradient(low = "yellow", high = "red") +
  scale_alpha(range = c(0.00, 0.25), guide = FALSE) +
  theme(legend.position = "none", axis.title = element_blank(), text = element_text(size = 12))

densimap <- wholemap + 
  stat_density2d(data = rbind(data.frame(auto_processed[auto_processed$mode=='asex',], group="a"),
                              data.frame(auto_processed[auto_processed$mode=='sex',], group="s")), 
                 aes(x = lon_median, y = lat_median,  fill = group, alpha = ..level..),
                 size = 0.01, bins = 16, geom = 'polygon') +
  scale_fill_manual(values=c("a"="#FF0000", "s"="#0000FF")) + 
  scale_alpha(range = c(0.00, 0.75), guide = T) +
  theme(legend.position = "none", axis.title = element_blank(), text = element_text(size = 12))
densimap


ggplot(rbind(data.frame(auto_processed[auto_processed$mode=='asex' & auto_processed$genus==testgen,], group="a"),
             data.frame(auto_processed[auto_processed$mode=='sex' & auto_processed$genus==testgen,], group="s")), 
       aes(x=lon_median,y=lat_median)) + 
  stat_density2d(geom="tile", aes(fill = group, alpha=..density..), contour=FALSE) + 
  scale_fill_manual(values=c("a"="#FF0000", "s"="#0000FF")) + 
  theme_minimal()
