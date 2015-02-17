# 15/02/2015
# Dom Bennett
# Phylogenetic testing

# LIBS
library (MoreTreeTools)

# READ
input.dir <- file.path ('data', 'Orre_data')
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
commPD



