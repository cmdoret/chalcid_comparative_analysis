# This scripts intends to test if sexual species from which asexual species 
# diverged are more widely distributed or have more hosts than other sexual 
# species. Here, both datasets are merged, since there is no information
# about relatedness in the auto dataset, and closest relative is known only in
# the manual dataset. The approach consists in comparing the sexuals from
# manual (sister species of an asexual), versus the other sexuals in the 
# auto dataset within the same genus (outgroup).
# Cyril Matthey-Doret, Casper Van Der Kooi
# 17.02.2017

rm(list=ls()); library(permute); library(nlme); library(lme4);library(ggplot2); library(gridExtra)

######
#Data#
######

# Loading number of references.
citat <-read.csv("~/Dropbox/Cyril-Casper_shared/Internship/Data/R_working_directory/auto/auto_citations_per_species.csv", header=T)

# Loading dataset and merging dataset with citations. Only species for which both data and number of citations is available will be kept.
manu0 <- read.csv("~/Dropbox/Cyril-Casper_shared/for_publication/manual_data.csv")
manu <- merge(x=manu0, y=citat, by.x=c("family","genus","species"), by.y=c("family","genus","species"), all=F)

close_sex0 <-manu[manu$pair!=0 & manu$mode=="sex",]
close_sex <- cbind(close_sex0, diverg=rep("close"))
close_sex <- close_sex[!close_sex$nbr_country==0 & !close_sex$host_spp==0,]

# Loading dataset and merging dataset with citations. Only species for which both data and number of citations is available will be kept.
auto0 <- read.csv("~/Dropbox/Cyril-Casper_shared/for_publication/auto_data.csv", header=T)
auto <- auto0
#auto <- merge(x=auto0, y=citat, by.x=c("family","genus","species"), by.y=c("family","genus","species"), all=F) 
auto <- auto[!auto$nbr_country ==0,] #remove species with no countries described
auto <- auto[!auto$host_spp ==0,] # remove species with no hosts described

# Conserving only sexual species
far_sex0 <- auto[auto$mode=="sex",]

# Adding a column, to label those species as "far", meaning they are not closely related to an asexual species.
far_sex <- cbind(far_sex0, diverg=rep("far"))

# Changing colnames for successful rbind.
close_sex <- close_sex[,c("family", "genus", "species", "mode", "lon_min", "lon_max", 
                          "lon_mean", "lon_median", "lat_min", "lat_max", "lat_mean", 
                          "lat_median", "nbr_country", "host_spp", "eco", "ref", "diverg")]
#colnames(close_sex)[14] <- "host_spp"
far_sex <- far_sex[, c("family", "genus", "species", "mode", "lon_min", "lon_max", "lon_mean", 
                       "lon_median", "lat_min", "lat_max", "lat_mean", "lat_median", "nbr_country", 
                       "host_spp", "eco", "ref", "diverg")]

#Merging both sets with rbind.
merged_sets <- rbind(close_sex, far_sex[far_sex$genus %in% close_sex$genus,])
merged_sets <- merged_sets[!is.na(merged_sets$genus),]

# Removing all dupplicate species to keep only those coming from close_sex.
merged <- subset(merged_sets, subset = !(duplicated(merged_sets$species) & duplicated(merged_sets$genus) &  merged_sets$diverg=="far"))

# Removing all genera without any "close" species.
merged$genus <-droplevels(merged$genus)

# Applying different cutoffs for references
merged2 <- merged[merged$ref>2,] # remove species very few studies
merged3 <- merged[merged$ref>4,] # remove species very few studies
merged4 <- merged[merged$ref>7,] # remove species very few studies
merged <- merged3

##########
#ANALYSIS#
##########

#=======================================================
test_var <- "nbr_country" # This line allows to choose the variable to be tested
#======================================================

#Comparing distribution of the number of references in both groups with different cutoff (would ideally be equal)
par(mfrow=c(1,4))
boxplot(merged$ref[merged$diverg=="close"], merged$ref[merged$diverg=="far"], ylim=c(0,30))
text(x = 1.5,y=0,round(t.test(merged$ref[merged$diverg=="close"],merged$ref[merged$diverg=="far"])$p.value,3))
boxplot(merged2$ref[merged2$diverg=="close"], merged2$ref[merged2$diverg=="far"], ylim=c(0,30))
text(x = 1.5,y=0,round(t.test(merged2$ref[merged2$diverg=="close"],merged2$ref[merged2$diverg=="far"])$p.value,3))
boxplot(merged3$ref[merged3$diverg=="close"], merged3$ref[merged3$diverg=="far"], ylim=c(0,30))
text(x = 1.5,y=0,round(t.test(merged3$ref[merged3$diverg=="close"],merged3$ref[merged3$diverg=="far"])$p.value,3))
boxplot(merged4$ref[merged4$diverg=="close"], merged4$ref[merged4$diverg=="far"], ylim=c(0,30))
text(x = 1.5,y=0,round(t.test(merged4$ref[merged4$diverg=="close"],merged4$ref[merged4$diverg=="far"])$p.value,3))
# Far tend to have fewer references (kind of expected) but not significantly different.


