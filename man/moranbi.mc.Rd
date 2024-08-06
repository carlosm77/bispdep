\name{moranbi.mc}
\alias{moranbi.mc}
\title{Permutation test for bivariate Moran's Ixy statistic}
\description{
 A permutation test for bivariate Moran's Ixy statistic calculated by using nsim random permutations of \code{x} and \code{y} for the given spatial weighting scheme, to establish the rank of the observed statistic in relation to the nsim simulated values.
}
\usage{
moranbi.mc(varX, varY, listw, nsim, zero.policy=NULL, alternative="greater",
           na.action=na.fail, spChk=NULL, return_boot=FALSE, adjust.n=TRUE, parallel="no",
           ncpus = getOption("boot.ncpus", 1L), cl = NULL)
}
\arguments{
  \item{varX}{a numeric vector of the variable \code{x} the same length as the neighbours list in listw}
    \item{varY}{a numeric vector of the variable \code{y} the same length as the neighbours list in listw}
  \item{listw}{a \code{listw} object created for example by \code{nb2listw}}
  \item{nsim}{number of permutations}
  \item{zero.policy}{default NULL, use global option value; if TRUE assign zero to the lagged value of zones without neighbours, if FALSE assign NA}
  \item{alternative}{a character string specifying the alternative hypothesis, must be one of "greater" (default), "two.sided", or "less".}
  \item{na.action}{a function (default \code{na.fail}), can also be \code{na.omit} or \code{na.exclude} - in these cases the weights list will be subsetted to remove NAs in the data. It may be necessary to set zero.policy to TRUE because this subsetting may create no-neighbour observations. Note that only weights lists created without using the glist argument to \code{nb2listw} may be subsetted. \code{na.pass} is not permitted because it is meaningless in a permutation test.}
  \item{spChk}{should the data vector names be checked against the spatial objects for identity integrity, TRUE, or FALSE, default NULL to use \code{get.spChkOption()}}
  \item{return_boot}{return an object of class \code{boot} from the equivalent permutation bootstrap rather than an object of class \code{htest}}
  \item{adjust.n}{default TRUE, if FALSE the number of observations is not adjusted for no-neighbour observations, if TRUE, the number of observations is adjusted}
  \item{parallel}{The type of parallel operation to be used (if any). If missing, the default is "no". for more details see \code{\link[boot]{boot}}}
  \item{ncpus}{integer: number of processes to be used in parallel operation: number of available CPUs. By default it is set to 1 with getOption("boot.ncpus", 1L)}
  \item{cl}{An optional parallel or snow cluster for use if \code{parallel} = "\code{snow}". If not supplied, a cluster on the local machine is created for the duration of the \code{boot} call (by default is NULL).}
}

\value{
A list with class \code{htest} and \code{mc.sim} containing the following components:
  \item{statistic}{the value of the observed bivariate Moran's I.}
  \item{parameter}{the rank of the observed bivariate Moran's I.}
  \item{p.value}{the pseudo p-value of the test.}
  \item{alternative}{a character string describing the alternative hypothesis.}
  \item{method}{a character string giving the method used.}
  \item{data.name}{a character string giving the name(s) of the data, and the number of simulations.}
  \item{res}{nsim simulated values of statistic, final value is observed statistic}
}
\references{Cliff, A. D., Ord, J. K. 1981 Spatial processes, Pion, p. 63-5.}

\seealso{\code{\link{moran.bi}}, \code{\link{moranbi.test}}}

\examples{
library(spdep)
data(oldcol)
colw <- nb2listw(COL.nb, style="W")
nsim <- 999
set.seed(123)
sim1 <- moranbi.mc(COL.OLD$CRIME, COL.OLD$INC, listw=colw, nsim=nsim, zero.policy=TRUE)
sim1
mean(sim1$res[1:nsim])
var(sim1$res[1:nsim])
summary(sim1$res[1:nsim])

\donttest{
colold.lags <- nblag(COL.nb, 3)
set.seed(1234)
sim2 <- moranbi.mc(COL.OLD$CRIME, COL.OLD$INC, nb2listw(colold.lags[[2]],style="W"),
                   nsim=nsim, zero.policy=TRUE)
summary(sim2$res[1:nsim])
sim3 <- moranbi.mc(COL.OLD$CRIME, COL.OLD$INC, nb2listw(colold.lags[[3]],style="W"),
                   nsim=nsim, zero.policy=TRUE)
summary(sim3$res[1:nsim])
sim4 <- moranbi.mc(COL.OLD$CRIME, COL.OLD$INC, colw, nsim=nsim, zero.policy=TRUE,
                   return_boot=TRUE,parallel="multicore")
sim4
}
}
\keyword{spatial}
