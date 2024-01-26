# Load all the packages required for the CSS Clustering workshop
# Run a test function for each. Do it one piece at a time to see the results.

# standard packages
library(dplyr)
library(ggplot2)
library(GGally)
library(viridis)

# packages for clustering
library(cluster)
library(factoextra)
library(dendextend)
library(kohonen)
library(SOMbrero)

# test dplyr - should produce table
irisSummary <- iris %>%
  group_by(Species) %>%
  summarise(plants = n())
irisSummary

# test ggplot and GGally and viridis - correlation plot
ggcorr(iris) +
  scale_fill_viridis_c()

# test cluster - dendrogram plot
data(agriculture)
ag.ag <- agnes(agriculture)
class(ag.ag)
pltree(ag.ag)

# test factoextra - line plot
fviz_nbclust(agriculture, kmeans, method = "wss")

# test dendextend - dendogram with several colours
plot(color_branches(as.dendrogram(ag.ag), k = 4))

# test kohonen - text about SOM
data(wines)
xyf.wines <- xyf(scale(wines),
                 classvec2classmat(vintages),
                 grid = somgrid(5, 5, "hexagonal"))
xyf.wines
summary(xyf.wines)

# test SOMbrero - plots a coloured grid
plot(initGrid(dimension = c(5, 7), dist.type = "maximum"))
