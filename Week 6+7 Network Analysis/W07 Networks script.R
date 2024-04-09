## Computational Social Science Week 7: Networks Workshop
## Durham University: Jennifer Badham and Will Craige

##--- Preparation ====

# install packages if required

# load packages
library(igraph)

##--- Network data

# village 1, vertices and edges
vertices1 <- read.csv("W07 Korea1vertices.txt")
edges1 <- read.csv("W07 Korea1edges.txt")
# village 2, vertices and edges
vertices2 <- read.csv("W07 Korea2vertices.txt")
edges2 <- read.csv("W07 Korea2edges.txt")

## Construct and examine networks ====

# construct networks from nodes and edges
net1 <- graph_from_data_frame(edges1, directed = FALSE, vertices = vertices1)
net2 <- graph_from_data_frame(edges2, directed = FALSE, vertices = vertices2)

# clean up
remove(edges1, edges2, vertices1, vertices2)

# two ways of showing checking networks
summary(net1)
net2

# network 1 - print the vertices and edges and the Adopted attribute
V(net1)
E(net1)
cat("\n")          # inserts blank line in the output
V(net1)$Adopted
cat("\n")

# network 1 - counts
noquote(paste("Network 1, number of vertices:", length(V(net1))))
noquote(paste("Network 1, number of edges:", length(E(net1))))
noquote(paste("Network 1, density:", edge_density(net1)))
noquote(paste("Network 1, number of adopters:", sum(V(net1)$Adopted)))
cat("\n")

# network 2 - counts
noquote(paste("Network 2, vertices and edges:", length(V(net2)), length(E(net2))))
noquote(paste("Network 2, density:", edge_density(net2)))

# tabulate adopters by mothers club members
print("Village 1")
table(V(net1)$Adopted, V(net1)$Club, dnn = c("Adopted", "Mothers Club"))
cat("\n")
print("Village 2")
table(V(net2)$Adopted, V(net2)$Club, dnn = c("Adopted", "Mothers Club"))

##--- Exploratory analysis: visualisation ====

# basic layouts
plot(net1, layout = layout_on_grid)
plot(net1, layout = layout_as_tree)
plot(net1, layout = layout_with_fr)

# store FR layout for each network
layout1 <- layout_with_fr(net1)
layout2 <- layout_with_fr(net2)

##--- visualise by mothers club membership

# create vector of two colours, dark for membership
colClub <- c("lightgrey", "yellow")

# adjust the membership to 1s and 2s
V(net1)$Club <- V(net1)$Club + 1
print("adjusted values")
V(net1)$Club

# display the colour for each vertex
colClub[V(net1)$Club]

# matching colours to TRUE and FALSE
V(net1)$Club <- V(net1)$Club - 1
print ("Check returned to 0s and 1s")
V(net1)$Club

# display the colour for each vertex
colClub[V(net1)$Club + 1]

# visualisation - sets up two plots on a single panel
par(mfrow=c(1,2))

# village 1
plot(net1, layout = layout1,                          # uses the stored layout positions
     title = "Village 1",
     vertex.color = colClub[V(net1)$Club + 1],
     vertex.label.cex	= 0.8,                          # label size
     vertex.size = 15 * V(net1)$Adopted + 10)         # size is 10 if no, 25 if yes
title(main = "Village 1")

# village 2
plot(net2, layout = layout2,
     vertex.color = colClub[V(net2)$Club + 1],
     vetex.label.size = 0.2,
     vertex.label.cex	= 0.8,
     vertex.size = 15 * V(net2)$Adopted + 10)
title(main = "Village 2")
legend(x = -2, y = -0.5,
       c("Not member","Mothers' Club"),
       pch = 21, pt.bg = colClub,
       pt.cex = 2, cex = 0.8, bty = "n", ncol = 1)

##--- Centrality ====

# common centrality measures for village 1 network
net1measures <- data.frame(vertex = V(net1)$name,
                           degr = degree(net1),
                           btwn = betweenness(net1, normalized = TRUE),
                           cls = closeness(net1, normalized = TRUE))

# common centrality measures for village 1 network
net2measures <- data.frame(vertex = V(net2)$name,
                           degr = degree(net2),
                           btwn = betweenness(net2, normalized = TRUE),
                           cls = closeness(net2, normalized = TRUE))

# correlations of the various centrality measures (over vertices)
cor(net1measures[2:4])
cor(net2measures[2:4])

##--- distribution of centrality

# sets up two plots on a single panel
par(mfrow=c(1,2))

# Village 1 degree distribution
hist(net1measures$degr, breaks = 0:max(net1measures$degr),
     main = "Village 1", xlab = "Degree", ylab = "Villagers")

