\name{moranbi.test}
\alias{moranbi.test}
\title{Moran's Ixy test for bivariate spatial autocorrelation}
\description{
 Moran's Ixy test for bivariate spatial autocorrelation using a spatial weights matrix in weights list form. The assumptions underlying the test are sensitive to the form of the graph of neighbour relationships and other factors, and results may be checked against those of \code{moranbi.mc} permutations.
}
\usage{
moranbi.test(varX,varY,listw,randomisation=TRUE,zero.policy=NULL,
             alternative="greater",rank=FALSE,spChk=NULL,adjust.n=TRUE,
             drop.EI2=FALSE)
}
\arguments{
  \item{varX}{a numeric vector of the same length as the neighbours list in listw with the values of the variable \code{x}}
  \item{varY}{a numeric vector of the same length as the neighbours list in listw with the values of the variable \code{y}}
  \item{listw}{a \code{listw} object created for example by \code{nb2listw}}
  \item{randomisation}{variance of I calculated under the assumption of randomisation, if FALSE normality}
  \item{zero.policy}{default NULL, use global option value; if TRUE assign zero to the lagged value of zones without neighbours, if FALSE assign NA}
  \item{alternative}{a character string specifying the alternative hypothesis, must be one of greater (default), less or two.sided.}
  \item{rank}{logical value - default FALSE for continuous variables, if TRUE, uses the adaptation of Moran's I for ranks suggested by Cliff and Ord (1981, p. 46)}
  \item{spChk}{should the data vector names be checked against the spatial objects for identity integrity, TRUE, or FALSE, default NULL to use \code{get.spChkOption()}}
  \item{adjust.n}{default TRUE, if FALSE the number of observations is not adjusted for no-neighbour observations, if TRUE, the number of observations is adjusted}
  \item{drop.EI2}{default FALSE, if TRUE, emulate CrimeStat <= 4.02}
}


\value{
A list with class \code{htest} containing the following components:
  \item{statistic}{the value of the standard deviate of Moran's Ixy.}
  \item{p.value}{the p-value of the test.}
  \item{estimate}{the value of the observed Moran's Ixy, its expectation and variance under the method assumption.}
  \item{alternative}{a character string specifying the alternative hypothesis, must be one of greater (default), less or two.sided.}
  \item{method}{a character string giving the assumption used for calculating the standard deviate.}
  \item{data.name}{a character string giving the name(s) of the data.}
}
\note{Var(Ixy) is taken from Cliff and Ord (1969, p. 28), and
Goodchild's CATMOG 47 (1986),
see also Upton & Fingleton (1985) p. 171; it agrees with SpaceStat,
see Tutorial workbook Chapter 22; VIxy is the second crude moment minus the
square of the first crude moment. The derivation of the test (Cliff and Ord, 1981, p. 18) assumes that the weights matrix is symmetric. For inherently non-symmetric matrices, such as k-nearest neighbour matrices, \code{listw2U()} can be used to make the matrix symmetric.
}

\references{Cliff, A. D., Ord, J. K. 1981 Spatial processes, Pion, p. 21; Bivand RS, Wong DWS 2018 Comparing implementations of global and local indicators of spatial association. TEST, 27(3), 716--748 \doi{10.1007/s11749-018-0599-x}}

\seealso{\code{\link[spdep]{moran}}, \code{\link[spdep]{moran.mc}}, \code{\link[spdep]{listw2U}}}

\examples{
library(spdep)
data(columbus)
data(oldcol)
columbus <- st_read(system.file("shapes/columbus.gpkg", package="spData")[1])
plot(st_geometry(columbus))
col_nbq <- poly2nb(columbus)
set.seed(123)
BMCrime <- moranbi.test(columbus$CRIME,columbus$INC,nb2listw(COL.nb, style="W"),
           zero.policy =TRUE, alternative = "two.sided")
BMCrime
moranbi.test(columbus$CRIME,columbus$INC,nb2listw(COL.nb,style="B"),
             zero.policy =TRUE,alternative = "two.sided",randomisation=FALSE)
colold.lags <- nblag(col_nbq, 3)
moranbi.test(columbus$CRIME,columbus$INC,nb2listw(colold.lags[[2]],style="W"),
             zero.policy =TRUE, alternative = "two.sided",randomisation=FALSE)
print(is.symmetric.nb(COL.nb))

COL.k4.nb <- knn2nb(knearneigh(coords, 4))
print(is.symmetric.nb(COL.k4.nb))
cat("Note: non-symmetric weights matrix, use listw2U()")
moranbi.test(columbus$CRIME,columbus$INC,listw2U(nb2listw(COL.k4.nb,style="W")),
             zero.policy =TRUE,adjust.n = TRUE)
moranbi.test(columbus$CRIME,columbus$INC,listw2U(nb2listw(COL.k4.nb,style="W")),
             zero.policy =TRUE, randomisation=FALSE)

ranksX <- rank(columbus$CRIME)
ranksY <- rank(columbus$INC)
names(ranksX) <- rownames(columbus)
names(ranksY) <- rownames(columbus)
moranbi.test(ranksX,ranksY,nb2listw(COL.k4.nb,style="W"),rank=TRUE,
             zero.policy=TRUE,alternative="two.sided")

crime <- columbus$CRIME
income <- columbus$INC
set.seed(123)
is.na(crime) <- sample(1:length(crime), 5)
is.na(income) <- sample(1:length(income), 4)
DF <- data.frame(crime,income)
col.na <- moranbi.test(DF$crime, DF$income, nb2listw(COL.nb, style="W"),
           zero.policy =TRUE)
col.na
}
\keyword{spatial}
