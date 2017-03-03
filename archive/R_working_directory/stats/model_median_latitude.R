library(lattice); library(multcomp); library(lme4); library(arm); library(lmerTest); library(car); library(MASS);library(blmeco);library(MCMCglmm)
library(gridExtra)


#MANUAL DATASET

setwd("/home/cyril/Documents/Internship/Data/R_working_directory/manual/")
mydf <- read.csv("manual_processed_data.csv", header=T)
mydf <- mydf[mydf$mode !="both" & mydf$nbr_country !=0 & mydf$pair!=0,] 
#remove spp with sex + asex populations, with 0 countries, 0 hosts or not in a pair
mydf <-mydf[complete.cases(mydf[,1:4]),]
# Dropping all rows from which data was deleted (i.e. containing NA in all columns, taking the 4 first as reference)

#------------------------------------------------------------------------------------------
# Comparing distance from equator against different distributions:
par(mfrow=c(2,2))
gamma <- fitdistr(mydf$lat_median, "Gamma")
qqp(main="Gamma",mydf$lat_median, "gamma", shape = gamma$estimate[[1]], rate = gamma$estimate[[2]])
qqp(main="Lognormal", mydf$lat_median,"lnorm")
qqp(main="Normal", mydf$lat_median,"norm")
poisson <- fitdistr(mydf$lat_median[!is.na(mydf$lat_median)], "Poisson")
qqp(main="Poisson",mydf$lat_median, "pois", poisson$estimate)
grid.arrange(nrow=2,
densityplot(mydf$lat_median[mydf$mode=="sex"]),
densityplot(mydf$lat_median[mydf$mode=="asex"]))
#crap! does not fit in any of these distributions...

qqnorm(log(mydf$lat_median[mydf$lat_median!=0]))
qqline(log(mydf$lat_median[mydf$lat_median!=0]))
#If log transformed, it kinds of fits the normal distribution :/
#Ask Casper: not sure, but if my data fits a normal once log-transformed, 
#it should fit equally well lognorm transformation when it it is not (lognorm graph hard to interpret)

#------------------------------------------------------------------------------------------
#Check for overdispersion
lat_median_means <- tapply(mydf$lat_median, mydf$pair, mean)
lat_median_vars <- tapply(mydf$lat_median, mydf$pair, var)
plot(lat_median_vars~lat_median_means)
abline(c(0,1))
overdisp <- function(model) {vpars <- function(m) {nrow(m)*(nrow(m)+1)/2}
model.df <- sum(sapply(VarCorr(model),vpars))+length(fixef(model))
(rdf <- nrow(model@frame)-model.df)
rp <- residuals(model)
Pearson.chisq <- sum(rp^2)
prat <- Pearson.chisq/rdf
pval <- pchisq(Pearson.chisq, df=rdf, lower.tail=FALSE,log.p=TRUE)
c(chisq=Pearson.chisq,ratio=prat,p=exp(pval))}
overdisp(m.median_lat)

#I don't know, points are more or less following the line, except for low values
#...pvalue=0 -> correcting for overdispersion.

#--------------------------------------------------------------------------------------------
obs_level <- factor(1:length(mydf$lat_median))
mydf$pair <- as.factor(mydf$pair)

m.median_lat <- glmer(log(lat_median) ~ mode + (1| genus / pair), data=mydf,family = gaussian(link="identity"))
#not working, probably related to the 0's in my data

summary(m.median_lat)
#nothing works

m.median_lat <- lmer(lat_median ~ mode + (1| genus / pair)+ (1|obs_level), data=mydf)
summary(m.median_lat)

PQLmedian_lat <- glmmPQL(data=mydf,lat_median ~ mode, ~1|genus/pair, family = gaussian(link = "identity"), verbose = FALSE)
summary(PQLmedian_lat)
#PQL: 
#corrected: p=0.18
#non-corrected: p=0.03


#this data is a nightmare, discuss with Casper, always getting obscure error messages caused by log transform
# If I have 0's, it cannot deal with created NAs
# If I remove the 0's, it cries about the length of data...
#Fitting against normal distribution yields a significant result, but this is wrong
#EDIT: I added obs_level. I now get even more obscure warnings, but it works and say it is not significant
# I will stick with that for now.


