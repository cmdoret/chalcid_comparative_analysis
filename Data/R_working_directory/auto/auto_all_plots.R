setwd("/home/cyril/Documents/Internship/Data/R_working_directory/auto/")

auto_processed = processed <-read.table("auto_processed_data.csv", header = T, sep= ",")

# Graphical representations:
library(ggplot2)
library(gridExtra)
#================================================================
# Overall
#------------------------------------------------------------------------------

#-----------------------------------------------------------------------------
# Number of hosts distribution sex vs asex
ggplot()+
  geom_histogram(data=processed[processed$mode=="asex",],aes(x=host_spp, stat=..count..,fill='Asexual'),alpha=0.3,bins=23)+
  geom_histogram(data=processed[processed$mode=="sex",],aes(x=host_spp, y=-..count..,fill='Sexual'),alpha=0.3,bins=25)+
  coord_cartesian(ylim=c(-30,30))+
  ggtitle("Distribution of the number of host species")

# Informations on hosts:
  #Number of different values for host number for each mode:
length(levels(as.factor(processed[processed$mode=="asex" & processed$host_spp!=0,"host_spp"])))
length(levels(as.factor(processed[processed$mode=="sex" & processed$host_spp!=0,"host_spp"])))
  # Maximal number of host recorded for both modes: 
max(processed[processed$mode=="sex","host_spp"],na.rm = T)
max(processed[processed$mode=="asex","host_spp"],na.rm = T)

# With log transform 
# Note: I ADDED +1 TO AVOID INFINITE, NOT SURE IT IS OK (doesn't seem to change much)
ggplot()+
  geom_histogram(data=processed[processed$mode=="asex" & processed$host_spp!=0,],aes(x=log2(host_spp), stat=log2(..count..),fill='Asexual')
                 ,alpha=0.3,bins=25)+
  geom_histogram(data=processed[processed$mode=="sex" & processed$host_spp!=0,],aes(x=log2(host_spp), y=-log2(..count..+1),fill='Sexual')
                 ,alpha=0.3,bins=25)+
  coord_cartesian(ylim=c(-30,30))


boxplot(log10(auto_processed$nbr_country[auto_processed$nbr_country>0 & auto_processed$mode!="both"])~droplevels(auto_processed$mode[auto_processed$nbr_country>0 & auto_processed$mode!="both"]),
        main="Number of countries by \nreproductive mode: Overall", ylab="Log countries",  names = c(
          paste0("Asex: n=",length(auto_processed$nbr_country[auto_processed$nbr_country>0 & auto_processed$mode=="asex"])),
          paste0("Sex: n=",length(auto_processed$nbr_country[auto_processed$nbr_country>0 & auto_processed$mode=="sex"]))))
#------------------------------------------------------------------------------
# Distance from equator, sex vs asex

max_equ <-ggplot()+
  geom_boxplot(data = processed[!is.na(processed$mode),],aes(x=mode,y=pmax(abs(lat_max),abs(lat_min))))+
  ggtitle("Maximum absolute distance from the equator")+
  labs(x="Reproduction mode",y="Absolute latitude")+
  annotate(x = c(1,2),y=c(10,10),geom= "text", label=c(paste0("n=",length(processed[processed$mode=="asex","lat_max"])),
                                                       paste0("n=",length(processed[processed$mode=="sex","lat_max"]))))
min_equ <-ggplot()+
  geom_boxplot(data = processed[!is.na(processed$mode),],aes(x=mode,y=pmin(abs(lat_max),abs(lat_min))))+
  ggtitle("Minimum absolute distance from the equator")+
  labs(x="Reproduction mode",y="Absolute latitude")+
  annotate(x = c(1,2),y=c(10,10),geom= "text", label=c(paste0("n=",length(processed[processed$mode=="asex","lat_max"])),
                                                       paste0("n=",length(processed[processed$mode=="sex","lat_max"]))))

mean_equ <-ggplot()+
  geom_boxplot(data = processed[!is.na(processed$mode),],aes(x=mode,y=abs(lat_mean)))+
  ggtitle("Mean absolute distance from the equator")+
  labs(x="Reproduction mode",y="Absolute latitude")+
  annotate(x = c(1,2),y=c(10,10),geom= "text", label=c(paste0("n=",length(processed[processed$mode=="asex","lat_max"])),
                                                       paste0("n=",length(processed[processed$mode=="sex","lat_max"]))))

median_equ <-ggplot()+
  geom_boxplot(data = processed[!is.na(processed$mode),],aes(x=mode,y=abs(lat_median)))+
  ggtitle("Median absolute distance from the equator")+
  labs(x="Reproduction mode",y="Absolute latitude")+
  annotate(x = c(1,2),y=c(10,10),geom= "text", label=c(paste0("n=",length(processed[processed$mode=="asex","lat_max"])),
                                                       paste0("n=",length(processed[processed$mode=="sex","lat_max"]))))

