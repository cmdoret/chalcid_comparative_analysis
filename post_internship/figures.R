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
data$max_dist_eq <- pmax(abs(data$lat_min),abs(data$lat_max))

data2 <- data[data$ref>"2",] # remove species very few studies
data3 <- data[data$ref>"4",] # remove species very few studies
data4 <- data[data$ref>"7",] # remove species very few studies
effect_size <- read.table("effect_size.txt",sep=",",header=T)

#========================
#Generating summary data with ratio per genus and number of species
pvals_a <- data.frame(var=c("nbr_country","max_dist_eq","lat_mean","lat_median","host_spp"),pval=c(0.002,0.009,0.056,0.055,0.001))
autoplot <- data.frame(genus=levels(data3$genus))
for(p in c(4:15,19)){
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

form_plot <- data.frame(genus=rep(0,length(autoplot$genus)*13), 
                        var=rep(0,length(autoplot$genus)*13), 
                        val=rep(0,length(autoplot$genus)*13))
var.vec <- colnames(autoplot)[2:14]
for(r in 1:length(autoplot$genus)){
  gen.vec <- rep(as.character(autoplot$genus[r]),13)
  val.vec <- rep(0,13)
  for(v in 2:14){
    val.vec[v-1] <- autoplot[r,v]
  }
  form_plot$genus[((r-1)*13+1):(r*13)] <- gen.vec
  form_plot$var[((r-1)*13+1):(r*13)] <- var.vec
  form_plot$val[((r-1)*13+1):(r*13)] <- val.vec
}
form_plot <- merge(form_plot, pvals_a, by="var", all = F)
a <- ggplot(data=form_plot[form_plot$var %in% c("nbr_country","max_dist_eq","lat_median","host_spp"),])+
  geom_boxplot(aes(y=log10(val),x=factor(var),fill=pval))+
  scale_fill_continuous(high = "#dddd88", low="#88dd88",guide = "colourbar")+
  geom_dotplot(aes(y=log10(val),x=factor(var)),stackdir="center",binaxis="y",position="dodge",binwidth=0.03)+
  theme_bw()


#==================================
# Manual dataset:
pvals_m <- data.frame(var=c("nbr_country","max_dist_eq","lat_mean","lat_median","nbr_host_spp","min_length","max_length"),
                    pval=c(0.009,0.003,0.041,0.021,0.002,0.409,0.332))
manual <- read.csv("../Data/R_working_directory/manual/manual_processed_data.csv")
manual$max_dist_eq <- pmax(abs(manual$lat_min),abs(manual$lat_max))
#Generating summary data with ratio per genus and number of species
autoplot_m <- data.frame(pair=levels(as.factor(manual$pair[manual$pair!=0])))

for(p in c(5:6,14:23,42)){
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


form_plot_m <- data.frame(pair=rep(0,length(autoplot_m$pair)*13), 
                        var=rep(0,length(autoplot_m$pair)*13), 
                        val=rep(0,length(autoplot_m$pair)*13))
var.vec <- colnames(autoplot_m)[2:14]
for(r in 1:length(autoplot_m$pair)){
  gen.vec <- rep(as.character(autoplot_m$pair[r]),13)
  val.vec <- rep(0,13)
  for(v in 2:14){
    val.vec[v-1] <- autoplot_m[r,v]
  }
  form_plot_m$pair[((r-1)*13+1):(r*13)] <- gen.vec
  form_plot_m$var[((r-1)*13+1):(r*13)] <- var.vec
  form_plot_m$val[((r-1)*13+1):(r*13)] <- val.vec
}
form_plot_m <- merge(form_plot_m, pvals_m, by="var")
m <- ggplot(data=form_plot_m[!(form_plot_m$var %in% c("lon_max","lon_mean","lon_median","lon_mean","lon_min")),])+
  geom_boxplot(aes(y=log10(val),x=factor(var), fill=log10(form_plot_m$pval)))+
  geom_dotplot(aes(y=log10(val),x=factor(var)),stackdir="center",binaxis="y",position="dodge",binwidth=0.03)+
  scale_fill_continuous(high = "#dd8888", low="#88dd88",guide = "colourbar")+
  theme_bw()

library(gridExtra)
grid.arrange(a,m,nrow=2)
