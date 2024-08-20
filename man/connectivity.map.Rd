\name{connectivity.map}
\alias{connectivity.map}
\title{Map of spatial connectivity}
\description{
Generates a map of spatial connectivity according to a predefined neighborhood scheme, around a region selected by the user by clicking on the screen.}
\usage{
connectivity.map(nb,polygons,var.label,obs,col,cex, ...)
}
\arguments{
  \item{nb}{an object of class \code{nb} with a list of integer vectors containing neighbour region number ids}
  \item{polygons}{the spatial dataset: sf or SpatialPolygonsDataFrame (spdep)}
  \item{var.label}{variable to label in the connectivity neighborhood}
  \item{obs}{number of the observation around which neighborhood connectivity will be performed. by default is NULL, the user can press the (first) mouse button over the map region for which he wishes to identify his neighborhood.}
  \item{col}{color to assign in the regions of the defined neighborhood}
  \item{cex}{text size on neighborhood labels}
  \item{...}{further specifications, see plot_sf and plot and details.}
}

\value{
around a region selected by the user by clicking on the screen
A spatial connectivity map showing the neighbors according to the weighting scheme.
}

\seealso{\code{\link[spdep]{poly2nb}}, \code{\link[spdep]{knn2nb}}, \code{\link[spdep]{graph2nb}}}

\examples{
library(spdep)
columbus <- st_read(system.file("shapes/columbus.gpkg", package="spData")[1])
#Queen neighbours
col_nbq1 <- poly2nb(columbus)             # queen, order 1
col.lags10 <- nblag(col_nbq1, 10)         # queen, up to order 10
connectivity.map(col.lags10[[1]],columbus,"COLUMBUS_I",obs=25,col="green",cex=0.5)

sf_obj <- st_centroid(st_geometry(columbus), of_largest_polygon)
sp_obj <- as(sf_obj, "Spatial")
coords <- st_coordinates(sf_obj)

col.k4 <- knn2nb(knearneigh(coords,4))
connectivity.map(col.k4,columbus,"COLUMBUS_I",obs=25,col="green",cex=0.5)

suppressMessages(trinb <- tri2nb(coords))
connectivity.map(trinb,columbus,"COLUMBUS_I",obs=25,col="green",cex=0.5)

gabrielnb=graph2nb(gabrielneigh(coords),sym=TRUE)
connectivity.map(gabrielnb,columbus,"COLUMBUS_I",obs=25,col="green",cex=0.5)
}
\keyword{spatial connectivity}
