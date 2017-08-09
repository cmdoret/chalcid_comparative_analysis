# This script runs a series of generalized linear mixed models with permutations on the manual dataset.
# The reproductive modes are permuted randomly in each pair over 10000 simulations (nboot parameter) to 
# generate an empirical distribution of z-values. The observed z-value is then compared to this distribution.
# Cyril Matthey-Doret, Casper Van Der Kooi
# 17.02.2017

library(nlme); library(lme4);library(parallel)

# Load and process data
data0 <- read.csv("sample_data/manual_data_ref.csv", header=T)
data <- data0[data0$pair != 0,]
data <- data[!is.na(data$species),]
rownames(data) <- NULL
data$pair <- as.factor(data$pair)

#======================================
## CHOOSE SETTINGS ##
nboot <- 10000 # Number of permutations
variable = "host_spp"  # Variable to be tested
####################################################
# Randomize the mode (sex, asex) within a genus
n.pairs <- length(levels(data$pair)) # number of genera
l.genus <- as.vector(table(data$pair)) #list w/ number of species per genus
fmla <- as.formula(paste(variable,"~ mode + (1|genus/pair)",sep=" "))
m_host <- glmer(fmla, data = data,family = "poisson")
zobs <- coef(summary(m_host))[2, "z value"]


random_test <- function(x,y) {  #x: data, y:genus

  pair_name <- subset(x, pair == y)$pair
  species_name <- subset(x, pair == y)$species
  var <- subset(x, pair == y)[,variable]
  genus_name <- subset(x, pair == y)$genus
    
  # Sample without replacement
  random_mode <- sample(subset(x, pair == y)$mode)
  
  # Return a partial data frame (for each genus)
  return(data.frame(pair_name, genus_name, species_name, var, random_mode)) 
}

####################################################
# For each genus, run the random_test() function.

zval_model <- function(data, n.pairs,count=F){
  
  # Complete data frame initialization.
  ref.distri <- data.frame(x= character(0), y= character(0), z = character(0))
  
  for (t in 1:n.pairs) {
    
    # Sub data frame (for each genus).
    part_distri <- random_test(data, levels(data$pair)[t])
    
    # Concatenation of each sub data frames.
    ref.distri <- rbind(ref.distri, part_distri)
  }
  
  #print(ref.distri)
  
  # Model
  if(count){
    m1 <- glmer(var ~ random_mode + (1|genus_name/pair_name), data = ref.distri,family = "poisson")
    st <- "z"
  } else{
    m1 <- lmer(var ~ random_mode + (1|genus_name/pair_name), data = ref.distri)
    st <- "t"
  }
  print(coef(summary(m1)))
  return(coef(summary(m1))[2, paste0(st," value")]) # Return zvalue
}

####################################################
# Main

# Note I leave 1 core free, so that it is still possible to do other things while the script runs
cl <- makeCluster(detectCores()-0)  

#get library support needed to run the code
clusterEvalQ(cl,c(library(nlme),library(lme4)))

# Export variables and functions to all nodes in the cluster
clusterExport(cl,c("random_test","zval_model","data","n.pairs"))
pdf("manual_10ksim_plots.pdf", height=15,width=12)
# Simulations are shared among the nodes and the results are put together in the end.
par(mfrow=c(3,3))
for(v in c("nbr_country","max_dist_eq","min_dist_eq","lat_mean","lat_median","min_length","max_length","lat_range","host_spp")){
  variable = v
  start_time <- proc.time()[3]
  clusterExport(cl,"variable")
  fmla <- as.formula(paste(variable,"~ mode + (1|genus/pair)",sep=" "))
  if(v %in% c("nbr_country","host_spp")){
    if(v=="host_spp"){
      data <- data[!data$host_spp ==0,] # remove species with no hosts described
      clusterExport(cl,"data")
    }
    
    zval.reference <-parSapply(cl, 1:nboot, function(i,...){zval_model(data,n.pairs,count=T)})
    m_host <- glmer(fmla, data = data,family = "poisson")
    st <- "z"
  }
  else{
    zval.reference <-parSapply(cl, 1:nboot, function(i,...){zval_model(data,n.pairs)})
    m_host <- lmer(fmla, data = data)
    st <- "t"
  }
  zobs <- coef(summary(m_host))[2, paste0(st," value")]
  pval1T <- ifelse(zobs>0,sum(zobs<=zval.reference)/nboot,sum(zobs>=zval.reference)/nboot)
  pval <- 2*min(sum(zobs<=zval.reference)/nboot,sum(zobs>=zval.reference)/nboot)
  hist(main=paste0(variable, "\n","P-value = ",pval),zval.reference, 
       breaks = 100, xlim=c(min(c(zval.reference,zobs)), max(c(zval.reference,zobs)))) # Vector of nboot pvalues.
  abline(v=zobs, col="red", lwd=3)
  print(paste0("P-value for ", variable, " is: ",pval))
  print(paste0(nboot, " simulations for ", variable, " took", unname(proc.time()[3]-start_time), " seconds"))
  line = paste(variable, pval1T, pval, round(zobs,3),sep=",")
  write(line, file="out_manual.csv",append=T)
}
#10 sim = 1.9 sec
#stop the cluster
dev.off()
stopCluster(cl)

# Example visualisation with box_lines.R. Replace variables at will
# source("box_lines.R")
# line.maxlat <- linebox(df = data,fac='mode',group='pair',var = 'latitude_max')
# line.minlat <- linebox(df = data,fac='mode',group='pair',var = 'latitude_min')
# grid.arrange(line.maxlat, line.minlat, nrow=1, ncol=2)