# Village 2 degree distribution
hist(net2measures$degr, breaks = 0:max(net2measures$degr),
     main = "Village 2", xlab = "Degree", ylab = "Villagers")

paste("Degree centralisation, network 1:", centr_degree(net1)$centralization)
paste("Betweenness centralisation, network 1:", centr_betw(net1)$centralization)
paste("Degree centralisation, network 2:", centr_degree(net2)$centralization)
paste("Betweenness centralisation, network 2:", centr_betw(net2)$centralization)

##--- centrality and family planning

# sets up two plots on a single panel
par(mfrow=c(1,2))

# use colour for adopted family planning (since size will be for degree)
colFP <- c("lightgrey", "lightblue")

# village 1
plot(net1, layout = layout1,
     title = "Village 1",
     vertex.color = colFP[V(net1)$Adopted + 1],
     vertex.label.cex	= 0.8,
     vertex.size = ifelse(degree(net1) >= 10, 25, 15)) # large for the higher degree
title(main = "Village 1")

# village 2
plot(net2, layout = layout2,
     vertex.color = colFP[V(net2)$Adopted + 1],
     vetex.label.size = 0.2,
     vertex.label.cex	= 0.8,
     vertex.size = ifelse(degree(net2) >= 10, 25, 12)) # large for the higher degree
title(main = "Village 2")
legend(x = -2, y = -0.5,
       c("Not adopted","Family Planning"),
       pch = 21, pt.bg = colFP,
       pt.cex = 2, cex = 0.8, bty = "n", ncol = 1)

##--- Subnetworks ====

# homophily of behaviour
paste("Homophily of adoption, Village 1:",
      round(assortativity_nominal(net1, types = (V(net1)$Adopted + 1)), digits = 2))
paste("Homophily of adoption, Village 2:",
      round(assortativity_nominal(net2, types = (V(net2)$Adopted + 1)), digits = 2))
paste("Homophily of club membership, Village 1:",
      round(assortativity_nominal(net1, types = (V(net1)$Club + 1)), digits = 2))
paste("Homophily of club membership, Village 2:",
      round(assortativity_nominal(net2, types = (V(net2)$Club + 1)), digits = 2))

# add k-core to measures dataframes for village networks
net1measures$kCore <- coreness(net1)
net2measures$kCore <- coreness(net2)

# plot distributions of k-coreness
par(mfrow=c(1,2))
hist(net1measures$kCore, breaks = 0:max(net1measures$kCore),
     main = "Village 1", xlab = "k-core", ylab = "Villagers")
hist(net2measures$kCore, breaks = 0:max(net2measures$kCore),
     main = "Village 2", xlab = "k-core", ylab = "Villagers")

# plot with k-core by colour, darker for higher
par(mfrow=c(1,2))
plot(net1, layout = layout1,
     vertex.color = heat.colors(6, rev = TRUE)[net1measures$kCore + 1],
     vetex.label.size = 0.2,
     vertex.label.cex	= 0.8,
     vertex.size = 15 * V(net1)$Adopted + 10)
title(main = "Village 1")
plot(net2, layout = layout2,
     vertex.color = heat.colors(6, rev = TRUE)[net2measures$kCore + 1],
     vetex.label.size = 0.2,
     vertex.label.cex	= 0.8,
     vertex.size = 15 * V(net2)$Adopted + 10)
title(main = "Village 2")

# community detection for village 1, uses edge betweenness
cluster1 <- cluster_edge_betweenness(net1)
sizes(cluster1)

# add the community to the network vertices as color for plotting
V(net1)$color <- pmin(cluster1$membership, 6)

par(mfrow=c(1,2))
# map the clusters with adoption
plot(net1, layout = layout1,
     vetex.label.size = 0.2,
     vertex.label.cex	= 0.8,
     vertex.size = 15 * V(net1)$Adopted + 10)
title(main = "Large are adopters")
# map the clusters with club membership
plot(net1, layout = layout1,
     vetex.label.size = 0.2,
     vertex.label.cex	= 0.8,
     vertex.size = 15 * V(net1)$Club + 10)
title(main = "Large are club members")

# community detection for village 2, uses random walks
cluster2 <- cluster_walktrap(net2)
sizes(cluster2)

# add the community to the network vertices as color for plotting
V(net2)$color <- pmin(cluster2$membership, 6)

par(mfrow=c(1,2))
# map the clusters with adoption
plot(net2, layout = layout2,
     vetex.label.size = 0.2,
     vertex.label.cex	= 0.8,
     vertex.size = 15 * V(net2)$Adopted + 10)
title(main = "Large are adopters")
# map the clusters with club membership
plot(net2, layout = layout2,
     vetex.label.size = 0.2,
     vertex.label.cex	= 0.8,
     vertex.size = 15 * V(net2)$Club + 10)
title(main = "Large are club members")


