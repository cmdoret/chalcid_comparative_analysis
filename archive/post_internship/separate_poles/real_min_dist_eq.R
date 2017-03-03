mydata <-read.table("/home/cyril/Documents/Internship/Data/R_working_directory/auto/auto_processed_data.csv", header = T, sep= ",")
# Loading auto-dataset


path = "/home/cyril/Documents/Internship/Data/web_scraping/scraped_data/our_geo_per_species_exp/"
setwd(path)
# Folder containing all text files with individual coordinates
sp_mat <- matrix(ncol=4,nrow=length(mydata$species))
file.names <- dir(path, pattern =".txt")  # Storing filenames in a variable
for(i in 1:length(file.names))
  {  # Iterating over file names
  for(j in 1:length(mydata$species))  # Iterating over species names in my list
  {
    if(grepl(paste(mydata$family[j],mydata$genus[j],mydata$species[j],sep="."),file.names[i]))  
      # returns true if filename contains family, genus and species names corresponding to species
    {
      setwd(path)
      file <- read.table(file.names[i],header=FALSE, sep=",",quote = "", stringsAsFactors=FALSE)
      # reading file corresponding to matched species
      min_dist <- min(abs(file[,2]))
      sp_mat[j,] <- c(as.character(mydata$family[j]),as.character(mydata$genus[j]),as.character(mydata$species[j]),min_dist)
      
    }
  }
}
setwd('~/Dropbox/Cyril-Casper_shared/post_internship/separate_poles/')
write.table(sp_mat, append = TRUE, col.names = FALSE, file = 'new_min_dist.txt',sep=',', 
            row.names = FALSE,quote=FALSE)

# Note: whenever coordinate of a species in mydata are unknown, there will be a line of NA in the new file.