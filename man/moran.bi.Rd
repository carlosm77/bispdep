\name{moran.bi}
\alias{moran.bi}
\title{Compute Bivariate Moran's Ixy}
\description{
  A simple function to compute bivariate Moran's Ixy, called by \code{moranbi.test} and \code{moranbi.mc};
\deqn{I = \frac{n}{\sum_{i=1}^{n}\sum_{j=1}^{n}w_{ij}}
\frac{\sum_{i=1}^{n}\sum_{j=1}^{n}w_{ij}(x_i-\bar{x})(y_j-\bar{y})}{\sum_{i=1}^{n}(x_i - \bar{x})^2}
}{I_{xy} = (n sum_i sum_j w_ij (x_i - xbar) (y_j - ybar)) / (S0 sum_i (x_i - xbar)^2)}
}
\usage{
moran.bi(varX, varY, listw, zero.policy=NULL, adjust.n = TRUE, NAOK=FALSE)
}
\arguments{
  \item{varX}{a numeric vector of the same length as the neighbours list in listw with the values of the variable \code{x}}
  \item{varY}{a numeric vector of the same length as the neighbours list in listw with the values of the variable \code{y}}
  \item{listw}{a \code{listw} object created for example by \code{nb2listw}}
  \item{zero.policy}{default NULL, use global option value; if TRUE assign zero to the lagged value of zones without neighbours, if FALSE assign NA}
  \item{adjust.n}{default TRUE, if FALSE the number of observations is not adjusted for no-neighbour observations, if TRUE, the number of observations is adjusted}
  \item{NAOK}{if 'TRUE' then any 'NA' or 'NaN' or 'Inf' values in x are passed on to the foreign function.  If 'FALSE', the presence of 'NA' or 'NaN' or 'Inf' values is regarded as an error}
}

\value{
a list of
  \item{I}{Bivariate Moran's I}
  \item{Kx}{sample kurtosis of the variable X}
  \item{Ky}{sample kurtosis of the variable Y}
}
\references{Czaplewski, R.L., Reich, R.M. 1993. Expected value and variance of Moran's bivariate spatial autocorrelation statistic for a permutation test, Research paper RM-309, Fort Collins, CO U.S. Department of Agriculture, Forest Service, Rocky Mountain Forest and Range Experiment Station, p, 13.}

\seealso{\code{\link{moranbi.test}}, \code{\link{moranbi.mc}}}

\examples{
library(spdep)
data(oldcol)
col.W <- nb2listw(COL.nb, style="W")
crime <- COL.OLD$CRIME
inc <- COL.OLD$INC
str(moran.bi(crime, inc, col.W, zero.policy = TRUE, NAOK=FALSE))
set.seed(123)
is.na(crime) <- sample(1:length(crime), 5)
is.na(inc) <- sample(1:length(inc), 10)
str(moran.bi(crime, inc, col.W, zero.policy = TRUE, NAOK=TRUE))
}
\keyword{spatial}
