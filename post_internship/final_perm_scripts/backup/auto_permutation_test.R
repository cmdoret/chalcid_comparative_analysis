rm(list=ls()); library(permute); library(nlme); library(lme4);library(parallel)
data <- read.csv("~/Dropbox/Cyril-Casper_shared/for_publication/auto_data_final.csv",header = T)
data <- data[!data$nbr_country ==0,] #remove species with no countries described


data2 <- data[data$ref>2,] # remove species very few studies
data<-data2

#Choose a variable
variable="min_dist_eq"

#fmla <- as.formula(paste(variable,"~ mode + (1|genus)",sep=" "))
#m_host <- glmer(fmla, data = data, family="poisson")
#z.obs <- coef(summary(m_host))[2, "t value"]


####################################################
# Randomize the mode (sex, asex) within a genus
n.genera <- length(levels(data$genus)) #number of genera
l.genus <- as.vector(table(data$genus)) #list w/ number of species per genus
nboot <- 100 #number of permutations

random_test <- function(x,y) {  #x: data, y:genus

  genus_name <- subset(x, genus == y)$genus
  species_name <- subset(x, genus == y)$species
  var <- subset(x, genus == y)[,variable]
    
  # Sample without replacement

  random_mode <- sample(subset(x, genus == y)$mode)
  
  # Return a partial data frame (for each genus)
  return(data.frame(genus_name, species_name, var, random_mode)) 
}

####################################################
# For each genus, run the random_test() function.

zval_model <- function(data, n.genera, count=F){
  
  # Complete data frame initialization.
  ref.distri <- data.frame(x= character(0), y= character(0), z = character(0))
  
  for (t in 1:n.genera) {
    
    # Sub data frame (for each genus).
    part_distri <- random_test(data, levels(data$genus)[t])
    
    # Concatenation of each sub data frames.
    ref.distri <- rbind(ref.distri, part_distri)
  }
  
  #print(ref.distri)
  
  # Model
  if(count){
    m1 <- glmer(var ~ random_mode + (1|genus_name), data = ref.distri,family = "poisson")
    st <- "z"
  } else{
    m1 <- lmer(var ~ random_mode + (1|genus_name), data = ref.distri)
    st <- "t"
  }
  
  return(coef(summary(m1))[2, paste0(st," value")]) # Return zvalue
}

####################################################
# Main

cl <- makeCluster(detectCores()-1)  

#get library support needed to run the code
clusterEvalQ(cl,c(library(nlme),library(lme4)))

# Export variables and functions to all nodes in the cluster
clusterExport(cl,c("random_test","zval_model","data","n.genera","variable"))


# Simulations are shared among the nodes and the results are put together in the end.
#zval.reference <- replicate(nboot, zval_model(data, n.genera))
par(mfrow=c(3,2))
for(v in c("nbr_country","max_dist_eq","min_dist_eq","lat_mean","lat_median","host_spp")){
  variable = v
  start_time <- proc.time()[3]
  clusterExport(cl,"variable")
  fmla <- as.formula(paste(variable,"~ mode + (1|genus)",sep=" "))
  if(v %in% c("nbr_country","host_spp")){
    if(v=="host_spp"){
      data <- data[!data$host_spp ==0,] # remove species with no hosts described
    }
    zval.reference <-parSapply(cl, 1:nboot, function(i,...){zval_model(data,n.genera,count=T)})
    m_host <- glmer(fmla, data = data,family = "poisson")
    st <- "z"
  }
  else{
    zval.reference <-parSapply(cl, 1:nboot, function(i,...){zval_model(data,n.genera)})
    m_host <- lmer(fmla, data = data)
    st <- "t"
  }
  z.obs <- coef(summary(m_host))[2, paste0(st, " value")]
  hist(main=paste0(variable, "\n","P-value = ",sum(z.obs>zval.reference)/nboot),zval.reference, 
       breaks = 100, xlim=c(min(c(zval.reference,z.obs)), max(c(zval.reference,z.obs)))) # Vector of nboot pvalues.
  abline(v=z.obs, col="red", lwd=3)
  print(paste0("P-value for ", variable, " is: ", sum(z.obs>zval.reference)/nboot))
  print(paste0(nboot, " simulations for ", variable, " took ", unname(proc.time()[3]-start_time), " seconds"))
}
stopCluster(cl)
#quantile(zval.reference,c(0.025, 0.975))


########################################################
#======================================================#
########################################################
# Run full script with all different references cutoffs
#(removes the need to manually change variables)

random_test <- function(x,y) {  #x: data, y:genus
  
  genus_name <- subset(x, genus == y)$genus
  species_name <- subset(x, genus == y)$species
  var <- subset(x, genus == y)[,variable]
  
  # Sample without replacement
  
  random_mode <- sample(subset(x, genus == y)$mode)
  
  # Return a partial data frame (for each genus)
  return(data.frame(genus_name, species_name, var, random_mode)) 
}


# For each genus, run the random_test() function.

