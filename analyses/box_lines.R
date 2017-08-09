# This script provides a function to generate similar plots as those in the publication with different variables.
# Cyril Matthey-Doret

library(dplyr);library(ggplot2)


#' Generates boxplots with lines connecting observations 
#' that belong to the same group.
#'
#' This function allows to generate similar plots as those 
#' in the publication, with any variable present in the 
#' input dataset. 
#' @param df The input dataframe containing all informations
#' @param fac The factor defining categories to compare. Must 
#' have either 2 (sex/asex) or 3 (close/far/asex) categories. 
#' One box will be drawn for each level.
#' @param group The grouping variable. Lines will connect 
#' observations from the same group within different categories.
#' @param var Quantitative variable to plot. Defines the y axis.
linebox <- function(df, fac, group, var){
  df[,group] <- as.factor(df[,group])
  tmp.list <- list()
  for(lev in levels(df[,fac])){
    tmp.list[[lev]] <- by (data=abs(df[df[,fac]==lev,var]), df[df[,fac]==lev,group] , mean, simplify=T, na.rm=T)
  }
  df2 <- as.data.frame(do.call(cbind, tmp.list))
  m.df <- reshape (df2, varying=levels(df[,fac]), v.names = var, timevar=fac, direction="long", idvar=group,
                   times = levels(df[,fac]))
  m.df[,fac] <- as.character(m.df[,fac] )
  m.df[,fac] <- factor(m.df[,fac],levels = levels(df[,fac]), ordered = T)
  
  
  m.df <- m.df %>% mutate(a=case_when(as.integer(.[,fac])>1.5 ~ 1.9, as.integer(.[,fac])<1.5 ~ 1.1),
                              b=case_when(as.integer(.[,fac])>2.5 ~ 2.9, as.integer(.[,fac])<2.5 ~ 2.1))
  
  line.box <- ggplot(data=m.df, aes_string(x=fac, y=var))+ 
    geom_point(col='white') + geom_boxplot(width=0.1) + 
    theme_classic() + theme(axis.line.x = element_line (color="black"), axis.line.y = element_line (color="black")) +
    ylab(var) + xlab("") + ylim(c(0,75))
  if(length(levels(df[,fac]))==3){
    line.box <- line.box + 
      geom_path(data=m.df[m.df$diverg!=min(m.df[,fac]),], alpha=0.6, aes_string(x = "b", y=var, group=group)) +
      geom_path(data=m.df[m.df$diverg!=max(m.df[,fac]),], alpha=0.6, lty=2, aes_string(x = "a", y=var, group=group))
  }
  if(length(levels(df[,fac]))==2){
    line.box <- line.box + 
      geom_path(data=m.df, alpha=0.6, aes_string(x = "a", y=var, group=group))
  }
  return(line.box)
}
