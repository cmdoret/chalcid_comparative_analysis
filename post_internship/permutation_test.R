rm(list=ls()); library(permute); library(nlme); library(lme4)
data0 <- read.csv("~/Documents/Internship/Data/R_working_directory/auto/auto_processed_data.csv", header=T)
citat <-read.csv("~/Dropbox/Cyril-Casper_shared/Internship/Data/auto/auto_citations_per_species.csv", header=T)
data <- merge(x=data0, y=citat, by.x=c("family","genus","species"), by.y=c("family","genus","species"), all=F)
data <- data[!data$nbr_country =="0",] #remove species with no countries described
data <- data[!data$host_spp =="0",] # remove species with no hosts described

data2 <- data[data$ref>"2",] # remove species very few studies
data3 <- data[data$ref>"4",] # remove species very few studies
data4 <- data[data$ref>"7",] # remove species very few studies


par(mfrow=c(1,3))
boxplot(data$ref[data$mode=="sex"], data$ref[data$mode=="asex"], ylim=c(0,10))
boxplot(data2$ref[data2$mode=="sex"], data2$ref[data2$mode=="asex"], ylim=c(0,10))
boxplot(data3$ref[data3$mode=="sex"], data3$ref[data3$mode=="asex"], ylim=c(0,10))
boxplot(data4$ref[data4$mode=="sex"], data4$ref[data4$mode=="asex"], ylim=c(0,10))

m_host <- glmer(host_spp ~ mode + (1|genus), data = data, family="poisson")
z.obs <- coef(summary(m_host))[2, "z value"]

####################################################
# Ramdomize the mode (sex, asex) within a genus
n.genera <- length(levels(data$genus)) #number of genera
l.genus <- as.vector(table(data$genus)) #list w/ number of species per genus
nboot <- 100 #number of permutations

random_test <- function(x,y) {  #x: data, y:genus

  genus_name <- subset(x, genus == y)$genus
  species_name <- subset(x, genus == y)$species
  host_spp <- subset(x, genus == y)$host_spp
    
  # Sample without replacement
  random_mode <- sample(subset(x, genus == y)$mode)
  
  # Return a partial data frame (for each genus)
  return(data.frame(genus_name, species_name, host_spp, random_mode)) 
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
  m1 <- glmer(host_spp ~ random_mode + (1|genus_name), data = ref.distri, family="poisson")
  
  return(coef(summary(m1))[2, "z value"]) # Return zvalue
}

####################################################
# Main

zval.reference <- replicate(nboot, zval_model(data, n.genera))
hist(zval.reference, breaks = 10000, xlim=c(-60, 60)) # Vector of nboot pvalues.
abline(v=z.obs, col="red", lwd=3)
quantile(zval.reference,c(0.025, 0.975))
sum(z.obs>zval.reference)/nboot