zval_model <- function(data, n.genera, count=F){
  
  # Complete data frame initialization.
  ref.distri <- data.frame(x= character(0), y= character(0), z = character(0))
  
  for (t in 1:n.genera) {
    
    # Sub data frame (for each genus).
    part_distri <- random_test(data, levels(data$genus)[t])
    
    # Concatenation of each sub data frames.
    ref.distri <- rbind(ref.distri, part_distri)
  }
  
  #print(ref.distri)
  
  # Model
  if(count){
    m1 <- glmer(var ~ random_mode + (1|genus_name), data = ref.distri,family = "poisson")
    st <- "z"
  } else{
    m1 <- lmer(var ~ random_mode + (1|genus_name), data = ref.distri)
    st <- "t"
  }
  
  return(coef(summary(m1))[2, paste0(st," value")]) # Return zvalue
}

library(permute); library(nlme); library(lme4);library(parallel)
data <- read.csv("~/Dropbox/Cyril-Casper_shared/for_publication/auto_data.csv", header=T)

nboot <- 10
# Simulations are shared among the nodes and the results are put together in the end.
#zval.reference <- replicate(nboot, zval_model(cut_data, n.genera))
for(cutoff in 1:3){
  cut_data <- data[data$ref>cutoff,] # remove species very few studies
  n.genera <- length(levels(cut_data$genus)) #number of genera
  l.genus <- as.vector(table(cut_data$genus)) #list w/ number of species per genus
  pdf(paste0("auto_10ksim_GT", cutoff,"ref.pdf"), width = 15, height=12)
  par(mfrow=c(3,2))
  cl <- makeCluster(detectCores()-0)  
  
  #get library support needed to run the code
  clusterEvalQ(cl,c(library(nlme),library(lme4)))
  # Export variables and functions to all nodes in the cluster
  clusterExport(cl,c("random_test","zval_model","cut_data","n.genera"))
  for(v in c("nbr_country","max_dist_eq","min_dist_eq","lat_mean","lat_median","host_spp")){
    variable = v
    start_time <- proc.time()[3]
    clusterExport(cl,"variable")
    fmla <- as.formula(paste(variable,"~ mode + (1|genus)",sep=" "))
    if(v %in% c("nbr_country","host_spp")){
      if(v=="host_spp"){
        cut_data <- cut_data[!cut_data$host_spp ==0,] # remove species with no hosts described
      }
      clusterExport(cl,"cut_data")
      zval.reference <-parSapply(cl, 1:nboot, function(i,...){zval_model(cut_data,n.genera,count=T)})
      m_host <- glmer(fmla, data = cut_data,family = "poisson")
      st <- "z"
    }
    else{
      zval.reference <-parSapply(cl, 1:nboot, function(i,...){zval_model(cut_data,n.genera)})
      m_host <- lmer(fmla, data = cut_data)
      st <- "t"
    }
    z.obs <- coef(summary(m_host))[2, paste0(st, " value")]
    #pval1T <- ifelse(z.obs>0,sum(z.obs<zval.reference)/nboot,sum(z.obs>zval.reference)/nboot)
    pval <- 2*min(sum(z.obs<=zval.reference)/nboot,sum(z.obs>=zval.reference)/nboot)
    hist(main=paste0(variable, "\n",st,"-value = ", round(z.obs,3),
                     ", P = ",sum(z.obs>zval.reference)/nboot),zval.reference, 
         breaks = 100, xlim=c(min(c(zval.reference,z.obs)), max(c(zval.reference,z.obs)))) # Vector of nboot pvalues.
    abline(v=z.obs, col="red", lwd=3)
    print(paste0("Number of references: More than ", cutoff, "; Variable: ", variable))
    print(paste0("P-value for ", variable, " is: ", sum(z.obs>zval.reference)/nboot))
    print(paste0(nboot, " simulations for ", variable, " took ", unname(proc.time()[3]-start_time), " seconds"))
    print(paste0("n=",nrow(cut_data)))
    print("=====================================================")
  }
  stopCluster(cl)
  dev.off()
}




#################
# Visualizing proportion of zeros at different references cutoff for latitude range min distance from equator
test_zero <- data.frame(mindist=rep(0,31),range = rep(0,31))
for(cu in 0:30){
  tmp <- data[data$ref>cu,] # remove species very few studies
  tmp_dist <- unname(apply(tmp,MARGIN = 1, FUN = mindist))
  test_zero$mindist[cu+1] <- length(tmp_dist[tmp_dist==0])/length(tmp_dist)
  tmp_range <- abs(tmp$lat_max-tmp$lat_min)
  test_zero$range[cu+1] <- length(tmp_dist[tmp_range==0])/length(tmp_range)
}
par(mfrow=c(1,2))
barplot(test_zero$mindist,names=0:30,main="Proportion of zero: \nMinimum distance to equator",xlab="References cutoff")
barplot(test_zero$range,names=0:30,main="Proportion of zero: \nLatitude range",xlab="References cutoff")

