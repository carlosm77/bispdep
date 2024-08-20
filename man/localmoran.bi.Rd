\name{localmoran.bi}
\alias{localmoran.bi}
\alias{localmoran_perm}
\title{BiLISA - Bivariate Local Indicators of Spatial Association Moran's Ixy statistic}
\description{
 The bivariate local spatial statistic Moran's I is calculated for each zone based on the spatial weights object used. The values returned include a Z-value, and may be used as a diagnostic tool. The statistic is:
\deqn{I(i)_{xy} = \frac{(x_i-\bar{x})}{{\sum_{k=1}^{n}(x_k-\bar{x})^2}/(n-1)}{\sum_{j=1}^{n}w_{ij}(y_j-\bar{y})}}, and its expectation and variance were given in Anselin (1995), but those from Sokal et al. (1998) are implemented here.
}
\usage{
localmoran.bi(varX,varY,listw,zero.policy=NULL,na.action=na.fail,conditional=TRUE,
              alternative="two.sided",mlvar=TRUE,spChk=NULL,adjust.x=FALSE)
}
\arguments{
  \item{varX}{a numeric vector the same length as the neighbours list in listw and \code{y}, with the values of the primary variable \code{x}}
  \item{varY}{a numeric vector the same length as the neighbours list in listw and \code{x}, with the values of the secundary variable \code{y}}
  \item{listw}{a \code{listw} object created for example by \code{nb2listw} with spatial weights}
  \item{zero.policy}{default NULL, use global option value; if TRUE assign zero to the lagged value of zones without neighbours, if FALSE assign NA and stop with error for any empty neighbours sets.}
  \item{na.action}{a function (default \code{na.fail}), can also be \code{na.omit} or \code{na.exclude} - in these cases the weights list will be subsetted to remove NAs in the data. Similar meaning and values than parameter \code{na.action} of \code{\link[spdep]{localmoran}}}
  \item{conditional}{default TRUE: expectation and variance are calculated using the conditional randomization null (Sokal 1998 Eqs. A7 & A8). Elaboration of these changes available in Sauer et al. (2021). If FALSE: expectation and variance are calculated using the total randomization null (Sokal 1998 Eqs. A3 & A4).}
  \item{alternative}{type of specifying the alternative hypothesis test, must be one of greater, less or two.sided (default).}
  \item{mlvar}{default TRUE: values of local Moran's I are reported using the variance of the variable of interest (sum of squared deviances over n), but can be reported as the sample variance, dividing by (n-1) instead; both are used in other implementations.}
  \item{spChk}{should the data vector names be checked against the spatial objects for identity integrity, TRUE, or FALSE, default NULL to use \code{get.spChkOption()}}
  \item{adjust.x}{default FALSE, if TRUE, x values of observations with no neighbours are omitted in the mean of x}
}

\details{
The values of local Moran's I are divided by the variance (or sample variance) of the variable of interest to accord with Table 1, p. 103, and formula (12), p. 99, in Anselin (1995), rather than his formula (7), p. 98. The variance of the local Moran statistic is taken from Sokal et al. (1998) p. 334, equations 4 & 5 or equations 7 & 8 located depending on user specification. By default, the implementation divides by n, not (n-1) in calculating the variance and higher moments. Conditional code contributed by Jeff Sauer and Levi Wolf.
}

\value{

  \item{Iyxi}{local moran statistic}
  \item{E.Iyxi}{expectation of local moran statistic; for \code{localmoran_perm}the permutation sample means}
  \item{Var.Iyxi}{variance of local moran statistic; for \code{localmoran_perm}the permutation sample standard deviations}
  \item{Z.Iyxi}{standard deviate of local moran statistic; for \code{localmoran_perm} based on permutation sample means and standard deviations}
  \item{Pr()}{p-value of local moran statistic using \code{pnorm()}; for \code{localmoran_perm} using standard deviatse based on permutation sample means and standard deviations}
  \item{Pr() Sim}{For \code{localmoran_perm}, \code{rank()} and \code{punif()} of observed statistic rank for [0, 1] p-values using \code{alternative=}}
  \item{Pr(folded) Sim}{the simulation folded [0, 0.5] range ranked p-value (based on \url{https://github.com/pysal/esda/blob/4a63e0b5df1e754b17b5f1205b8cadcbecc5e061/esda/crand.py#L211-L213})}
  \item{Skewness}{For \code{localmoran_perm}, the output of \code{e1071::skewness()} for the permutation samples underlying the standard deviates}
  \item{Kurtosis}{For \code{localmoran_perm}, the output of \code{e1071::kurtosis()} for the permutation samples underlying the standard deviates}
In addition, an attribute data frame \code{"quadr"} with mean and median quadrant columns, and a column splitting on the demeaned variable and lagged demeaned variable at zero.
}
\note{Conditional permutations added for comparative purposes; permutations are over the whole data vector omitting the observation itself. For p-value adjustment, use \code{p.adjust()} or \code{p.adjustSP()} on the output vector.}
\references{Getis, A. and Ord, J. K. 1996 Local spatial
statistics: an overview. In P. Longley and M. Batty (eds) \emph{Spatial
analysis: modelling in a GIS environment} (Cambridge: Geoinformation International), 261--277; Sokal, R. R, Oden, N. L. and Thomson, B. A. 1998. Local Spatial Autocorrelation in a Biological Model. Geographical Analysis, 30. 331--354;
Czaplewski, R.L., Reich, R.M. 1993. Expected value and variance of Moran's bivariate spatial autocorrelation statistic for a permutation test, Research paper RM-309, Fort Collins, CO U.S. Department of Agriculture, Forest Service, Rocky Mountain Forest and Range Experiment Station, p, 13.;
Anselin, Luc, Ibnu Syabri, and Oleg Smirnov. 2002. “Visualizing Multivariate Spatial Correlation with Dynamically Linked Windows.” In New Tools for Spatial Data Analysis: Proceedings of the Specialist Meeting, edited by Luc Anselin and Sergio Rey. University of California, Santa Barbara: Center for Spatially Integrated Social Science (CSISS)

}

\seealso{\code{\link[spdep]{localG}}}

\examples{
library(spdep)
# load columbus data
data(columbus)
data(oldcol)
columbus <- st_read(system.file("shapes/columbus.gpkg", package="spData")[1])
col_nbq <- poly2nb(columbus)
a.lw <- nb2listw(col_nbq, style="W")
localmoran.bi(columbus$CRIME, columbus$HOVAL, a.lw, zero.policy=TRUE,
              alternative="two.sided")
}
\keyword{spatial}
