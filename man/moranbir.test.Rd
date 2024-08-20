\name{moranbir.test}
\alias{moranbir.test}
\title{Moran's Ixy test using Monte Carlo permutations for bivariate spatial autocorrelation}
\description{
Moran's Ixy test for bivariate spatial autocorrelation using a spatial weights matrix in weights list form. Constructs a plot of the empirical density from the simulations (Monte Carlo permutations) and superimposes Moran's bivariate Ixy index.
}
\usage{
moranbir.test(varX,varY,listw,zero.policy=NULL,adjust.n=TRUE,N,graph=FALSE,
              alternative="greater", spChk=NULL, print.results=TRUE, ...)
}
\arguments{
  \item{varX}{a numeric vector of the same length as the neighbours list in listw with the values of the variable \code{x}}
  \item{varY}{a numeric vector of the same length as the neighbours list in listw with the values of the variable \code{y}}
  \item{listw}{a \code{listw} object created for example by \code{nb2listw}}
  \item{zero.policy}{by default NULL, use global option value; if TRUE assign zero to the lagged value of zones without neighbours, if FALSE stop with error for any empty
neighbours sets and assign NA.}
  \item{adjust.n}{default TRUE, if FALSE the number of observations is not adjusted for no-neighbour observations, if TRUE, the number of observations is adjusted}
  \item{N}{set the number of spatial permutations for the calculation.}
  \item{graph}{by default = FALSE. Use TRUE to create test's graphic.}
  \item{alternative}{a character string specifying the alternative hypothesis, must be one of greater (default), less or two.sided.}
  \item{spChk}{should the data vector names be checked against the spatial objects for identity integrity, TRUE, or FALSE, default NULL to use \code{get.spChkOption()}}
  \item{print.results}{by default = TRUE. Use FALSE to hide test results (table).
Results are: observed, expected and p-value.}
 \item{...}{other parameters similar to original}
}

\value{
A list with class \code{htest} containing the following components:
  \item{Observed}{the value of the observed Moran's Ixy.}
  \item{Expected}{the expected value of Moran's Ixy.}
  \item{p.value}{the p-value of the test.}
  \item{Values}{corresponds to the N simulated values of Moran's Ixy coefficient for bivariate autocorrelation.}
}

\details{
Compare the observed bivariate Moran's Ixy (moran.bi function) with the expected value empirical density. The expected value is -cor(x,y)/(n-1), where n is the number of rows/samples (number of polygons), and represents the null hyphothesis (Ho) of no spatial Autocorrelation (bivariate Moran's Ixy coefficient around zero). This expected value density is constructed with Monte Carlo simulations. Values significant below of -cor(x,y)/(n-1) represents negative spatial autocorrelation (generally negative values of observed bivariate Moran's Ixy), and values significant above of -cor(x,y)/(n-1) represents positive spatial autocorrelation (generally positive values of observed bivariate Moran's Ixy).
For hypothesis testing the sample values are compared with empirical density, and p-value is calculated. For significant values of p-value (reject Ho), the conclusion of the test could be: "given the value of p-value, there is less than alpha (1\%, or 5\%, or 10\%) likelihood that the pattern (clustered or dispersed) could be the result of random change".
}

\section{Links}{
Adapted from:
\enumerate{
   \item Spatial Autocorrelation \href{https://www.paulamoraga.com/book-spatial/spatial-autocorrelation.html}{(Moran’s I) Test}
   \item Moran's I \href{https://stats.oarc.ucla.edu/r/faq/how-can-i-calculate-morans-i-in-r/}{Test}
}
}

\references{Cliff, A. D., Ord, J. K. 1981 Spatial processes, Pion, p. 21; Bivand RS, Wong DWS 2018 Comparing implementations of global and local indicators of spatial association. TEST, 27(3), 716--748 \doi{10.1007/s11749-018-0599-x}}

\seealso{\code{\link{moran.bi}}, \code{\link{moranbi.mc}}, \code{\link[spdep]{listw2U}}}

\examples{
library(spdep)
data(columbus)
data(oldcol)
columbus <- st_read(system.file("shapes/columbus.gpkg", package="spData")[1])
plot(st_geometry(columbus))
col_nbq <- poly2nb(columbus)
a.lw <- nb2listw(col_nbq, style="W")
set.seed(123)
RCrimeInc.Q <- moranbir.test(columbus$CRIME,columbus$INC,a.lw,graph=TRUE,
                             zero.policy =TRUE,N=1000)
RCrimeInc.Q$Values

\donttest{
COL.k4.nb <- knn2nb(knearneigh(coords, 4))
RCrimeInc.Knn <- moranbir.test(columbus$CRIME, columbus$INC, listw2U(nb2listw(COL.k4.nb,
                               style="W")),graph=TRUE,zero.policy =TRUE,N=1000)
RCrimeInc.Knn
}
}
\keyword{spatial}
