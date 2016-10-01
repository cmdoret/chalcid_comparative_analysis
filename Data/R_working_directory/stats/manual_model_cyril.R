rm(list=ls()); 
library(lattice); library(multcomp); library(lme4); library(arm); library(lmerTest); library("car"); library("MASS")
setwd("/home/cyril/Documents/Internship/Data/R_working_directory/manual/")
#MANUAL mydfSET
mydf <- read.csv("manual_processed_data.csv", header=T)
mydf <- mydf[mydf$mode !="both" & mydf$nbr_country !=0 & mydf$nbr_host_spp !=0 & mydf$pair!=0,] 
#remove spp with sex + asex populations, with 0 countries, 0 hosts or not in a pair
mydf <-mydf[complete.cases(mydf[,1:4]),]
# Dropping all rows from which data was deleted (i.e. containing NA in all columns, taking the 4 first as reference)

#DISTRIBUTION:

# Comparing nbr of countries against different distributions:
par(mfrow=c(2,2))
nbinom <- fitdistr(mydf$nbr_country, "Negative Binomial")
qqp(main="Negative binomial",mydf$nbr_country, 
    "nbinom", size = nbinom$estimate[[1]], mu = nbinom$estimate[[2]])
qqp(main="Lognormal", mydf$nbr_country,"lnorm")
qqp(main="Normal", mydf$nbr_country,"norm")
poisson <- fitdistr(mydf$nbr_country[!is.na(mydf$nbr_country)], "Poisson")
qqp(main="Poisson",mydf$nbr_country, "pois", poisson$estimate)

# Our data for number of countries fits best with the lognormal distribution.
# Since the data is not normal we need to use a glmm. Because the response variable fits a distribution with continous 
# distribution (as opposed to discrete counts distribution like poisson and binomial), we can use Penalized Quasilikelihood (PQL).
# PQL GLM is available in the MASS package via the glmmPQL function.

# Model based on Penalized Quasilikelihood (PQL):
mydf$pair <- factor(mydf$pair)
PQLcountry <- glmmPQL(data=mydf,nbr_country ~ mode, ~1|genus/pair, family = gaussian(link = "log"), verbose = FALSE)
# Note: Formula is structured differently, because the glmmPQL function takes random effects in a separate argument.
summary(PQLcountry)

# Casper's model, based on LaPlace approximation
bwplot(mydf$nbr_country~mydf$mode|mydf$genus)
m.country <- glmer(nbr_country ~ mode + (1| genus / pair), data=mydf, family="poisson")
summary(m.country)

# Both models return infinitisely small p-values


#extract the random effects
par(mfrow=c(1,2))
#PQL:
rPQLcountry <- ranef(PQLcountry, condVar=T) 
dotplot(rPQLcountry) #Not working, probably because the function for PQL models returns differently structured data.
qqnorm(rPQLcountry[[1]][,1])
qqline(rPQLcountry[[1]][,1])
#Laplace:
rcountry <- ranef(m.country, condVar=T)
dotplot(rcountry)
qqnorm(rcountry[[1]][,1])
qqline(rcountry[[1]][,1])
#Weird: PQL model seems to display only genera on the plot, while Laplace model displays every species.

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

#correct for overdispersion
obs_level <- factor(1:length(mydf$nbr_country))
#PQL model:
PQLcountry2 <- glmmPQL(data=mydf,nbr_country ~ mode, ~obs_level + 1|genus/pair, family = gaussian(link = "log"), verbose = FALSE)
#Does not work with PQL, violates assumption? wrong formula ?
summary(m.country2)

#Laplace model:
m.country2 <- update (m.country, .~.+(1|obs_level))
summary(m.country2)
#Works, but oddly significant result

ran.country2 <- ranef(m.country2, condVar=T)
dotplot(ran.country2)
qqnorm(m.country2[[1]][,1])
qqline(m.country2[[1]][,1])
densityplot(m.country2[[2]][,1], xlab="Random Effect")
overdisp(m.country2)

#What about the random effects?
m.country2fix <- glm (nbr_country ~ mode, data=mydf, family="poisson")
summary(m.country2fix)
anova (m.country2, m.country2fix, test="Chi")

#alternative: calculate likelihoods manually
llA <- as.numeric(logLik(m.country2))
llC <- as.numeric(logLik(m.country2fix))
lrt <- 2*(llC-llA)
lrt_a <-sqrt(lrt^2)
(sig <- pchisq(lrt_a, df=2, lower.tail=F))

