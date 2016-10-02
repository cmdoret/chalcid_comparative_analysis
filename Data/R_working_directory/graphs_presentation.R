auto_processed <-read.csv("/home/cyril/Documents/Internship/Data/R_working_directory/auto/auto_processed_data.csv", header = T)
manual_processed <-read.csv("/home/cyril/Documents/Internship/Data/R_working_directory/manual/manual_processed_data.csv", header = T)
manual_processed <- manual_processed[manual_processed$mode!="both" & mydf$pair!=0,]
manual_processed$mode <- droplevels(manual_processed$mode)
manual_processed <- manual_processed[complete.cases(manual_processed[,1:4]),]
library(ggplot2)
library(gridExtra)
library(lattice)



body_length <- rowMeans(cbind(manual_processed$min_length,manual_processed$max_length))
manual_processed <- cbind(manual_processed, body_length)
boxplot(manual_processed$body_length~manual_processed$mode)

par(mfrow=c(4,3))
host_ratio <- c()
for(i in levels(manual_processed$genus)[-c(7,9)])
{
  genus_df <- manual_processed[manual_processed$genus==i & manual_processed$mode!="both",]
  genus_df$mode <- factor(genus_df$mode)
  boxplot(genus_df[,"nbr_host_spp"]~genus_df$mode,main=paste(i, "Host species", sep=":"))
  text(x = c(1.1,2.1),y=c(mean(na.rm=T,genus_df$nbr_host_spp[genus_df$mode=="asex"])*1.1,
                          mean(na.rm=T,genus_df$nbr_host_spp[genus_df$mode=="sex"])*1.1),
       labels=c(paste0("n=",length(genus_df[genus_df$mode=="asex" & !is.na(genus_df$nbr_host_spp),"lat_max"])),
                paste0("n=",length(genus_df[genus_df$mode=="sex" & !is.na(genus_df$nbr_host_spp),"lat_max"]))))
  host_ratio <- append(host_ratio,)
}
dotplot(host_ratio)

par(mfrow=c(2,4))
latrange_diff <- c()
latrange_ratio <- c()
genname <- c()
for(i in levels(manual_processed$genus))
{
  gen_df <- manual_processed[manual_processed$genus==i & manual_processed$mode!="both",]
  gen_df <- subset(gen_df,subset = gen_df$nbr_country>0)
  gen_df$mode <- factor(gen_df$mode)
  if(length(gen_df$nbr_country[gen_df$nbr_country>0 & gen_df$mode =="asex"])>0 & length(gen_df$nbr_country[gen_df$nbr_country>0 & gen_df$mode =="sex"])>0)
  {
    my_names <-c(as.character(paste0("n=",length(gen_df[gen_df$mode=="asex" & !is.na(gen_df$nbr_country),"lat_max"]))),
                 as.character(paste0("n=",length(gen_df[gen_df$mode=="sex" & !is.na(gen_df$nbr_country),"lat_max"]))))
    diff <- gen_df[gen_df$nbr_country>0,"lat_max"]-gen_df[gen_df$nbr_country>0,"lat_min"]
    sexdiff <-gen_df[gen_df$mode=='sex' & gen_df$nbr_country>1,"lat_max"]-gen_df[gen_df$mode=='sex' & gen_df$nbr_country>1,"lat_min"]
    asexdiff <-gen_df[gen_df$mode=='asex' & gen_df$nbr_country>1,"lat_max"]-gen_df[gen_df$mode=='asex' & gen_df$nbr_country>1,"lat_min"]
    latrange_ratio <- append(latrange_ratio,median(asexdiff,na.rm = T)/median(sexdiff,na.rm = T))
    latrange_diff <- append(latrange_diff,median(asexdiff,na.rm = T)-median(sexdiff,na.rm = T))
    genname<- append(genname,i)
    #boxplot(diff~gen_df$mode[gen_df$nbr_country>0],main=paste(i, "Latitude range", sep=":"),
    #names = c(paste('asex',my_names[1],sep=': '),paste('sex',my_names[2],sep=': ')))
  }
  
}
# df with asex-sex latranges I used diffferences instead of ratios because many values are close or == 0
df_latrange_diff <-data.frame(latrange_diff, genname)
df_latrange_ratio <-data.frame(latrange_ratio, genname)
library(lattice)
dotplot(df_latrange_diff$latrange_diff,
        main="Difference of latitude range between asex and sex per genus",
        xlab="Difference (asex-sex)")

