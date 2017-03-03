rm(list=ls()); library(permute); library(nlme); library(lme4);library(parallel)


data0 <- read.csv("~/Documents/Internship/Data/R_working_directory/manual/manual_processed_data.csv", header=T)
data0 <- data0[!data0$nbr_country =="0",] #remove species with no countries described
data0 <- data0[!data0$nbr_host_spp =="0",] # remove species with no hosts described
data <- data0[data0$pair != 0,]
data$pair <- as.factor(data$pair)
data$max_dist_eq <- pmax(abs(data$lat_min),abs(data$lat_max))

variable = "nbr_host_spp"
fmla <- as.formula(paste(variable,"~ mode + (1|pair)",sep=" "))
m_host <- lmer(fmla, data = data)
z.obs <- coef(summary(m_host))[2, "t value"]

####################################################
# Ramdomize the mode (sex, asex) within a genus
n.genera <- length(levels(data$pair)) #number of genera
l.genus <- as.vector(table(data$pair)) #list w/ number of species per genus
nboot <- 1000 #number of permutations

random_test <- function(x,y) {  #x: data, y:genus

  pair_name <- subset(x, pair == y)$pair
  species_name <- subset(x, pair == y)$species
  var <- subset(x, pair == y)[,variable]
    
  # Sample without replacement
  random_mode <- sample(subset(x, pair == y)$mode)
  
  # Return a partial data frame (for each genus)
  return(data.frame(pair_name, species_name, var, random_mode)) 
}

####################################################
# For each genus, run the random_test() function.

zval_model <- function(data, n.genera){
  
  # Complete data frame initialization.
  ref.distri <- data.frame(x= character(0), y= character(0), z = character(0))
  
  for (t in 1:n.genera) {
    
    # Sub data frame (for each genus).
    part_distri <- random_test(data, levels(data$pair)[t])
    
    # Concatenation of each sub data frames.
    ref.distri <- rbind(ref.distri, part_distri)
  }
  
  #print(ref.distri)
  
  # Model
  m1 <- lmer(var ~ random_mode + (1|pair_name), data = ref.distri)
  
  return(coef(summary(m1))[2, "t value"]) # Return zvalue
}

####################################################
# Main

# Note I leave 1 core free, so that it is still possible to do other things while the script runs
cl <- makeCluster(detectCores()-1)  

#get library support needed to run the code
clusterEvalQ(cl,c(library(nlme),library(lme4)))

# Export variables and functions to all nodes in the cluster
clusterExport(cl,c("random_test","zval_model","data","n.genera"))

# Simulations are shared among the nodes and the results are put together in the end.
par(mfrow=c(3,3))
for(v in c("nbr_country","max_dist_eq","lat_mean","lat_median","nbr_host_spp","min_length","max_length")){
  variable = v
  clusterExport(cl,"variable")
  zval.reference <-parSapply(cl, 1:nboot, function(i,...){zval_model(data,n.genera)})
  fmla <- as.formula(paste(variable,"~ mode + (1|genus)",sep=" "))
  m_host <- lmer(fmla, data = data)
  z.obs <- coef(summary(m_host))[2, "t value"]
  hist(main=variable,zval.reference, breaks = 100, xlim=c(-40, 40)) # Vector of nboot pvalues.
  text(x = 35,y = nboot/50,labels = paste0("P-value = ",sum(z.obs>zval.reference)/nboot))
  abline(v=z.obs, col="red", lwd=3)
  print(paste0("P-value for ", variable, " is: ", sum(z.obs>zval.reference)/nboot))
}
stopCluster(cl)
#10 sim = 1.9 sec



#stop the cluster
stopCluster(cl)
