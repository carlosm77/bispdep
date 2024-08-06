\name{geary.bi}
\alias{geary.bi}

\title{Compute Bivariate Geary's Cxy}
\description{
  A simple function to compute Bivariate Geary's Cxy;
\deqn{C_{xy} = \frac{(n-1)}{2\sum_{i=1}^{n}\sum_{j=1}^{n}w_{ij}}
\frac{\sum_{i=1}^{n}\sum_{j=1}^{n}w_{ij}(x_i-y_j)^2}{\sum_{i=1}^{n}(x_i - \bar{x})^2}
}

}
\usage{
geary.bi(varX, varY, listw, zero.policy=NULL, adjust.n = TRUE,
         alternative = "greater")
}

\arguments{
  \item{varX}{a numeric vector the same length as the neighbours list in listw with the values of the variable \code{x}}
  \item{varY}{a numeric vector the same length as the neighbours list in listw with the values of the variable \code{y}}
  \item{listw}{a \code{listw} object created for example by \code{nb2listw}}
  \item{zero.policy}{default NULL, use global option value; if TRUE assign zero to the lagged value of zones without neighbours, if FALSE assign NA}
  \item{adjust.n}{default TRUE, if FALSE the number of observations is not adjusted for no-neighbour observations, if TRUE, the number of observations is adjusted}
  \item{alternative}{a character string specifying the alternative hypothesis, must be one of greater (default), less or two.sided.}

}

\value{
a list with
  \item{C}{Bivariate Geary's C}
  \item{Kx}{sample kurtosis of \code{x}}
  \item{Ky}{sample kurtosis of \code{y}}
}

\references{Wartenberg, Daniel. 2010. Multivariate Spatial Correlation: A Method for Exploratory Geographical Analysis. Geographical Analysis. 17. 263 - 283. 10.1111/j.1538-4632.1985.tb00849.x.}

\seealso{\code{\link{gearybi.test}}}

\examples{
library(spdep)
data(oldcol)
col.W <- nb2listw(COL.nb, style="W")
geary.bi(COL.OLD$CRIME, COL.OLD$INC, col.W, zero.policy = TRUE)
}
\keyword{spatial}
