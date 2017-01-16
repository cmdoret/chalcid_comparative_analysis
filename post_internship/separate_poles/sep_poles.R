rm(list=ls()); library(permute); library(nlme); library(lme4);library(parallel)
data0 <- read.csv("~/Documents/Internship/Data/R_working_directory/auto/auto_processed_data.csv", header=T)
#data0 <- read.csv("~/Documents/Internship/chalcid_comparative_analysis/Data/R_working_directory/auto/auto_processed_data.csv", header=T)
citat <-read.csv("~/Dropbox/Cyril-Casper_shared/Internship_tidy/Data/auto/auto_citations_per_species.csv", header=T)
data <- merge(x=data0, y=citat, by.x=c("family","genus","species"), by.y=c("family","genus","species"), all=F)
data <- data[!data$nbr_country =="0",] #remove species with no countries described
data <- data[!data$host_spp =="0",] # remove species with no hosts described

#data2 <- data[data$ref>2,]
#data<-data2
data$max_dist_eq <- pmax(abs(data$lat_min),abs(data$lat_max))
#data <- data[(data$lat_max*data$lat_min)>0,]
data$hemi <- rep(0,nrow(data))
data$hemi[data$lat_min > 0] <- "N"
data$hemi[data$lat_max < 0] <- "S"

mindist <- function(myrow){
  Min = as.numeric(myrow[5])
  Max = as.numeric(myrow[7])
  if((Max*Min) > 0){
    min_dist_eq <- pmin(abs(Min),abs(Max))
  } else{
    min_dist_eq <- 0
  }
  return(min_dist_eq)
}

data$lat_range <- abs(data$lat_max-data$lat_min)
data$lat_range[data$lat_range == 0] <- 0.001
tmp_mindist<- apply(data,MARGIN = 1,FUN = mindist)
data$min_dist_eq <- unname(tmp_mindist)

# ==========================

# Only 2 asexual species are exclusively sampled in the southern hemisphere.
# Not relevant to analyze species separately for both hemispheres (2 species won't give enough info) 
# Moreover, the have only been sampled once and twice, respectively.

#data[data$hemi=="S" & data$mode =="asex",]

#===============================

# Computing shift for max, min distance to equator and latitude range

# RESULTS WITH cutoff=2
#!!!!CAREFUL!!!! RESULTS DESCRIBED IN COMMENTS OBTAINED AFTER USING data[(data$lat_max*data$lat_min)>0,]
# MEANING ALL SPECIES OCCURING ACROSS THE EQUATOR HAVE BEEN REMOVED. UNCOMMENT LINES 9-12 TO REPRODUCE THESE RESULTS

# Ratios method

shift_max <- mean(data$max_dist_eq[data$mode=="asex"])/mean(data$max_dist_eq[data$mode=="sex"])
shift_min <- mean(data$min_dist_eq[data$mode=="asex"])/mean(data$min_dist_eq[data$mode=="sex"])
shift_range <- mean(data$lat_range[data$mode=="asex"])/mean(data$lat_range[data$mode=="sex"])

# Difference method

shift_max <- mean(data$max_dist_eq[data$mode=="asex"])- mean(data$max_dist_eq[data$mode=="sex"])
shift_min <- mean(data$min_dist_eq[data$mode=="asex"]) - mean(data$min_dist_eq[data$mode=="sex"]) 
shift_range <- mean(data$lat_range[data$mode=="asex"]) - mean(data$lat_range[data$mode=="sex"])

# max_dist_eq shift is positive (+18.6% [ratio] or +8.26° [difference]) -> asexual distribution shifted towards poles
# min_dist_eq shift is slightly negative (-6.7% [ratio] or -2.05° [difference]) -> asexual distribution slightly expands towards equator
# lat_range shift is highly positive (+73% [ratio] or 10.32° [difference]) -> asexual have a larger latitude range.

# Since 1° of latitude equals 111km -> Maxima of asexual distribution is shifted by 917.27km towards poles and minima by 227.833km towards equator, 
# on average over all species in the auto dataset. Latitude range increases by 1145.077km for asexual on average.

#===============================
# TESTING SENSITIVITY OF RESULTS AT DIFFERENT CUTOFFS
# Ratio

rat_sensi_shift <- data.frame(cutoff=seq(0,20))
namevec <- c(min_dist_eq="shift_min",max_dist_eq="shift_max",lat_range="shift_range")
for(cut in 0:20){
  for(p in c("min_dist_eq","max_dist_eq","lat_range")){
    rat_sensi_shift[(cut+1),namevec[p]] <- mean(data[data$mode=="asex" & data$ref>cut,p])/mean(data[data$mode=="sex" & data$ref>cut,p])
  }
}

# Difference (in km)

dif_sensi_shift <- data.frame(cutoff=seq(0,20))
namevec <- c(min_dist_eq="shift_min",max_dist_eq="shift_max",lat_range="shift_range")
for(cut in 0:20){
  for(p in c("min_dist_eq","max_dist_eq","lat_range")){
    dif_sensi_shift[(cut+1),namevec[p]] <- (mean(data[data$mode=="asex" & data$ref>cut,p])-mean(data[data$mode=="sex" & data$ref>cut,p]))*111
  }
}
par(mfrow=c(1,2))
plot(rat_sensi_shift$cutoff,rat_sensi_shift$shift_min,type="l",col="blue",ylim=c(-1,3),
     main="Ratios comparisons",xlab="reference cutoff",ylab="ratio of mean asex/sex")