grid.arrange(min_equ, max_equ, mean_equ, median_equ)

#==============================================================================
#Same plots per family

#Number of hosts per family:
par(mfrow=c(3,4))
for(i in levels(processed_host$family))
{
  per_fam <- processed[processed$family == i,]
  boxplot(per_fam[,"host_spp"]~per_fam$mode,main=paste(i,  length(per_fam[!is.na(per_fam$host_spp),"species"]), sep=': '), 
          names=c(paste0("Asex, n=", length(per_fam[per_fam$mode=="asex" & !is.na(per_fam$host_spp),"species"])),
                  paste0("Sex, n=",length(per_fam[per_fam$mode=="sex" & !is.na(per_fam$host_spp),"species"]))))
}

# After removing zero's:
par(mfrow=c(3,4))
for(i in levels(processed$family))
{
  per_fam <- processed[processed$family == i & processed$host_spp>0,]
  boxplot(per_fam[,"host_spp"]~per_fam$mode,main=paste(i,  length(per_fam[!is.na(per_fam$host_spp),"species"]), sep=': '), 
          names=c(paste0("Asex, n=", length(per_fam[per_fam$mode=="asex" & !is.na(per_fam$host_spp),"species"])),
                  paste0("Sex, n=",length(per_fam[per_fam$mode=="sex" & !is.na(per_fam$host_spp),"species"]))))
}

# Plotting ratios of medians per family for number of host species:
# Note: Changing the threshold of minimum number of host species can be interesting
spp_ratio_fam <- c()
for(i in levels(processed$family))
{
  ratio <- median(processed$host_spp[processed$family == i & processed$mode=='asex' & processed$host_spp>0])/
    median(processed$host_spp[processed$family == i & processed$mode=='sex'& processed$host_spp>0])
  spp_ratio_fam <- append(spp_ratio_fam,ratio)
}
boxplot(spp_ratio_fam)
summary(spp_ratio_fam)
# Same operation for geographic data:

max_lat_ratio_fam <- c()
for(i in levels(processed$family)){
  processed_fam <-processed[processed$family==i,]
  ratio <- median(abs(processed_fam$lat_max[processed_fam$mode=='asex']))/median(abs(processed_fam$lat_max[processed_fam$mode=='sex' & processed_fam$nbr_country>0]))
  max_lat_ratio_fam <- append(max_lat_ratio_fam,ratio)
}
ggplot()+
  geom_point(aes(x=1,y=max_lat_ratio_fam))+
  labs(title="Ration of maximum absolute latitude between reproduction modes per family",y="Ratio")+
  theme_bw()

#------------------------------------------------------------------------------------------------------

min_lat_ratio_fam <- c()
for(i in levels(processed$family)){
  processed_fam <-processed[processed$family==i,]
  ratio <- median(abs(processed_fam$lat_min[processed_fam$mode=='asex']))/median(abs(processed_fam$lat_min[processed_fam$mode=='sex' & processed_fam$nbr_country>0]))
  min_lat_ratio_fam <- append(min_lat_ratio_fam,ratio)
}
ggplot()+
  geom_point(aes(x=1,y=min_lat_ratio_fam))+
  labs(title="Ration of minimum absolute latitude between reproduction modes per family",y="Ratio")+
  theme_bw()

#-------------------------------------------------------------------------------------------------------

mean_lat_ratio_fam <- c()
for(i in levels(processed$family)){
  processed_fam <-processed[processed$family==i,]
  ratio <- mean(processed_fam$lat_mean[processed_fam$mode=='asex'])/mean(processed_fam$lat_mean[processed_fam$mode=='sex' & processed_fam$nbr_country>0])
  mean_lat_ratio_fam <- append(mean_lat_ratio_fam,ratio)
}
ggplot()+
  geom_point(aes(x=1,y=mean_lat_ratio_fam))+
  labs(title="Ration of mean latitude between reproduction modes per family",y="Ratio")+
  theme_bw()

#-----------------------------------------------------------------------------

median_lat_ratio_fam <- c()
for(i in levels(processed$family)){
  processed_fam <-processed[processed$family==i,]
  ratio <- median(processed_fam$lat_median[processed_fam$mode=='asex'])/median(processed_fam$lat_median[processed_fam$mode=='sex' & processed_fam$nbr_country>0])
  median_lat_ratio_fam <- append(median_lat_ratio_fam,ratio)
}
ggplot()+
  geom_point(aes(x=1,y=median_lat_ratio_fam))+
  labs(title="Ration of median latitude between reproduction modes per family",y="Ratio")+
  theme_bw()

