## Computational Social Science Week 3: Clustering Workshop
## Durham University: Jennifer Badham

##--- Preparation ====

# Load packages
# NOTE: Install packages if required

library(dplyr)
library(ggplot2)
library(GGally)
library(viridis)
library(cluster)
library(factoextra)

# Obtain and describe built-in R dataset
data("USArrests")
?USArrests        # information about dataset
summary(USArrests)

# scale (centre at 0, value is multiples of standard deviation) and see adjusted
scaledData <- as.data.frame(scale(USArrests))
summary(scaledData)

##--- k-means clustering ====

# Try with 3 clusters and report results
km3 <- kmeans(scaledData, centers = 3, nstart = 10)
km3

# Try with 4 clusters
km4 <- kmeans(scaledData, centers = 4, nstart = 10)
km4

# Comparison metrics to select the number of clusters
fviz_nbclust(scaledData, FUNcluster = kmeans, method = "wss", k.max = 10)
fviz_nbclust(scaledData, FUNcluster = kmeans, method = "silhouette", k.max = 10)
fviz_nbclust(scaledData, FUNcluster = kmeans, method = "gap_stat", k.max = 10)

# NOTE: continue with the 4 clusters solution (km4)

# visualise the 4 cluster solution om two dimensional space (principle components)
fviz_cluster(km4, data = scaledData) + theme_minimal()

##--- Hierarchical clustering ====

## BOTTOM UP

# construct dendrogram with core R function
distArrests <- dist(scaledData, method = "manhattan")
hcUp <- hclust(distArrests)

# report the results
hcUp

# plot the dendrogram
plot(hcUp, hang = -1)

# Use silhouette plots (from cluster package) to find a good number of clusters
hcUp3 <- cutree(hcUp, k = 3)
plot(silhouette(hcUp3, distArrests))

hcUp4 <- cutree(hcUp, k = 4)
plot(silhouette(hcUp4, distArrests))

hcUp5 <- cutree(hcUp, k = 5)
plot(silhouette(hcUp5, distArrests))

## TOP DOWN

# construct and visualise the dendrogram
hcDown <- diana(scaledData, diss = FALSE, metric = "manhattan",
               stand = FALSE)         # tells the function that data are not already standardised
pltree(hcDown, hang = -1)

# compare silhouette plots for different cutpoints (numbers of clusters)
hcDown3 <- cutree(hcDown, k = 3)
plot(silhouette(hcDown3, distArrests))

hcDown4 <- cutree(hcDown, k = 4)
plot(silhouette(hcDown4, distArrests))

hcDown5 <- cutree(hcDown, k = 5)
plot(silhouette(hcDown5, distArrests))

##--- Interpret the clusters ====

## NOTE: Continuing example with 4 clusters

# clear out other objects
remove(hcDown3, hcDown5, hcUp3, hcUp5, km3)

# compare 4 clusters for up and down
table(hcUp4)
table(hcDown4)
table(hcUp4, hcDown4)

# compare 4 clusters for up and k-means
table(hcUp4)
table(km4$cluster)
table(hcUp4, km4$cluster)

# dendrogram with clusters
plot(hcUp)
rect.hclust(hcUp, k = 4, which = c(1:4), border = "red")

# just for fun plot, visually compare the agglomorative and divisive solutions
dendextend::tanglegram(hcUp, hcDown, sort = TRUE)

# assign cluster numbers to original data
USArrests$cluster <- as.character(hcUp4)   # NOTE: they are in the same order

# summary table
res <- USArrests %>% 
        group_by(cluster) %>% 
        summarise(count = n(),
                  murderRate = mean(Murder),
                  assaultRate = mean(Assault),
                  rapeRate = mean(Rape),
                  urbanProp = mean(UrbanPop))
res

# parallel coordinates plot with one cluster highlighted, from GGally package
ggparcoord(USArrests, columns = 1:4, groupColumn = "cluster",
           scale = "std", showPoints = FALSE, alphaLines = 0.7) + 
  scale_color_manual(values=c("darkblue", "grey", "grey", "grey")) +
  theme_minimal()
ggparcoord(USArrests, columns = 1:4, groupColumn = "cluster",
           scale = "std", showPoints = FALSE, alphaLines = 0.7) + 
  scale_color_manual(values=c("grey", "darkblue", "grey", "grey")) +
  theme_minimal()
