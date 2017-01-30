# making some spaghettis from Casper's template code.
setwd("~/Documents/Internship/Biology17/")
auto <- read.csv("auto_data.csv",header=T)
manual <- read.csv("manual_data.csv",header=T)
manual <- manual[manual$pair!=0,]
library(ggplot2);library(gridExtra)
#==================================
#Manual dataset

host.asex <- by (data=manual$host_spp[manual$mode=="asex"], manual$pair[manual$mode=="asex"] , mean, simplify=T, na.rm=T)
host.sex <- by (data=manual$host_spp[manual$mode=="sex"], manual$pair[manual$mode=="sex"] , mean, simplify=T, na.rm=T)
df <- as.data.frame(cbind(host.asex, host.sex))
m.host <- reshape (df, varying=c("host.asex", "host.sex"), v.names = "host_spp", timevar="mode", direction="long", 
                   times = c("asex", "sex"), idvar="pair")
m.host<- merge(x=m.host,y=manual[,c("family","pair")],by="pair")
line.host <- ggplot(data=m.host, aes(x=mode, y=host_spp, group=pair)) + 
  geom_path(alpha=0.6) + theme_classic() + theme(axis.line.x = element_line (color="black"), axis.line.y = element_line (color="black")) +
  ylab("Number of host species") + xlab("") + annotate("text", x=1.5, y=170, label="p = 0.0042", size=4)+ylim(c(0,75))

country.asex <- by (data=manual$nbr_country[manual$mode=="asex"], manual$pair[manual$mode=="asex"] , mean, simplify=T, na.rm=T)
country.sex <- by (data=manual$nbr_country[manual$mode=="sex"], manual$pair[manual$mode=="sex"] , mean, simplify=T, na.rm=T)
df <- as.data.frame(cbind(country.asex, country.sex))
m.country <- reshape (df, varying=c("country.asex", "country.sex"), v.names = "nbr_country", timevar="mode", direction="long", 
                   times = c("asex", "sex"), idvar="pair")
m.country<- merge(x=m.country,y=manual[,c("family","pair")],by="pair")

line.country <- ggplot(data=m.country, aes(x=mode, y=nbr_country, group=pair))+  
  geom_path(alpha=0.6) + theme_classic() + theme(axis.line.x = element_line (color="black"), axis.line.y = element_line (color="black")) +
  ylab("Number of countries") + xlab("") + annotate("text", x=1.5, y=120, label="p = 0.0046", size=4)+ylim(c(0,100))

grid.arrange(line.host, line.country, nrow=1, ncol=2)

# Latitude

minlat.asex <- by(data=manual$min_dist_eq[manual$mode=="asex"],manual$pair[manual$mode=="asex"],mean,simplify=T,na.rm=T)
minlat.sex <- by(data=manual$min_dist_eq[manual$mode=="sex"],manual$pair[manual$mode=="sex"],mean,simplify=T,na.rm=T)
df <- as.data.frame(cbind(minlat.asex, minlat.sex))
m.mindist <- reshape (df, varying=c("minlat.asex", "minlat.sex"), v.names = "min_dist_eq", timevar="mode", direction="long", 
                      times = c("asex", "sex"), idvar="pair")
m.mindist<- merge(x=m.mindist,y=manual[,c("family","pair")],by="pair")

line.mindist <- ggplot(data=m.mindist, aes(x=mode, y=min_dist_eq, group=pair))+  
  geom_path(alpha=0.6) + theme_classic() + theme(axis.line.x = element_line (color="black"), axis.line.y = element_line (color="black")) +
  ylab("Minimum distance to equator") + xlab("") + annotate("text", x=1.5, y=40, label="p = 0.63", size=4)

maxlat.asex <- by(data=manual$max_dist_eq[manual$mode=="asex"],manual$pair[manual$mode=="asex"],mean,simplify=T,na.rm=T)
maxlat.sex <- by(data=manual$max_dist_eq[manual$mode=="sex"],manual$pair[manual$mode=="sex"],mean,simplify=T,na.rm=T)
df <- as.data.frame(cbind(maxlat.asex, maxlat.sex))
m.maxdist <- reshape (df, varying=c("maxlat.asex", "maxlat.sex"), v.names = "max_dist_eq", timevar="mode", direction="long", 
                      times = c("asex", "sex"), idvar="pair")
m.maxdist<- merge(x=m.maxdist,y=manual[,c("family","pair")],by="pair")

line.maxdist <- ggplot(data=m.maxdist, aes(x=mode, y=max_dist_eq, group=pair))+  
  geom_path(alpha=0.6) + theme_classic() + theme(axis.line.x = element_line (color="black"), axis.line.y = element_line (color="black")) +
  ylab("Maximum distance to equator") + xlab("") + annotate("text", x=1.5, y=75, label="p = 0.0078", size=4)

latrange.asex <- by(data=manual$lat_range[manual$mode=="asex"],manual$pair[manual$mode=="asex"],mean,simplify=T,na.rm=T)
latrange.sex <- by(data=manual$lat_range[manual$mode=="sex"],manual$pair[manual$mode=="sex"],mean,simplify=T,na.rm=T)
df <- as.data.frame(cbind(latrange.asex, latrange.sex))
m.latrange <- reshape (df, varying=c("latrange.asex", "latrange.sex"), v.names = "lat_range", timevar="mode", direction="long", 
                      times = c("asex", "sex"), idvar="pair")
m.latrange<- merge(x=m.latrange,y=manual[,c("family","pair")],by="pair")

