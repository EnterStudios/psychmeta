% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ma_d_ic.R
\name{ma_d_ic}
\alias{ma_d_ic}
\title{Individual-correction meta-analysis of \emph{d} values}
\usage{
ma_d_ic(d, n1, n2 = NULL, n_adj = NULL, sample_id = NULL,
  treat_as_d = TRUE, wt_type = "inv_var_mean", error_type = "mean",
  correct_bias = TRUE, correct_rGg = FALSE, correct_ryy = TRUE,
  correct_rr_g = FALSE, correct_rr_y = TRUE, indirect_rr_g = TRUE,
  indirect_rr_y = TRUE, rGg = NULL, pi = NULL, pa = NULL, ryy = NULL,
  ryy_restricted = TRUE, ryy_type = "alpha", uy = NULL,
  uy_observed = TRUE, sign_rgz = 1, sign_ryz = 1, conf_level = 0.95,
  cred_level = 0.8, conf_method = "t", cred_method = "t",
  var_unbiased = TRUE, moderators = NULL, cat_moderators = TRUE,
  moderator_type = "simple", impute_method = "bootstrap_mod",
  decimals = 2, hs_override = FALSE, use_all_arts = FALSE,
  supplemental_ads_y = NULL, data = NULL, ...)
}
\arguments{
\item{d}{Vector or column name of observed \emph{d} values.}

\item{n1}{Vector or column name of sample sizes.}

\item{n2}{Vector or column name of sample sizes.}

\item{n_adj}{Optional: Vector or column name of sample sizes adjusted for sporadic artifact corrections.}

\item{sample_id}{Optional vector of identification labels for samples/studies in the meta-analysis.}

\item{treat_as_d}{Logical scalar determining whether \emph{d} values are to be meta-analyzed as d values (\code{TRUE}) or whether they should be meta-analyzed as correlations (\code{FALSE}).}

\item{wt_type}{Type of weight to use in the meta-analysis: options are "sample_size", "inv_var_mean" (inverse variance computed using mean effect size), and
"inv_var_sample" (inverse variance computed using sample-specific effect sizes). Supported options borrowed from metafor are "DL", "HE", "HS", "SJ", "ML", "REML", "EB", and "PM"
(see metafor documentation for details about the metafor methods).}

\item{error_type}{Method to be used to estimate error variances: "mean" uses the mean effect size to estimate error variances and "sample" uses the sample-specific effect sizes.}

\item{correct_bias}{Logical scalar that determines whether to correct correlations for small-sample bias (\code{TRUE}) or not (\code{FALSE}).}

\item{correct_rGg}{Logical scalar or vector that determines whether to correct the grouping variable variable for measurement error (\code{TRUE}) or not (\code{FALSE}).}

\item{correct_ryy}{Logical scalar or vector that determines whether to correct the Y variable for measurement error (\code{TRUE}) or not (\code{FALSE}).}

\item{correct_rr_g}{Logical scalar or vector or column name determining whether each \emph{d} value should be corrected for range restriction in the grouping variable (\code{TRUE}) or not (\code{FALSE}).}

\item{correct_rr_y}{Logical scalar or vector or column name determining whether each \emph{d} should be corrected for range restriction in Y (\code{TRUE}) or not (\code{FALSE}).}

\item{indirect_rr_g}{Logical vector or column name determining whether each \emph{d} should be corrected for indirect range restriction in the grouping variable (\code{TRUE}) or not (\code{FALSE}).
Superceded in evaluation by \code{correct_rr_x} (i.e., if \code{correct_rr_g} == \code{FALSE}, the value supplied for \code{indirect_rr_g} is disregarded).}

\item{indirect_rr_y}{Logical vector or column name determining whether each \emph{d} should be corrected for indirect range restriction in Y (\code{TRUE}) or not (\code{FALSE}).
Superceded in evaluation by \code{correct_rr_y} (i.e., if \code{correct_rr_y} == \code{FALSE}, the value supplied for \code{indirect_rr_y} is disregarded).}

\item{rGg}{Vector or column name of reliability estimates for X.}

\item{pi}{Scalar or vector containing the restricted-group proportions of group membership. If a vector, it must either have as many elements as there are \emph{d} values.}

\item{pa}{Scalar or vector containing the unrestricted-group proportions of group membership. If a vector, it must either have as many elements as there are \emph{d} values.}

\item{ryy}{Vector or column name of reliability estimates for Y.}

\item{ryy_restricted}{Logical vector or column name determining whether each element of \code{ryy} is an incumbent reliability (\code{TRUE}) or an applicant reliability (\code{FALSE}).}

\item{ryy_type}{String vector identifying the types of reliability estimates supplied (e.g., "alpha", "retest", "interrater_r", "splithalf"). See the documentation for \code{\link{ma_r}} for a full list of acceptable reliability types.}

\item{uy}{Vector or column name of u ratios for Y.}

\item{uy_observed}{Logical vector or column name determining whether each element of \code{uy} is an observed-score u ratio (\code{TRUE}) or a true-score u ratio (\code{FALSE}).}

\item{sign_rgz}{Sign of the relationship between X and the selection mechanism (for use with bvirr corrections only).}

\item{sign_ryz}{Sign of the relationship between Y and the selection mechanism (for use with bvirr corrections only).}

\item{conf_level}{Confidence level to define the width of the confidence interval (default = .95).}

\item{cred_level}{Credibility level to define the width of the credibility interval (default = .80).}

\item{conf_method}{Distribution to be used to compute the width of confidence intervals. Available options are "t" for \emph{t} distribution or "norm" for normal distribution.}

\item{cred_method}{Distribution to be used to compute the width of credibility intervals. Available options are "t" for \emph{t} distribution or "norm" for normal distribution.}

\item{var_unbiased}{Logical scalar determining whether variances should be unbiased (\code{TRUE}) or maximum-likelihood (\code{FALSE}).}

\item{moderators}{Matrix or column names of moderator variables to be used in the meta-analysis (can be a vector in the case of one moderator).}

\item{cat_moderators}{Logical scalar or vector identifying whether variables in the \code{moderators} argument are categorical variables (\code{TRUE}) or continuous variables (\code{FALSE}).}

\item{moderator_type}{Type of moderator analysis: "none" means that no moderators are to be used, "simple" means that moderators are to be examined one at a time,
"hierarchical" means that all possible combinations and subsets of moderators are to be examined, and "all" means that simple and hierarchical moderator analyses are to be performed.}

\item{impute_method}{Method to use for imputing artifacts. See the documentation for \code{\link{ma_r}} for a list of available imputation methods.}

\item{decimals}{Number of decimal places to which results should be rounded (default is to perform no rounding).}

\item{hs_override}{When \code{TRUE}, this will override settings for \code{wt_type} (will set to "sample_size"), \code{error_type} (will set to "mean"),
\code{correct_bias} (will set to \code{TRUE}), \code{conf_method} (will set to "norm"), \code{cred_method} (will set to "norm"), and \code{var_unbiased} (will set to \code{FALSE}).}

\item{use_all_arts}{Logical scalar that determines whether artifact values from studies without valid effect sizes should be used in artifact distributions (\code{TRUE}) or not (\code{FALSE}).}

\item{supplemental_ads_y}{List supplemental artifact distribution information from studies not included in the meta-analysis. The elements of this list  are named like the arguments of the \code{create_ad()} function.}

\item{data}{Data frame containing columns whose names may be provided as arguments to vector arguments and/or moderators.}

\item{...}{Further arguments to be passed to functions called within the meta-analysis.}
}
\value{
A list object of the classes \code{psychmeta}, \code{ma_d_as_r} or \code{ma_d_as_d}, \code{ma_bb}, and \code{ma_ic}.
}
\description{
This function computes individual-correction meta-analyses of \emph{d} values.
}
\examples{
## Example meta-analyses using simulated data:
ma_d_ic(d = d, n1 = n1, n2 = n2, ryy = ryyi, correct_rr_y = FALSE,
        data = data_d_meas_multi[data_d_meas_multi$construct == "Y",])
ma_d_ic(d = d, n1 = n1, n2 = n2, ryy = ryyi, correct_rr_y = FALSE,
        data = data_d_meas_multi[data_d_meas_multi$construct == "Z",])
}
\references{
Schmidt, F. L., & Hunter, J. E. (2015).
\emph{Methods of meta-analysis: Correcting error and bias in research findings (3rd ed.)}.
Thousand Oaks, California: SAGE Publications, Inc. Chapter 3.

Dahlke, J. A., & Wiernik, B. M. (2017). \emph{One of these artifacts is not like the others:
New methods to account for the unique implications of indirect range-restriction corrections in organizational research}.
Unpublished manuscript.
}
