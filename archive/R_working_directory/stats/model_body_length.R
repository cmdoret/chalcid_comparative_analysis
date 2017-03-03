library(lattice); library(multcomp); library(lme4); library(arm); library(lmerTest); library("car"); library("MASS");library("blmeco")
#plot models residuals instead of ratios (test)
#check if there is another function in lme4 --> bootstrap model to deal with werird distribution
# nested randomization of mode
# 

#MANUAL DATASET

setwd("/home/cyril/Documents/Internship/Data/R_working_directory/manual/")
mydf <- read.csv("manual_processed_data.csv", header=T)
mydf <- mydf[mydf$mode !="both" & !is.na(mydf$max_length) & mydf$pair!=0,] 
#remove spp with sex + asex populations, with 0 countries, 0 hosts or not in a pair
mydf <-mydf[complete.cases(mydf[,1:4]),]
# Dropping all rows from which data was deleted (i.e. containing NA in all columns, taking the 4 first as reference)
body_length <- rowMeans(mydf[,5:6])
mydf <- cbind(mydf,body_length)
#Using mean of min and max length


# Comparing nbr of countries against different distributions:

par(mfrow=c(2,2))
gamma <- fitdistr(mydf$body_length, "Gamma")
qqp(main="Gamma",mydf$body_length, "gamma", shape = gamma$estimate[[1]], rate = gamma$estimate[[2]])
qqp(main="Lognormal", mydf$body_length,"lnorm")
qqp(main="Normal", mydf$body_length,"norm")
poisson <- fitdistr(mydf$body_length[!is.na(mydf$body_length)], "Poisson")
qqp(main="Poisson",mydf$body_length, "pois", poisson$estimate)
# lognormal = least bad

hist(mydf$body_length)

qqnorm(log(mydf$body_length))
qqline(log(mydf$body_length))
#Check for overdispersion
par(mfrow=c(1,1))
length_means <- tapply(mydf$body_length, mydf$pair, mean)
length_vars <- tapply(mydf$body_length, mydf$pair, var)
plot(length_vars~length_means)
abline(c(0,1))
overdisp <- function(model) {vpars <- function(m) {nrow(m)*(nrow(m)+1)/2}
model.df <- sum(sapply(VarCorr(model),vpars))+length(fixef(model))
(rdf <- nrow(model@frame)-model.df)
rp <- residuals(model)
Pearson.chisq <- sum(rp^2)
prat <- Pearson.chisq/rdf
pval <- pchisq(Pearson.chisq, df=rdf, lower.tail=FALSE,log.p=TRUE)
c(chisq=Pearson.chisq,ratio=prat,p=exp(pval))}
overdisp(m.length) 
#looks okay

m.length <- glmer(body_length ~ mode + (1| genus / pair), data=mydf, family=gaussian(link="log"))
dispersion_glmer(m.length)
residuals.glm(m.length)
#overdispersed, correcting
obs_level <- factor(1:length(mydf$body_length))
m.length <- glmer(body_length ~ mode + (1| genus / pair) + (1|obs_level), data=mydf, family=gaussian(link="log"))
# Error : cannot converge


#Meh, getting warnings because values are not integers... other model required ?
#FIXED: cannot fit a non-count data to Poisson -> changed to lognorm
# Trying PQL because... reasons
mydf$pair <- factor(mydf$pair)
# Using lognormal, kinda fits the data
PQLlength <- glmmPQL(data=mydf,body_length ~ mode, ~1|genus/pair, family = gaussian(link = "log"), verbose = FALSE)
summary(PQLlength)
residuals.glm(PQLlength)
#Note: both models are pretty similar: Laplace gives p-value=0.42 for mode, while PQL gives 0.46
#Anyway, there is no effect (PQL forbidden here: mean is <5)