line.latrange <- ggplot(data=m.latrange, aes(x=mode, y=lat_range, group=pair))+  
  geom_path(alpha=0.6) + theme_classic() + theme(axis.line.x = element_line (color="black"), axis.line.y = element_line (color="black")) +
  ylab("Latitude range") + xlab("") + annotate("text", x=1.5, y=120, label="p = 0.0328", size=4)

grid.arrange(line.country,line.host,line.mindist,line.maxdist,line.latrange,nrow=1)

#==========================================
# Automated dataset

host.asex <- by (data=auto$host_spp[auto$mode=="asex"], auto$genus[auto$mode=="asex"] , mean, simplify=T, na.rm=T)
host.sex <- by (data=auto$host_spp[auto$mode=="sex"], auto$genus[auto$mode=="sex"] , mean, simplify=T, na.rm=T)
df <- as.data.frame(cbind(host.asex, host.sex))
m.host <- reshape (df, varying=c("host.asex", "host.sex"), v.names = "host_spp", timevar="mode", direction="long", 
                   times = c("asex", "sex"), idvar="genus")

line.host <- ggplot(data=m.host, aes(x=mode, y=host_spp, group=genus)) + 
  geom_path(alpha=0.6) + theme_classic() + theme(axis.line.x = element_line (color="black"), axis.line.y = element_line (color="black")) +
  ylab("Number of host species") + xlab("") + annotate("text", x=1.5, y=140, label="p < 0.001", size=4)

country.asex <- by (data=auto$nbr_country[auto$mode=="asex"], auto$genus[auto$mode=="asex"] , mean, simplify=T, na.rm=T)
country.sex <- by (data=auto$nbr_country[auto$mode=="sex"], auto$genus[auto$mode=="sex"] , mean, simplify=T, na.rm=T)
df <- as.data.frame(cbind(country.asex, country.sex))
m.country <- reshape (df, varying=c("country.asex", "country.sex"), v.names = "nbr_country", timevar="mode", direction="long", 
                      times = c("asex", "sex"), idvar="genus")

line.country <- ggplot(data=m.country, aes(x=mode, y=nbr_country, group=genus))+
  geom_path(alpha=0.6) + theme_classic() + theme(axis.line.x = element_line (color="black"), axis.line.y = element_line (color="black")) +
  ylab("Number of countries") + xlab("") + annotate("text", x=1.5, y=90, label="p < 0.001", size=4)

grid.arrange(line.host, line.country, nrow=1, ncol=2)

# Latitude

minlat.asex <- by(data=auto$min_dist_eq[auto$mode=="asex"],auto$genus[auto$mode=="asex"],mean,simplify=T,na.rm=T)
minlat.sex <- by(data=auto$min_dist_eq[auto$mode=="sex"],auto$genus[auto$mode=="sex"],mean,simplify=T,na.rm=T)
df <- as.data.frame(cbind(minlat.asex, minlat.sex))
m.mindist <- reshape (df, varying=c("minlat.asex", "minlat.sex"), v.names = "min_dist_eq", timevar="mode", direction="long", 
                      times = c("asex", "sex"), idvar="genus")

line.mindist <- ggplot(data=m.mindist, aes(x=mode, y=min_dist_eq, group=genus))+  
  geom_path(alpha=0.6) + theme_classic() + theme(axis.line.x = element_line (color="black"), axis.line.y = element_line (color="black")) +
  ylab("Minimum distance to equator") + xlab("") + annotate("text", x=1.5, y=50, label="p < 0.001", size=4)

maxlat.asex <- by(data=auto$max_dist_eq[auto$mode=="asex"],auto$genus[auto$mode=="asex"],mean,simplify=T,na.rm=T)
maxlat.sex <- by(data=auto$max_dist_eq[auto$mode=="sex"],auto$genus[auto$mode=="sex"],mean,simplify=T,na.rm=T)
df <- as.data.frame(cbind(maxlat.asex, maxlat.sex))
m.maxdist <- reshape (df, varying=c("maxlat.asex", "maxlat.sex"), v.names = "max_dist_eq", timevar="mode", direction="long", 
                      times = c("asex", "sex"), idvar="genus")

line.maxdist <- ggplot(data=m.maxdist, aes(x=mode, y=max_dist_eq, group=genus))+  
  geom_path(alpha=0.6) + theme_classic() + theme(axis.line.x = element_line (color="black"), axis.line.y = element_line (color="black")) +
  ylab("Maximum distance to equator") + xlab("") + annotate("text", x=1.5, y=75, label="p < 0.001", size=4)

latrange.asex <- by(data=auto$lat_range[auto$mode=="asex"],auto$genus[auto$mode=="asex"],mean,simplify=T,na.rm=T)
latrange.sex <- by(data=auto$lat_range[auto$mode=="sex"],auto$genus[auto$mode=="sex"],mean,simplify=T,na.rm=T)
df <- as.data.frame(cbind(latrange.asex, latrange.sex))
m.latrange <- reshape (df, varying=c("latrange.asex", "latrange.sex"), v.names = "lat_range", timevar="mode", direction="long", 
                       times = c("asex", "sex"), idvar="genus")

line.latrange <- ggplot(data=m.latrange, aes(x=mode, y=lat_range, group=genus))+  
  geom_path(alpha=0.6) + theme_classic() + theme(axis.line.x = element_line (color="black"), axis.line.y = element_line (color="black")) +
  ylab("Latitude range") + xlab("") + annotate("text", x=1.5, y=120, label="p < 0.001", size=4)

grid.arrange(line.country,line.host,line.mindist,line.maxdist,line.latrange,nrow=1)