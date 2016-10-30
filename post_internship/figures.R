# In this script I try to generate a figure  that sums up the informations about
# the different ecological variables.
# 29.10.2016
##################

# Loading data
library(ggplot2)
setwd("/home/cyril/Documents/Internship/post_internship/")
data0 <- read.csv("~/Documents/Internship/Data/R_working_directory/auto/auto_processed_data.csv", header=T)
citat <-read.csv("~/Dropbox/Cyril-Casper_shared/Internship/Data/auto/auto_citations_per_species.csv", header=T)
data <- merge(x=data0, y=citat, by.x=c("family","genus","species"), by.y=c("family","genus","species"), all=F)
data <- data[!data$nbr_country =="0",] #remove species with no countries described
data <- data[!data$host_spp =="0",] # remove species with no hosts described

data2 <- data[data$ref>"2",] # remove species very few studies
data3 <- data[data$ref>"4",] # remove species very few studies
data4 <- data[data$ref>"7",] # remove species very few studies
effect_size <- read.table("effect_size.txt",sep=",",header=T)

#========================
#Generating summary data with ratio per genus and number of species
autoplot <- data.frame(genus=levels(data3$genus))
for(p in 4:15){
  count <- 1
  gen.vec <- rep(0,length(levels(data3$genus)))
  for(g in levels(data3$genus)){
    medasex <- median(abs(as.numeric(data3[data3$genus==g & data3$mode=="asex",p])),na.rm=T)
    medsex <- median(abs(as.numeric(data3[data3$genus==g & data3$mode=="sex",p])),na.rm=T)
    gen.vec[count] <- medasex/medsex
    count <- count +1
  }
  autoplot[,colnames(data3)[p]] <-gen.vec
}
autoplot <- na.omit(autoplot)
rownames(autoplot) <- NULL

form_plot <- data.frame(genus=rep(0,length(autoplot$genus)*12), 
                        var=rep(0,length(autoplot$genus)*12), 
                        val=rep(0,length(autoplot$genus)*12))
var.vec <- colnames(autoplot)[2:13]
for(r in 1:length(autoplot$genus)){
  gen.vec <- rep(as.character(autoplot$genus[r]),12)
  val.vec <- rep(0,12)
  for(v in 2:13){
    val.vec[v-1] <- autoplot[r,v]
  }
  form_plot$genus[((r-1)*12+1):(r*12)] <- gen.vec
  form_plot$var[((r-1)*12+1):(r*12)] <- var.vec
  form_plot$val[((r-1)*12+1):(r*12)] <- val.vec
}

a <- ggplot(data=form_plot[!(form_plot$var %in% c("lon_max","lon_mean","lon_median","lon_mean","lon_min")),])+
  geom_boxplot(aes(y=log10(val),x=factor(var)))+
  geom_dotplot(aes(y=log10(val),x=factor(var),fill=var),stackdir="center",binaxis="y",position="dodge",binwidth=0.03)


#==================================
# Manual dataset:

manual <- read.csv("../Data/R_working_directory/manual/manual_processed_data.csv")

#Generating summary data with ratio per genus and number of species
autoplot_m <- data.frame(pair=levels(as.factor(manual$pair[manual$pair!=0])))
for(p in c(5:6,14:23)){
  count <- 1
  gen.vec <- rep(0,length(levels(as.factor(manual$pair[manual$pair!=0]))))
  for(g in levels(as.factor(manual$pair[manual$pair!=0]))){
    medasex <- median(abs(as.numeric(manual[manual$pair==g & manual$mode=="asex",p])),na.rm=T)
    medsex <- median(abs(as.numeric(manual[manual$pair==g & manual$mode=="sex",p])),na.rm=T)
    print(paste0("asex : ",medasex));print(medsex)
    gen.vec[count] <- medasex/medsex
    count <- count +1
  }
  autoplot_m[,colnames(manual)[p]] <-gen.vec
}


form_plot_m <- data.frame(pair=rep(0,length(autoplot_m$pair)*12), 
                        var=rep(0,length(autoplot_m$pair)*12), 
                        val=rep(0,length(autoplot_m$pair)*12))
var.vec <- colnames(autoplot_m)[2:13]
for(r in 1:length(autoplot_m$pair)){
  gen.vec <- rep(as.character(autoplot_m$pair[r]),12)
  val.vec <- rep(0,12)
  for(v in 2:13){
    val.vec[v-1] <- autoplot_m[r,v]
  }
  form_plot_m$pair[((r-1)*12+1):(r*12)] <- gen.vec
  form_plot_m$var[((r-1)*12+1):(r*12)] <- var.vec
  form_plot_m$val[((r-1)*12+1):(r*12)] <- val.vec
}

m <- ggplot(data=form_plot_m[!(form_plot_m$var %in% c("lon_max","lon_mean","lon_median","lon_mean","lon_min")),])+
  geom_boxplot(aes(y=log10(val),x=factor(var)))+
  geom_dotplot(aes(y=log10(val),x=factor(var),fill=var),stackdir="center",binaxis="y",position="dodge",binwidth=0.03)

library(gridExtra)
grid.arrange(a,m,nrow=2)
