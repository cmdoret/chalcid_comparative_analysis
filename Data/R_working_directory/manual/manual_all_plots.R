setwd("/home/cyril/Documents/Internship/Data/R_working_directory/manual/")
processed <-read.table("manual_processed_data.csv", header = T, sep= ",")

# Visualisation:
library(ggplot2)
#================================================================
# Overall
#------------------------------------------------------------------------------
# Length vs number of hosts
ggplot(data = processed,aes(x=rowMeans(processed[,c("min_length","max_length")],na.rm=F),y=processed[,"nbr_host_spp"]))+
  geom_point(aes(colour = processed[,"mode"]))+
  theme_bw()
# with log transform 
ggplot(data = processed,aes(x=rowMeans(processed[,c("min_length","max_length")],na.rm=F),y=processed[,"nbr_host_spp"]))+
  geom_point(aes(colour = processed[,"mode"]))+
  theme_bw()+
  coord_trans(x = "log2", y = "log2")

#Number of countries
boxplot(log10(processed$nbr_country[processed$nbr_country>0 & processed$mode!="both"])~droplevels(processed$mode[processed$nbr_country>0 & processed$mode!="both"]),
        main="Number of countries by \nreproductive mode: Overall", ylab="Log countries",  names = c(
          paste0("Asex: n=",length(processed$nbr_country[processed$nbr_country>0 & processed$mode=="asex"])),
          paste0("Sex: n=",length(processed$nbr_country[processed$nbr_country>0 & processed$mode=="sex"]))))

#-----------------------------------------------------------------------------
# Number of hosts distribution sex vs asex
ggplot()+
  geom_histogram(data=processed[processed$mode=="asex",],aes(x=nbr_host_spp, stat=..count..,fill='Asexual'),alpha=0.3,bins=23)+
  geom_histogram(data=processed[processed$mode=="sex",],aes(x=nbr_host_spp, y=-..count..,fill='Sexual'),alpha=0.3,bins=25)+
  coord_cartesian(ylim=c(-30,30))+
  ggtitle("Distribution of the number of host species")



length(levels(as.factor(processed[processed$mode=="asex" & processed$nbr_host_spp!=0,"nbr_host_spp"])))
length(levels(as.factor(processed[processed$mode=="sex" & processed$nbr_host_spp!=0,"nbr_host_spp"])))
max(processed[processed$mode=="sex","nbr_host_spp"],na.rm = T)
max(processed[processed$mode=="asex","nbr_host_spp"],na.rm = T)

# With log transform
ggplot()+
  geom_histogram(data=processed[processed$mode=="asex" & processed$nbr_host_spp!=0,],aes(x=log2(nbr_host_spp), stat=..count..,fill='Asexual')
                 ,alpha=0.3,bins=25)+
  geom_histogram(data=processed[processed$mode=="sex" & processed$nbr_host_spp!=0,],aes(x=log2(nbr_host_spp), y=-..count..,fill='Sexual')
                 ,alpha=0.3,bins=25)+
  coord_cartesian(ylim=c(-30,30))
#------------------------------------------------------------------------------

# Maximum distance from equator, sex vs asex (vs both modes)
ggplot()+
  geom_boxplot(data = processed[!is.na(processed$mode) & processed$mode!='both',],aes(x=mode,y=pmax(abs(lat_max),abs(lat_min))))+
  ggtitle("Max distance from the equator between reproductive modes")+
  labs(x="Reproductive mode",y="Absolute latitude")+
  annotate(x = c(1,2),y=c(10,10),geom= "text", label=c(paste0("n=",length(processed[processed$mode=="asex","lat_max"])),
                                                            paste0("n=",length(processed[processed$mode=="sex","lat_max"]))))

# Mean latitude
ggplot()+
  geom_boxplot(data = processed[!is.na(processed$mode) & processed$mode!='both',],aes(x=mode,y=lat_mean))+
  ggtitle("Mean latitude between reproductive modes")+
  labs(x="Reproductive mode",y="Latitude")+
  annotate(x = c(1,2),y=c(10,10),geom= "text", label=c(paste0("n=",length(processed[processed$mode=="asex","lat_max"])),
                                                            paste0("n=",length(processed[processed$mode=="sex","lat_max"]))))

