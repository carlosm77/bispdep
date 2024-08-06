\name{randomize_vector}
\alias{randomize_vector}
\title{Generate a random sample from other vector}
\usage{
randomize_vector(X, N)
}
\arguments{
\item{X}{vector to choose from}

\item{N}{number of random elements to select from X}
}
\value{
a list, a vector
}
\description{
Use function 'sample' from base R library
to generate a random sample.
Function taken from Edzer Pebesma package.
}
\examples{
library(spdep)
example(columbus)
#col_nbq <- poly2nb(columbus)
#a.lw <- nb2listw(col_nbq, style="W")
#set.seed(123)
DF <- data.frame(1:length(columbus$CRIME),columbus$CRIME,columbus$INC)
X1<-randomize_vector(DF$Obs,999)
}
