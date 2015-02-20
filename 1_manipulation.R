# 15/02/2015
# Dom Bennett
# Manipulating trees in R

# LIBS
library (MoreTreeTools)

# READ IN TREE
input.dir <- file.path ('data', 'Orre_data')
tree <- read.tree (file.path (input.dir, 'tree.tre'))

# EXPLORING TREE 1
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
plot (drop.tip (tree, tip = sample (tree$tip.label, 1)))  # one fewer tip
sample.tips <- sample (tree$tip.label, round (length (tree$tip.label) * 0.1))  # random tips
sample.tree <- drop.tip (tree, tip = tree$tip.label[!tree$tip.label %in% sample.tips])
plot (sample.tree)  # smaller tree!
sample.tips2 <- sample (tree$tip.label, round (length (tree$tip.label) * 0.1))  # random tips
sample.tree2 <- drop.tip (tree, tip = tree$tip.label[!tree$tip.label %in% sample.tips2])
calcDist (sample.tree, sample.tree2)  # too many tips aren't shared
clade <- extract.clade (tree, node=110)
clade.parent <- tree$edge[which (tree$edge[ ,2] == 110), 1]
tree$edge[which (tree$edge[ ,1] == clade.parent), 2] # 189 is the sister

# EXPLORING TREE 2
# let's look at the sample.tree, it's easier to see what's going on
ttt.dists <- cophenetic.phylo (sample.tree)  # tip to tip distances
ntr.dists <- vcv.phylo (sample.tree)  # node to root distances
which (colSums (ttt.dists == max (ttt.dists)) > 0)  # most distant tips
mean (diag (ntr.dists))  # tree age i.e. the mean root to tip distance
max (diag (ntr.dists))
min (diag (ntr.dists))
tree$tip.label[which.max (calcED (tree)[ ,1])]  # most ED species
# and for different ED metrics ...
tree$tip.label[which.max (calcED (tree, type='ES')[ ,1])]
tree$tip.label[which.max (calcED (tree, type='PE')[ ,1])]

# CALCPD
# See tools.R