# Median latitude
ggplot()+
  geom_boxplot(data = processed[!is.na(processed$mode) & processed$mode!='both',],aes(x=mode,y=lat_median))+
  ggtitle("Median latitude between reproductive modes")+
  labs(x="Reproductive mode",y="Latitude")+
  annotate(x = c(1.2,2.2),y=c(10,10),geom= "text", label=c(paste0("n=",length(processed[processed$mode=="asex","lat_max"])),
                                                       paste0("n=",length(processed[processed$mode=="sex","lat_max"]))))


#------------------------------------------------------------------------------

# Length per reproduction mode
boxplot(rowMeans(cbind(processed$min_length[processed$mode!="both"],processed$max_length[processed$mode!="both"]))~droplevels(processed[processed$mode!="both","mode"]),main="Body length vs Reproduction mode")
text(x = c(1,2),y=c(1,1),labels=c(paste0("n=",length(processed[processed$mode=="asex" & !is.na(processed$min_length),"lat_max"])),
                                      paste0("n=",length(processed[processed$mode=="sex" & !is.na(processed$min_length),"lat_max"]))))

# Number of host species
boxplot(processed[,"nbr_host_spp"]~processed[,"mode"],main="Number of host species vs Reproduction mode")
text(x = c(1,2,3),y=c(110,110,110),labels=c(paste0("n=",length(processed[processed$mode=="asex" & !is.na(processed$nbr_host_spp),"lat_max"])),
                                      paste0("n=",length(processed[processed$mode=="both" & !is.na(processed$nbr_host_spp),"lat_max"])),
                                      paste0("n=",length(processed[processed$mode=="sex" & !is.na(processed$nbr_host_spp),"lat_max"]))))

#==============================================================================
#Same plots per family
#Length
par(mfrow=c(4,4))
for(i in levels(processed$family))
{
  fam_df <- processed[processed$family==i & processed$mode!="both",]
  fam_df$mode <- factor(fam_df$mode)
  if(length(fam_df$min_length[fam_df$mode =="asex"])>0 & length(fam_df$min_length[fam_df$mode =="sex"])>0)
  {
    my_names <-c(as.character(paste0("n=",length(fam_df[fam_df$mode=="asex" & !is.na(fam_df$min_length),"lat_max"]))),
                 as.character(paste0("n=",length(fam_df[fam_df$mode=="sex" & !is.na(fam_df$min_length),"lat_max"]))))
    boxplot(rowMeans(fam_df[,c("min_length","max_length")])~fam_df$mode,main=paste(i, "Body length", sep=":"),names = c(paste('asex',my_names[1],sep=': '),paste('sex',my_names[2],sep=': ')))
  }
  
}

#-----------------------------------------------------------------------------
#Number of hosts
par(mfrow=c(4,4))
for(i in levels(processed$family))
{
  fam_df <- processed[processed$family==i & processed$mode!="both",]
  fam_df <- subset(fam_df,subset = fam_df$host_spp>0)
  fam_df$mode <- factor(fam_df$mode)
  if(length(fam_df$host_spp[fam_df$host_spp>0 & fam_df$mode =="asex"])>0 & length(fam_df$host_spp[fam_df$host_spp>0 & fam_df$mode =="sex"])>0)
  {
    my_names <-c(as.character(paste0("n=",length(fam_df[fam_df$mode=="asex" & !is.na(fam_df$host_spp),"lat_max"]))),
                 as.character(paste0("n=",length(fam_df[fam_df$mode=="sex" & !is.na(fam_df$host_spp),"lat_max"]))))
    boxplot(fam_df[fam_df$host_spp>0,"host_spp"]~fam_df$mode,main=paste(i, "Host species", sep=":"),names = c(paste('asex',my_names[1],sep=': '),paste('sex',my_names[2],sep=': ')))
  }
  
}

#-----------------------------------------------------------------------------
# Distribution
par(mfrow=c(4,4))
for(i in levels(processed$family))
{
  fam_df <- processed[processed$family==i & processed$mode!="both",]
  fam_df <- subset(fam_df,subset = fam_df$host_spp>0)
  fam_df$mode <- factor(fam_df$mode)
  if(length(fam_df$host_spp[fam_df$host_spp>0 & fam_df$mode =="asex"])>0 & length(fam_df$host_spp[fam_df$host_spp>0 & fam_df$mode =="sex"])>0)
  {
    my_names <-c(as.character(paste0("n=",length(fam_df[fam_df$mode=="asex" & !is.na(fam_df$host_spp),"lat_max"]))),
                 as.character(paste0("n=",length(fam_df[fam_df$mode=="sex" & !is.na(fam_df$host_spp),"lat_max"]))))
    boxplot(fam_df[fam_df$host_spp>0,"host_spp"]~fam_df$mode,main=paste(i, "Host species", sep=":"),names = c(paste('asex',my_names[1],sep=': '),paste('sex',my_names[2],sep=': ')))
  }
  
}

