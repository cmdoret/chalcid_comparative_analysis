rm(list=ls()); library(permute); library(nlme); library(lme4);library(parallel)
data0 <- read.csv("~/Documents/Internship/Data/R_working_directory/auto/auto_processed_data.csv", header=T)
citat <-read.csv("~/Dropbox/Cyril-Casper_shared/Internship/Data/auto/auto_citations_per_species.csv", header=T)
data <- merge(x=data0, y=citat, by.x=c("family","genus","species"), by.y=c("family","genus","species"), all=F)
data <- data[!data$nbr_country =="0",] #remove species with no countries described
data <- data[!data$host_spp =="0",] # remove species with no hosts described

data2 <- data[data$ref>"2",] # remove species very few studies
data3 <- data[data$ref>"4",] # remove species very few studies
data4 <- data[data$ref>"7",] # remove species very few studies
data<-data3
data$max_dist_eq <- pmax(abs(data$lat_min),abs(data$lat_max))

# for(c in 1:length(colnames(data))){
#   if(is.numeric(data[,c])){data[,c] <- abs(data[,c])}
# }

# par(mfrow=c(1,3))
# boxplot(data$ref[data$mode=="sex"], data$ref[data$mode=="asex"], ylim=c(0,10))
# boxplot(data2$ref[data2$mode=="sex"], data2$ref[data2$mode=="asex"], ylim=c(0,10))
# boxplot(data3$ref[data3$mode=="sex"], data3$ref[data3$mode=="asex"], ylim=c(0,10))
# boxplot(data4$ref[data4$mode=="sex"], data4$ref[data4$mode=="asex"], ylim=c(0,10))
#Choose a variable
variable="host_spp"

fmla <- as.formula(paste(variable,"~ mode + (1|genus)",sep=" "))
m_host <- glmer(fmla, data = data, family="poisson")
z.obs <- coef(summary(m_host))[2, "t value"]


####################################################
# Ramdomize the mode (sex, asex) within a genus
n.genera <- length(levels(data$genus)) #number of genera
l.genus <- as.vector(table(data$genus)) #list w/ number of species per genus
nboot <- 1000 #number of permutations

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

zval_model <- function(data, n.genera){
  
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
  m1 <- lmer(var ~ random_mode + (1|genus_name),data=ref.distri)
  
  return(coef(summary(m1))[2, "t value"]) # Return zvalue
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
for(v in c("nbr_country","max_dist_eq","lat_mean","lat_median","host_spp")){
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
#quantile(zval.reference,c(0.025, 0.975))

