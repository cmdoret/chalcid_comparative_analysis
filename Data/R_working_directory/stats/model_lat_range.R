library(lattice); library(multcomp); library(lme4); library(arm); library(lmerTest); library("car"); library("MASS")


#MANUAL DATASET

setwd("/home/cyril/Documents/Internship/Data/R_working_directory/manual/")
mydf <- read.csv("manual_processed_data.csv", header=T)
mydf <- mydf[mydf$mode !="both" & mydf$nbr_country >1 & mydf$pair!=0,] 
#remove spp with sex + asex populations, with 0 or 1 countries or not in a pair
mydf <-mydf[complete.cases(mydf[,1:4]),]
# Dropping all rows from which data was deleted (i.e. containing NA in all columns, taking the 4 first as reference)

lat_range <- mydf$lat_max-mydf$lat_min
mydf <- cbind(mydf,lat_range)
mydf$lat_range[mydf$lat_range==0] <- 0.1
#generating response variable

#------------------------------------------------------------------------------------------
# Comparing distance from equator against different distributions:
par(mfrow=c(2,2))
mydf$lat_range[mydf$lat_range==0] <- 0.1
gamma <- fitdistr(mydf$lat_range, "Gamma")
qqp(main="Gamma",mydf$lat_range, "gamma", shape = gamma$estimate[[1]], rate = gamma$estimate[[2]])
qqp(main="Lognormal", mydf$lat_range,"lnorm")
qqp(main="Normal", mydf$lat_range,"norm")
poisson <- fitdistr(mydf$lat_range, "Poisson")
qqp(main="Poisson",mydf$lat_range, "pois", poisson$estimate)


#kinda fits all 4 distributino. Low values do not fit normal and poisson, middle values do not fit lognorm  and high values do noot fit gamma.
# It appears gamma is the distribution with the least unfit-values.
# Going for gamma

#------------------------------------------------------------------------------------------
#Check for overdispersion
lat_range_means <- tapply(mydf$lat_range, mydf$pair, mean)
lat_range_vars <- tapply(mydf$lat_range, mydf$pair, var)
plot(lat_range_vars~lat_range_means)
abline(c(0,1))
overdisp <- function(model) {vpars <- function(m) {nrow(m)*(nrow(m)+1)/2}
model.df <- sum(sapply(VarCorr(model),vpars))+length(fixef(model))
(rdf <- nrow(model@frame)-model.df)
rp <- residuals(model)
Pearson.chisq <- sum(rp^2)
prat <- Pearson.chisq/rdf
pval <- pchisq(Pearson.chisq, df=rdf, lower.tail=FALSE,log.p=TRUE)
c(chisq=Pearson.chisq,ratio=prat,p=exp(pval))}
overdisp(m.lat_range) 

#Looks overdispersed to me, but p=0.99


#--------------------------------------------------------------------------------------------
obs_level <- factor(1:length(mydf$lat_range))
mydf$pair <- as.factor(mydf$pair)

m.lat_range <- glmer(lat_range ~ mode + (1| genus / pair), data=mydf, family = "Gamma")
dispersion_glmer(m.lat_range)
#says it is not overdispersed
summary(m.lat_range)
#Not significant (p=0.3)

PQLlat_range <- glmmPQL(data=mydf,lat_range ~ mode, ~1|genus/pair, family = "Gamma", verbose = FALSE)
summary(PQLlat_range)
#PQL doesn't work with obs_level here, but it works properly when removing this facor.
#PQL yields a p=0.2, in accordance to Laplace used with correction for overdispersion-> not significant

#corrected or not, it is not significant 0.2<p<0.3

mydf <-within(mydf, rm("family"))
mydf <-cbind(mydf,obs_level)
mydf <-mydf[,c("genus","pair","mode","lat_range")]
prior = list(R = list(V = 1, n = 0, fix = 1), G = list(G1 = list(V = 1, n = 1),
                                                       G2 = list(V = 1, n = 1)))

MCMC2 <- MCMCglmm(lat_range ~ 1 + mode, random = ~genus:pair,
                 data = mydf, verbose = FALSE)
summary(MCMC2)
# not significant, p=0.158, CI95(modesex)=[-19.802;-8.867]
#============================================================================================
#AUTO DATASET

setwd("/home/cyril/Documents/Internship/Data/R_working_directory/auto/")
mydf <- read.csv("auto_processed_data.csv", header=T)
mydf <- mydf[mydf$mode !="both" & mydf$nbr_country >1,] 
#remove spp with sex + asex populations, with 0 or 1 countries or not in a pair
mydf <-mydf[complete.cases(mydf[,1:4]),]
# Dropping all rows from which data was deleted (i.e. containing NA in all columns, taking the 4 first as reference)
lat_range <- mydf$lat_max-mydf$lat_min
mydf <- cbind(mydf,lat_range)
#generating response variable
mydf$lat_range[mydf$lat_range==0] <- 0.1
#---------------------------------------------------------------------------------------
# Comparing latitude range against different distributions:
par(mfrow=c(2,2))
mydf$lat_range[mydf$lat_range==0] <- 0.1
gamma <- fitdistr(mydf$lat_range, "Gamma")
qqp(main="Gamma",mydf$lat_range, "gamma", shape = gamma$estimate[[1]], rate = gamma$estimate[[2]])
qqp(main="Lognormal", mydf$lat_range,"lnorm")
qqp(main="Normal", mydf$lat_range,"norm")
poisson <- fitdistr(mydf$lat_range, "Poisson")
qqp(main="Poisson",mydf$lat_range, "pois", poisson$estimate)

#Do not fit properly to any distribution

# -> using gamma because it seems least bad here. Ask Casper .


#Check for overdispersion
overdisp <- function(model) {vpars <- function(m) {nrow(m)*(nrow(m)+1)/2}
model.df <- sum(sapply(VarCorr(model),vpars))+length(fixef(model))
(rdf <- nrow(model@frame)-model.df)
rp <- residuals(model)
Pearson.chisq <- sum(rp^2)
prat <- Pearson.chisq/rdf
pval <- pchisq(Pearson.chisq, df=rdf, lower.tail=FALSE,log.p=TRUE)
c(chisq=Pearson.chisq,ratio=prat,p=exp(pval))}
overdisp(m.lat_range) #yes, overdispersed

country_means <- tapply(mydf$lat_range, mydf$genus, mean)
country_vars <- tapply(mydf$lat_range, mydf$genus, var)
plot(country_vars~country_means)
abline(c(0,1)) 
#ehm, not sure points are above the curve, so probably yes

#correct for overdispersion
obs_level <- factor(1:length(mydf$lat_range))
mydf$pair <- as.factor(mydf$pair)

m.lat_range <- glmer(lat_range ~ mode + (1| family / genus), data=mydf,family="Gamma")
dispersion_glmer(m.lat_range)

m.lat_range <- glmer(lat_range ~ mode + (1| family / genus)+(1|obs_level), data=mydf,family="Gamma")
summary(m.lat_range)
#Warning saying the model failed to converge and has a very large eigen value -> ask casper
# p=6.5e-9

#Trying with PQL anyway:
PQLlat_range <- glmmPQL(data=mydf,lat_range ~ mode, ~1|family/genus, family = "Gamma", verbose = FALSE)
summary(PQLlat_range)
#Same, p-value is extremely small(displayed as 0 in this function)
# This is the case both with and without correcting for overdispersion
# Getting warning about more random effects than observation when correcting
