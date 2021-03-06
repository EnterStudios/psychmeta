% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/intervals.R
\name{confidence}
\alias{confidence}
\title{Construct a confidence interval}
\usage{
confidence(mean, se = NULL, sd = NULL, k = 1, conf_level = 0.95,
  conf_method = "t")
}
\arguments{
\item{mean}{Mean effect size (if used in a meta-analysis) or observed effect size (if used on individual statistics).}

\item{se}{For individual statistic.: standard error of the statistic.}

\item{sd}{For meta-analyses: Observed standard deviation of effect sizes, before accouting for variance from artifacts.}

\item{k}{For meta-analyses: Number of studies in the meta-analysis.}

\item{conf_level}{Confidence level that defines the width of the confidence interval (default = .95).}

\item{conf_method}{Distribution to be used to compute the width of confidence intervals. Available options are "t" for \emph{t} distribution or "norm" for normal distribution.}
}
\value{
A matrix of confidence intervals of the specified width.
}
\description{
Function to construct a confidence interval around an effect size or mean effect size.
}
\details{
\deqn{CI=mean_{es}\pm quantile\times SE_{es}}{CI = mean_es +/- quantile * SE_es}
}
\examples{
confidence(mean = .3, sd = .15, k = 10, conf_level = .95)
confidence(mean = c(.3, .5), sd = c(.15, .2), k = c(10, 5), conf_level = .95)
confidence(mean = c(.3, .5), se = c(.15, .2), conf_level = .95)
}
