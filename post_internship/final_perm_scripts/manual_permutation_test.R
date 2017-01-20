library(nlme); library(lme4);library(parallel)
#Note: If run on the cluster, needs R 3.2.2 as packages are not installed for R 3.3
setwd("Dropbox/Cyril-Casper_shared/post_internship/final_perm_scripts/")
data0 <- read.csv("./manual_data.csv", header=T)
data <- data0[data0$pair != 0,]
data <- data[!is.na(data$species),]
rownames(data) <- NULL
data$pair <- as.factor(data$pair)

variable = "host_spp"
#fmla <- as.formula(paste(variable,"~ mode + (1|genus/pair)",sep=" "))
#m_host <- lmer(fmla, data = data)
#zobs <- coef(summary(m_host))[2, "t value"]

####################################################
# Randomize the mode (sex, asex) within a genus
n.pairs <- length(levels(data$pair)) #number of genera
l.genus <- as.vector(table(data$pair)) #list w/ number of species per genus
nboot <- 10 #number of permutations

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
  if(v %in% c("nbr_country","nbr_host_spp")){
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
