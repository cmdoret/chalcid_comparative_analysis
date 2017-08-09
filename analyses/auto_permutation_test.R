# This script runs a series of generalized linear mixed models with permutations on the automated dataset.
# It is different from the manual_permutation script; it runs simulations on all variables automatically 
# different reference number cutoff. It is parallelized to speedup the analysis. 
# Cyril Matthey-Doret

library(nlme); library(lme4);library(parallel)
# Load data
data <- read.csv("./auto_data.csv", header=T)
nboot <- 10000  # Number of permutations per test



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



# Simulations are shared among the nodes and the results are put together in the end.
#zval.reference <- replicate(nboot, zval_model(cut_data, n.genera))
for(cutoff in -1:20){
  cut_data <- data[data$ref>cutoff,] # remove species very few studies
  n.genera <- length(levels(cut_data$genus)) #number of genera
  l.genus <- as.vector(table(cut_data$genus)) #list w/ number of species per genus
  if(cutoff<0){
    pdf(paste0("auto_10ksim_nocutoff.pdf"), width = 15, height=12)
  }else{
    pdf(paste0("auto_10ksim_GT", cutoff,"ref.pdf"), width = 15, height=12)
  }
  par(mfrow=c(4,2))
  cl <- makeCluster(detectCores()-0)  
  
  #get library support needed to run the code
  clusterEvalQ(cl,c(library(nlme),library(lme4)))
  # Export variables and functions to all nodes in the cluster
  clusterExport(cl,c("random_test","zval_model","cut_data","n.genera"))
  for(v in c("nbr_country","max_dist_equator","min_dist_equator","latitude_mean",
             "latitude_median","latituderange","host_spp")){
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
    pval1T <- ifelse(z.obs>0,sum(z.obs<=zval.reference)/nboot,sum(z.obs>=zval.reference)/nboot)
    pval <- 2*min(sum(z.obs<=zval.reference)/nboot,sum(z.obs>=zval.reference)/nboot)
    hist(main=paste0(variable, "\n",st,"-value = ", round(z.obs,3),
                     ", P = ",pval),zval.reference, 
         breaks = 100, xlim=c(min(c(zval.reference,z.obs)), max(c(zval.reference,z.obs)))) # Vector of nboot pvalues
    abline(v=z.obs, col="red", lwd=3)
    print(paste0("P-value for ", variable, " is: ", pval))
    print(paste0(nboot, " simulations for ", variable, " took ", unname(proc.time()[3]-start_time), " seconds"))
    print(paste0("n=",nrow(cut_data)))
    print("=====================================================")
    line = paste(cutoff,variable,pval1T,pval,round(z.obs,3),sep=",")
    write(line,file="out_auto.csv",append=T)
  }
  stopCluster(cl)
  dev.off()
}
