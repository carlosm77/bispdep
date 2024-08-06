\name{getis.cluster}
\alias{getis.cluster}
\title{Getis and Ord's Gi* Cluster and Significance Map}
\description{
Create the Getis Gi* Cluster Map and the corresponding Significance Map.
Maps are done calculating the Local Gi* (localG - spdep) for each
spatial unit and testing its significance.
}
\usage{
getis.cluster(x, listw, zero.policy = NULL, polygons, significant = TRUE, pleg, ...)
}
\arguments{
\item{x}{variable to create cluster and significance map}

\item{listw}{a neighbours list with spatial weights. From package spdep:
a listw object. Use poly2nb (class nb)
and nb2listw (class listw, nb) from package spdep. Can be any type of listw
object, for instance, rook contiguity (common edge) or queen contiguity (common
edge or common vertex)}

\item{zero.policy}{by default = NULL, if FALSE stop with error for any empty
neighbour sets, if TRUE permit the weights list to be formed with zero-length
weights vectors. Parameter inherited from the spdep package.}

\item{polygons}{SpatialPolygons, SpatialPolygonsDataFrame or sfc_POLYGON object}

\item{significant}{by default is TRUE, if FALSE the significant map is not created}

\item{pleg}{the x and y co-ordinates to be used to position the legend. They can be specified by keyword or in any way which is accepted by \code{\link[grDevices]{xy.coords}}}

\item{...}{other graphical parameters as in \code{par(..)}}
}
\value{
one or two maps
}
\details{
Using the function localG (spdep) create the Getis Gi* Cluster Map and the
corresponding Significance Map.
The significance map is done testing the null hypothesis (Ho) of zero spatial
autocorrelation for each spatial unit, then plotting a choropleth map with this
legend values: (Not Significant, p-value=0.05, p-value= 0.01, p-value=0.001,
p-value=0.0001, and Neighborless). Most significant clustered spatial units are
those with p-values smaller than 0.0001. Not significant
clustered spatial units are those with p-values grather than 0.05. Gi* Cluster Map
is done based on the significance map, but the choropleth legend is different (Not
- Significant, High-High, Low-Low, Low-High, High-Low, and Neighborless).
}
\section{Links}{


\enumerate{
   \item \href{https://pysal.org/esda/notebooks/spatialautocorrelation.html}{Spatial Autocorrelation}
}
}

\examples{
library(spdep)
columbus <- st_read(system.file("shapes/columbus.gpkg", package="spData")[1])
col_nbq <- poly2nb(columbus)
a.lw <- nb2listw(col_nbq, style="W")
getis.cluster(columbus$CRIME, a.lw, zero.policy = FALSE, st_geometry(columbus),
              significant=TRUE, pleg = "topleft")

}
\seealso{
\itemize{
  \item Bivariate Moran's Ixy: \code{\link{moran.bi}}
  \item Plot Bivariate Moran's Ixy: \code{\link{moranbi.plot}}
  \item Bivariate Moran's Ixy Test: \code{\link{moranbi.test}}
  \item Bivariate Local Moran's Ixy and Test: \code{\link{localmoran.bi}}
  \item Create object "nb": \code{\link[spdep]{poly2nb}}
  \item Create object "listw"/"nb": \code{\link[spdep]{nb2listw}}
}
}
