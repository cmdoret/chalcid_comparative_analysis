library(lattice); library(multcomp); library(lme4); library(arm); library(lmerTest); library("car"); library("MASS");library("MCMCglmm");library("blmeco")


#MANUAL DATASET

setwd("/home/cyril/Documents/Internship/Data/R_working_directory/manual/")
mydf <- read.csv("manual_processed_data.csv", header=T)
mydf <- mydf[mydf$mode !="both" & !is.na(mydf$nbr_country) & mydf$nbr_country !=0 & mydf$pair!=0,] 
#remove spp with sex + asex populations, with 0 countries, 0 hosts or not in a pair
mydf <-mydf[complete.cases(mydf[,1:4]),]
# Dropping all rows from which data was deleted (i.e. containing NA in all columns, taking the 4 first as reference)

max_dist_eq <- pmax(abs(mydf$lat_min),abs(mydf$lat_max))
mydf <- cbind(mydf,max_dist_eq)
#generating response variable

#------------------------------------------------------------------------------------------
# Comparing distance from equator against different distributions:
par(mfrow=c(2,2))
nbinom <- fitdistr(mydf$max_dist_eq[!is.na(mydf$max_dist_eq)], "Negative Binomial")
gamma <- fitdistr(mydf$max_dist_eq, "Gamma")
qqp(main="Gamma",mydf$max_dist_eq, "gamma", shape = gamma$estimate[[1]], rate = gamma$estimate[[2]])
qqp(main="Lognormal", mydf$max_dist_eq,"lnorm")
qqp(main="Normal", mydf$max_dist_eq,"norm")
poisson <- fitdistr(mydf$max_dist_eq[!is.na(mydf$max_dist_eq)], "Poisson")
qqp(main="Poisson",mydf$max_dist_eq, "pois", poisson$estimate)

qqnorm(mydf$max_dist_eq)
qqline(mydf$max_dist_eq)
shapiro.test(mydf$max_dist_eq)
densityplot(mydf$max_dist_eq)
#oh, it is normally distributed, for once! (well more or less)

#------------------------------------------------------------------------------------------
#Check for overdispersion
max_dist_eq_means <- tapply(mydf$max_dist_eq, mydf$pair, mean)
max_dist_eq_vars <- tapply(mydf$max_dist_eq, mydf$pair, var)
plot(max_dist_eq_vars~max_dist_eq_means)
abline(c(0,1))
overdisp <- function(model) {vpars <- function(m) {nrow(m)*(nrow(m)+1)/2}
model.df <- sum(sapply(VarCorr(model),vpars))+length(fixef(model))
(rdf <- nrow(model@frame)-model.df)
rp <- residuals(model)
Pearson.chisq <- sum(rp^2)
prat <- Pearson.chisq/rdf
pval <- pchisq(Pearson.chisq, df=rdf, lower.tail=FALSE,log.p=TRUE)
c(chisq=Pearson.chisq,ratio=prat,p=exp(pval))}
overdisp(m.max_dist_eq) 

#I don't know, p-value = 0 so i guess it is overdispersed


#--------------------------------------------------------------------------------------------
obs_level <- factor(1:length(mydf$max_dist_eq))
mydf$pair <- as.factor(mydf$pair)
mydf<-mydf[!is.na(max_dist_eq),]
m.max_dist_eq <- lmer(max_dist_eq ~ mode + (1| genus / pair), data=mydf)
dispersion_glmer(m.max_dist_eq)
#overdispersed
m.max_dist_eq <- lmer(max_dist_eq ~ mode + (1| genus / pair) + (1 | obs_level), data=mydf)
#ehm... won't work because there are not more observations than factor levels.

summary(m.max_dist_eq)
#Yay! significant (0.0126), testing with PQL out of curiosity
#ok, this one was without correction, wrong

PQLmax_dist_eq <- glmmPQL(data=mydf,max_dist_eq ~ mode, ~1|genus/pair, family = gaussian(link = "identity"), verbose = FALSE)
summary(PQLmax_dist_eq)

#Not correcting
#Getting 0.0126 with Laplace and 0.0132 with PQL, really nice -> significant

#Correcting
#Getting 0.0789 with PQL and Laplace won't work -> not significant

