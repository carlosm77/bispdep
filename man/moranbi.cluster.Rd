\name{moranbi.cluster}
\alias{moranbi.cluster}
\title{Maps of BiLISA clusters and statistical significance associated with BiLISA}
\description{
Using the \code{localmoran.bi} function, create a Bivariate Local Indicators of Spatial Association (BiLISA) cluster map and corresponding significance map. The maps are made by calculating the BiLISAs from \code{localmoran.bi} for each of the spatial units and then the statistical significance is evaluated to determine the spatial clusters and outliers.
}
\usage{
moranbi.cluster(varY, varX, listw, zero.policy = NULL, polygons, conditional=TRUE,
                significant = TRUE, alternative = "two.sided", pleg, ...)
}
\arguments{
  \item{varY}{a numeric vector the same length as the neighbours list in listw and \code{x}, with the values of the secundary variable \code{y}}

  \item{varX}{a numeric vector the same length as the neighbours list in listw and \code{y}, with the values of the primary variable \code{x}}

  \item{listw}{a neighbours list with spatial weights. From package spdep:
a listw object. Use \code{poly2nb} (class \code{nb})
and \code{nb2listw} (class \code{listw}, \code{nb}) from package spdep. Can be any type of listw
object, for instance, rook contiguity (common edge) or queen contiguity (common
edge or common vertex)}

\item{zero.policy}{by default = NULL, if FALSE stop with error for any empty
neighbour sets, if TRUE permit the weights list to be formed with zero-length
weights vectors. Parameter inherited from the \code{spdep} package.}

\item{polygons}{SpatialPolygons, SpatialPolygonsDataFrame or sfc_POLYGON object}

\item{conditional}{default TRUE: expectation and variance are calculated using the conditional randomization null (Sokal 1998 Eqs. A7 & A8). Elaboration of these changes available in Sauer et al. (2021). If FALSE: expectation and variance are calculated using the total randomization null (Sokal 1998 Eqs. A3 & A4).}


\item{significant}{by default is TRUE, if FALSE the significant map is not created}

\item{alternative}{by default is "two.sided". Type of alternative hypothesis test.
Other values are "less" or "greater".}

\item{pleg}{the x and y co-ordinates to be used to position the legend. They can be specified by keyword or in any way which is accepted by \code{\link[grDevices]{xy.coords}}}

\item{...}{other parameters similar to internal function \code{\link[spdep]{moran}} and other graphical parameters as in \code{par(..)}}
}
\value{
one or two maps
}

\details{
Using the function \code{localmoran.bi} create the Bivariate Local Indicators of Spatial
Association - BiLISA Cluster Map and the corresponding Significance Map.
The significance map is done testing the null hypothesis (Ho) of zero spatial
autocorrelation for each spatial unit and then plotting a choropleth map with this
legend values: (Not Significant, p-value=0.05, p-value= 0.01, p-value=0.001,
p-value=0.0001, and Neighborless). Maps can represent concentrations of similar (cluster)
or dissimilar values (spatial outliers). Most significant clustered spatial units are
those with p-values smaller than 0.0001. Not significant clustered spatial units are
those with p-values greater than 0.05. BiLISA Cluster Map is done based on the
significance map but the choropleth legend is different (Not - Significant, High-High, Low-Low, Low-High, High-Low, and Neighborless).
}
\section{Links}{


\enumerate{
   \item \href{https://en.wikipedia.org/wiki/Indicators_of_spatial_association}{Indicators of Spatial Association}
}
}

\examples{
library(spdep)
data(columbus)
columbus <- st_read(system.file("shapes/columbus.gpkg", package="spData")[1])
plot(st_geometry(columbus))
col_nbq <- poly2nb(columbus)
a.lw <- nb2listw(col_nbq, style="W")
moranbi.cluster(columbus$CRIME, columbus$HOVAL, a.lw, zero.policy = FALSE,
                conditional=TRUE, st_geometry(columbus), significant=TRUE,
                pleg = "topleft")
moranbi.cluster(columbus$CRIME, columbus$HOVAL, a.lw, zero.policy = FALSE,
                st_geometry(columbus), significant=TRUE, alternative="greater",
                pleg = "topleft")
}
\seealso{
\itemize{
  \item Bivariate Moran's Ixy: \code{\link{moran.bi}}
  \item Plot Bivariate Moran's Ixy: \code{\link{moranbi.plot}}
  \item Bivariate Moran's Ixy Test: \code{\link{moranbi.test}}
  \item Create object "nb": \code{\link[spdep]{poly2nb}}
  \item Create object "listw"/"nb": \code{\link[spdep]{nb2listw}}
}
}
