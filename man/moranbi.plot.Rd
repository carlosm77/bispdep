\name{moranbi.plot}
\alias{moranbi.plot}
\title{Bivariate Moran scatterplot}
\description{
 A plot of spatial data of the variable "varY" against the spatially lagged values of the variable "varX", augmented by reporting the summary of influence measures for the linear relationship between the data of "varY" and the lag of "varX" ". If policy zero is TRUE, such observations are also flagged if they occur.
}
\usage{
moranbi.plot(varY, varX, listw, zero.policy=NULL, spChk=NULL, labels=NULL,
 xlab=NULL, ylab=NULL, quiet=NULL, plot=TRUE, return_df=TRUE, ...)
}
\arguments{
  \item{varX}{a numeric vector of the same length as the neighbours list in listw with the values of the variable \code{x}}
  \item{varY}{a numeric vector of the same length as the neighbours list in listw with the values of the variable \code{y}}
  \item{listw}{a \code{listw} object created for example by \code{nb2listw}}
  \item{zero.policy}{default NULL, use global option value; if TRUE assign zero to the lagged value of zones without neighbours, if FALSE assign NA}
  \item{spChk}{should the data vector names be checked against the spatial objects for identity integrity, TRUE, or FALSE, default NULL to use \code{get.spChkOption()}}
  \item{labels}{character labels for points with high influence measures, if set to FALSE, no labels are plotted for points with large influence}
  \item{xlab}{label for x axis}
  \item{ylab}{label for x axis}
  \item{quiet}{default NULL, use !verbose global option value; if TRUE, output of summary of influence object suppressed}
  \item{plot}{default is TRUE, to suppress the plotting use FALSE}
  \item{return_df}{default TRUE, invisibly return a data.frame object; if FALSE invisibly return an influence measures object}
  \item{\dots}{other graphical parameters as in \code{par(..)}}
}

\value{
 The function returns a data.frame object with coordinates and influence measures if \code{return_df} is TRUE, or an influence object from \code{influence.measures}.
}
\references{Matkan, A.A., Shahri, M. and Mirzaie, M., 2013, September. Bivariate Moran’s I and LISA to explore the crash risky locations in urban areas. In Proceedings of the Conference of Network-Association of European Researchers on Urbanisation in the South, Enschede, The Netherlands (pp. 12-14).}

\seealso{\code{\link{localmoran.bi}}, \code{\link[stats]{influence.measures}}}

\examples{
library(spdep)
columbus <- st_read(system.file("shapes/columbus.gpkg", package="spData")[1])
col_nbq <- poly2nb(columbus)
a.lw <- nb2listw(col_nbq, style="W")

# Editing axis labels
CRIME <- as.vector(scale(columbus$CRIME))
INCOME <- as.vector(scale(columbus$INC))
moranbi.plot(CRIME,INCOME,quiet =FALSE,zero.policy =FALSE,listw=a.lw)
# Without editing the label of the axes
moranbi.plot(as.vector(scale(columbus$CRIME)),as.vector(scale(columbus$INC)),
             quiet =FALSE,zero.policy =FALSE,listw=a.lw)

# Moran scatterplot
mp <- moranbi.plot(CRIME,INCOME,quiet=FALSE,zero.policy=FALSE,listw=a.lw,
                   label=columbus$POLYID, plot = FALSE)

# Plot Moran Scatterplot in ggplot
if (require(ggplot2, quietly=TRUE)) {
# xname <- attr(mp, "xname")
ggplot2::ggplot(mp, aes(x=varY, y=wx)) + geom_point(shape=1) +
  geom_smooth(formula=y ~ x, method="lm") +
  geom_hline(yintercept=mean(mp$wx), lty=2) +
  geom_vline(xintercept=mean(mp$varY), lty=2) + theme_minimal() +
  geom_point(data=mp[mp$is_inf,], aes(x=varY, y=wx), shape=9) +
  geom_text(data=mp[mp$is_inf,], aes(x=varY, y=wx, label=labels, vjust=1.5)) +
  # xlab(xname) + ylab(paste0("Spatially lagged ", xname))
  xlab("Crime") + ylab("Spatially Lagged Income")
}
}
\keyword{spatial}
