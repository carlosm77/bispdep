\name{correlogram.bi}
\alias{correlogram.bi}
\alias{plot.correlogrambi}
\alias{print.correlogrambi}

\title{ Computes Bivariate Moran's or Geary's coefficients on distance classes }
\description{
  Computes Bivariate Moran's or Geary's coefficients on distance classes from a set of spatial coordinates and values of the two corresponding variables varX and varY.
}
\usage{
correlogram.bi(coords, varX, varY, method="Moran", nbclass = NULL, zero.policy=NULL, ...)
}

\arguments{
  \item{coords}{a two columns array, data.frame or matrix of spatial coordinates. Column 1 = X, Column 2 = Y. }
  \item{varX}{a vector for the values of the variable \code{x} at each location. Must have the same length as the row number of coords}
  \item{varY}{a vector for the values of the variable \code{y} at each location. Must have the same length as the row number of coords }
  \item{method}{ the method used. Must be "Moran" (default) or "Geary" }
  \item{nbclass}{number of bins. If NULL Sturges method is used to compute an optimal number}
  \item{zero.policy}{default NULL, use global option value; if TRUE assign zero to the lagged value of zones without neighbours, if FALSE assign NA}

  \item{\dots}{further arguments to pass to e.g. \code{\link[bispdep]{moranbi.test}} or \code{\link[bispdep]{gearybi.test}}}
}
\details{
  Uses the library bispdep including \code{\link[bispdep]{moranbi.test}} or \code{\link[bispdep]{gearybi.test}}. Distances are euclidian and in the same unit as the spatial coordinates.  Moran's Ho: I values larger than 0 due to chance; Geary's Ho: C values lesser than 1 due to chance, \code{correlogrambi} has print and plot methods; statistically significant values (p<0.05) are plotted in red.
}
\value{
  An object of class "correlogrambi", a matrix including:
  \item{class }{bin centers}
  \item{I }{the coefficient values}
  \item{p.value }{probability of Ho }
  \item{n }{the number of pairs}
  \item{low.l}{bin lower limit}
  \item{up.l}{bin upper limit}
}
\references{ see library bispdep }

\section{Warning }{Computing can take a long time for large data sets}

\seealso{ \code{\link[bispdep]{gearybi.test}}, \code{\link[bispdep]{moranbi.test}} }
\examples{
library(spdep)
library(sf)
data(oldcol)
attach(COL.OLD)
coords<-cbind(X,Y)
columbus <- st_read(system.file("shapes/columbus.gpkg", package="spData")[1])
plot(st_geometry(columbus))

\donttest{
corbiM <- correlogram.bi(coords,columbus$CRIME,columbus$INC,zero.policy=TRUE)
corbiM
plot(corbiM)

corbiG <- correlogram.bi(coords,columbus$CRIME,columbus$INC,method="Geary",zero.policy=TRUE)
corbiG
plot(corbiG)
}
}
\keyword{ spatial }