ggparcoord(USArrests, columns = 1:4, groupColumn = "cluster",
           scale = "std", showPoints = FALSE, alphaLines = 0.7) + 
  scale_color_manual(values=c("grey", "grey", "darkblue", "grey")) +
  theme_minimal()
ggparcoord(USArrests, columns = 1:4, groupColumn = "cluster",
           scale = "std", showPoints = FALSE, alphaLines = 0.7) + 
  scale_color_manual(values=c("grey", "grey", "grey", "darkblue")) +
  theme_minimal()

# or violin plots for each measure
ggplot(USArrests, aes(x=cluster, y = Murder)) +
  geom_violin() + coord_flip() +
  theme_bw()
ggplot(USArrests, aes(x=cluster, y = Assault)) +
  geom_violin() + coord_flip() +
  theme_bw()
ggplot(USArrests, aes(x=cluster, y = Rape)) +
  geom_violin() + coord_flip() +
  theme_bw()
ggplot(USArrests, aes(x=cluster, y = UrbanPop)) +
  geom_violin() + coord_flip() +
  theme_bw()

##--- Self organised map: Kohonen ====

# preparation
library(kohonen)

# convert scaled data to matrix
arrestMatrix <- as.matrix(scaledData)

# create a colour palette based on Viridis but purple as high value
revViridis <- function(n) {viridis(n, direction = -1)}

# train the map
somMap1 <- som(arrestMatrix,
               grid = somgrid(4, 4, "rectangular"),
               rlen = 25)

# visualise the fit through iterations
plot(somMap1, type = "changes")

# visualisations of the SOM
plot(somMap1, type = "counts", shape = "straight", palette.name = revViridis)
plot(somMap1, type = "dist.neighbours", shape = "straight", palette.name = revViridis)
plot(somMap1, type = "quality", shape = "straight", palette.name = revViridis)

# visualisation of attributes in each cell
plot(somMap1, type = "codes", shape = "straight", palette.name = revViridis)
somMap1$codes

# component planes, visualising each attribute separately
par(mfrow = c(2,2))                   # lays out multiple plots but does not work with ggplot
plot(somMap1, type = "property", property = getCodes(somMap1, 1)[, 1],
     main = colnames(getCodes(somMap1, 1))[1],
     shape = "straight", palette.name = revViridis)
plot(somMap1, type = "property", property = getCodes(somMap1, 1)[, 2],
     main = colnames(getCodes(somMap1, 1))[2],
     shape = "straight", palette.name = revViridis)
plot(somMap1, type = "property", property = getCodes(somMap1, 1)[, 3],
     main = colnames(getCodes(somMap1, 1))[3],
     shape = "straight", palette.name = revViridis)
plot(somMap1, type = "property", property = getCodes(somMap1, 1)[, 4],
     main = colnames(getCodes(somMap1, 1))[4],
     shape = "straight", palette.name = revViridis)
par(mfrow = c(1,1))

# allocation of cases to cells
plot(somMap1, type = "mapping", labels = row.names(USArrests), shape = "straight")
somMap1$unit.classif

##--- Self organised map: SOMbrero ====

# preparation
detach("package:kohonen",  unload=TRUE)
library(SOMbrero)

# initialise the SOM, there are sensible defaults but specified here for clarity
initSOM(dimension = c(4, 4),
        topo = "square",
        radius.type = "gaussian",
        dist.type = "euclidean",
        init.proto = "random",
        scaling = "unitvar")

# train and report the SOM
somMap2 <- trainSOM(x.data = USArrests[,1:4],
                    nb.save = 5)    # stores intermediate points for improvement plot
somMap2

# visualise the SOM
plot(somMap2, what = "energy")

# count of cases allocated to each node
plot(somMap2, what = "obs", type = "hitmap",
     main = "Cases")

# Attribute value plots
plot(somMap2, what = "obs", type = "lines",
     main = "Attribute values, all cases")
plot(somMap2, what = "obs", type = "boxplot",
     main = "Attribute value distribution")
plot(somMap2, what = "obs", type = "barplot",
     main = "Mean value of allocated cases")

##--- Compare SOMbrero and k-means solutions ====

# pie chart with number of cases by cluster
plot(somMap2, what = "add", type = "pie", variable = USArrests$cluster)
# identify cases at each SOM node
plot(somMap2, what = "add", type = "names", variable = row.names(USArrests))

