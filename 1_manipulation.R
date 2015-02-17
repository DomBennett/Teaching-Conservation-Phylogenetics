# 15/02/2015
# Dom Bennett
# Manipulating trees in R

# LIBS
library (MoreTreeTools)

# READ IN TREE
input.dir <- file.path ('data', 'Orre_data')
tree <- read.tree (file.path (input.dir, 'tree.tre'))

# EXPLORING TREE STRUCTURE
str (tree)  # composed of 4 slots
tree$Nnode  # number of internal nodes
tree$tip.label  # labels of tips
tree$edge.length  # lengths of the branches in the tree
tree$edge  # edge matrix, which node connects to which
length (tree$tip.label)  # number of tips
sum (tree$edge.length)  # total branch length
length (tree$tip.label) + tree$Nnode  # total number of nodes
tree$Nnode == (length (tree$tip.label) - 1)  # yes, bifurcating

# PLOTTING TREE
plot (tree, type = 'phylogram')  # plotting different types of plot
plot (tree, type = 'fan')
plot (tree, type = 'unrooted')
plot (tree, type = 'radial')
plot (tree, show.tip.label=FALSE)  # no tip labels
plot (tree, show.tip.label=FALSE, edge.width = 3)  # thicker edges
#  ... you get the idea
nodelabels ()  # adds labels to the nodes
edgelabels ()  # now if we compare what we see to tree$edge, we can better understand the structure
ltt.plot (tree)  # lineages through time, this is a community plot
 # it can't tell us much about the evolution of the clade

# MANIPULATING TREE
