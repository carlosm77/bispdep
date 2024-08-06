\name{correlogram}
\alias{correlogram}
\alias{plot.correlogram}
\alias{print.correlogram}

\title{ Computes Moran's or Geary's coefficients on distance classes }
\description{
  Computes Moran's or Geary's coefficients on distance classes from a set of spatial coordinates and corresponding z values
}
\usage{
correlogram(coords, z, method="Moran", nbclass = NULL, zero.policy=NULL, ...)
}

\arguments{
  \item{coords}{a two columns array, data.frame or matrix of spatial coordinates. Column 1 = X, Column 2 = Y. }
  \item{z}{ a vector for the values at each location. Must have the same length as the row number of coords }
  \item{method}{ the method used. Must be "Moran" (default) or "Geary" }
  \item{nbclass}{number of bins. If NULL Sturges method is used to compute an optimal number}
  \item{zero.policy}{default NULL, use global option value; if TRUE assign zero to the lagged value of zones without neighbours, if FALSE assign NA}

  \item{\dots}{further arguments to pass to e.g. \code{\link[spdep]{moran.test}} or \code{\link[spdep]{geary.test}}}
}
\details{
  Uses the library spdep including \code{\link[spdep]{moran.test}} or \code{\link[spdep]{geary.test}}. Distances are euclidian and in the same unit as the spatial coordinates.  Moran's Ho: I values larger than 0 due to chance; Geary's Ho: C values lesser than 1 due to chance. \code{correlogram} has print and plot methods; statistically significant values (p<0.05) are plotted in red.
}
\value{
  An object of class "correlogram", a matrix including:
  \item{class }{bin centers}
  \item{I }{the coefficient values}
  \item{p.value }{probability of Ho }
  \item{n }{the number of pairs}
  \item{low.l}{bin lower limit}
  \item{up.l}{bin upper limit}
}
\references{see library spdep}

\section{Warning }{Computing can take a long time for large data sets}

\seealso{ \code{\link[spdep]{geary.test}}, \code{\link[spdep]{moran.test}} }
\examples{

library(spdep)
data(oldcol)
attach(COL.OLD)
coords<-cbind(X,Y)
corM <- correlogram(coords,CRIME,zero.policy=TRUE)
corM
plot(corM)

corG <- correlogram(coords,CRIME,method="Geary",zero.policy=TRUE)
corG
plot(corG)

}
\keyword{ spatial }