dotplot(log(df_latrange_ratio$latrange_ratio),
        main="Log ratio of latitude ranges between asex and sex per genus", 
        xlab="Log ratio (log(asex/sex))")


#Slide 16,  pairs:

ggplot()+
  geom_boxplot(data = manual_processed[manual_processed$nbr_country>0 &
                                         !is.na(manual_processed$mode) & manual_processed$mode != "both",]
               ,aes(x = mode,y = log10(nbr_country)))+labs(x="Reproductive mode", y="Log number of countries")+
  annotate(x = c(1,2),y=c(1,1),geom= "text", label=c(paste0("n=",length(manual_processed[manual_processed$mode=="asex" & manual_processed$nbr_country>0,"lat_max"])),
                                                     paste0("n=",length(manual_processed[manual_processed$mode=="sex" & manual_processed$nbr_country>0,"lat_max"]))))+
  theme_bw()

ratios <- list(c(), c(), c(), c(), c())
for(i in 1:(length(levels(as.factor(manual_processed$pair)))-1))
{
  count <-1
  for(j in c("nbr_host_spp", "lat_max", "lat_min", "lat_mean", "lat_median"))
  {
    tmp_ratio <- mean(na.rm = T,manual_processed[manual_processed$mode=='asex' & manual_processed$pair==i,j])/
      mean(na.rm = T, manual_processed[manual_processed$mode=='sex' & manual_processed$pair==i,j])
    ratios[[count]] <- append(ratios[[count]], tmp_ratio)
    count <- count + 1
  }
}
df_ratio <- data.frame(ratios)
colnames(df_ratio)<-c("host_ratio","north_ratio", "south_ratio", "mean_ratio","median_ratio")

dotplot(log(df_ratio$host_ratio),xlab ="Log ratio",main="Number of host species: asex/sex in each pair")

par(mfrow=c(2,4))
latrange_diff <- c()
latrange_ratio <- c()
genname <- c()
for(i in 1:max(manual_processed$pair))
{
  pair_df <- manual_processed[manual_processed$pair==i & manual_processed$mode!="both",]
  pair_df <- subset(pair_df,subset = pair_df$nbr_country>0)
  pair_df$mode <- factor(pair_df$mode)
  if(length(pair_df$nbr_country[pair_df$nbr_country>1 & pair_df$mode =="asex"])>0 & length(pair_df$nbr_country[pair_df$nbr_country>1 & pair_df$mode =="sex"])>0)
  {
    my_names <-c(as.character(paste0("n=",length(pair_df[pair_df$mode=="asex" & !is.na(pair_df$nbr_country),"lat_max"]))),
                 as.character(paste0("n=",length(pair_df[pair_df$mode=="sex" & !is.na(pair_df$nbr_country),"lat_max"]))))
    diff <- pair_df[pair_df$nbr_country>0,"lat_max"]-pair_df[pair_df$nbr_country>0,"lat_min"]
    sexdiff <-pair_df[pair_df$mode=='sex' & pair_df$nbr_country>1,"lat_max"]-pair_df[pair_df$mode=='sex' & pair_df$nbr_country>1,"lat_min"]
    asexdiff <-pair_df[pair_df$mode=='asex' & pair_df$nbr_country>1,"lat_max"]-pair_df[pair_df$mode=='asex' & pair_df$nbr_country>1,"lat_min"]
    latrange_ratio <- append(latrange_ratio,median(asexdiff,na.rm = T)/median(sexdiff,na.rm = T))
    latrange_diff <- append(latrange_diff,median(asexdiff,na.rm = T)-median(sexdiff,na.rm = T))
    genname<- append(genname,i)
    boxplot(diff~pair_df$mode[pair_df$nbr_country>0],main=paste(i, "Latitude range", sep=":"),
            names = c(paste('asex',my_names[1],sep=': '),paste('sex',my_names[2],sep=': ')))
  }
  
}

