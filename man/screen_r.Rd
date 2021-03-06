% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filters.R
\name{screen_r}
\alias{screen_r}
\title{Screen to detect impossible values in vectors of correlations and sample sizes.}
\usage{
screen_r(r_vec, n_vec)
}
\arguments{
\item{r_vec}{Vector of correlations.}

\item{n_vec}{Vector of sample sizes.}
}
\value{
List of filtered correlations and sample sizes.
}
\description{
Screen to detect impossible values in vectors of correlations and sample sizes.
}
\examples{
## Not run
## screen_r(r_vec = c(-.3, .5, 1.1), n_vec = c(100, 100, 100))
## screen_r(r_vec = c(-.3, .5, .8), n_vec = c(Inf, 100, 100))
## screen_r(r_vec = c(-.3, .5, .8), n_vec = c(2, 100, 100))
}
\keyword{internal}
