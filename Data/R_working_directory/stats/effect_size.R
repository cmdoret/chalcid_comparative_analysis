auto_processed <-read.table("/home/cyril/Documents/Internship/Data/R_working_directory/auto/auto_processed_data.csv", header = T, sep= ",")
manual_processed <-read.table("/home/cyril/Documents/Internship/Data/R_working_directory/manual/manual_processed_data.csv", header = T, sep= ",")
library(ggplot2)
library(gridExtra)
library(lattice)

#Effetct size: automated


max_dist_eq <- pmax(abs(auto_processed$lat_min),abs(auto_processed$lat_max))
lat_range <- auto_processed$lat_max-auto_processed$lat_min
auto_processed <- cbind(auto_processed, lat_range, max_dist_eq)
effect_asex <- c()
effect_sex <- c()
variable_names <- c()



for(var in c("nbr_country", "host_spp", "max_dist_eq", "lat_median", "lat_range")) #loops over variable
{
  restrict <- auto_processed$nbr_country>0 #excluding species with 0 locations
  if(var=="lat_range")
  {
    restrict <- auto_processed$nbr_country>1 #raising exclusion threshold to 1 when computing ranges (to avoid ranges of 0)
  }
  if(var=="host_spp")
  {
    restrict <- auto_processed$host_spp>0 #changing restriction to host species when using this variable
  }
  medgenus_asex <-c() #reseting genus vector
  medgenus_sex <- c() #resetting genus vector
  for(g in levels(auto_processed$genus)) #loops over genera
  {
    tmp_med_asex <- median(auto_processed[auto_processed$genus==g & auto_processed$mode=="asex" & restrict,var],na.rm = T) #computes per genus median for asex spp
    tmp_med_sex <- median(auto_processed[auto_processed$genus==g & auto_processed$mode=="sex" & restrict,var],na.rm = T) #computes per genus median for sex spp
    medgenus_asex <- append(medgenus_asex, tmp_med_asex) #adds it to a vector
    medgenus_sex <- append(medgenus_sex, tmp_med_sex) #adds it to a vector
  }
  variable_names <- append(variable_names, var) # stores variable names for further use
  effect_asex <- append(effect_asex, mean(medgenus_asex,na.rm=T)) # Takes the mean of values from all genera for asex spp
  effect_sex <- append(effect_sex, mean(medgenus_sex,na.rm=T)) #Takes the mean of values from all genera for sex spp
}

df_effect <- data.frame(variable_names, effect_asex, effect_sex)


#Effect size: manual

max_dist_eq <- pmax(abs(manual_processed$lat_min),abs(manual_processed$lat_max))
lat_range <- manual_processed$lat_max-manual_processed$lat_min
body_length <- rowMeans(cbind(manual_processed$min_length,manual_processed$max_length))
manual_processed <- cbind(manual_processed, lat_range, max_dist_eq, body_length)
effect_asex <- c()
effect_sex <- c()
variable_names <- c()


for (var in c("nbr_country", "nbr_host_spp", "body_length","max_dist_eq", "lat_median", "lat_range"))
{
  restrict <- manual_processed$nbr_country>0 #excluding species with 0 locations
  if(var=="lat_range")
  {
    restrict <- manual_processed$nbr_country>1 #raising exclusion threshold to 1 when computing ranges (to avoid ranges of 0)
  }
  if(var=="nbr_host_spp")
  {
    restrict <- manual_processed$nbr_host_spp>0 #changing restriction to host species when using this variable
  }
  medpair_asex <- c()
  medpair_sex <- c()
  for(p in 1:max(manual_processed$pair)) #looping over pairs, excluding pair number 0 since it represents unpaired species
  {
    tmp_med_asex <- median(manual_processed[manual_processed$pair==p & manual_processed$mode=="asex" & restrict,var],na.rm = T) #computes per genus median for asex spp
    tmp_med_sex <- median(manual_processed[manual_processed$pair==p & manual_processed$mode=="sex" & restrict,var],na.rm = T) #computes per genus median for sex spp
    medpair_asex <- append(medpair_asex, tmp_med_asex) #adds it to a vector
    medpair_sex <- append(medpair_sex, tmp_med_sex) #adds it to a vector
  }
  variable_names <- append(variable_names, var) # stores variable names for further use
  effect_asex <- append(effect_asex, mean(medpair_asex,na.rm=T)) # Takes the mean of values from all genera for asex spp
  effect_sex <- append(effect_sex, mean(medpair_sex,na.rm=T)) #Takes the mean of values from all genera for sex spp
}
df_effect <- data.frame(variable_names, effect_asex, effect_sex)