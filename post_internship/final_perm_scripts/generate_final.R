# These few lines generate the final auto_data file by merging input files. It requires: 
# - file with number of references
# - file with minimum distance to equator (generated using real_min_dist_eq.R)
# - file with the whole data (taxo,geo,host)


data0 <- read.csv("~/Documents/Internship/Data/R_working_directory/auto/auto_processed_data.csv", header=T)
mindist <- read.csv("~/Dropbox/Cyril-Casper_shared/post_internship/separate_poles/new_min_dist.txt",header=T)
citat <-read.csv("~/Dropbox/Cyril-Casper_shared/Internship_tidy/Data/auto/auto_citations_per_species.csv", header=T)
data <- merge(x=data0, y=citat, by.x=c("family","genus","species"), by.y=c("family","genus","species"), all=F)
data <- merge(x=data, y=mindist, by.x=c("family","genus","species"), by.y=c("family","genus","species"), all=F)

data$max_dist_eq <- pmax(abs(data$lat_min),abs(data$lat_max))


data$lat_range <- abs(data$lat_max-data$lat_min)
data$lat_range[data$lat_range == 0] <- 0.001

#=============================

# for manual data
# min distance were obtained using my old coords.py script and format the output (commas between genus and species)
data <- read.csv("~/Dropbox/Cyril-Casper_shared/for_publication/manual_data.csv",header=T)
mindist <- read.csv("places.txt",header=T)
mindist <- mindist[,c(1,2,8)]
data$max_dist_eq <- pmax(abs(data$lat_min),abs(data$lat_max))
data$lat_range <- abs(data$lat_max-data$lat_min)
data$lat_range[data$lat_range == 0] <- 0.001
data <- data <- merge(x=data, y=mindist, by.x=c("genus","species"), by.y=c("genus","species"), all=F)
write.csv(data,"manual_data.csv",row.names = F,quote = F)