#=============================================================================
# Per genus:

par(mfrow=c(4,3))
for(i in levels(processed$genus)[-c(7,9)])
{
  genus_df <- processed[processed$genus==i & processed$mode!="both",]
  genus_df$mode <- factor(genus_df$mode)
  boxplot(genus_df[,"min_length"]~genus_df$mode,main=paste(i, "Body length", sep=":"))
  text(x = c(1,2),y=c(0.9,0.9),labels=c(paste0("n=",length(genus_df[genus_df$mode=="asex" & !is.na(genus_df$min_length),"lat_max"])),
                                        paste0("n=",length(genus_df[genus_df$mode=="sex" & !is.na(genus_df$min_length),"lat_max"]))))
}



#-----------------------------------------------------------------------------
#Number of hosts

par(mfrow=c(4,3))
for(i in levels(processed$genus)[-c(7,9)])
{
  genus_df <- processed[processed$genus==i & processed$mode!="both",]
  genus_df$mode <- factor(genus_df$mode)
  boxplot(genus_df[,"min_length"]~genus_df$mode,main=paste(i, "Body length", sep=":"))
  text(x = c(1,2),y=c(0.9,0.9),labels=c(paste0("n=",length(genus_df[genus_df$mode=="asex" & !is.na(genus_df$min_length),"lat_max"])),
                                        paste0("n=",length(genus_df[genus_df$mode=="sex" & !is.na(genus_df$min_length),"lat_max"]))))
}



#-----------------------------------------------------------------------------
# Distribution


par(mfrow=c(2,4))
for(i in levels(processed$genus))
{
  gen_df <- processed[processed$genus==i & processed$mode!="both",]
  gen_df <- subset(gen_df,subset = gen_df$nbr_country>0)
  gen_df$mode <- factor(gen_df$mode)
  if(length(gen_df$nbr_country[gen_df$nbr_country>0 & gen_df$mode =="asex"])>0 & length(gen_df$nbr_country[gen_df$nbr_country>0 & gen_df$mode =="sex"])>0)
  {
    my_names <-c(as.character(paste0("n=",length(gen_df[gen_df$mode=="asex" & !is.na(gen_df$nbr_country),"lat_max"]))),
                 as.character(paste0("n=",length(gen_df[gen_df$mode=="sex" & !is.na(gen_df$nbr_country),"lat_max"]))))
    boxplot(gen_df[gen_df$nbr_country>0,"nbr_country"]~gen_df$mode,main=paste(i, "Number of countries/states", sep=":"),names = c(paste('asex',my_names[1],sep=': '),paste('sex',my_names[2],sep=': ')))
  }
  
}


#median latitude

par(mfrow=c(2,4))
for(i in levels(processed$genus))
{
  gen_df <- processed[processed$genus==i & processed$mode!="both",]
  gen_df <- subset(gen_df,subset = gen_df$nbr_country>0)
  gen_df$mode <- factor(gen_df$mode)
  if(length(gen_df$nbr_country[gen_df$nbr_country>0 & gen_df$mode =="asex"])>0 & length(gen_df$nbr_country[gen_df$nbr_country>0 & gen_df$mode =="sex"])>0)
  {
    my_names <-c(as.character(paste0("n=",length(gen_df[gen_df$mode=="asex" & !is.na(gen_df$nbr_country),"lat_max"]))),
                 as.character(paste0("n=",length(gen_df[gen_df$mode=="sex" & !is.na(gen_df$nbr_country),"lat_max"]))))
    boxplot(gen_df[gen_df$nbr_country>0,"lat_median"]~gen_df$mode,main=paste(i, "Median latitude", sep=":"),names = c(paste('asex',my_names[1],sep=': '),paste('sex',my_names[2],sep=': ')))
  }
  
}

#----------------------------------------------------------------------------
# Latitude range