# Distribution


boxplot(aphel[,"number_loc"]~aphel$mode,main="Aphelinidae: Number of host species")
text(x = c(1,2),y=c(0.9,0.9),labels=c(paste0("n=",length(aphel[aphel$mode=="asex" & !is.na(aphel$number_loc),"lat_max"])),
                                      paste0("n=",length(aphel[aphel$mode=="sex" & !is.na(aphel$number_loc),"lat_max"]))))

boxplot(torym[,"number_loc"]~torym$mode,main="Torymidae: Number of species")
text(x = c(1,2),y=c(2.7,2.7),labels=c(paste0("n=",length(torym[torym$mode=="asex" & !is.na(torym$number_loc),"lat_max"])),
                                      paste0("n=",length(torym[torym$mode=="sex" & !is.na(torym$number_loc),"lat_max"]))))

boxplot(tricho[,"number_loc"]~tricho$mode,main="Trichogrammatidae: Number of host species")
text(x = c(1,2),y=c(0.4,0.4),labels=c(paste0("n=",length(tricho[tricho$mode=="asex" & !is.na(tricho$number_loc),"lat_max"])),
                                      paste0("n=",length(tricho[tricho$mode=="sex" & !is.na(tricho$number_loc),"lat_max"]))))

#=============================================================================
# Per genus:

# Latitude range
par(mfrow=c(4,4))
latrange_diff <- c()
latrange_ratio <- c()
genname <- c()
for(i in levels(auto_processed$genus))
{
  genus_df <- auto_processed[auto_processed$genus==i & auto_processed$mode!="both",]
  genus_df$mode <- factor(genus_df$mode)
  if(length(genus_df$nbr_country[genus_df$nbr_country>1 & genus_df$mode =="asex"])>0 & length(genus_df$nbr_country[genus_df$nbr_country>1 & genus_df$mode =="sex"])>0)
  {
    my_names <-c(as.character(paste0("n=",length(genus_df[genus_df$mode=="asex" & !is.na(genus_df$nbr_country),"lat_max"]))),
                 as.character(paste0("n=",length(genus_df[genus_df$mode=="sex" & !is.na(genus_df$nbr_country),"lat_max"]))))
    diff <-genus_df[genus_df$nbr_country>1,"lat_max"]-genus_df[genus_df$nbr_country>1,"lat_min"]
    sexdiff <-genus_df[genus_df$mode=='sex' & genus_df$nbr_country>1,"lat_max"]-genus_df[genus_df$mode=='sex' & genus_df$nbr_country>1,"lat_min"]
    asexdiff <-genus_df[genus_df$mode=='asex' & genus_df$nbr_country>1,"lat_max"]-genus_df[genus_df$mode=='asex' & genus_df$nbr_country>1,"lat_min"]
    latrange_ratio <- append(latrange_ratio,median(asexdiff,na.rm = T)/median(sexdiff,na.rm = T))
    latrange_diff <- append(latrange_diff,median(asexdiff,na.rm = T)-median(sexdiff,na.rm = T))
    genname<- append(genname,i)
    boxplot(diff~genus_df$mode[genus_df$nbr_country>1],main=paste(i, "Latitude range", sep=":"),names = c(paste('asex',my_names[1],sep=': '),paste('sex',my_names[2],sep=': ')))
  }
}


# df with asex-sex latranges I used diffferences instead of ratios because many values are close or == 0
df_latrange_diff <-data.frame(latrange_diff, genname)
df_latrange_ratio <-data.frame(latrange_ratio, genname)
library(lattice)
dotplot(df_latrange_diff$latrange_diff,main="Difference of lattitude range between asex and sex per genus")
dotplot(log(df_latrange_ratio$latrange_ratio),main="Log ratio of lattitude ranges between asex and sex per genus")
#-----------------------------------------------------------------------------
#Number of hosts

par(mfrow=c(4,3))
host_ratio <- c()
for(i in levels(auto_processed$genus))
{
  genus_df <- auto_processed[auto_processed$genus==i & auto_processed$mode!="both",]
  genus_df <- subset(genus_df,subset = genus_df$host_spp>0)
  genus_df$mode <- factor(genus_df$mode)
  if(length(genus_df$nbr_country[genus_df$host_spp>0 & genus_df$mode =="asex"])>0 & length(genus_df$nbr_country[genus_df$host_spp>0 & genus_df$mode =="sex"])>0)
  {
    tmp_ratio <- median(genus_df$host_spp[genus_df$host_spp>0 & genus_df$mode=='asex'])/median(genus_df$host_spp[genus_df$host_spp>0 & genus_df$mode=='sex'])
    host_ratio <- append(host_ratio,tmp_ratio)
    my_names <-c(as.character(paste0("n=",length(genus_df[genus_df$mode=="asex" & !is.na(genus_df$host_spp),"lat_max"]))),
                 as.character(paste0("n=",length(genus_df[genus_df$mode=="sex" & !is.na(genus_df$host_spp),"lat_max"]))))
    boxplot(genus_df$host_spp[genus_df$host_spp>0]~genus_df$mode[genus_df$host_spp>0],main=paste(i, "Latitude range", sep=":"),names = c(paste('asex',my_names[1],sep=': '),paste('sex',my_names[2],sep=': ')))
  }
}

