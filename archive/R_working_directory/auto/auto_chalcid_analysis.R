setwd("/home/cyril/Documents/Internship/Data/R_working_directory/auto/")

raw <-read.table("auto_raw_data.csv", header = T, sep= ",")
blacklist <-read.table("blacklist.csv", header = T, sep= ",")
asexlist <-read.table("asex_list.csv", header = T, sep=",")
phytolist <- read.table("raw_phytophagous.csv", header = T, sep=",")

#================================================================
#Removing species on blacklist:

black_index <- c()
for(i in 1:length(raw$species)){
  for(j in 1:length(blacklist$species)){
    if(paste0(as.character(raw$family[i]), as.character(raw$genus[i]),as.character(raw$species[i])) 
       == paste0(as.character(blacklist$family[j]), as.character(blacklist$genus[j]), as.character(blacklist$species[j]))){
      black_index<-append(black_index,i)
    }
  }
  print(paste(i,length(raw$species),sep='/'))
}
raw <- raw[-black_index,]
rownames(raw) <- 1:length(raw$species)

#================================================================
#Assigning reproduction mode:



reproduction <-c()
for(i in 1:length(raw$species)){
  for(j in 1:length(asexlist$species)){
    if(paste0(as.character(raw$family[i]), as.character(raw$genus[i]),as.character(raw$species[i])) 
       == paste0(as.character(asexlist$family[j]), as.character(asexlist$genus[j]), as.character(asexlist$species[j]))){
      reproduction <- append(reproduction,i)
    }
  }
  print(paste(i,length(raw$species),sep='/'))
}

mode <- c()
for(k in 1:length(raw$species)){
  if(any(k %in% reproduction)){
    mode <-append(mode,"asex")
  }
  else{
    mode <-append(mode,"sex")
  }
  print(paste(k,length(raw$species),sep='/'))
}
processed <-cbind(raw,mode)

#================================================================
# Assigning ecology:

eco <-rep("par",length(processed$species))
for(i in 1:length(processed$species)){
  for(j in 1:length(phytolist$genera)){
    if(paste0(as.character(processed$family[i]), as.character(processed$genus[i])) 
       == paste0(as.character(phytolist$fam[j]), as.character(phytolist$genera[j])) & phytolist$result[j]=='phyt'){
      eco[i] <- "phyt"
    }
  }
  print(paste(i,length(processed$species),sep='/'))
}

processed <-cbind(processed,eco)



#================================================================
# Generating new dataframe and creating corresponding csv file:
write.table(processed, file = "auto_processed_data.csv", sep = ",",col.names = T,row.names = F)
#================================================================
# General info about the data:
length(processed$species[processed$mode=="sex"])
length(processed$species[processed$mode=="asex"])
for(i in levels(processed$family)){
  print(i)
  print("Number of asex:")
  print(length(processed$species[na.omit(processed$mode=="asex") & processed$family==i]))
  print("Number of sex:")
  print(length(processed$species[na.omit(processed$mode=="sex") & processed$family==i]))
}
for(i in levels(processed$family)){
  print(i)
  print(length(processed$species[processed$family==i]))
}

#===========================
# Small dataframe with 1 genus/line 
# Note: leaving this here, just in case. I used it to assign %phyto to genera by hand
genera <- levels(processed$genus)
fam <- c()
for(i in genera)
{
  fam <- append(fam,as.character(processed$family[processed$genus==i][1]))
}
ext_df <-data.frame(fam,genera)
write.table(ext_df, file = "Percentage_phyto.csv", sep = ",", col.names = T)
