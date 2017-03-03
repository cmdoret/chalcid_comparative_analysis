rm(list=ls()); 
library(lattice); library(multcomp); library(lme4); library(arm); library(lmerTest)
setwd("/home/cyril/Documents/Internship/Data/R_working_directory/manual/")
#MANUAL DATASET
data <- read.csv("manual_processed_data.csv", header=T)
data <- data[!data$mode =="both",] #remove spp with sex + asex populations
data <- data[!data$nbr_country =="0",] #remove species with no countries described
data <- data[!data$nbr_host_spp =="0",] # remove species with no hosts described
data$lcountry <- (log(data$nbr_country))
data$lhost <- (log(data$nbr_host_spp))

hist(data$nbr_country)
hist(data$nbr_host_sp)

#DISTRIBUTION
bwplot(data$nbr_country~data$mode|data$genus)
m.country <- glmer(nbr_country ~ mode + (1| genus / pair), data=data, family="poisson")
summary(m.country)

#extract the random effects
rcountry <- ranef(m.country, condVar=T)
dotplot(rcountry)
qqnorm(rcountry[[1]][,1])
qqline(rcountry[[1]][,1])

#Check for overdispersion
country_means <- tapply(data$nbr_country, data$pair, mean)
country_vars <- tapply(data$nbr_country, data$pair, var)
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
obs_level <- factor(1:length(data$nbr_country))
m.country2 <- update (m.country, .~.+(1|obs_level))
summary(m.country2)

ran.country2 <- ranef(m.country2, condVar=T)
dotplot(ran.country2)
qqnorm(mcountry2[[1]][,1])
qqline(mcountry2[[1]][,1])
densityplot(mcountry2[[2]][,1], xlab="Random Effect")
overdisp(m.country2)

#What about the random effects?
m.country2fix <- glm (nbr_country ~ mode, data=data, family="poisson")
summary(m.country2fix)
anova (m.country2, m.country2fix, test="Chi")

#alternative: calculate likelihoods manually
llA <- as.numeric(logLik(m.country2))
llC <- as.numeric(logLik(m.country2fix))
lrt <- 2*(llC-llA)
lrt_a <-sqrt(lrt^2)
(sig <- pchisq(lrt_a, df=2, lower.tail=F))

m.country3 <- glmer (nbr_country ~ mode + (1 | obs_level), data=data, family="poisson")
anova(m.country2, m.country3, test="Chi")
llC2 <- as.numeric(logLik(m.country3))
lrt2 <- 2*(llC2-llA)
lrt_a2 <-sqrt(lrt^2)
(sig <- pchisq(lrt_a2, df=3, lower.tail=F))

#Number of HOST SPECIES
bwplot(data$nbr_host_spp~data$mode|data$genus)
m.host <- glmer(nbr_host_spp ~ mode + (1| genus / pair), data=data, family="poisson")
summary(m.host)
ran.host <- ranef(m.host,condVar=T)
dotplot(ran.host)
#log likelihood ratio test
qqnorm(ran.host[[1]][,1])
qqline(ran.host[[1]][,1])

overdisp(m.host)
host_means <- tapply(data$nbr_host, data$pair, mean)
host_vars <- tapply(data$nbr_host, data$pair, var)
plot(host_vars~host_means)
abline(c(0,1))

obs_level_host <- factor(1:length(data$nbr_host))
m.host2 <- update (m.host, .~.+(1|obs_level_host))
summary(m.host2)
ran.host2 <- ranef(m.host2, condVar=T)
dotplot(ran.host2)
qqnorm(ran.host2[[1]][,1])
qqline(ran.host2[[1]][,1])

m.host2fix <- glm (nbr_host_spp ~ mode, data=data, family="poisson")
summary(m.host2fix)
anova (m.host2, m.host2fix, test="Chi")

m.host3 <- glmer (nbr_host_spp ~ mode + (1|obs_level_host), data=data, family="poisson")
anova(m.host2, m.host3)

summary(m.host2)


#Calculate percentage variance components
#vc <- as.data.frame(VarCorr(m.country), comp="Variance")
#vc <- 100*vc$vcov/sum(vc$vcov)
#plot(vc)
#coplot(log(data$mean_length)~data$genus|data$pair)

#LOOK UP 
#multcomp - glht
#posthoc test with e.g. tuckey
#http://jaredknowles.com/journal/2013/11/25/getting-started-with-mixed-effect-models-in-r
#LmerTest
#difflsmeans ()
