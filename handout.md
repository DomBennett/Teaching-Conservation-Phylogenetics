# How do community phylogenies respond to human impact?
*If this isn't rendered properly, see it [online](https://github.com/DomBennett/Teaching-Conservation-Phylogenetics/blob/master/handout.md)*

Here I provide a framework for analysing how community phylogenies respond to
human impact in R.

## Pre-requisities
* A computer with R v3+ installed
* Basic R skills

## Aims
* Understand the structure of the phylogenetic tree in R
* Feel confident at manipulating phylogenetic trees in R
* Understand how different phylogenetic metrics work
* Understand how to interpret results from community phylogenetic analyses
* Be able to create a permutation test
* Become aware of the range of available tools and packages in R

## Setup
All scripts required are available via my Github account. Navigate to a suitable
folder where you keep your coding projects and type:

`git clone https://github.com/DomBennett/Teaching-Conservation-Phylogenetics.git`

This will install a local copy of the R files I have created for this practical.
You will find three R scripts: `0_setup.R`, `1_manipulation.R`,
`2_calculation.R` and `tools.R`

I will also pass around data files separately via USB. In the meantime, make
sure you have installed all the relevant packages by running the script
`0_setup.R`.

There are A LOT of phylogenetic packages in R -- [CRAN lists 60](http://cran.r-project.org/web/packages/available_packages_by_date.html).
This, however, doesn’t include all the functions written to handle phylogenies
not in CRAN (such as my own MoreTreeTools!). The most common package you will come
across is ape written by Emmanuel Paradis. The vast majority of people who deal
with phylogenies use ape’s phylogenetic class structure, this is something we
will explore as part of this practical. Although, other class structures exist
and are probably better (e.g. their S4), given the huge scope of the field of
phylogenetics and the number of functions that already depend on ape’s class
structure, it is unlikely that it’s going to change any time soon.

If you're waiting for the data, checkout some of the new package vignettes:
`vignettes([PACKAGE])`

## 1. Manipulating phylogenetic trees
We’re going to start by reading in a tree into R and exploring its structure
and seeing what we can do with it. The idea of this section of the practical is
just to get an idea of how to work with trees and feel confident at being able
to play with them to better run and interpret tests.

### Exercises
Look at `1_manipulation.R`, use this script to work through the exercises below.
First start, by choosing a dataset (whichever tickles your fancy) and read in
its tree.

#### Exploring tree 1
* What is the structure of ape’s phylogenetic class?
* How many data slots does it have and what do they represent?
* How many tips does your tree have?
* What is the total branch length of your tree?
* How many nodes are there in the tree -- internal and tip?
* Is your tree bifurcating? How can you test for this?

#### Plotting the tree
* Search ‘plot.phylo’ and test out different ways to plot the tree.
* Use `nodelabels()` and `edgelabels()` to confirm what you understood when
exploring the tree structure, i.e. do you understand the edge matrix now?
* Use `ltt.plot()` to see how many lineages there are through time -- what do
you conclude from this?

#### Manipulating the tree
* Remove a tip from the tree with `drop.tip()`.
* Take a random subset of the tree representing 10% of the total tree size.
* Repeat and then use `calcDist()` to test how distant the the random trees
are.
* Use `extract.clade()`, to extract the clade of your choice. If you had a big
tree, perhaps repeat the plotting exercises with a smaller clade.
* What is the sister clade to your chosen clade?

#### Exploring tree 2
* Check out these functions: `cophenetic.phylo()` and `vcv.phylo()` -- what do
they do?
* What are the most distant tips in your tree?
* Use them to test whether the tree is ultrametric. (This may be obvious anyway
when plotting.)
* Now.... how old is your tree? This is NOT the same as the total branch length.
(If it is not ultrametric, what is the minimum and maximum ‘ages’ of the tree?)
* Use `calcED()` to calculate the most ED tips.

#### Calculating differences between communities
* Use `drop.tip()` to create a function that takes tip labels and calculates
the total branch length they represent. In other words, create a function that
calculates PD. When it's done, add it to `tools.R`.

## Testing for phylogenetic change
Now we’ve come to grips with the phylogenetic structure in R, let’s explore how
the community phylogeny responds to human impact.

The data consists of 6 regions of different community data. Data has been
collected from different sites, with each site classified by catch zone (1-3).
The lower the catch zone the greater the impact of human disturbance
(hunting, persecution, pet trade, animal cruelty, forced battles, human
developments). The data is real but obfuscated, please do not circulate.

Try your best to [softcode](http://en.wikipedia.org/wiki/Softcoding) so that
if you want to try your analysis on a different dataset you only need change a
single parameter in your script -- the data folder.

### Exercises
Read in your data and organise them for further analysis by separating the
`community.csv` into a community matrix and a vector of site classifications.

#### 'Traditional' stats
* Calculate incidence and abundance per site
* Model how incidence and abundance respond to increasing catch zone
* Is there any difference?

#### Visualising
* Use `plotcomm()` to visualise the phylogenetic structure between sites
* Can you *see* any difference between catch zones? Are whole sections of the
tree missing between sites?

#### Phylogenetic stats
* Use your PD-calculation function to calculate the PD per site.
* Is there any difference between catch zones?

#### Permutation test
Regardless of whether there is a difference, we're going to learn how to create
a permutation test -- the mainstay of community phylogenetic analysis. The idea
of a permutation test is to use resampling to generate a null distribution of
expected values if nothing interesting was happening. By then seeing where the
observed value lands in this null distribution we can determine the significance
of the observed value. The important thing to remember when creating permutation
tests for community phylogenetics, is to think about what your source pool is.

* [Pseudocode](http://en.wikipedia.org/wiki/Pseudocode) what the permutation
test needs to do first.
* In `tools.R`, you will find the shells of two functions `nullify()` and
`permutationTest()`. Adapt these, so `permutationTest()` can take a community
matrix and calculate whether the observed PD is lower than expected for sites
with an equal number of species present.
* Run your permutation test on subsets of the community matrix representing
each catch zone.
* Adapt the permutation test so it can test for differences between groups of
sites -- e.g. is there a significant difference between catch zone 1 and 2 sites?
* What do you conclude from the results of your tests? Is there evidence to
suggest that sites within different catch zones form different communities? Is
there a significant difference in PD between zones?

#### Other Phylogenetic Stats
* Use `calcPhyMets()` to explore differences in other phylogenetic metrics
between sites.
* What do you find?

## 3. Finishing up
Now you can simply compare your answers to mine. Either browse the answer’s
branch of the online repo [here](https://github.com/DomBennett/Teaching-Conservation-Phylogenetics/tree/answers).

Or download a hard copy into a folder called `_answers/`, like so:

`git clone https://github.com/DomBennett/Teaching-Conservation-Phylogenetics.git -b answers _answers`

Feel free to browse the history as I developed answers with things like [gitk](http://git-scm.com/docs/gitk).

## 4. Extra challenges
* An important class of phylogenetic metrics has been excluded so far, these are
the metrics that calculate overdispersion/clustering. Find a function in R that
can calculate any of these metrics and repeat the permutation test exercises
on these.
* A recent paper in [Science](www.sciencemag.org/content/345/6202/1343.short)
discovered that the best explanation in change of phylogenetic structuring
between human impacted and non-human impacted sites was the increased loss of
ED species in human impacts sites. Can you think of a way to test for this in
the data I have provided? Use `calcED()`, with the obvious caveat that these
ED values will be dependent on the representativeness of the community
phylogeny of the whole clade phylogeny.

## Useful Resources
* [Wiki for phylogenetics in R](http://www.r-phylo.org/wiki/Main_Page)
* [Phytools blog](http://blog.phytools.org/)  -- Liam Revell's (the developer
of `phytools`) blog, often there's lots of useful stuff to be read here. If
you're struggling to do something with a tree in R, chances are, Liam's written
about it here.
* [EcoDataTools](https://github.com/DomBennett/EcoDataTools/wiki)  -- functions
a friend and I created during our Masters (if you want to do this, I can show
you!)
