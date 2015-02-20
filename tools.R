# [Date]
# [Your name]
# Tools for conseravtion phylogenetics

nullify <- function (cmatrix) {
  # rearrange a cmatrix randomly
  randomise <- function (i) {
    # take a random row, rearrange colnames randomly, add to growing null matrix
    # TODO
    # bind temp to null.cmatrix, push to environment above
    # TODO
  }
  # remove species absent in all sites
  cmatrix <- cmatrix[ ,colSums (cmatrix == 0) != nrow (cmatrix)]
  # create empty null cmatrix
  null.cmatrix <- data.frame ()
  mdply (.data=data.frame(i=1:nrow(cmatrix)), .fun=randomise)
  null.cmatrix
}

# SAME AS ABOVE BUT CALCED
permutationTest <- function (cmatrix, tree, iterations=999, plot=TRUE) {
  # internals
  calcNull <- function (i) {
    # nullify cmatrix
    null.cmatrix <- nullify (cmatrix)
    # calculate pmetric per site
    # TODO
    # calculate mean difference between groups
    temp.mean <- mean (temp.res, na.rm=TRUE)
    temp.sd <- sd (temp.res, na.rm=TRUE)
    data.frame (mean=temp.mean, sd=temp.sd)
  }

  # get observed results
  # TODO
  # generate null distritbution
  null.res <- mdply (.data=data.frame(i=1:iterations), .fun=calcNull)
  obs.mean <- mean (obs.res, na.rm=TRUE)
  obs.sd <- sd (obs.res, na.rm=TRUE)
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
