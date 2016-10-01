library(lattice); library(multcomp); library(lme4); library(arm); library(lmerTest); library("car"); library("MASS"); library("MCMCglmm");library("blmeco")


#MANUAL DATASET

setwd("/home/cyril/Documents/Internship/Data/R_working_directory/manual/")
mydf <- read.csv("manual_processed_data.csv", header=T)
mydf <- mydf[mydf$mode !="both" & mydf$nbr_country !=0 & mydf$pair!=0,] 
#remove spp with sex + asex populations, with 0 countries, 0 hosts or not in a pair
mydf <-mydf[complete.cases(mydf[,1:4]),]
# Dropping all rows from which data was deleted (i.e. containing NA in all columns, taking the 4 first as reference)

# Comparing nbr of countries against different distributions:
par(mfrow=c(2,2))
gamma <- fitdistr(mydf$nbr_country, "gamma")
qqp(main="gamma",mydf$nbr_country, 
    "gamma", shape = gamma$estimate[[1]], rate = gamma$estimate[[2]])
qqp(main="Lognormal", mydf$nbr_country,"lnorm")
qqp(main="Normal", mydf$nbr_country,"norm")
poisson <- fitdistr(mydf$nbr_country[!is.na(mydf$nbr_country)], "Poisson")
qqp(main="Poisson",mydf$nbr_country, "pois", poisson$estimate)
#Fits best on lognorm, but count data -> poisson
#update: ok we can use lognorm

#Check for overdispersion
country_means <- tapply(mydf$nbr_country, mydf$pair, mean)
country_vars <- tapply(mydf$nbr_country, mydf$pair, var)
plot(country_vars~country_means)
abline(c(0,1))
overdisp <- function(model) {vpars <- function(m) {nrow(m)*(nrow(m)+1)/2}
model.df <- sum(sapply(VarCorr(model),vpars))+length(fixef(model))
(rdf <- nrow(model@frame)-model.df)
rp <- residuals(model)
Pearson.chisq <- sum(rp^2)
prat <- Pearson.chisq/rdf
pval <- pchisq(Pearson.chisq, df=rdf, lower.tail=FALSE,log.p=TRUE)
c(chisq=Pearson.chisq,ratio=prat,p=exp(pval))}
overdisp(m.country) #Yes, overdispersed




m.country <- glmer(nbr_country ~ mode + (1| genus / pair), data=mydf, family=gaussian(link="log"))
dispersion_glmer(modelglmer = m.country)
#overdispersed, correcting
obs_level <- factor(1:length(mydf$nbr_country))
m.country <- glmer(nbr_country ~ mode + (1| genus / pair) + (1|obs_level), data=mydf, family=gaussian(link="log"))
#cannot converge with a lognormal distribution, using PQL instead

# Go for PQL ?
PQL.country <- glmmPQL(nbr_country ~ mode, ~1|genus/pair, data=mydf, family=gaussian(link='log'))
summary(PQL.country)
ranef.PQL.country <- ranef(PQL.country)
order(ranef.PQL.country[[1]])
plot(rr.order)

# Meh... not significant 
#EDIT: No need to correct in PQL's

#Trying MonteCarlo Markov Chain glm
mydf <-within(mydf, rm("family"))
mydf <-cbind(mydf,obs_level)
prior = list(R = list(V = 1, n = 0, fix = 1), G = list(G1 = list(V = 1, n = 1),
                                                       G2 = list(V = 1, n = 1),
                                                       G3 = list(V = 1, n = 1)))

MCMC <- MCMCglmm(nbr_country ~ 1 + mode, random = ~genus:pair,
                 data = mydf, verbose = FALSE)
summary(MCMC)
# not sure about how to set priors, left empty also the function would not accept genus/pair, had to change syntaxe, ask casper
# WARNING: MCMC removed an effect because it was "not estimable" probably obs_level becasuse levels=sample size
# yields p=0.01 and CI95[-15.995; -2.568] for modesex
#CI is very large, probably the reason I don't get a significant value with PQL (too much variance)
# Should probably stick to the non-significant PQL. Distribution fits well.

#=====================================================================================================
#AUTO DATASET

setwd("/home/cyril/Documents/Internship/Data/R_working_directory/auto/")
mydf <- read.csv("auto_processed_data.csv", header=T)
mydf <- mydf[mydf$mode !="both" & mydf$nbr_country !=0,] 
#remove spp with sex + asex populations, with 0 countries, 0 hosts or not in a pair
mydf <-mydf[complete.cases(mydf[,1:4]),]
# Dropping all rows from which data was deleted (i.e. containing NA in all columns, taking the 4 first as reference)

# Comparing nbr of countries against different distributions:
par(mfrow=c(2,2))
nbinom <- fitdistr(mydf$nbr_country, "Negative Binomial")
qqp(main="Negative binomial",mydf$nbr_country, 
    "nbinom", size = nbinom$estimate[[1]], mu = nbinom$estimate[[2]])
qqp(main="Lognormal", mydf$nbr_country,"lnorm")
qqp(main="Normal", mydf$nbr_country,"norm")
poisson <- fitdistr(mydf$nbr_country[!is.na(mydf$nbr_country)], "Poisson")
qqp(main="Poisson",mydf$nbr_country, "pois", poisson$estimate)


#Check for overdispersion
overdisp <- function(model) {vpars <- function(m) {nrow(m)*(nrow(m)+1)/2}
model.df <- sum(sapply(VarCorr(model),vpars))+length(fixef(model))
(rdf <- nrow(model@frame)-model.df)
rp <- residuals(model)
Pearson.chisq <- sum(rp^2)
prat <- Pearson.chisq/rdf
pval <- pchisq(Pearson.chisq, df=rdf, lower.tail=FALSE,log.p=TRUE)
c(chisq=Pearson.chisq,ratio=prat,p=exp(pval))}
overdisp(m.country) #yes, overdispersed

country_means <- tapply(mydf$nbr_country, mydf$genus, mean)
country_vars <- tapply(mydf$nbr_country, mydf$genus, var)
plot(country_vars~country_means)
abline(c(0,1)) #yes, overdispersed





m.country <- glmer(nbr_country ~ mode + (1| genus), data=mydf, family=gaussian(link="log"))
summary(m.country)
dispersion_glmer(m.country)
#overdispersed, correcting
obs_level <- factor(1:length(mydf$nbr_country))
m.country <- glmer(nbr_country ~ mode + (1| genus) + (1|obs_level), data=mydf, family=gaussian(link="log"))
summary(m.country)
#cannot converge with lognormal, using PQL

PQL.country <- glmmPQL(data=mydf, nbr_country ~ mode, ~ 1|genus + 1|obs_level, family=gaussian(link="log"))
summary(PQL.country)
# can't converge either... we need a bootstrap anyway, it doesn't even fit the lognormal distribution.

#Trying MonteCarlo Markov Chain glm
mydf <-within(mydf, rm("family"))
mydf <-cbind(mydf,obs_level)
prior = list(R = list(V = 1, n = 0, fix = 1), G = list(G1 = list(V = 1, n = 1),
                                                       G2 = list(V = 1, n = 1)))

MCMC <- MCMCglmm(nbr_country ~ 1 + mode, random = ~genus + obs_level,
                 data = mydf, verbose = FALSE,prior=prior)
summary(MCMC)
# not sure about how to set priors, left empty
# p<0.001 and CI95(modesex) [-14.43;-12.17] without  specifying priors. 
# p<0.001 and CI95(modesex) [-14.38;-12.04] when specifying these priors, but not sure this is correct.
