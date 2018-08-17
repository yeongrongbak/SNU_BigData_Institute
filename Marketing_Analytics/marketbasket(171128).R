library(arules)
library(datasets)

# Load the data set
data(Groceries)

# check how the data look like
str(Groceries)
Groceries@itemInfo   # item information
Groceries@data[,1:100]  # the first 100 baskets
image(Groceries@data[,1:100])

# Create an item frequency plot for the top 20 items
itemFrequencyPlot(Groceries,topN=20,type="absolute")

# Get the rules
rules = apriori(Groceries, parameter = list(supp = 0.001, conf = 0.8))
plot(rules)

library(arulesViz)

plot(rules,method="graph",interactive=TRUE,shading=NA)

plot(rules[1:10],method="graph",interactive=TRUE,shading=NA)


# Show the top 5 rules, but only 2 digits

options(digits=2)

inspect(rules[1:5])

rules<-sort(rules, by="confidence", decreasing=TRUE)

inspect(rules[1:5])



rules<-apriori(data=Groceries, parameter=list(supp=0.001,conf = 0.08), 
               appearance = list(default="lhs",rhs="whole milk"),
               control = list(verbose=F))

rules<-sort(rules, decreasing=TRUE,by="confidence")

inspect(rules[1:5])


rules<-apriori(data=Groceries, parameter=list(supp=0.001,conf = 0.15,minlen=2), 
               appearance = list(default="rhs",lhs="whole milk"),
               control = list(verbose=F))
rules<-sort(rules, decreasing=TRUE,by="confidence")
inspect(rules[1:5])


