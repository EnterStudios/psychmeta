% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ma_r_bb.R
\name{ma_r_bb}
\alias{ma_r_bb}
\alias{ma_r_barebones}
\title{Bare-bones meta-analysis of correlations}
\usage{
ma_r_bb(r, n, n_adj = NULL, sample_id = NULL, wt_type = "sample_size",
  error_type = "mean", correct_bias = TRUE, conf_level = 0.95,
  cred_level = 0.8, conf_method = "t", cred_method = "t",
  var_unbiased = TRUE, moderators = NULL, cat_moderators = TRUE,
  moderator_type = "simple", hs_override = FALSE, data = NULL, ...)
}
\arguments{
\item{r}{Vector or column name of observed correlations.}

\item{n}{Vector or column name of sample sizes.}

\item{n_adj}{Optional: Vector or column name of sample sizes adjusted for sporadic artifact corrections.}

\item{sample_id}{Optional vector of identification labels for samples/studies in the meta-analysis.
When \code{TRUE}, program will use sample-size weights, error variances estimated from the mean effect size, maximum likelihood variances, and normal-distribution confidence and credibility intervals.}

\item{wt_type}{Type of weight to use in the meta-analysis: native options are "sample_size", "inv_var_mean" (inverse variance computed using mean effect size), and
"inv_var_sample" (inverse variance computed using sample-specific effect sizes). Supported options borrowed from metafor are "DL", "HE", "HS", "SJ", "ML", "REML", "EB", and "PM"
(see metafor documentation for details about the metafor methods).}

\item{error_type}{Method to be used to estimate error variances: "mean" uses the mean effect size to estimate error variances and "sample" uses the sample-specific effect sizes.}

\item{correct_bias}{Logical argument that determines whether to correct correlations for small-sample bias (\code{TRUE}) or not (\code{FALSE}).}

\item{conf_level}{Confidence level to define the width of the confidence interval (default = .95).}

\item{cred_level}{Credibility level to define the width of the credibility interval (default = .80).}

\item{conf_method}{Distribution to be used to compute the width of confidence intervals. Available options are "t" for \emph{t} distribution or "norm" for normal distribution.}

\item{cred_method}{Distribution to be used to compute the width of credibility intervals. Available options are "t" for \emph{t} distribution or "norm" for normal distribution.}

\item{var_unbiased}{Logical scalar determining whether variances should be unbiased (\code{TRUE}) or maximum-likelihood (\code{FALSE}).}

\item{moderators}{Matrix of moderator variables to be used in the meta-analysis (can be a vector in the case of one moderator).}

\item{cat_moderators}{Logical scalar or vector identifying whether variables in the \code{moderators} argument are categorical variables (\code{TRUE}) or continuous variables (\code{FALSE}).}

\item{moderator_type}{Type of moderator analysis ("none", "simple", or "hierarchical").}

\item{hs_override}{When TRUE, this will override settings for \code{wt_type} (will set to "sample_size"), \code{error_type} (will set to "mean"),
\code{correct_bias} (will set to \code{TRUE}), \code{conf_method} (will set to "norm"), \code{cred_method} (will set to "norm"), and \code{var_unbiased} (will set to \code{FALSE}).}

\item{data}{Data frame containing columns whose names may be provided as arguments to vector arguments and/or moderators.}

\item{...}{Further arguments to be passed to functions called within the meta-analysis.}
}
\value{
A list object of the classes \code{psychmeta}, \code{ma_r_as_r}, and \code{ma_bb}.
}
\description{
This function computes bare-bones meta-analyses of correlations.
}
\examples{
## Example analysis using data from Gonzalez-Mule et al. (2014):

## Not correcting for bias and using normal distributions to compute uncertainty intervals
## allows for exact replication of the results reported in the text:
ma_r_bb(r = rxyi, n = n, correct_bias = FALSE, conf_method = "norm", cred_method = "norm",
               data = data_r_gonzalezmule_2014)

## Using hs_override = TRUE allows one to easily implement the traditional Hunter-Schmidt method:
ma_r_bb(r = rxyi, n = n, hs_override = TRUE, data = data_r_gonzalezmule_2014)

## With hs_override = FALSE, the program defaults will compute unbiased variances and use
## t-distributions to estimate confidence and credibility intervals - these settings make
## a noticeable difference for small studies like the textbook example:
ma_r_bb(r = rxyi, n = n, hs_override = FALSE, data = data_r_gonzalezmule_2014)
}
\references{
Schmidt, F. L., & Hunter, J. E. (2015).
\emph{Methods of meta-analysis: Correcting error and bias in research findings} (3rd ed.).
Thousand Oaks, CA: Sage. \url{https://doi.org/10/b6mg}. Chapter 3.
}
