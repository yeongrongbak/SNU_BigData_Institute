## Network Diagram

install.packages("networkD3")
install.packages("igraph")

library(networkD3)
library(igraph)

# Simple network

src <- c("A", "A", "A", "A",
         "B", "B", "C","C", "D")
target <- c("B","C","D","J",
            "E", "F", "G", "H","I")
networkData <-data.frame(src, target)
head(networkData)

networkD3::simpleNetwork(networkData, fontSize = 15, zoom=T)

# Force network

data(MisLinks)
head(MisLinks)

data(MisNodes)
head(MisNodes)

forceNetwork(Links = MisLinks, Nodes= MisNodes,
             Source = "source", Target = "target",
             Value = "value", NodeID = "name",
             Group = "group", opacity = 0.8, zoom= TRUE)

