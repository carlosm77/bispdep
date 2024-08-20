\name{gearybi.test}
\alias{gearybi.test}
\title{Bivariate Geary's Cxy test for spatial autocorrelation}
\description{
   Bivariate Geary's test for spatial autocorrelation using a spatial weights matrix in weights list form. The assumptions underlying the test are sensitive to the form of the graph of neighbour relationships and other factors.
}
\usage{
gearybi.test(varX, varY, listw, randomisation=TRUE, zero.policy=NULL,
    alternative="greater", spChk=NULL, adjust.n=TRUE)
}

\arguments{
  \item{varX}{a numeric vector the same length as the neighbours list in listw with the values of the variable X}
  \item{varY}{a numeric vector the same length as the neighbours list in listw with the values of the variable Y}
  \item{listw}{a \code{listw} object created for example by \code{nb2listw}}
  \item{randomisation}{variance of I calculated under the assumption of randomisation, if FALSE normality}
  \item{zero.policy}{default NULL, use global option value; if TRUE assign zero to the lagged value of zones without neighbours, if FALSE assign NA}
  \item{alternative}{a character string specifying the alternative hypothesis, must be one of "greater" (default), "less" or "two.sided".}
  \item{spChk}{should the data vector names be checked against the spatial objects for identity integrity, TRUE, or FALSE, default NULL to use \code{get.spChkOption()}}
  \item{adjust.n}{default TRUE, if FALSE the number of observations is not adjusted for no-neighbour observations, if TRUE, the number of observations is adjusted}
}

\value{
A list with class \code{htest} containing the following components:
  \item{statistic}{the value of the standard deviate of Geary's Cxy, in the order given in Cliff and Ord 1973, p. 21, which is (ECxy - Cxy) / sqrt(VCxy), that is with the sign reversed with respect to the more usual (Cxy - ECxy) / sqrt(VCxy); this means that the \dQuote{greater} alternative for the Bivariate Geary Cxy test corresponds to the \dQuote{greater} alternative for Bivariate Moran's Ixy test.}
  \item{p.value}{the p-value of the test.}
  \item{estimate}{the value of the observed BIvariate Geary's Cxy, its expectation and
 variance under the method assumption.}
  \item{alternative}{a character string describing the alternative hypothesis.}
  \item{method}{a character string giving the assumption used for calculating
 the standard deviate.}
  \item{data.name}{a character string giving the name(s) of the data.}
}
\references{Cliff, A. D., Ord, J. K. 1981 Spatial processes, Pion, p. 21, Cliff, A. D., Ord, J. K. 1973 Spatial Autocorrelation, Pion, pp. 15-16, 21; Bivand RS, Wong DWS 2018 Comparing implementations of global and local indicators of spatial association. TEST, 27(3), 716--748 \doi{10.1007/s11749-018-0599-x}}

\note{The derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric. For inherently non-symmetric matrices, such as k-nearest neighbour matrices, \code{listw2U()} can be used to make the matrix symmetric. In non-symmetric weights matrix cases, the variance of the test statistic may be negative (thanks to Franz Munoz I for a well documented bug report). Geary's C is affected by non-symmetric weights under normality much more than Moran's I. From 0.4-35, the sign of the standard deviate of C is changed to match Cliff and Ord (1973, p. 21).
}

\seealso{\code{\link{geary.bi}}, \code{\link[spdep]{listw2U}}}

\examples{
library(spdep)
data(oldcol)
gearybi.test(COL.OLD$CRIME,COL.OLD$INC,nb2listw(COL.nb,style="W"),zero.policy=TRUE)
gearybi.test(COL.OLD$CRIME,COL.OLD$INC,nb2listw(COL.nb,style="W"),zero.policy=TRUE,
             randomisation=FALSE)
colold.lags <- nblag(COL.nb, 3)
gearybi.test(COL.OLD$CRIME,COL.OLD$INC,nb2listw(colold.lags[[2]],style="W"),
             zero.policy=TRUE)
gearybi.test(COL.OLD$CRIME,COL.OLD$INC,nb2listw(colold.lags[[3]],style="W"),
             zero.policy=TRUE,alternative="greater")
print(is.symmetric.nb(COL.nb))
coords.OLD <- cbind(COL.OLD$X, COL.OLD$Y)
COL.k4.nb <- knn2nb(knearneigh(coords.OLD, 4))
print(is.symmetric.nb(COL.k4.nb))
gearybi.test(COL.OLD$CRIME,COL.OLD$INC,nb2listw(COL.k4.nb,style="W"),zero.policy=TRUE)
gearybi.test(COL.OLD$CRIME,COL.OLD$INC,nb2listw(COL.k4.nb,style="W"),zero.policy=TRUE,
             randomisation=FALSE)
cat("Note non-symmetric weights matrix - use listw2U()\n")
gearybi.test(COL.OLD$CRIME,COL.OLD$INC,listw2U(nb2listw(COL.k4.nb,style="W")),
             zero.policy=TRUE)
gearybi.test(COL.OLD$CRIME,COL.OLD$INC,listw2U(nb2listw(COL.k4.nb,style="W")),
             zero.policy=TRUE,randomisation=FALSE)
}
\keyword{spatial}
