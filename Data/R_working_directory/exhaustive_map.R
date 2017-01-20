mydata <-read.table("/home/cyril/Documents/Internship/Data/R_working_directory/auto/auto_processed_data.csv", header = T, sep= ",")

asex.full<-""
sex.full<-""
setwd("/home/cyril/PycharmProjects/internship_geodata/experimental/our_geo_per_species_exp/")
path = "/home/cyril/PycharmProjects/internship_geodata/experimental/our_geo_per_species_exp/"
myasex <- mydata[mydata$mode=="asex",]

# WARNING: DONT RUN THIS BLOCK UNLESS YOU NEED TO GENERATE THE FILE AGAIN.
# BEFORE RUNNING THIS BLOCK: 1. DELETE all_asex_loc.txt and all_sex_loc.txt, and recreate them, leaving them empty. Otherwise the script
# will just append values to the existing files.
#Note: I did not bother handling errors, therefore the data needs to be cleared first by:
#1: removing all empty files (sort by size and remove all 0B files)
#2: replacing all commas and ticks in location names with points
# This command line will be helpful:
#grep -rl 'Goa,' /home/cyril/PycharmProjects/internship_geodata/experimental/our_geo_per_species_exp/ | xargs sed -i 's/Goa,/Goa/g'
#Replaces all occurences of "Goa," in the directory by "Goa"

# More general command to find such occurences: egrep -rl '[a-zA-Z]*,[ ]*[a-zA-Z]' ./ | xargs sed -i -E "s/([a-zA-Z]+),([ ])*([a-zA-Z]+)/\1\2\3/"
 

file.names <- dir(path, pattern =".txt")
for(i in 1:length(file.names)){
  nmatch <- 0
  for(j in 1:length(myasex$species))
  {
    if(grepl(paste(myasex$family[j],myasex$genus[j],myasex$species[j],sep="."),file.names[i]))
    {
      setwd('/home/cyril/PycharmProjects/internship_geodata/experimental/our_geo_per_species_exp/')
      file <- read.table(file.names[i],header=FALSE, sep=",",quote = "", stringsAsFactors=FALSE)
      file[,1] <- gsub("'", " ", file[,1])
      taxo <- rep(file.names[i],length(file[,1]))
      fam <- c()
      gen <- c()
      spp <- c()
      for(k in 1:length(taxo))
      {
        taxosplit <- strsplit(taxo[k],split = ".",fixed = T)
        fam <- append(fam,taxosplit[[1]][1])
        gen <- append(gen,taxosplit[[1]][2])
        spp <- append(spp,taxosplit[[1]][3])
      }
      file <- cbind(fam,gen,spp,file)
      asex.full <- rbind(asex.full, file) 
      setwd('/home/cyril/Documents/Internship/Data/R_working_directory/')
      write.table(asex.full, append = TRUE, col.names = FALSE, file = 'all_asex_loc.txt',sep=',', 
                  row.names = FALSE,quote=FALSE)
      nmatch <- 1
      asex.full<-''
      sex.full<-''
    }
  }
  if(nmatch==0)
  {
    setwd('/home/cyril/PycharmProjects/internship_geodata/experimental/our_geo_per_species_exp/')
    file <- read.table(file.names[i],header=FALSE, quote = "", sep=',', stringsAsFactors=FALSE)
    file[,1] <- gsub("'", " ", file[,1])
    taxo <- rep(file.names[i],length(file[,1]))
    fam <- c()
    gen <- c()
    spp <- c()
    for(k in 1:length(taxo))
    {
      taxosplit <- strsplit(taxo[k],split = ".",fixed = T)
      fam <- append(fam,taxosplit[[1]][1])
      gen <- append(gen,taxosplit[[1]][2])
      spp <- append(spp,taxosplit[[1]][3])
    }
    file <- cbind(fam,gen,spp,file)
    sex.full <- rbind(sex.full, file)  
    setwd('/home/cyril/Documents/Internship/Data/R_working_directory/')
    write.table(sex.full, append = TRUE, col.names = FALSE, file = 'all_sex_loc.txt',sep=',', 
                row.names = FALSE,quote=FALSE)
    asex.full<-""
    sex.full<-""
  }
  print(i)
}

#==============================================================


setwd("/home/cyril/Documents/Internship/Data/R_working_directory/auto")
coord.a<-read.table("all_asex_loc.txt",sep=",",header = FALSE)
coord.s<-read.table("all_sex_loc.txt",sep=",",header = FALSE)
colnames(coord.a) <- c("fam","gen","spp","loc","lat","lon")
colnames(coord.s) <- c("fam","gen","spp","loc","lat","lon")
coord.a <- coord.a[!is.na(coord.a$fam),]
coord.s <- coord.s[!is.na(coord.s$fam),]

mygen <- "Paraphytis"
library(ks)
library(scales)

Xa=cbind(coord.a$lon[coord.a$gen==mygen],
         coord.a$lat[coord.a$gen==mygen])
Xs=cbind(coord.s$lon[coord.s$gen==mygen],
         coord.s$lat[coord.s$gen==mygen])
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
points(Xa,cex=.8,col=alpha("red",1),pch=1)
#pch = manual_processed$pair[manual_processed$mode=='asex' & manual_processed$genus==testgen & manual_processed$pair!=0]
plot(DXs,add=TRUE,col="blue")
points(Xs,cex=1,col=alpha("blue",1),pch=16)
#pch = manual_processed$pair[manual_processed$mode=='sex' & manual_processed$genus==testgen & manual_processed$pair!=0]

# ggmap version

library(ggmap)
library(ggplot2)
library(maptools)
library(maps)

wholemap <- ggplot() + borders("world", colour="gray50", fill="gray50")
pointsmap <- wholemap + geom_point(aes(x=Xs[,1], y=Xs[,2]),pch=15 ,color="blue",alpha=0.5, size=3) + 
  geom_point(aes(x=Xa[,1], y=Xa[,2]),alpha=0.5,color="red",pch=15, size=3)
pointsmap+ggtitle(mygen)


densimap <- wholemap + 
  stat_density2d(data = rbind(data.frame(coord.a[coord.a$gen==mygen,], group="asex"),
                              data.frame(coord.s[coord.a$gen==mygen,], group="sex")), 
                 aes(x = lon, y = lat,  fill = group, alpha = ..level..),
                 size = 0.01, bins = 15, geom = 'polygon') +
  scale_fill_manual(values=c("asex"="#FF0000", "sex"="#0000FF")) + 
  scale_alpha(range = c(0.1, 0.8), guide = F)+ggtitle(mygen)
densimap




#Test chunk
ggplot(rbind(data.frame(coord.a[coord.a$gen==mygen], group="a"),
             data.frame(coord.s[coord.a$gen==mygen], group="s")), 
       aes(x=lon,y=lat)) + 
  stat_density2d(geom="tile", aes(fill = group, alpha=..density..), contour=FALSE) + 
  scale_fill_manual(values=c("a"="#FF0000", "s"="#0000FF")) + 
  theme_minimal()+ggtitle(mygen)
