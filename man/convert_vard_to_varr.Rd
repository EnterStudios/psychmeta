% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convert_ma.R
\name{convert_vard_to_varr}
\alias{convert_vard_to_varr}
\title{Convert the variance of d to the variance of r via TSA}
\usage{
convert_vard_to_varr(d, var, p)
}
\arguments{
\item{d}{Standardized mean difference in the d-value metric.}

\item{var}{Variance of the d value.}

\item{p}{Proportion of the dichotomous variable involved in the d value.}
}
\value{
An approximated variance in the correlation metric.
}
\description{
Convert the variance of d to the variance of r via TSA
}
\keyword{internal}