# df with asex-sex latranges I used diffferences instead of ratios because many values are close or == 0
df_latrange_diff <-data.frame(latrange_diff, genname)
df_latrange_ratio <-data.frame(latrange_ratio, genname)
library(lattice)
densityplot(df_latrange_diff$latrange_diff,main="Difference of latitude range between asex and sex per pair",xlab="Difference (asex-sex)")

densityplot(log(df_latrange_ratio$latrange_ratio),main="Ratio of latitude range between asex and sex per pair",xlab="Log ratio (asex/sex)")
§par(mfrow=c(3,3))
densityplot(log2(df_ratio$host_ratio), main="Number of host per pair: asex/sex", xlab="Log ratio")



densityplot(log2(df_ratio$south_ratio), main="Ratio of min latitude per pair: asex/sex", xlab="Log ratio")

densityplot(log2(df_ratio$north_ratio), main="Ratio of max latitude per pair: asex/sex", xlab="Log ratio")

densityplot(log2(df_ratio$mean_lat_ratio), main="Ratio of mean latitude per pair: asex/sex", xlab="Log ratio")

densityplot(log2(df_ratio$median_lat_ratio), main="Ratio of median latitude per pair: asex/sex", xlab="Log ratio")

densityplot(log2(df_ratio$west_ratio), main="Ratio of min longitude per pair: asex/sex", xlab="Log ratio")

densityplot(log2(df_ratio$east_ratio), main="Ratio of max longitude per pair: asex/sex", xlab="Log ratio")

densityplot(log2(df_ratio$mean_lon_ratio), main="Ratio of mean longitude per pair: asex/sex", xlab="Log ratio")

densityplot(log2(df_ratio$median_lon_ratio), main="Ratio of median longitude per pair: asex/sex", xlab="Log ratio")

grid.arrange(nrow=4,
             dotplot(log10(abs(df_ratio$median_lat_ratio)),panel=function(x, ...){
               panel.dotplot(x, ...)
               panel.abline(v=0)
             }, main="Ratio of median distance from equator per pair: asex/sex", xlab="Log ratio"),
             dotplot(log10(df_latrange_ratio$latrange_ratio),panel=function(x, ...){
               panel.dotplot(x, ...)
               panel.abline(v=0)
             },main="Ratio of latitude ranges per pair: asex/sex",xlab="Log ratio"),
             dotplot(log10(df_ratio$min_dist_equ),panel=function(x, ...){
               panel.dotplot(x, ...)
               panel.abline(v=0)
             }, main="Ratio of minimum distance from the equator per pair: asex/sex", xlab="Log ratio"),
             dotplot(log10(df_ratio$max_dist_equ),panel=function(x, ...){
               panel.dotplot(x, ...)
               panel.abline(v=0)
             }, main="Ratio of maximum distance from equator: asex/sex", xlab="Log ratio"))


par(mar=c(4,7,2,1))
boxplot(log10(df_ratio$median_lat_ratio),
        log10(df_ratio$host_ratio),
        log10(df_latrange_ratio$latrange_ratio),
        log10(df_ratio$dist_equ), main="Log ratio per pair (asex/sex)",
        names=c("Median latitude", "Host species", "Latitude range", "Distance\n from equator"),horizontal = T,las=2)
abline(v=0)

# Per genus auto, slide 18: 