par(mfrow=c(2,4))
for(i in levels(processed$genus))
{
  gen_df <- processed[processed$genus==i & processed$mode!="both",]
  gen_df <- subset(gen_df,subset = gen_df$nbr_country>0)
  gen_df$mode <- factor(gen_df$mode)
  if(length(gen_df$nbr_country[gen_df$nbr_country>0 & gen_df$mode =="asex"])>0 & length(gen_df$nbr_country[gen_df$nbr_country>0 & gen_df$mode =="sex"])>0)
  {
    my_names <-c(as.character(paste0("n=",length(gen_df[gen_df$mode=="asex" & !is.na(gen_df$nbr_country),"lat_max"]))),
                 as.character(paste0("n=",length(gen_df[gen_df$mode=="sex" & !is.na(gen_df$nbr_country),"lat_max"]))))
    diff <- gen_df[gen_df$nbr_country>0,"lat_max"]-gen_df[gen_df$nbr_country>0,"lat_min"]
    boxplot(diff~gen_df$mode[gen_df$nbr_country>0],main=paste(i, "Latitude range", sep=":"),
            names = c(paste('asex',my_names[1],sep=': '),paste('sex',my_names[2],sep=': ')))
  }
  
}


#=============================================================================
# Per comparison group:
# Length per reproduction mode per comparison group
chalcid_box <-function(par,relatgr){
  edge <-ceiling(sqrt(length(relatgr)))
  par(mfrow=c(edge,edge))
  for(i in relatgr){
    processed_gr <-processed[processed$pair==i,]
    plot(as.numeric(processed_gr[,"mode"]),processed_gr[,par],xlim=c(0.5,3.5),pch=20
            ,main=paste(processed_gr$genus[1],sep=", n=",length(processed_gr$min_length[!is.na(processed_gr[,par])])))
    text(x = c(0.8,1.8,2.8),y=c(mean(na.rm = T,processed_gr[processed_gr$mode=="asex" & !is.na(processed_gr[,par]),par]),
                          mean(na.rm = T,processed_gr[processed_gr$mode=="both" & !is.na(processed_gr[,par]),par]),
                          mean(na.rm = T,processed_gr[processed_gr$mode=="sex" & !is.na(processed_gr[,par]),par])),labels=c(
                                          paste0("n=",length(processed_gr[processed_gr$mode=="asex" & !is.na(processed_gr[,par]),"lat_max"])),
                                          paste0("n=",length(processed_gr[processed_gr$mode=="both" & !is.na(processed_gr[,par]),"lat_max"])),
                                          paste0("n=",length(processed_gr[processed_gr$mode=="sex" & !is.na(processed_gr[,par]),"lat_max"]))))
    
  }
}
# Aphelinus
chalcid_box("min_length",c(1))
chalcid_box("nbr_host_spp",c(1))
# Aphytis
chalcid_points("min_length",c(3,5,6,7,8,9,10))
chalcid_box("nbr_host_spp",c(3,5,6,7,8,9,10))
# Encarsia
chalcid_box("nbr_host_spp",c(2,11,12,13,14))
chalcid_box("min_length",c(2,11,12,13,14))
# Eretmocerus
chalcid_box("nbr_host_spp",c(4,15))
# Megastigmus
chalcid_box("nbr_host_spp",c(16,17,18,19))
# Torymus
chalcid_box("min_length",25)
# Megaphragma
chalcid_box("min_length",26)
chalcid_box("nbr_host_spp",26)
# Trichogramma
chalcid_box("min_length",c(20,21,23,24))
chalcid_points("min_length",c(20,21,23,24))


# PAIRWISE ANALYSIS USING RATIOS:
library(lattice)
body_length <- rowMeans(cbind(processed$min_length,processed$max_length))
processed <- cbind(processed,body_length)
ratios <- list(c(), c(), c(), c(), c(), c(), c(), c(), c(), c(), c())
for(i in 1:(length(levels(as.factor(processed$pair)))-1))
{
  count <-1
  for(j in c("body_length","nbr_country","nbr_host_spp", "lat_min", "lat_max", "lat_mean", "lat_median", "lon_min", "lon_max", "lon_mean", "lon_median"))
  {
    tmp_ratio <- mean(na.rm = T,processed[processed$mode=='asex' & processed$pair==i,j])/
      mean(na.rm = T, processed[processed$mode=='sex' & processed$pair==i,j])
    ratios[[count]] <- append(ratios[[count]], tmp_ratio)
    count <- count + 1
  }
}
df_ratio <- data.frame(ratios)
colnames(df_ratio)<-c("length_ratio","country_ratio","host_ratio","south_ratio", "north_ratio", "mean_lat_ratio","median_lat_ratio","west_ratio", "east_ratio", "mean_lon_ratio", "median_lon_ratio")
par(mfrow=c(3,3))
densityplot(log2(df_ratio$host_ratio), main="Number of host per pair: asex/sex", xlab="Log ratio")
densityplot(log2(df_ratio$south_ratio), main="Ratio of min latitude per pair: asex/sex", xlab="Log ratio")
densityplot(log2(df_ratio$north_ratio), main="Ratio of max latitude per pair: asex/sex", xlab="Log ratio")
densityplot(log2(df_ratio$mean_lat_ratio), main="Ratio of mean latitude per pair: asex/sex", xlab="Log ratio")
densityplot(log2(df_ratio$median_lat_ratio), main="Ratio of median latitude per pair: asex/sex", xlab="Log ratio")
densityplot(log2(df_ratio$west_ratio), main="Ratio of min longitude per pair: asex/sex", xlab="Log ratio")
densityplot(log2(df_ratio$east_ratio), main="Ratio of max longitude per pair: asex/sex", xlab="Log ratio")
densityplot(log2(df_ratio$mean_lon_ratio), main="Ratio of mean longitude per pair: asex/sex", xlab="Log ratio")
densityplot(log2(df_ratio$median_lon_ratio), main="Ratio of median longitude per pair: asex/sex", xlab="Log ratio")