points(rat_sensi_shift$cutoff,rat_sensi_shift$shift_max,type = "l",col="red")
points(rat_sensi_shift$cutoff,rat_sensi_shift$shift_range,type = "l",col="green")
abline(h=1,col="black",lty=2)
legend("bottomleft",legend=c("min distance from equator","max distance from equator","latitude range"),fill = c("blue","red","green"))
plot(dif_sensi_shift$cutoff,dif_sensi_shift$shift_min,type="l",col="blue",ylim=c(-5000,5000),
     main="Differences comparisons",xlab="reference cutoff",ylab="km difference of mean asex-sex")
points(dif_sensi_shift$cutoff,dif_sensi_shift$shift_max,type = "l",col="red")
points(dif_sensi_shift$cutoff,dif_sensi_shift$shift_range,type = "l",col="green")
abline(h=0,col="black",lty=2)
legend("bottomleft",legend=c("min distance from equator","max distance from equator","latitude range"),fill = c("blue","red","green"))

# Side note: Depending on if I exclude or include species occuring at equator, results are dramatically different -> need to think about it and what is the best approach.
# probably caused by 0.

#######################################33
# Trying to compute shift separately in each genus. Using difference, as ratio will result in infinite when dist_min=0 for sex

genus_shift <- data.frame(ref=rep(0:20,each=length(levels(data$genus))),
                          genus = levels(data$genus),min_shift=rep(0),max_shift=rep(0),range_shift=rep(0))

for(cut in 0:20){
  for(g in levels(data$genus)){
    if(length(levels(data[data$genus==g,"mode"]))==2){
      genus_shift[genus_shift$genus==g & genus_shift$ref==cut,3] <-(mean(data[data$mode=="asex" & data$genus==g & data$ref>cut,"min_dist_eq"])-
                                                          mean(data[data$mode=="sex" & data$genus==g & data$ref>cut,"min_dist_eq"]))*111
      genus_shift[genus_shift$genus==g & genus_shift$ref==cut,4] <-(mean(data[data$mode=="asex" & data$genus==g & data$ref>cut,"max_dist_eq"])-
                                                          mean(data[data$mode=="sex" & data$genus==g & data$ref>cut,"max_dist_eq"]))*111
      genus_shift[genus_shift$genus==g & genus_shift$ref==cut,5] <-(mean(data[data$mode=="asex" & data$genus==g & data$ref>cut,"lat_range"])-
                                                          mean(data[data$mode=="sex" & data$genus==g & data$ref>cut,"lat_range"]))*111
    }else{
      genus_shift[genus_shift$genus==g & genus_shift$ref==cut,3:5] <- NA
    }
  }
}

plot(genus_shift)  # plotting pairs of variable reveals interesting patterns

par(mfrow=c(3,3))
for(c in seq(1,18,2)){
  boxplot(genus_shift$min_shift[genus_shift$ref==c],genus_shift$max_shift[genus_shift$ref==c],genus_shift$range_shift[genus_shift$ref==c],names=c("min distance to eq shift","max distance to eq shift","latitude range shift"),
          ylab="km shift",main=paste0("Shift at cutoff=",c," (asex-sex)"))
  abline(h=0,lty=2,col="blue")
  
}

par(mfrow=c(1,3))
qqnorm(genus_shift$min_shift);qqline(genus_shift$min_shift)
qqnorm(genus_shift$max_shift);qqline(genus_shift$max_shift)
qqnorm(genus_shift$range_shift);qqline(genus_shift$range_shift)

# OK for normal distribution
# Testing if shifts significantly differ from 0 (i.e. if there is actually a shift between sex and asex)
sigshift <- data.frame(ref=seq(0,20),pmin=NA,pmax=NA,prange=NA)
for(c in seq(0,20)){
  sigshift[c+1,2]<-t.test(genus_shift$min_shift[genus_shift$ref==c])$p.val  # t=-7.2, p=-2.4e-12
  sigshift[c+1,3]<-t.test(genus_shift$max_shift[genus_shift$ref==c])$p.val  # 12.442, p=2.2e-16
  sigshift[c+1,4]<-t.test(genus_shift$range_shift[genus_shift$ref==c])$p.val  # t=13.702, p=2.2e-16
}
plot(sigshift$ref,sigshift$pmin,type="l",col="blue",main="P-value of shifts (H0: mean shift=0) vs reference cutoff",
     xlab="reference cutoff",ylab="p-value",ylim=c(0,1))
points(sigshift$ref,sigshift$pmax,type = "l",col="red")
points(sigshift$ref,sigshift$prange,type = "l",col="green")
abline(h=0.05,col="black",lty=2)

# Shift for min_dist_eq (i.e. shift towards equator) quickly loses statistical significance when increasing the reference cutoff

# same with t-statistic

strshift <- data.frame(ref=seq(0,20),tmin=NA,tmax=NA,trange=NA)
for(c in seq(0,20)){
  strshift[c+1,2]<-t.test(genus_shift$min_shift[genus_shift$ref==c])$statistic  # t=-7.2, p=-2.4e-12
  strshift[c+1,3]<-t.test(genus_shift$max_shift[genus_shift$ref==c])$statistic  # 12.442, p=2.2e-16
  strshift[c+1,4]<-t.test(genus_shift$range_shift[genus_shift$ref==c])$statistic  # t=13.702, p=2.2e-16
}
plot(strshift$ref,abs(strshift$tmin),type="l",col="blue",main="t-stat of shifts (H0: mean shift=0) vs reference cutoff",
     xlab="reference cutoff",ylab="absolute t-statistic",ylim=c(0,8))  # Using absolute statistic for better visual comparison between shift strength
points(strshift$ref,strshift$tmax,type = "l",col="red")
points(strshift$ref,strshift$trange,type = "l",col="green")



# According to the t-test, the strongest shift would be increased latitude range for asex, followed by shift towards poles, 
# and the weakest shift is the shift towards equator

######################################################

# Conclusion:

# Depending on the method used, the resutls can differ a lot.