# 15/02/2015
# Dom Bennett
# Tools for conseravtion phylogenetics

calcPD <- function (tree, tip.labels) {
  # drop all but tip.labels, sum all remaining branch lengths
  tree <- drop.tip (tree, tip=tree$tip.label[!tree$tip.label %in% tip.labels])
  sum (tree$edge.length)
}

nullify <- function (cmatrix) {
  # rearrange a cmatrix randomly
  randomise <- function (i) {
    # take a random row, rearrange colnames randomly, add to growing null matrix
    i <- sample (1:nrow (cmatrix), 1)
    temp <- cmatrix[i, ]
    colnames (temp) <- sample (colnames (temp))
    # bind temp to null.cmatrix, push to environment above
    null.cmatrix <<- rbind (temp, null.cmatrix)
  }
  # remove species absent in all sites
  cmatrix <- cmatrix[ ,colSums (cmatrix == 0) != nrow (cmatrix)]
  # create empty null cmatrix
  null.cmatrix <- data.frame ()
  mdply (.data=data.frame(i=1:nrow(cmatrix)), .fun=randomise)
  null.cmatrix
}

permutationTest <- function (cmatrix, tree, metric, groups=NULL, iterations=999,
                             plot=TRUE) {
  # internals
  calcNull <- function (i) {
    # nullify cmatrix
    null.cmatrix <- nullify (cmatrix)
    # calculate pmetric per site
    temp.res <- calcComPhyMets (null.cmatrix, tree, metrics = c (metric))[ ,metric]
    # calculate mean difference between groups
    temp.mean <- mean (temp.res, na.rm=TRUE)
    temp.sd <- sd (temp.res, na.rm=TRUE)
    data.frame (mean=temp.mean, sd=temp.sd)
  }
  meandiff <- function (res, v=FALSE) {
    # calculates the mean difference (or sd) for grouped vector
    if (v) {
      res <- sum ( diff (tapply (res, factor (groups), sd, na.rm=TRUE))) /
        length (unique (groups))
    } else {
      res <- sum (abs (diff (tapply (res, factor (groups), mean, na.rm=TRUE)))) /
        length (unique (groups))
    }
    res
  }
  calcGroupedNull <- function (i) {
    # nullify grouped cmatrix
    null.cmatrix <- nullify (cmatrix)
    # calculate pmetric per site
    temp.res <- calcComPhyMets (null.cmatrix, tree, metrics = c (metric))[ ,metric]
    # calculate mean difference between groups
    temp.mean <- mean (temp.res, na.rm=TRUE)
    temp.sd <- mean (temp.res, na.rm=TRUE)
    data.frame (mean=temp.mean, sd=temp.sd)
  }
  # get observed results
  obs.res <- calcComPhyMets (cmatrix, tree, metrics = c (metric))[, metric]
  # generate null distritbution
  if (!is.null (groups)) {
    null.res <- mdply (.data=data.frame(i=1:iterations), .fun=calcGroupedNull)
    # calc meandiff for groups
    obs.mean <- meandiff (obs.res)
    obs.sd <- meandiff (obs.res, v=TRUE)
  } else {
    null.res <- mdply (.data=data.frame(i=1:iterations), .fun=calcNull)
    obs.mean <- mean (obs.res, na.rm=TRUE)
    obs.sd <- sd (obs.res, na.rm=TRUE)
  }
  # calc stats
  null.mean <- mean (null.res$mean, na.rm=TRUE)
  null.sd <- sd (null.res$sd, na.rm=TRUE)
  p.value <- sum (null.res$mean <= obs.mean) / iterations
  z.score <- (obs.mean - null.mean) / null.sd
  if (plot) {
    # plot histogram, with observed as red line
    hist (null.res$mean, main=NULL, xlab=paste0 ('Null dist for [', metric, ']'))
    abline (v=obs.mean, col='red')
  }
  data.frame (Null_mean=null.mean, Null_sd=null.sd, Obs_mean=obs.mean,
              Obs_sd=obs.sd, Z=z.score, P=p.value)
}