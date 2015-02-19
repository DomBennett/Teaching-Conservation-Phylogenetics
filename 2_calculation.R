# 15/02/2015
# Dom Bennett
# Phylogenetic testing

# LIBS
library (MoreTreeTools)

# READ
input.dir <- file.path ('data', 'Unova_data')
tree <- read.tree (file.path (input.dir, 'tree.tre'))
cmatrix <- read.csv (file.path (input.dir, 'community.csv'))

# ORGANISE
catch.zones <- cmatrix$Catch_zone  # let's separate catch zone
cmatrix <- cmatrix[ ,-1]
cmatrix <- cmatrix[order(catch.zones), ]  # let's order by increasing catch zone
catch.zones <- catch.zones[order (catch.zones)]
(ncol (cmatrix) > length (tree$tip.label))  # there are more community species than in tree
pull <- colnames (cmatrix) %in% tree$tip.label  # let's create a bool vector to remove them
part.cmatrix <- cmatrix[ ,pull]

# TRADITIONAL STATS
abund <- apply (cmatrix, 1, sum)  # create incidence and abundance data frame
incid <- apply (cmatrix > 0, 1, sum)
comm.stats <- data.frame (Catch_zone = catch.zones,
                          Abund = abund, Incid = incid)
# scatter plot
plot (comm.stats$Incid ~ factor (comm.stats$Catch_zone), ylab = 'Catch Zone',
      xlab = 'Species Incidence')
plot (comm.stats$Abund ~ factor (comm.stats$Catch_zone), ylab = 'Catch Zone',
      xlab = 'Species Abundance')
# model with linear model
model1 <- lm (comm.stats$Incid ~ comm.stats$Catch_zone)
summary (model1)
model2 <- lm (comm.stats$Abund ~ comm.stats$Catch_zone)
summary (model2)
# ... is there a significant difference?

# PLOTTING
commplot (part.cmatrix, tree, groups = catch.zones)  # can I see any change between the zones?
commplot (part.cmatrix > 0, tree, groups = catch.zones)  # what about for just abundance?

# PHYLOGENETIC STATS
source ('tools.R')  # see tools to see my permutation functions
# 1. PD
phy.stats <- calcComPhyMets (part.cmatrix, tree, metrics=c ('PD1'))  # PD1 is the normal PD value
plot (phy.stats$PD1 ~ factor (catch.zones), ylab='Catch Zone', xlab='PD')  # they look different
res.all <- permutationTest (part.cmatrix, tree=tree, metric='PD1')  # for this dataset, less PD than expected across all sites
res1 <- permutationTest(part.cmatrix[catch.zones==1, ], tree, metric='PD1')
res2 <- permutationTest(part.cmatrix[catch.zones==2, ], tree, metric='PD1')
res3 <- permutationTest(part.cmatrix[catch.zones==3, ], tree, metric='PD1')
res12 <- permutationTest (part.cmatrix[catch.zones==1 | catch.zones==2, ], tree, metric='PD1')
res23 <- permutationTest (part.cmatrix[catch.zones==2 | catch.zones==3, ], tree, metric='PD1')
# indicates a significant shift in community composition from 1 and 2 to 3
# explicit test with group specification, first let's test our permutation test with random groups
resRvR <- permutationTest (part.cmatrix, tree, groups=sample (catch.zones), metric='PD1')
print (resRvR)  # non-significant, great!
res1v2v3 <- permutationTest (part.cmatrix, tree, groups=catch.zones, metric='PD1')
print (res1v2v3)  # non-significant, but threeway comparison not great as it's the mean difference between groups
res1v2 <- permutationTest (part.cmatrix[catch.zones==1 | catch.zones==2, ], tree,
                           groups=catch.zones[catch.zones==1 | catch.zones==2], metric='PD1')
print (res1v2)  # non-significant, shift from 1 to 2
res2v3 <- permutationTest (part.cmatrix[catch.zones==2 | catch.zones==3, ], tree,
                           groups=catch.zones[catch.zones==2 | catch.zones==3], metric='PD1')
print (res2v3)  # non-significant, we can't say there's a compositional shift from 1 to 2
res1v3 <- permutationTest (part.cmatrix[catch.zones==1 | catch.zones==3, ], tree,
                           groups=catch.zones[catch.zones==1 | catch.zones==3], metric='PD1')
print (res1v3)  # significant, strong shift from 1 to 3
# What about the other metrics?

# TESTING FOR ED CHANGE




