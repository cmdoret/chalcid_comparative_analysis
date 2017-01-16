mydata <-read.table("/home/cyril/Documents/Internship/Data/R_working_directory/auto/auto_processed_data.csv", header = T, sep= ",")

asex.full<-""
sex.full<-""
setwd("/home/cyril/PycharmProjects/internship_geodata/experimental/our_geo_per_species_exp/")
path = "/home/cyril/PycharmProjects/internship_geodata/experimental/our_geo_per_species_exp/"
myasex <- mydata[mydata$mode=="asex",]

# Careful, need to rewrite chunk, atm it could mess up data.
file.names <- dir(path, pattern =".txt")
for(i in 1:length(file.names)){
  nmatch <- 0
  for(j in 1:length(myasex$species))
  {
    if(grepl(paste(myasex$family[j],myasex$genus[j],myasex$species[j],sep="."),file.names[i]))
    {
      setwd('/home/cyril/PycharmProjects/internship_geodata/experimental/our_geo_per_species_exp/')
      file <- read.table(file.names[i],header=FALSE, sep=",",quote = "", stringsAsFactors=FALSE)
      file[,1] <- gsub("'", " ", file[,1])
      taxo <- rep(file.names[i],length(file[,1]))
      fam <- c()
      gen <- c()
      spp <- c()
      for(k in 1:length(taxo))
      {
        taxosplit <- strsplit(taxo[k],split = ".",fixed = T)
        fam <- append(fam,taxosplit[[1]][1])
        gen <- append(gen,taxosplit[[1]][2])
        spp <- append(spp,taxosplit[[1]][3])
      }
      file <- cbind(fam,gen,spp,file)
      asex.full <- rbind(asex.full, file) 
      setwd('/home/cyril/Documents/Internship/Data/R_working_directory/')
      write.table(asex.full, append = TRUE, col.names = FALSE, file = 'all_asex_loc.txt',sep=',', 
                  row.names = FALSE,quote=FALSE)
      nmatch <- 1
      asex.full<-''
      sex.full<-''
    }
  }
  if(nmatch==0)
  {
    setwd('/home/cyril/PycharmProjects/internship_geodata/experimental/our_geo_per_species_exp/')
    file <- read.table(file.names[i],header=FALSE, quote = "", sep=',', stringsAsFactors=FALSE)
    file[,1] <- gsub("'", " ", file[,1])
    taxo <- rep(file.names[i],length(file[,1]))
    fam <- c()
    gen <- c()
    spp <- c()
    for(k in 1:length(taxo))
    {
      taxosplit <- strsplit(taxo[k],split = ".",fixed = T)
      fam <- append(fam,taxosplit[[1]][1])
      gen <- append(gen,taxosplit[[1]][2])
      spp <- append(spp,taxosplit[[1]][3])
    }
    file <- cbind(fam,gen,spp,file)
    sex.full <- rbind(sex.full, file)  
    setwd('/home/cyril/Documents/Internship/Data/R_working_directory/')
    write.table(sex.full, append = TRUE, col.names = FALSE, file = 'all_sex_loc.txt',sep=',', 
                row.names = FALSE,quote=FALSE)
    asex.full<-""
    sex.full<-""
  }
  print(i)
}
