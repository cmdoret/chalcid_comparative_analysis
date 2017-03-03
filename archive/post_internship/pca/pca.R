# Performing PCA on the auto dataset to see patterns in the data.
# Cyril Matthey-Doret
# Fri Jan 13 00:58:22 2017 ------------------------------

# Loading data
library(ggplot2);library(FactoMineR); library(factoextra)
#data0 <- read.csv("~/Documents/Internship/Data/R_working_directory/auto/auto_processed_data.csv", header=T)
data <- read.csv("~/Dropbox/Cyril-Casper_shared/for_publication/auto_data.csv")
data <- data[!data$nbr_country =="0",] #remove species with no countries described
data <- data[!data$host_spp =="0",] # remove species with no hosts described

cut_data <- data[data$ref>0,] # remove species very few studies
data<-cut_data
vars <- c("nbr_country","lat_median","lat_range","host_spp","min_dist_eq","max_dist_eq","ref")

pc <- prcomp(x = data[,vars])$x
weight <- prcomp(x=data[,vars])$rotation

ggplot()+
  geom_point(aes(x=pc[,5],y=pc[,7],col=data$mode))

res.pca <- PCA(data[,vars], graph = FALSE)

# Proportion of variance explained by each PC
fviz_screeplot(res.pca, ncp=10)


# Which variables correlate together ? which are best described by the 2 first PC
# The sum of the cos2 for variables on the principal components is equal to one.
# If a variable is perfectly represented by only two components, the sum of the 
# cos2 is equal to one. In this case the variables will be positioned on the circle of correlations.

fviz_pca_var(res.pca, col.var="cos2") +
  scale_color_gradient2(low="white", mid="blue", 
                        high="red", midpoint=0.5) + theme_minimal()

# Control variable colors using their contributions
fviz_pca_var(res.pca, col.var="contrib",axes =c(1,2)) +
  scale_color_gradient2(low="white", mid="blue", 
                        high="red", midpoint=5) + theme_minimal()

# Contribution of each variable to variation between species on PC1 and PC2
fviz_pca_contrib(res.pca, choice = "var", axes = 1)
fviz_pca_contrib(res.pca, choice = "var", axes = 3)
fviz_pca_contrib(res.pca, choice = "var", axes = 3:4) # Contribution on PC 1 and 2 together
fviz_pca_ind(res.pca,axes=c(4,2),habillage = data$mode,geom="point")
fviz_pca_ind(res.pca,axes=c(2,3),habillage=data$family,geom="point")
pairs(res.pca$ind$coord,col=data$mode)
#fviz_pca_contrib(res.pca, choice = "ind", axes = 1,color=data$mode)