m.country3 <- glmer (nbr_country ~ mode + (1 | obs_level), data=mydf, family="poisson")
PQLcountry3 <- glmmPQL(data=mydf,nbr_country ~ mode, ~1|obs_level, family = gaussian(link = "log"), verbose = FALSE)
summary(m.country3)
summary(PQL3)


anova(m.country2, m.country3, test="Chi")
llC2 <- as.numeric(logLik(m.country3))
lrt2 <- 2*(llC2-llA)
lrt_a2 <-sqrt(lrt^2)
(sig <- pchisq(lrt_a2, df=3, lower.tail=F))


#Plotting residuals of the model against fitted values. 
par(mfrow=c(3,2))
count <- 1
for(i in c(m.country,m.country2,m.country3))
{
  plot(fitted(i), residuals(i), xlab = "Fitted Values", ylab = "Residuals", main=paste0("m.country",count))
  abline(h = 0, lty = 2)
  lines(smooth.spline(fitted(i), residuals(i)))
  count <- count+1
  
}
plot(fitted(PQLcountry), residuals(PQLcountry), xlab = "Fitted Values", ylab = "Residuals",main="PQLcountry")
abline(h = 0, lty = 2)
lines(smooth.spline(fitted(PQLcountry), residuals(PQLcountry)))

plot(fitted(PQLcountry3), residuals(PQLcountry3), xlab = "Fitted Values", ylab = "Residuals", main="PQLcountry3")
abline(h = 0, lty = 2)
lines(smooth.spline(fitted(PQLcountry3), residuals(PQLcountry3)))
#http://ase.tufts.edu/gsc/gradresources/guidetomixedmodelsinr/mixed%20model%20guide.html

#Number of HOST SPECIES

# Comparing nbr of host species against different distributions:
par(mfrow=c(2,2))
nbinom <- fitdistr(mydf$nbr_host_spp, "Negative Binomial")
qqp(main="Negative binomial",mydf$nbr_host_spp, 
    "nbinom", size = nbinom$estimate[[1]], mu = nbinom$estimate[[2]])
qqp(main="Lognormal", mydf$nbr_host_spp,"lnorm")
qqp(main="Normal", mydf$nbr_host_spp,"norm")
poisson <- fitdistr(mydf$nbr_host_spp[!is.na(mydf$nbr_host_spp)], "Poisson")
qqp(main="Poisson",mydf$nbr_host_spp, "pois", poisson$estimate)

# Our data for number of host species fits best with the lognormal distribution.
# Since the data is not normal we need to use a glmm. Because the response variable fits a distribution with continous 
# distribution (as opposed to discrete counts distribution like poisson and binomial), we can use Penalized Quasilikelihood (PQL).
# PQL GLM is available in the MASS package via the glmmPQL function.


bwplot(mydf$nbr_host_spp~mydf$mode|mydf$genus)
m.host <- glmer(nbr_host_spp ~ mode + (1| genus / pair), mydf=mydf, family="poisson")
summary(m.host)
ran.host <- ranef(m.host,condVar=T)
dotplot(ran.host)
#log likelihood ratio test
qqnorm(ran.host[[1]][,1])
qqline(ran.host[[1]][,1])

overdisp(m.host)
host_means <- tapply(mydf$nbr_host, mydf$pair, mean)
host_vars <- tapply(mydf$nbr_host, mydf$pair, var)
plot(host_vars~host_means)
abline(c(0,1))

obs_level_host <- factor(1:length(mydf$nbr_host))
m.host2 <- update (m.host, .~.+(1|obs_level_host))
summary(m.host2)
ran.host2 <- ranef(m.host2, condVar=T)
dotplot(ran.host2)
qqnorm(ran.host2[[1]][,1])
qqline(ran.host2[[1]][,1])

m.host2fix <- glm (nbr_host_spp ~ mode, mydf=mydf, family="poisson")
summary(m.host2fix)
anova (m.host2, m.host2fix, test="Chi")

m.host3 <- glmer (nbr_host_spp ~ mode + (1|obs_level_host), mydf=mydf, family="poisson")
anova(m.host2, m.host3)

summary(m.host2)

#Calculate percentage variance components
#vc <- as.mydf.frame(VarCorr(m.country), comp="Variance")
#vc <- 100*vc$vcov/sum(vc$vcov)
#plot(vc)
#coplot(log(mydf$mean_length)~mydf$genus|mydf$pair)

#LOOK UP 
#multcomp - glht
#posthoc test with e.g. tuckey
#http://jaredknowles.com/journal/2013/11/25/getting-started-with-mixed-effect-models-in-r
#LmerTest
#difflsmeans ()