dotplot(log10(host_ratio), main="Log ratio (sex/asex) of number of host species",xlab='Log ratio',panel=function(x, ...){
  panel.dotplot(x, ...)
  panel.abline(v=0)})

plot(1:length(host_ratio),log10(host_ratio), main="Log ratio (sex/asex) of number of host species",xlab='genera')
abline(h=0)


plot(1:length(host_ratio),sort(log10(host_ratio)), main="Log ratio (sex/asex) of number of host species",xlab='genera')
abline(h=0)

#NUmber of locations:
par(mfrow=c(4,3))
loc_ratio <- c()
for(i in levels(auto_processed$genus))
{
  genus_df <- auto_processed[auto_processed$genus==i & auto_processed$mode!="both",]
  genus_df <- subset(genus_df,subset = genus_df$nbr_country>0)
  genus_df$mode <- factor(genus_df$mode)
  if(length(genus_df$nbr_country[genus_df$nbr_country>0 & genus_df$mode =="asex"])>0 & length(genus_df$nbr_country[genus_df$nbr_country>0 & genus_df$mode =="sex"])>0)
  {
    tmp_ratio <- median(genus_df$nbr_country[genus_df$nbr_country>0 & genus_df$mode=='asex'])/median(genus_df$nbr_country[genus_df$nbr_country>0 & genus_df$mode=='sex'])
    loc_ratio <- append(loc_ratio,tmp_ratio)
    my_names <-c(as.character(paste0("n=",length(genus_df[genus_df$mode=="asex" & !is.na(genus_df$nbr_country),"lat_max"]))),
                 as.character(paste0("n=",length(genus_df[genus_df$mode=="sex" & !is.na(genus_df$nbr_country),"lat_max"]))))
    boxplot(genus_df$nbr_country[genus_df$nbr_country>0]~genus_df$mode[genus_df$nbr_country>0],main=paste(i, "Number of countries", sep=":"),names = c(paste('asex',my_names[1],sep=': '),paste('sex',my_names[2],sep=': ')))
  }
}
dotplot(log(loc_ratio), main="Log ratio (sex/asex) of number of locations",xlab='Log ratio')

par(mar=c(4,7,2,1))
boxplot(log10(loc_ratio),log10(df_ratio$country_ratio), 
        main="Ratio of number of locations: asex/sex",xlab='Log ratio',names=c("Auto \n(per genus)","Manual \n(per pair)"),horizontal = T,las=2)


#median latitude
par(mfrow=c(4,3))
medlat_ratio <- c()
for(i in levels(auto_processed$genus))
{
  genus_df <- auto_processed[auto_processed$genus==i & auto_processed$mode!="both",]
  genus_df <- subset(genus_df,subset = genus_df$nbr_country>0)
  genus_df$mode <- factor(genus_df$mode)
  if(length(genus_df$nbr_country[genus_df$nbr_country>0 & genus_df$mode =="asex"])>0 & length(genus_df$nbr_country[genus_df$nbr_country>0 & genus_df$mode =="sex"])>0)
  {
    tmp_ratio <- median(genus_df$lat_median[genus_df$nbr_country>0 & genus_df$mode=='asex'])/median(genus_df$lat_median[genus_df$nbr_country>0 & genus_df$mode=='sex'])
    medlat_ratio <- append(medlat_ratio,tmp_ratio)
    my_names <-c(as.character(paste0("n=",length(genus_df[genus_df$mode=="asex" & !is.na(genus_df$nbr_country),"lat_max"]))),
                 as.character(paste0("n=",length(genus_df[genus_df$mode=="sex" & !is.na(genus_df$nbr_country),"lat_max"]))))
    boxplot(genus_df$lat_median[genus_df$nbr_country>0]~genus_df$mode[genus_df$nbr_country>0],main=paste(i, "Median latitude", sep=":"),names = c(paste('asex',my_names[1],sep=': '),paste('sex',my_names[2],sep=': ')))
  }
}
densityplot(log(medlat_ratio), main="Log ratio (sex/asex) of median latitude",xlab='Log ratio')

#-----------------------------------------------------------------------------
# Distribution

#=============================================================================
