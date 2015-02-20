# 17/02/2015
# Dom Bennett
# Installing useful phylo packages
# See: http://www.r-phylo.org/wiki/HowTo/Taskview

# START
cat ('\nInstalling useful phylo packages ....')

# GET INSTALLED PACKAGES
packages <- installed.packages ()[ ,1]

# CHECK AND INSTALL
if (!'devtools' %in% packages) {
  install.packages ('devtools')
}
if (!'MoreTreeTools' %in% packages) {
  install_github ('https://github.com/DomBennett/MoreTreeTools.git')
}
if (!'ape' %in% packages) {
  install.packages('ape')
}
if (!'phytools' %in% packages) {
  install.packages('phytools')
}
if (!'plyr' %in% packages) {
  install.packages('plyr')
}
if (!'reshape' %in% packages) {
  install.packages('reshape')
}
if (!'picante' %in% packages) {
  install.packages('picante')
}
if (!'paleotree' %in% packages) {
  install.packages('paleotree')
}
if (!'phangorn' %in% packages) {
  install.packages('phangorn')
}
if (!'treebase' %in% packages) {
  install.packages('treebase')
}
if (!'geiger' %in% packages) {
  install.packages('geiger')
}
if (!'phylobase' %in% packages) {
  install.packages('phylobase')
}

# END
cat ('\nDone.')