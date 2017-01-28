# In this script I visualize the output of the permutation glmm.
# Cyril Matthey-Doret
# Fri Jan 20 17:50:49 2017 ------------------------------

# Loading data and libraries
library(ggplot2)
setwd("Dropbox/Cyril-Casper_shared/post_internship/final_perm_scripts/")
auto_data <- read.csv("auto_data.csv",header=T)
manual_data <- read.csv("manual_data.csv",header=T)
out_auto <- read.csv("output/out_auto.csv",header=T)
out_manual <- read.csv("output/out_manual.csv",header=T)
out_auto <- out_auto[out_auto$ref>=0,]

# Auto: number of species vs references cutoff
auto_size <- data.frame(cutoff=seq(0,20),size=rep(0,21),n_asex=rep(0,21))
for(c in seq(0,20)){auto_size$size[c+1] <- nrow(auto_data[auto_data$ref>c,])
  auto_size$n_asex[c+1] <- nrow(auto_data[auto_data$ref>c & auto_data$mode=="asex",])
}
barplot(auto_size$size,names=auto_size$cutoff,xlab="More than n references",ylab="Number of species")
abline(h=118,lty=2,col="red")  # Number of species in manual dataset

# Model p-values vs reference cutoff
ggplot(data=out_auto,aes(x=ref,y=pval2T,col=var))+
  #facet_grid(~var)+
  geom_line()+
  geom_line(aes(y=0.05),col="red",lty=2)+xlab("Reference cutoff")+ylab("p-value")+theme_minimal()

ggplot(data=out_auto,aes(x=ref,y=z,col=var))+
  #facet_grid(~var)+
  geom_line()+
  geom_line(aes(y=0),col="red",lty=2)+xlab("Reference cutoff")+ylab("z-value")+theme_bw()

###############
# looking at maximum reference cutoff at which each variable retain significance.
for(l in levels(out_auto$var)){
  max_ref <- max(out_auto$ref[out_auto$var==l & out_auto$pval2T<0.05])
  sample <- auto_size$size[auto_size$cutoff==max_ref]
  asex <- auto_size$n_asex[auto_size$cutoff==max_ref]
  print(paste(l,": ", max_ref, " (",sample, " species left, ",asex," asex)"))
}
# 3 groups of variables when looking at p-values: 
#  mean and median latitude losing significance at cutoff 5 and 6 respectively
# lat_range, min and max distance from equator lose significance between cutoffs of 12 and 13 references.
# number of hosts and countries do not lose significance until maximum cutoff of 20 references.
# For z-values note the median and mean latitude are inverted as we increase cutoff. (direction differs between genera)

########