#Trying MonteCarlo Markov Chain glm
mydf <-within(mydf, rm("family"))
mydf <-cbind(mydf,obs_level)
prior = list(R = list(V = 1, n = 0, fix = 1), G = list(G1 = list(V = 1, n = 1),
                                                       G2 = list(V = 1, n = 1),
                                                       G3 = list(V = 1, n = 1)))

MCMC <- MCMCglmm(max_dist_eq ~ 1 + mode, random = ~genus:pair, 
                 data = mydf, verbose = FALSE)
summary(MCMC)

#============================================================================================
#AUTO DATASET

setwd("/home/cyril/Documents/Internship/Data/R_working_directory/auto/")
mydf <- read.csv("auto_processed_data.csv", header=T)
mydf <- mydf[mydf$mode !="both" & mydf$nbr_country !=0,] 
#remove spp with sex + asex populations, with 0 countries, 0 hosts or not in a pair
mydf <-mydf[complete.cases(mydf[,1:4]),]
# Dropping all rows from which data was deleted (i.e. containing NA in all columns, taking the 4 first as reference)
max_dist_eq <- pmax(abs(mydf$lat_min),abs(mydf$lat_max))
mydf <- cbind(mydf,max_dist_eq)
#generating response variable

#---------------------------------------------------------------------------------------
# Comparing distance from equator against different distributions:
par(mfrow=c(2,2))
nbinom <- fitdistr(mydf$max_dist_eq[!is.na(mydf$max_dist_eq)], "Negative Binomial")
qqp(main="Negative binomial",mydf$max_dist_eq, 
    "nbinom", size = nbinom$estimate[[1]], mu = nbinom$estimate[[2]])
qqp(main="Lognormal", mydf$max_dist_eq,"lnorm")
qqp(main="Normal", mydf$max_dist_eq,"norm")
poisson <- fitdistr(mydf$max_dist_eq[!is.na(mydf$max_dist_eq)], "Poisson")
qqp(main="Poisson",mydf$max_dist_eq, "pois", poisson$estimate)
#Do not fit properly to any distribution (looks like it's because of the poles; our data stops increasing 
#after reaching ~polar circle, which is to be expected in this context)

# -> using normal because it fits well, except for the extremes.

qqnorm(mydf$max_dist_eq)
qqline(mydf$max_dist_eq)

#Check for overdispersion
overdisp <- function(model) {vpars <- function(m) {nrow(m)*(nrow(m)+1)/2}
model.df <- sum(sapply(VarCorr(model),vpars))+length(fixef(model))
(rdf <- nrow(model@frame)-model.df)
rp <- residuals(model)
Pearson.chisq <- sum(rp^2)
prat <- Pearson.chisq/rdf
pval <- pchisq(Pearson.chisq, df=rdf, lower.tail=FALSE,log.p=TRUE)
c(chisq=Pearson.chisq,ratio=prat,p=exp(pval))}
overdisp(m.max_dist_eq) #yes, overdispersed

country_means <- tapply(mydf$max_dist_eq, mydf$genus, mean)
country_vars <- tapply(mydf$max_dist_eq, mydf$genus, var)
plot(country_vars~country_means)
abline(c(0,1)) 
#ehm, not sure points are above the curve, so probably yes


mydf$pair <- as.factor(mydf$pair)

m.max_dist_eq <- lmer(max_dist_eq ~ mode + (1| family / genus), data=mydf)
dispersion_glmer(m.max_dist_eq)
#overdipsersed, correcting
#Since data is normally distributed I used a linear model (not generalized), however i am not sure about
obs_level <- factor(1:length(mydf$max_dist_eq))

#Trying with PQL anyway:
PQLmax_dist_eq <- glmmPQL(data=mydf,max_dist_eq ~ mode, ~1|family/genus + 1|obs_level, family = gaussian(link = "log"), verbose = FALSE)
summary(PQLmax_dist_eq)
#Same, p-value is extremely small(displayed as 0 in this function)

#Trying MonteCarlo Markov Chain glm
mydf <-within(mydf, rm("family"))
mydf <-cbind(mydf,obs_level)
prior = list(R = list(V = 1, n = 0, fix = 1), G = list(G1 = list(V = 1, n = 1),
                                                       G2 = list(V = 1, n = 1)))

MCMC <- MCMCglmm(max_dist_eq ~ 1 + mode, random = ~genus + obs_level,
                 data = mydf, verbose = FALSE,prior=prior)
summary(MCMC)