# Model, using divergence as a two level factor (far vs close) where close means the species is the closest relative of an asexual species.
my_model <- glmer(merged[,test_var] ~ diverg + (1|genus), data = merged, family="poisson")
z.obs <- coef(summary(my_model))[2, "z value"]
z.obs
####################################################
# Randomize the divergence (close, far) within a genus
n.genera <- length(levels(merged$genus)) #number of genera
l.genus <- as.vector(table(merged$genus)) #list w/ number of species per genus
nboot <- 100 #number of permutations

random_test <- function(x,y) {  #x: merged, y:genus

  genus_name <- subset(x, genus == y)$genus
  species_name <- subset(x, genus == y)$species
  genus_var <- subset(x, genus == y)[,test_var]
    
  # Sample without replacement
  random_diverg <- sample(subset(x, genus == y)$diverg)
  
  # Return a partial data frame (for each genus)
  return(data.frame(genus_name, species_name, genus_var, random_diverg)) 
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
  m1 <- glmer(ref.distri[,"genus_var"] ~ random_diverg + (1|genus_name), data = ref.distri, family="poisson")
  
  return(coef(summary(m1))[2, "z value"]) # Return zvalue
}

####################################################
# Main

zval.reference <- replicate(nboot, zval_model(merged, n.genera))
hist(zval.reference, breaks = 30, xlim=c(-60, 60)) # Vector of nboot pvalues.
abline(v=z.obs, col="red", lwd=3)
quantile(zval.reference,c(0.025, 0.975))
sum(z.obs>zval.reference)/nboot


############### -------------- VISUALIZATION --------------- ###################

#BOXPLOTS
country <- ggplot()+
  geom_boxplot(data = merged,
  aes(x=diverg,y=nbr_country)) +
  labs(x="",y="Number of countries") +
  annotate(x = c(1,2),y=c(10,10),geom= "text", 
  label=NA ) + theme_classic() + theme(axis.line.x = element_line(color = "black"), axis.line.y = element_line(color = "black"))
country
host <- ggplot()+
  geom_boxplot(data = merged,
  aes(x=diverg,y=host_spp)) +
  labs(x="",y="Number of hosts") +
  annotate(x = c(1,2),y=c(10,10),geom= "text", 
  label=NA ) + theme_classic() + theme(axis.line.x = element_line(color = "black"), axis.line.y = element_line(color = "black"))
host

host.close <- by (data=abs(merged$host_spp[merged$diverg=="close"]), merged$genus[merged$diverg=="close"] , mean, simplify=T, na.rm=T)
host.far <- by (data=abs(merged$host_spp[merged$diverg=="far"]), merged$genus[merged$diverg=="far"] , mean, simplify=T, na.rm=T)
df <- as.data.frame(cbind(host.close, host.far))
m.host <- reshape (df, varying=c("host.close", "host.far"), v.names = "host_spp", timevar="diverg", direction="long", 
                   times = c("Sister species", "Outgroup"), idvar="genus")

line.host <- ggplot(data=m.host, aes(x=diverg, y=host_spp, group=genus))+ geom_path(alpha=0.6) +
  theme_classic() + theme(axis.line.x = element_line (color="black"), axis.line.y = element_line (color="black")) +
  ylab("Number of host species") + xlab("") + annotate("text", x=1.5, y=29, label="p < 0.001", size=4)

country.close <- by (data=abs(merged$nbr_country[merged$diverg=="close"]), merged$genus[merged$diverg=="close"] , mean, simplify=T, na.rm=T)
country.far <- by (data=abs(merged$nbr_country[merged$diverg=="far"]), merged$genus[merged$diverg=="far"] , mean, simplify=T, na.rm=T)
df <- as.data.frame(cbind(country.close, country.far))
m.country <- reshape (df, varying=c("country.close", "country.far"), v.names = "nbr_country", timevar="diverg", direction="long", 
                      times = c("Sister species", "Outgroup"), idvar="genus")

line.country <- ggplot(data=m.country, aes(x=diverg, y=nbr_country, group=genus))+ geom_path(alpha=0.6) +
  theme_classic() + theme(axis.line.x = element_line (color="black"), axis.line.y = element_line (color="black")) +
  ylab("Number of countries") + xlab("") + annotate("text", x=1.5, y=55, label="p < 0.001", size=4)

grid.arrange(line.host, line.country, nrow=1, ncol=2)


cor.test(merged$host_spp, merged$nbr_country, method = "kendall")
m <- glm(diverg ~  host_spp + nbr_country, data=merged, family=binomial)
summary(m) # effect of country is more important than host, per se
