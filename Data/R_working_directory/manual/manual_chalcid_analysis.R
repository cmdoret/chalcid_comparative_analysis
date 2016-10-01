setwd("/home/cyril/Documents/Internship/Data/R_working_directory/manual")

raw <-read.table("manual_raw_data.csv", header = T, sep= ",")


#================================================================
#Modifying data structure:
-----------------------------------------------------------------
#Splitting body_length_mm column into 2 columns

body <- raw[,"body_length"]
bodmin <-rep(0,times=length(body))
bodmax <-bodmin
count <- 1
for(i in body){
  split_len <- strsplit(x = as.character(i), split = "-",fixed = T)
  print(i)
  print(split_len)
  if(length(split_len[[1]])==1){
    bodmin[count] <- as.numeric(split_len[[1]][1])
    bodmax[count] <- bodmin[count]
    print(bodmin[count])
  }
  else{
    bodmin[count] <- as.numeric(split_len[[1]][1])
    bodmax[count] <- as.numeric(split_len[[1]][2])
  }
  count <- count+1
}

#----------------------------------------------------------------
#Splitting distribution column into multiple columns
dist <- raw[,"distribution"]
e <-rep(0,times=length(dist))
terra <- data.frame(Nearctic = e,Neotropical = e, W.Palearctic = e, Ethiopian = e, E.Palearctic = e, Oriental = e, Australasian = e)
count <- 1
for(n in dist){
  if(as.character(n)=="WW"){
    terra[count,1:7]<- 1
  }
  else{
    for(k in as.character(seq(1,7))){
      if(grepl(k,n)){
        terra[count,as.numeric(k)] <- 1
      }
    }   
  }
  count <- count + 1
}
#----------------------------------------------------------------
# Separating minimum, maximum, min and median coordinates:
min_coor <- raw[,"coord_lower"]
max_coor <- raw[,"coord_upper"]
mean_coor <- raw[,"coord_mean"]
median_coor <- raw[,"coord_median"]
lat_min = lon_min = lat_max = lon_max = lat_mean = lon_mean = lat_median = lon_median <- rep(0,times=length(min_coor))
# For lower coordinates
count <- 1
for(i in min_coor){
  split_min_coor <- strsplit(x = as.character(i), split = ";",fixed = T)
  lat_min[count] <- as.numeric(split_min_coor[[1]][1])
  lon_min[count] <- as.numeric(split_min_coor[[1]][2])
  count <- count+1
}
# For upper coordinates:
count <- 1
for(i in max_coor){
  split_max_coor <- strsplit(x = as.character(i), split = ";",fixed = T)
  lat_max[count] <- as.numeric(split_max_coor[[1]][1])
  lon_max[count] <- as.numeric(split_max_coor[[1]][2])
  count <- count+1
}
# For mean coordinates:
count <- 1
for(i in mean_coor){
  split_mean_coor <- strsplit(x = as.character(i), split = ";",fixed = T)
  lat_mean[count] <- as.numeric(split_mean_coor[[1]][1])
  lon_mean[count] <- as.numeric(split_mean_coor[[1]][2])
  count <- count+1
}
# For median coordinates:
count <- 1
for(i in median_coor){
  split_median_coor <- strsplit(x = as.character(i), split = ";",fixed = T)
  lat_median[count] <- as.numeric(split_median_coor[[1]][1])
  lon_median[count] <- as.numeric(split_median_coor[[1]][2])
  count <- count+1
}
geo <- data.frame(lat_min,lon_min,lat_max,lon_max,lat_mean,lon_mean,lat_median,lon_median)
#----------------------------------------------------------------
# Same with development time:
dev_time <- raw[,"development_time_days"]
t_min <-rep(0,times=length(dev_time))
t_max <-t_min
count <- 1
for(i in dev_time){
  split_dev <- strsplit(x = as.character(i), split = "-",fixed = T)
  if(length(split_dev[[1]])==1){
    t_min[count] <- as.numeric(split_dev[[1]][1])
    t_max[count] <- t_min[count]
  }
  else{
    t_min[count] <- as.numeric(split_dev[[1]][1])
    t_max[count] <- as.numeric(split_dev[[1]][2])
  }
  count <- count+1
}

eco <- rep("par", length(raw$species))
for(i in 1:length(raw$species))
{
  if (!is.na(sum(raw[i,13:23]))  & !is.na(sum(raw[i,13:23])))
  {
    if (sum(raw[i,13:23])>0)
    {
      if (sum(raw[i,24:26])>0)
      {
        eco[i] <- "par"
      }
      else
      {
        eco[i] <- "par"
      }
    }
    else
    {
      if (sum(raw[i,24:26])>0)
      {
        eco[i] <- "phyt"
      }
      else
      {
        eco[i] <- "NA"
      }
    }
  print(i)
  }
  else 
  {
    eco[i] <- "NA"
  }
}

#================================================================
# Generating new dataframe and creating corresponding csv file:
processed <- data.frame(raw[,1:4],min_length = bodmin,max_length = bodmax,terra,geo,raw[,11:27],min_dev = t_min,max_dev = t_max, eco)
write.table(processed, file = "manual_processed_data.csv", sep = ",",col.names = T,row.names = F)
#================================================================
# General info about the data:
length(processed$species[processed$mode=="sex"])
length(processed$species[processed$mode=="asex"])
for(i in levels(processed$genus)){
  print(i)
  print("Number of asex:")
  print(length(processed$species[na.omit(processed$mode=="asex") & processed$genus==i]))
  print("Number of sex:")
  print(length(processed$species[na.omit(processed$mode=="sex") & processed$genus==i]))
}
for(i in levels(processed$genus)){
  print(i)
  print(length(processed$species[processed$genus==i]))
}
