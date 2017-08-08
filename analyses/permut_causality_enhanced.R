# This scripts intends to test if sexual species from which asexual species 
# diverged are more widely distributed or have more hosts than other sexual 
# species. Here, both datasets are merged, since there is no information
# about relatedness in the auto dataset, and closest relative is known only in
# the manual dataset. The approach consists in comparing the sexuals in each 
# pair from manual (sister species of an asexual), versus the other sexuals 
# in the auto dataset within the same genus (outgroup).
# Cyril Matthey-Doret, Casper Van Der Kooi
# 17.02.2017

rm(list=ls()); library(permute); library(nlme); library(lme4);library(ggplot2); library(gridExtra); library(dplyr)

######
#Data#
######

# Loading number of references.
citat <-read.csv("sample_data/auto_citations_per_species.csv", header=T)

# Loading dataset and merging dataset with citations. Only species for which both data and number of citations is available will be kept.
manu0 <- read.csv("sample_data/manual_data_ref.csv")
manu <- merge(x=manu0, y=citat, by.x=c("family","genus","species"), by.y=c("family","genus","species"), all=F)

close_sex0 <-manu[manu$pair!=0,]  # Removing species not assigned to a pair (if any)
close_sex <- cbind(close_sex0, diverg=rep("close"))  # all asex in manual dataset are sister species (close)
close_sex$diverg <- as.character(close_sex$diverg)
close_sex$diverg[close_sex$mode=='asex'] <- 'asex' # Adding separate level for asexuals
close_sex$diverg <- as.factor(close_sex$diverg)
close_sex <- close_sex[!close_sex$nbr_country==0 & !close_sex$host_spp==0,]
# Excluding species without country or host information
close_sex <- close_sex[!is.na(close_sex$family),];rownames(close_sex) <- NULL

# Loading dataset and merging dataset with citations. Only species for which both data and number of citations is available will be kept.
auto0 <- read.csv("sample_data/auto_data.csv", header=T)
auto <- auto0
#auto <- merge(x=auto0, y=citat, by.x=c("family","genus","species"), by.y=c("family","genus","species"), all=F) 
auto <- auto[!auto$nbr_country ==0,] #remove species with no countries described
auto <- auto[!auto$host_spp ==0,] # remove species with no hosts described

# Conserving only sexual species
far_sex0 <- auto[auto$mode=="sex",]

# Adding a column, to label those species as "far", meaning they are not closely related to an asexual species.
far_sex <- cbind(far_sex0, diverg=rep("far"))
far_sex$pair <- rep(0) 
# Changing colnames for successful rbind.

close_sex <- close_sex[,c("family", "genus", "species", "pair", "mode", "latitude_min", "latitude_max", "latitude_mean", 
                          "latitude_median", "nbr_country", "host_spp",  "ref", "diverg")]

far_sex <- far_sex[, c("family", "genus", "species", "pair", "mode", 
                       "latitude_min", "latitude_max", "latitude_mean", "latitude_median", "nbr_country", 
                       "host_spp", "ref", "diverg")]

# Adding outgroup for each pair (convenient for plotting)
merged_sets <- close_sex
for(g in levels(close_sex$genus)){
  tmp_pairs <- unique(close_sex$pair[close_sex$genus==g])
  for(p in tmp_pairs){
    tmp_far <- far_sex[far_sex$genus==g,]
    tmp_far$pair <- p
    excl <- data.frame(genus = close_sex$genus,species = close_sex$species)
    tmp_far <- anti_join(tmp_far, excl, by = c("genus", "species"))
    merged_sets <- rbind(merged_sets, tmp_far)
  }
}
merged <- merged_sets
# Removing all genera without any "close" species.
merged$genus <-droplevels(merged$genus)

##########
#ANALYSIS#
##########

#=======================================================
test_var <- "host_spp" # This line allows to choose the variable to be tested
#======================================================
merged$pair <- as.factor(merged$pair)


# Model, using divergence as a two level factor (far vs close) where close means the species 
# is the closest relative of an asexual species.
mod_data <- merged[merged$diverg!='Parthenogen',]
# Excluding asexuals to compare only sister species versus outgroup
my_model <- glmer(mod_data[,test_var] ~ diverg + (1|pair), data = mod_data, family="poisson")
z.obs <- coef(summary(my_model))[2, "z value"]
z.obs
####################################################
# Randomize the divergence (close, far) within a genus
n.pairs <- length(levels(mod_data$pair)) #number of genera
l.genus <- as.vector(table(mod_data$genus)) #list w/ number of species per genus
nboot <- 10000 #number of permutations

random_test <- function(x,y) {  #x: merged, y:genus
  
  pair_name <- subset(x, pair == y)$pair
  species_name <- subset(x, pair == y)$species
  pair_var <- subset(x, pair == y)[,test_var]
  
  # Sample without replacement
  random_diverg <- sample(subset(x, pair == y)$diverg)
  
  # Return a partial data frame (for each genus)
  return(data.frame(pair_name, species_name, pair_var, random_diverg)) 
}

####################################################
# For each pair, run the random_test() function.

zval_model <- function(data, n.pairs){
  
  # Complete data frame initialization.
  ref.distri <- data.frame(x= character(0), y= character(0), z = character(0))
  
  for (t in 1:n.pairs) {
    
    # Sub data frame (for each pair).
    part_distri <- random_test(data, levels(data$pair)[t])
    
    # Concatenation of each sub data frames.
    ref.distri <- rbind(ref.distri, part_distri)
  }
  
  #print(ref.distri)
  
  # Model
  m1 <- glmer(ref.distri[,"pair_var"] ~ random_diverg + (1|genus/pair_name), data = ref.distri, family="poisson")
  
  return(coef(summary(m1))[2, "z value"]) # Return zvalue
}

