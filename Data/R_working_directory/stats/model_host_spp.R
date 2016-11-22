library(lattice); library(multcomp); library(lme4); library(arm); library(lmerTest); library("car"); library("MASS");library("AER");library("blmeco");library("MCMCglmm")


#MANUAL DATASET

setwd("/home/cyril/Documents/Internship/chalcid_comparative_analysis/Data/R_working_directory/manual/")
mydf <- read.csv("manual_processed_data.csv", header=T)
mydf <- mydf[mydf$mode !="both" & mydf$nbr_host_spp !=0 & mydf$pair!=0,] 
#remove spp with sex + asex populations, 0 hosts or not in a pair
mydf <-mydf[complete.cases(mydf[,1:4]),]
# Dropping all rows from which data was deleted (i.e. containing NA in all columns, taking the 4 first as reference)

# Comparing nbr of hosts against different distributions:
par(mfrow=c(2,2))
nbinom <- fitdistr(mydf$nbr_host_spp, "Negative Binomial")
qqp(main="Negative binomial",mydf$nbr_host_spp, 
    "nbinom", size = nbinom$estimate[[1]], mu = nbinom$estimate[[2]])
qqp(main="Lognormal", mydf$nbr_host_spp,"lnorm")
qqp(main="Normal", mydf$nbr_host_spp,"norm")
poisson <- fitdistr(mydf$nbr_host_spp[!is.na(mydf$nbr_host_spp)], "Poisson")
qqp(main="Poisson",mydf$nbr_host_spp, "pois", poisson$estimate)


#Fits best to lognormal, but using Poisson because this is count data.
#update: using lognormal because i can

#Check for overdispersion
country_means <- tapply(mydf$nbr_host_spp, mydf$pair, mean)
country_vars <- tapply(mydf$nbr_host_spp, mydf$pair, var)
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
dispersiontest(m.host) #Yes, overdispersed
dispersion_glmer(modelglmer = m.host)


#Poisson: noot using this block because data doesn't fit Poisson
m.host <- glmer(nbr_host_spp ~ mode + (1| genus / pair), data=mydf, family="poisson")
dispersion_glmer(modelglmer = m.host)
#overdispersed, correcting.
obs_level <- factor(1:length(mydf$nbr_host_spp))
m.host <- glmer(nbr_host_spp ~ mode + (1| genus / pair) + (1|obs_level), data=mydf, family="poisson")
summary(m.host)

#lognorm
m.host <- glmer(nbr_host_spp ~ mode + (1| genus / pair), data=mydf, family=gaussian(link="log"))
#model failed to converge
dispersion_glmer(modelglmer = m.host)
#overdispersed, correcting.
m.host <- glmer(nbr_host_spp ~ mode + (1| genus / pair) + (1|obs_level), data=mydf, family=gaussian(link="log"))
summary(m.host)
#Model cannot converge, gooing for PQL

#PQL
PQL.host <- glmmPQL(nbr_host_spp ~mode, ~ 1|genus/pair, data=mydf, family=gaussian(link="log"))
summary(PQL.host)
#OK, pvalue=0.0292
#=========================================================================================================
#AUTO DATASET

setwd("/home/cyril/Documents/Internship/Data/R_working_directory/auto/")
mydf <- read.csv("auto_processed_data.csv", header=T)
mydf <- mydf[mydf$mode !="both" & mydf$host_spp !=0,] 
#remove spp with sex + asex populations, 0 hosts or not in a pair
mydf <-mydf[complete.cases(mydf[,1:4]),]
# Dropping all rows from which data was deleted (i.e. containing NA in all columns, taking the 4 first as reference)

# Comparing nbr of hosts against different distributions:
par(mfrow=c(2,2))
nbinom <- fitdistr(mydf$host_spp, "Negative Binomial")
qqp(main="Negative binomial",mydf$host_spp, 
    "nbinom", size = nbinom$estimate[[1]], mu = nbinom$estimate[[2]])
qqp(main="Lognormal", mydf$host_spp,"lnorm")
qqp(main="Normal", mydf$host_spp,"norm")
poisson <- fitdistr(mydf$host_spp[!is.na(mydf$host_spp)], "Poisson")
qqp(main="Poisson",mydf$host_spp, "pois", poisson$estimate)
#Doesn't fit any

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

host_means <- tapply(mydf$host_spp, mydf$genus, mean)
host_vars <- tapply(mydf$host_spp, mydf$genus, var)
plot(host_vars~host_means)
abline(c(0,1)) #yes, overdispersed

#correct for overdispersion
obs_level <- factor(1:length(mydf$host_spp))
m.host <- glmer(host_spp ~ mode + (1| family / genus) + (1|obs_level), data=mydf, family="poisson")
summary(m.host)
summary(m.host)
#not using this because it doesn't fit distribution. Going for MCMC

#Trying MonteCarlo Markov Chain glm
mydf <-within(mydf, rm("family"))
mydf <-cbind(mydf,obs_level)
prior = list(R = list(V = 1, n = 0, fix = 1), G = list(G1 = list(V = 1, n = 1),
                                                       G2 = list(V = 1, n = 1)))

MCMC <- MCMCglmm(host_spp ~ 1 + mode, random = ~genus,
                 data = mydf, verbose = FALSE)
summary(MCMC)
# cool, got a CI95[-14.46;-11.04] with p<0.001
