rm(list=ls()); 
library(lattice); library(multcomp); library(lme4); library(arm); library(lmerTest)

#AUTOMATED DATASET
auto <- read.csv("~/Dropbox/Cyril-Casper_shared/Internship/auto/auto_processed_data.csv", header=T)
auto <- auto[!auto$nbr_country =="0",] #remove species with no countries described
auto <- auto[!auto$host_spp =="0",] # remove species with no hosts described
hist(auto$nbr_country)
hist(auto$host_spp)

#DISTRIBUTION
bwplot(auto$nbr_country~auto$mode|auto$family)
m.country <- glmer(nbr_country ~ mode + (1| family / genus), data=auto, family="poisson")
summary(m.country)

#extract the random effects
ran.country <- ranef(m.country, condVar=T)
dotplot(ran.country)
qqnorm(ran.country[[1]][,1])
qqline(ran.country[[1]][,1])

#Check for overdispersion
#Overdispersion test by Bolker
overdisp <- function(model) {vpars <- function(m) {nrow(m)*(nrow(m)+1)/2}
model.df <- sum(sapply(VarCorr(model),vpars))+length(fixef(model))
(rdf <- nrow(model@frame)-model.df)
rp <- residuals(model)
Pearson.chisq <- sum(rp^2)
prat <- Pearson.chisq/rdf
pval <- pchisq(Pearson.chisq, df=rdf, lower.tail=FALSE,log.p=TRUE)
c(chisq=Pearson.chisq,ratio=prat,p=exp(pval))}
overdisp(m.country) #yes, overdispersed

country_means <- tapply(auto$nbr_country, auto$genus, mean)
country_vars <- tapply(auto$nbr_country, auto$genus, var)
plot(country_vars~country_means)
abline(c(0,1)) #yes, overdispersed

obs_level_country <- factor(1:length(auto$nbr_country))
m.country2 <- update (m.country, .~.+(1|obs_level_country))
summary(m.country2)
ran.country2 <- ranef(m.country2, condVar=T)
dotplot(ran.country2) #not ideal, but also not worrisome (we don't care much about randeffects)
qqnorm(ran.country2[[1]][,1])
qqline(ran.country2[[1]][,1])
overdisp(m.country2) #this helps

#NUMBER OF HOST SPECIES
bwplot(auto$host_spp~auto$mode|auto$family)
m.host <- glmer(host_spp ~ mode + (1| family / genus), data=auto, family="poisson")
summary(m.host)

ran.host <- ranef(m.host, condVar=T)
dotplot(ran.host)
qqnorm(ran.host[[1]][,1])
qqline(ran.host[[1]][,1])

#Check for overdispersion
#Overdispersion test by Bolker
overdisp(m.host) #yes, overdispersed

host_means <- tapply(auto$host_spp, auto$genus, mean)
host_vars <- tapply(auto$host_spp, auto$genus, var)
plot(host_vars~host_means)
abline(c(0,1)) #yes, overdispersed

obs_level_host <- factor(1:length(auto$host_spp))
m.host2 <- update (m.host, .~.+(1|obs_level_host))
summary(m.host2)
ran.host2 <- ranef(m.host2, condVar=T)
dotplot(ran.host2); overdisp(m.country2) #this helps