auto_ratios <- list(c(), c(), c(), c(), c(), c(), c(), c(), c(), c(), c(), c(), c())
var_cleaner <- auto_processed$host_spp>0 & auto_processed$nbr_country>0
for(i in levels(auto_processed$genus))
{
  count <-1
  for(j in c("nbr_country","host_spp", "lat_min", "lat_max", "lat_mean", "lat_median", "lon_min", "lon_max", "lon_mean", "lon_median","far_equ","close_equ", "lat_range"))
  {
    if(j!="close_equ" & j!="far_equ" & j!="lat_range")
    {
      tmp_ratio <- mean(na.rm = T,auto_processed[var_cleaner & auto_processed$mode=='asex' & auto_processed$genus==i,j])/
        mean(na.rm = T, auto_processed[var_cleaner & auto_processed$mode=='sex' & auto_processed$genus==i,j])
      auto_ratios[[count]] <- append(auto_ratios[[count]], tmp_ratio)
      count <- count + 1
    }
    if(j=="far_equ")
    {
      tmp_ratio <- mean(na.rm = T,pmax(abs(auto_processed[var_cleaner & auto_processed$mode=='asex' & auto_processed$genus==i,"lat_min"]),
                                       abs(auto_processed[var_cleaner & auto_processed$mode=='asex' & auto_processed$genus==i,"lat_max"])))/
        mean(na.rm = T, pmax(abs(auto_processed[var_cleaner & auto_processed$mode=='sex' & auto_processed$genus==i,"lat_min"]),
                             abs(auto_processed[var_cleaner & auto_processed$mode=='sex' & auto_processed$genus==i,"lat_max"])))
      auto_ratios[[count]] <- append(auto_ratios[[count]], tmp_ratio)
      count <- count + 1
    }
    if(j=="close_equ")
    {
      tmp_ratio <- mean(na.rm = T,pmin(abs(auto_processed[var_cleaner & auto_processed$mode=='asex' & auto_processed$genus==i,"lat_min"]),
                                       abs(auto_processed[var_cleaner & auto_processed$mode=='asex' & auto_processed$genus==i,"lat_max"])))/
        mean(na.rm = T, pmin(abs(auto_processed[var_cleaner & auto_processed$mode=='sex' & auto_processed$genus==i,"lat_min"]),
                             abs(auto_processed[var_cleaner & auto_processed$mode=='sex' & auto_processed$genus==i,"lat_max"])))
      auto_ratios[[count]] <- append(auto_ratios[[count]], tmp_ratio)
      count <- count + 1
    }
    if(j=="lat_range")
    {
      tmp_ratio <- mean(na.rm = T,auto_processed[var_cleaner & auto_processed$mode=='asex' & auto_processed$nbr_country>1 & auto_processed$genus==i,"lat_max"]-
                                  auto_processed[var_cleaner & auto_processed$mode=='asex' & auto_processed$nbr_country>1 & auto_processed$genus==i,"lat_min"])/
        mean(na.rm = T, auto_processed[var_cleaner & auto_processed$mode=='sex' & auto_processed$nbr_country>1 & auto_processed$genus==i,"lat_max"]-
                        auto_processed[var_cleaner & auto_processed$mode=='sex' & auto_processed$nbr_country>1 & auto_processed$genus==i,"lat_min"])
      auto_ratios[[count]] <- append(auto_ratios[[count]], tmp_ratio)
      count <- count + 1
    }
  }
}
auto_df_ratio <- data.frame(auto_ratios)
colnames(auto_df_ratio)<-c("nbr_country","host_ratio","south_ratio", "north_ratio", "mean_lat_ratio","median_lat_ratio","west_ratio", "east_ratio", "mean_lon_ratio", "median_lon_ratio","max_dist_equ","min_dist_equ", "lat_range")

grid.arrange(nrow=4,
             dotplot(log10(abs(auto_df_ratio$median_lat_ratio)),panel=function(x, ...){
               panel.dotplot(x, ...)
               panel.abline(v=0)
             }, main="Ratio of median distance from equator per genus: asex/sex", xlab="Log ratio"),
             dotplot(log10(auto_df_ratio$lat_range),panel=function(x, ...){
               panel.dotplot(x, ...)
               panel.abline(v=0)
             },main="Ratio of latitude ranges per genus: asex/sex",xlab="Log ratio"),
             dotplot(log10(auto_df_ratio$min_dist_equ),panel=function(x, ...){
               panel.dotplot(x, ...)
               panel.abline(v=0)
             }, main="Ratio of minimum distance from equator per genus: asex/sex", xlab="Log ratio"),
             dotplot(log10(auto_df_ratio$max_dist_equ),panel=function(x, ...){
               panel.dotplot(x, ...)
               panel.abline(v=0)
             }, main="Ratio of maximum distance from equator per genus: asex/sex", xlab="Log ratio"))


