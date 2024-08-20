\name{spcorrelogram.bi}
\alias{spcorrelogram.bi}
\alias{plot.spcorbi}
\alias{print.spcorbi}
\title{Bivariate spatial correlogram}
\description{
  Bivariate spatial correlograms for Moran's Ixy and the autocorrelation coefficient, with print and plot helper functions.
}
\usage{
spcorrelogram.bi(neighbours, varX, varY, order = 1, method = "corr",
                 style = "W", randomisation = TRUE, zero.policy = NULL,
                 spChk=NULL, alternative = "greater", drop.EI2=FALSE)
\method{plot}{spcorbi}(x, main, ylab, ylim, ...)
\method{print}{spcorbi}(x, p.adj.method="none", ...)
}

\arguments{
  \item{neighbours}{an object of class \code{nb}}
  \item{varX}{a numeric vector of the variable \code{x}}
  \item{varY}{a numeric vector of the variable \code{y}}
  \item{order}{maximum lag order}
  \item{method}{"corr" for correlation, "I" for Moran's Ixy, "C" for Geary's Cxy}
  \item{style}{\code{style} can take values W, B, C, and S}
  \item{randomisation}{variance of I or C calculated under the assumption of randomisation, if FALSE normality}
  \item{zero.policy}{default NULL, use global option value; if FALSE stop with error for any empty neighbour sets,
if TRUE permit the weights list to be formed with zero-length weights vectors}
  \item{spChk}{should the data vector names be checked against the spatial objects for identity integrity, TRUE, or FALSE, default NULL to use \code{get.spChkOption()}}
  \item{alternative}{a character string specifying the alternative hypothesis, must be one of greater (default), less or two.sided.}
  \item{drop.EI2}{default FALSE, if TRUE, emulate CrimeStat <= 4.02}
  \item{x}{an object from \code{spcorrelogram.bi()} of class \code{spcorbi}}
  \item{p.adj.method}{correction method as in \code{p.adjust}}
  \item{main}{an overall title for the plot}
  \item{ylab}{a title for the y axis}
  \item{ylim}{the y limits of the plot}
  \item{\dots}{further arguments passed through}
}
\details{
  The print function also calculates the standard deviates of Bivariate Moran's Ixy or Geary's Cxy and a two-sided probability value, optionally using \code{p.adjust} to correct by the nymber of lags. The plot function plots a bar from the estimated value of Bivariate Moran's Ixy, or Geary's Cxy to +/- twice the square root of its variance (in previous releases only once, not twice). The table includes the count of included observations in brackets after the lag order. Care must be taken when interpreting the results, since increasing the order of the lag tends to include fewer observations.
}

\value{
  returns a list of class \code{spcorbi}:
  \item{res}{for "corr" a vector of values; for "I", a matrix of estimates of "I", expectations, and variances}
  \item{method}{"I" or "corr"}
  \item{cardnos}{list of tables of neighbour cardinalities for the lag orders used}
  \item{var}{variable name}
}
\references{Czaplewski, R.L., Reich, R.M. 1993. Expected value and variance of Moran's bivariate spatial autocorrelation statistic for a permutation test, Research paper RM-309, Fort Collins, CO U.S. Department of Agriculture, Forest Service, Rocky Mountain Forest and Range Experiment Station, p, 13.}

\seealso{\code{\link[spdep]{nblag}}, \code{\link{moran.bi}}, \code{\link[stats]{p.adjust}}}

\examples{
library(spdep)
data(columbus)
data(oldcol)
columbus <- st_read(system.file("shapes/columbus.gpkg", package="spData")[1])
plot(st_geometry(columbus))
col_nbq <- poly2nb(columbus)

Cspcb <- spcorrelogram.bi(col_nbq,columbus$CRIME,columbus$INC,order=7,
                          method="corr",zero.policy=TRUE,alternative="two.sided")
print(Cspcb)
plot(Cspcb)

Ispcb <- spcorrelogram.bi(col_nbq,columbus$CRIME,columbus$INC,order=7,
                          method="I",zero.policy=TRUE,alternative="two.sided")
print(Ispcb)
plot(Ispcb)

Cspcb <- spcorrelogram.bi(col_nbq,columbus$CRIME,columbus$INC,order=7,
                          method="C",zero.policy=TRUE,alternative="two.sided")
print(Ispcb)
plot(Ispcb)
}
\keyword{spatial}
