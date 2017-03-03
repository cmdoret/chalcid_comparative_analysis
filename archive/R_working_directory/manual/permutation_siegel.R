#0: Choose variable
setwd("/home/cyril/Documents/Internship/Data/R_working_directory/manual/")
processed <-read.table("manual_processed_data.csv", header = T, sep= ",")
my_var <- "nbr_country"
my_df <- data.frame(processed[,1:4],processed[my_var], pair = processed[,"pair"])
my_df<- my_df[my_df$pair>0,]


#I: calculate mean asex and mean sex.
#II: Calculate diff between asex and sex.
pair_df <-data.frame(pair = levels(factor(my_df$pair)), T_stat = rep(0,length(levels(factor(my_df$pair)))))
for(p in levels(my_df$pair))
{
  my_mean_asex <-mean(my_df$my_var[my_df$mode=='asex'])
  my_mean_sex <-mean(my_df$my_var[my_df$mode=='sex'])
  my_diff <- my_mean_asex-my_mean_sex
  
}


#III: convert diff to sign -1 or +1.

#IV: Compute T (mean, sum, t-value or anything).

#V: Randomize signs and compute T everytime.

#VI:  Build distribution (density plot) of T.

#VII: Compare our T to distribution.