####################################################
# Main

zval.reference <- replicate(nboot, zval_model(mod_data, n.pairs))
hist(zval.reference, breaks = 30, xlim=c(-60, 60)) # Vector of nboot pvalues.
abline(v=z.obs, col="red", lwd=3)
quantile(zval.reference,c(0.025, 0.975))
sum(z.obs>zval.reference)/nboot


############### -------------- VISUALIZATION --------------- ###################

merged$pair <- as.factor(merged$pair)
host.close <- by (data=abs(merged$host_spp[merged$diverg=="close"]), merged$pair[merged$diverg=="close"] , mean, simplify=T, na.rm=T)
host.far <- by (data=abs(merged$host_spp[merged$diverg=="far"]), merged$pair[merged$diverg=="far"] , mean, simplify=T, na.rm=T)
host.asex <- by (data=abs(merged$host_spp[merged$diverg=="asex"]), merged$pair[merged$diverg=="asex"] , mean, simplify=T, na.rm=T)
df <- as.data.frame(cbind(host.close, host.far, host.asex))
m.host <- reshape (df, varying=c("host.close", "host.far", "host.asex"), v.names = "host_spp", timevar="diverg", direction="long", 
                   times = c("Sister species", "Outgroup", "Parthenogen"), idvar="pair")
m.host$diverg <- as.character(m.host$diverg)
m.host$diverg <- factor(m.host$diverg,levels = c("Outgroup","Sister species","Parthenogen"), ordered = T)

xa_offset <- function(x){
  for(i in 1:length(x)){
    if(x[i]>1.5)
      {x[i] <- x[i]-0.1}
    else
      {x[i] <- x[i]+0.1}
  }  
}

xb_offset <- function(x){
  for(i in 1:length(x)){
    if(x[i]<2.5)
      {x[i] <- x[i]+0.1}
    else
      {x[i] <- x[i]-0.1}
  }  
}
m.host <- m.host %>% mutate(a=case_when(as.integer(.$diverg)>1.5 ~ 1.9, as.integer(.$diverg)<1.5 ~ 1.1),
                            b=case_when(as.integer(.$diverg)>2.5 ~ 2.9, as.integer(.$diverg)<2.5 ~ 2.1))

line.host <- ggplot(data=m.host, aes(x=diverg, y=host_spp))+ 
  geom_point(col='white') + 
  geom_path(data=m.host[m.host$diverg!='Parthenogen',], alpha=0.6, aes(x = a, y=host_spp, group=pair)) +
  geom_path(data=m.host[m.host$diverg!='Outgroup',], alpha=0.6, lty=2, aes(x = b, y=host_spp, group=pair)) + 
  geom_boxplot(width=0.1) + 
  theme_classic() + theme(axis.line.x = element_line (color="black"), axis.line.y = element_line (color="black")) +
  ylab("Number of host species") + xlab("") + ylim(c(0,75)) + 
  annotate("text", x=1.5, y=max(m.host$host_spp[m.host$diverg!="Parthenogen"]*1.1, na.rm=T), 
           label="p = 0.0007", size=4)  

country.close <- by (data=abs(merged$nbr_country[merged$diverg=="close"]), merged$pair[merged$diverg=="close"] , mean, simplify=T, na.rm=T)
country.far <- by (data=abs(merged$nbr_country[merged$diverg=="far"]), merged$pair[merged$diverg=="far"] , mean, simplify=T, na.rm=T)
country.asex <- by (data=abs(merged$nbr_country[merged$diverg=="asex"]), merged$pair[merged$diverg=="asex"] , mean, simplify=T, na.rm=T)
df <- as.data.frame(cbind(country.close, country.far, country.asex))
m.country <- reshape (df, varying=c("country.close", "country.far", "country.asex"), v.names = "nbr_country", timevar="diverg", direction="long", 
                      times = c("Sister species", "Outgroup", "Parthenogen"), idvar="pair")
m.country$diverg <- as.character(m.country$diverg)
m.country$diverg <- factor(m.country$diverg,levels = c("Outgroup","Sister species","Parthenogen"), ordered = T)

m.country <- m.country %>% mutate(a=case_when(as.integer(.$diverg)>1.5 ~ 1.9, as.integer(.$diverg)<1.5 ~ 1.1),
                            b=case_when(as.integer(.$diverg)>2.5 ~ 2.9, as.integer(.$diverg)<2.5 ~ 2.1))

line.country <- ggplot(data=m.country, aes(x=diverg, y=nbr_country))+ 
  geom_point(col='white') + 
  geom_path(data=m.country[m.country$diverg!='Parthenogen',], alpha=0.6, aes(x = a, y=nbr_country, group=pair)) +
  geom_path(data=m.country[m.country$diverg!='Outgroup',], alpha=0.6, lty=2, aes(x = b, y=nbr_country, group=pair)) + 
  geom_boxplot(width=0.1) + 
  theme_classic() + theme(axis.line.x = element_line (color="black"), axis.line.y = element_line (color="black")) +
  ylab("Number of countries") + xlab("") + 
  annotate("text", x=1.5, y=max(m.country$nbr_country[m.country$diverg!="Parthenogen"]*1.1, na.rm=T), 
           label="p = 0.0007", size=4)

grid.arrange(line.host, line.country, nrow=1, ncol=2)