dotplot(df_ratio$length_ratio,main="Ratio of body length per pair: asex/sex",xlab= "Ratio",panel=function(x, ...){
  panel.dotplot(x, ...)
  panel.abline(v=1)})

dotplot(log10(df_ratio$country_ratio), main="Ratio of number of locations per pair: asex/sex", xlab="Log ratio")
plot(rownames(df_ratio),df_ratio$length_ratio, xlab="Pairs",ylab= "Ratios")
abline(h=1)


dotplot(log10(df_ratio$host_ratio), main="Number of host per pair: asex/sex", xlab="Log ratio",panel=function(x, ...){
  panel.dotplot(x, ...)
  panel.abline(v=0)})
plot(rownames(df_ratio),log10(df_ratio$host_ratio), xlab="Pairs",ylab= "Ratios")
abline(h=0)
#----------------------------------------------------
# Cluster along coordinates ?
kmeans()
#=========================================================================================
# TEST ZONE
library(gridExtra)
chalcid_points <-function(par,relatgr){
  edge <-ceiling(sqrt(length(relatgr)))
  plot_nr <-1
  plot_list<-list()
  for(i in relatgr){
    processed_gr <-processed[processed$pair==i,]
    plot_list[[plot_nr]]<-ggplot()+
      geom_point(aes(x=processed_gr$mode,y=processed_gr[,par]))+
      labs(title=par,x="reproductive mode",y=par)+
      annotate(geom = "text",x = c(0.9,1.9),y=c(mean(na.rm = T,processed_gr[processed_gr$mode=="asex" & !is.na(processed_gr[,par]),par]),
                                                mean(na.rm = T,processed_gr[processed_gr$mode=="sex" & !is.na(processed_gr[,par]),par])),label=c(
                                                  paste0("n=",length(processed_gr[processed_gr$mode=="asex" & !is.na(processed_gr[,par]),"lat_max"])),
                                                  paste0("n=",length(processed_gr[processed_gr$mode=="sex" & !is.na(processed_gr[,par]),"lat_max"]))))
      theme_bw()
    plot_nr <-plot_nr+1
  }
  do.call(grid.arrange,plot_list)
}

par<-"min_length"
edge <-3
plot_nr <-1
plot_list<-list()
for(i in c(20,21,23)){
  processed_gr <-processed[processed$pair==i,]
  plot_list[[plot_nr]]<-ggplot()+
           geom_point(aes(x=processed_gr$mode,y=processed_gr[,par]))+
           labs(title=var,x="reproductive mode",y=par)+
           annotate(geom = "text",x = c(0.9,1.9),y=c(mean(na.rm = T,processed_gr[processed_gr$mode=="asex" & !is.na(processed_gr[,par]),par]),
                                                     mean(na.rm = T,processed_gr[processed_gr$mode=="sex" & !is.na(processed_gr[,par]),par])),label=c(
                                                       paste0("n=",length(processed_gr[processed_gr$mode=="asex" & !is.na(processed_gr[,par]),"lat_max"])),
                                                       paste0("n=",length(processed_gr[processed_gr$mode=="sex" & !is.na(processed_gr[,par]),"lat_max"]))))+
           theme_bw()
  plot_nr <-plot_nr+1
}
do.call(grid.arrange,plot_list)