par(mfrow=c(3,3))

dotplot(log10(auto_df_ratio$nbr_country),panel=function(x, ...){
  panel.dotplot(x, ...)
  panel.abline(v=0)
}, main="Ratio of number of countries per genus: asex/sex", xlab="Log ratio")



par(mar=c(4,7,2,1))
boxplot(log10(auto_df_ratio$median_lat_ratio),
        log10(auto_df_ratio$host_ratio),
        log10(df_latrange_ratio$latrange_ratio),
        log10(auto_df_ratio$dist_equ), main="Log ratio per genus (asex/sex)",
        names=c("Median latitude", "Host species", "Latitude range", "Distance\n from equator"),horizontal = T,las=2)
abline(v=0)

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
  }
}



dotplot(log(host_ratio), main="Log ratio (asex/sex) per genus of number of host species",xlab='Log ratio')



par(mfrow=c(3,4))
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
dotplot(df_latrange_diff$latrange_diff,main="Difference of latitude range between asex and sex per genus",xlab="Difference (asex-sex)")


dotplot(log(df_latrange_ratio$latrange_ratio),main="Log ratio of latitude ranges between asex and sex per genus", xlab="Log ratio (log(asex/sex))")

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
manual_processed$mode <-droplevels(manual_processed$mode)
# Bias, manual vs auto
manual_processed <- manual_processed[manual_processed$mode!="both",]
manual_processed$mode <- droplevels(manual_processed$mode)
par(mfrow=c(2,2))
boxplot(log10(manual_processed$nbr_country[manual_processed$nbr_country>0])~manual_processed$mode[manual_processed$nbr_country>0], 
        main="Log number of countries: \nmanual dataset", 
        ylab="Log number of countries", 
        names=c(paste0("Asex, n=",length(manual_processed$nbr_country[manual_processed$nbr_country>0 & manual_processed$mode=="asex"]) ),
                paste0("Sex, n=", length(manual_processed$nbr_country[manual_processed$nbr_country>0 & manual_processed$mode=="sex"]))))
boxplot(log10(auto_processed$nbr_country[auto_processed$nbr_country>0])~auto_processed$mode[auto_processed$nbr_country>0], 
        main="Log number of countries: \nautomated dataset", 
        ylab="Log number of countries", 
        names=c(paste0("Asex, ", length(auto_processed$nbr_country[auto_processed$nbr_country>0 & auto_processed$mode=="asex"])),
                paste0("Sex, ", length(auto_processed$nbr_country[auto_processed$nbr_country>0 & auto_processed$mode=="sex"]))))
boxplot(log10(manual_processed$nbr_host_spp[manual_processed$nbr_host_spp>0])~manual_processed$mode[manual_processed$nbr_host_spp>0], 
        main="Log number of host species: \nmanual dataset", 
        ylab="Log number of host species", 
        names=c(paste0("Asex, ",length(manual_processed$nbr_host_spp[manual_processed$nbr_host_spp>0 & manual_processed$mode=="asex"])),
                paste0("Sex, ",length(manual_processed$nbr_host_spp[manual_processed$nbr_host_spp>0 & manual_processed$mode=="sex"]))))
boxplot(log10(auto_processed$host_spp[auto_processed$host_spp>0])~auto_processed$mode[auto_processed$host_spp>0], 
        main="Log number of host species: \nautomated dataset", 
        ylab="Log number of host species", 
        names=c(paste0("Asex, ", length(auto_processed$host_spp[auto_processed$host_spp>0 & auto_processed$mode=="asex"])),
                paste0("Sex, ", length(auto_processed$host_spp[auto_processed$host_spp>0 & auto_processed$mode=="sex"]))))