#Go for MCMC
mydf <-within(mydf, rm("family"))
mydf <-cbind(mydf,obs_level)
prior = list(R = list(V = 1, n = 0, fix = 1), G = list(G1 = list(V = 1, n = 1),
                                                       G2 = list(V = 1, n = 1)))

MCMC <- MCMCglmm(lat_median ~ 1 + mode, random = ~genus:pair,
                 data = mydf, verbose = T)
#looks like it dropped obs_level
summary(MCMC)
#MCMC says p=0.032 & CI95(modesex)=[-15.753;-1.014]


#============================================================================================
#AUTO DATASET

setwd("/home/cyril/Documents/Internship/Data/R_working_directory/auto/")
mydf <- read.csv("auto_processed_data.csv", header=T)
mydf <- mydf[mydf$mode !="both" & mydf$nbr_country !=0,] 
#remove spp with sex + asex populations, with 0 countries, 0 hosts or not in a pair
mydf <-mydf[complete.cases(mydf[,1:4]),]
# Dropping all rows from which data was deleted (i.e. containing NA in all columns, taking the 4 first as reference)
#generating response variable

#---------------------------------------------------------------------------------------
# Comparing distance from equator against different distributions:
par(mfrow=c(2,2))
#nbinom <- fitdistr(mydf$lat_median[!is.na(mydf$lat_median)], "Negative Binomial")
#gamma <- fitdistr(mydf$lat_median[!is.na(mydf$lat_median)],"Gamma")
#qqp(main="gamma, shape=30",mydf$lat_median,"gamma",shape=30) 
qqp(main="Lognormal", mydf$lat_median,"lnorm")
qqp(main="Normal", mydf$lat_median,"norm")
poisson <- fitdistr(mydf$lat_median[!is.na(mydf$lat_median)], "Poisson")
qqp(main="Poisson",mydf$lat_median, "pois", poisson$estimate)
#Do not fit properly to any distribution (looks like it's because of the poles; our data stops increasing 
#after reaching ~polar circle, which is to be expected in this context)

# -> using normal because I used it for manual, and nothing fits well anyways.

qqnorm(mydf$lat_median)
qqline(mydf$lat_median)

#Check for overdispersion
overdisp <- function(model) {vpars <- function(m) {nrow(m)*(nrow(m)+1)/2}
model.df <- sum(sapply(VarCorr(model),vpars))+length(fixef(model))
(rdf <- nrow(model@frame)-model.df)
rp <- residuals(model)
Pearson.chisq <- sum(rp^2)
prat <- Pearson.chisq/rdf
pval <- pchisq(Pearson.chisq, df=rdf, lower.tail=FALSE,log.p=TRUE)
c(chisq=Pearson.chisq,ratio=prat,p=exp(pval))}
overdisp(m.median_lat)
country_means <- tapply(mydf$lat_median, mydf$genus, mean)
country_vars <- tapply(mydf$lat_median, mydf$genus, var)
plot(country_vars~country_means)
abline(c(0,1)) 
#yes, definitely

#correct for overdispersion
obs_level <- factor(1:length(mydf$lat_median))

#CAREFUL, model crashing my R session... weird? will try on desktop
#m.median_lat <- lmer(lat_median ~ mode + (1| family / genus) + obs_level, data=mydf)
#summary(m.median_lat)


#Trying with PQL anyway:
PQLmedian_lat <- glmmPQL(data=mydf,lat_median ~ mode, ~1|family/genus + 1|obs_level, family = gaussian(link = "identity"), verbose = FALSE)
summary(PQLmedian_lat)
#model with observation level yields a p-value = 0.03...significant, but shhould be interpreted carefully, many warnings
# Warnings: "fewer observations than random effects in all level 1 groups" and "In Ops.factor(family, genus) : ‘/’ not meaningful for factors"
# Seems to be caused by observation levels.

# OK, go for MCMC
#Trying MonteCarlo Markov Chain glm
mydf <-within(mydf, rm("family"))
mydf <-cbind(mydf,obs_level)
prior = list(R = list(V = 1, n = 0, fix = 1), G = list(G1 = list(V = 1, n = 1)))

MCMC <- MCMCglmm(lat_median ~ 1 + mode, random = ~genus,
                 data = mydf, verbose = FALSE,prior=prior)
summary(MCMC)
#signif, p<0.001; CI95(modesex)=[-14.659;-6.006]