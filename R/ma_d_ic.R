#' Individual-correction meta-analysis of \emph{d} values
#'
#' This function computes individual-correction meta-analyses of \emph{d} values.
#'
#' @param d Vector or column name of observed \emph{d} values.
#' @param n1 Vector or column name of sample sizes.
#' @param n2 Vector or column name of sample sizes.
#' @param n_adj Optional: Vector or column name of sample sizes adjusted for sporadic artifact corrections.
#' @param sample_id Optional vector of identification labels for samples/studies in the meta-analysis.
#' @param treat_as_d Logical scalar determining whether \emph{d} values are to be meta-analyzed as d values (\code{TRUE}) or whether they should be meta-analyzed as correlations (\code{FALSE}).
#' @param wt_type Type of weight to use in the meta-analysis: options are "sample_size", "inv_var_mean" (inverse variance computed using mean effect size), and
#' "inv_var_sample" (inverse variance computed using sample-specific effect sizes). Supported options borrowed from metafor are "DL", "HE", "HS", "SJ", "ML", "REML", "EB", and "PM"
#' (see metafor documentation for details about the metafor methods).
#' @param error_type Method to be used to estimate error variances: "mean" uses the mean effect size to estimate error variances and "sample" uses the sample-specific effect sizes.
#' @param correct_bias Logical scalar that determines whether to correct correlations for small-sample bias (\code{TRUE}) or not (\code{FALSE}).
#' @param correct_rGg Logical scalar or vector that determines whether to correct the grouping variable variable for measurement error (\code{TRUE}) or not (\code{FALSE}).
#' @param correct_ryy Logical scalar or vector that determines whether to correct the Y variable for measurement error (\code{TRUE}) or not (\code{FALSE}).
#' @param correct_rr_g Logical scalar or vector or column name determining whether each \emph{d} value should be corrected for range restriction in the grouping variable (\code{TRUE}) or not (\code{FALSE}).
#' @param correct_rr_y Logical scalar or vector or column name determining whether each \emph{d} should be corrected for range restriction in Y (\code{TRUE}) or not (\code{FALSE}).
#' @param indirect_rr_g Logical vector or column name determining whether each \emph{d} should be corrected for indirect range restriction in the grouping variable (\code{TRUE}) or not (\code{FALSE}).
#' Superceded in evaluation by \code{correct_rr_x} (i.e., if \code{correct_rr_g} == \code{FALSE}, the value supplied for \code{indirect_rr_g} is disregarded).
#' @param indirect_rr_y Logical vector or column name determining whether each \emph{d} should be corrected for indirect range restriction in Y (\code{TRUE}) or not (\code{FALSE}).
#' Superceded in evaluation by \code{correct_rr_y} (i.e., if \code{correct_rr_y} == \code{FALSE}, the value supplied for \code{indirect_rr_y} is disregarded).
#' @param rGg Vector or column name of reliability estimates for X.
#' @param ryy Vector or column name of reliability estimates for Y.
#' @param ryy_restricted Logical vector or column name determining whether each element of \code{ryy} is an incumbent reliability (\code{TRUE}) or an applicant reliability (\code{FALSE}).
#' @param ryy_type String vector identifying the types of reliability estimates supplied (e.g., "alpha", "retest", "interrater_r", "splithalf"). See the documentation for \code{\link{ma_r}} for a full list of acceptable reliability types.
#' @param pi Scalar or vector containing the restricted-group proportions of group membership. If a vector, it must either have as many elements as there are \emph{d} values.
#' @param pa Scalar or vector containing the unrestricted-group proportions of group membership. If a vector, it must either have as many elements as there are \emph{d} values.
#' @param uy Vector or column name of u ratios for Y.
#' @param uy_observed Logical vector or column name determining whether each element of \code{uy} is an observed-score u ratio (\code{TRUE}) or a true-score u ratio (\code{FALSE}).
#' @param sign_rgz Sign of the relationship between X and the selection mechanism (for use with bvirr corrections only).
#' @param sign_ryz Sign of the relationship between Y and the selection mechanism (for use with bvirr corrections only).
#' @param conf_level Confidence level to define the width of the confidence interval (default = .95).
#' @param cred_level Credibility level to define the width of the credibility interval (default = .80).
#' @param conf_method Distribution to be used to compute the width of confidence intervals. Available options are "t" for \emph{t} distribution or "norm" for normal distribution.
#' @param cred_method Distribution to be used to compute the width of credibility intervals. Available options are "t" for \emph{t} distribution or "norm" for normal distribution.
#' @param var_unbiased Logical scalar determining whether variances should be unbiased (\code{TRUE}) or maximum-likelihood (\code{FALSE}).
#' @param moderators Matrix or column names of moderator variables to be used in the meta-analysis (can be a vector in the case of one moderator).
#' @param moderator_type Type of moderator analysis: "none" means that no moderators are to be used, "simple" means that moderators are to be examined one at a time,
#' "hierarchical" means that all possible combinations and subsets of moderators are to be examined, and "all" means that simple and hierarchical moderator analyses are to be performed.
#' @param cat_moderators Logical scalar or vector identifying whether variables in the \code{moderators} argument are categorical variables (\code{TRUE}) or continuous variables (\code{FALSE}).
#' @param impute_method Method to use for imputing artifacts. See the documentation for \code{\link{ma_r}} for a list of available imputation methods.
#' @param decimals Number of decimal places to which results should be rounded (default is to perform no rounding).
#' @param hs_override When \code{TRUE}, this will override settings for \code{wt_type} (will set to "sample_size"), \code{error_type} (will set to "mean"),
#' \code{correct_bias} (will set to \code{TRUE}), \code{conf_method} (will set to "norm"), \code{cred_method} (will set to "norm"), and \code{var_unbiased} (will set to \code{FALSE}).
#' @param use_all_arts Logical scalar that determines whether artifact values from studies without valid effect sizes should be used in artifact distributions (\code{TRUE}) or not (\code{FALSE}).
#' @param supplemental_ads_y List supplemental artifact distribution information from studies not included in the meta-analysis. The elements of this list  are named like the arguments of the \code{create_ad()} function.
#' @param data Data frame containing columns whose names may be provided as arguments to vector arguments and/or moderators.
#' @param ... Further arguments to be passed to functions called within the meta-analysis.
#'
#' @return A list object of the classes \code{psychmeta}, \code{ma_d_as_r} or \code{ma_d_as_d}, \code{ma_bb}, and \code{ma_ic}.
#' @export
#'
#' @references
#' Schmidt, F. L., & Hunter, J. E. (2015).
#' \emph{Methods of meta-analysis: Correcting error and bias in research findings (3rd ed.)}.
#' Thousand Oaks, California: SAGE Publications, Inc. Chapter 3.
#'
#' Dahlke, J. A., & Wiernik, B. M. (2017). \emph{One of these artifacts is not like the others:
#' New methods to account for the unique implications of indirect range-restriction corrections in organizational research}.
#' Unpublished manuscript.
#'
#' @examples
#' ## Example meta-analyses using simulated data:
#' ma_d_ic(d = d, n1 = n1, n2 = n2, ryy = ryyi, correct_rr_y = FALSE,
#'         data = data_d_meas_multi[data_d_meas_multi$construct == "Y",])
#' ma_d_ic(d = d, n1 = n1, n2 = n2, ryy = ryyi, correct_rr_y = FALSE,
#'         data = data_d_meas_multi[data_d_meas_multi$construct == "Z",])
ma_d_ic <- function(d, n1, n2 = NULL, n_adj = NULL, sample_id = NULL,
                    treat_as_d = TRUE, wt_type = "inv_var_mean", error_type = "mean",
                    correct_bias = TRUE,
                    correct_rGg = FALSE, correct_ryy = TRUE,
                    correct_rr_g = FALSE, correct_rr_y = TRUE,
                    indirect_rr_g = TRUE, indirect_rr_y = TRUE,
                    rGg = NULL, pi = NULL, pa = NULL,
                    ryy = NULL, ryy_restricted = TRUE, ryy_type = "alpha",
                    uy = NULL, uy_observed = TRUE,
                    sign_rgz = 1, sign_ryz = 1,
                    conf_level = .95, cred_level = .8, conf_method = "t", cred_method = "t", var_unbiased = TRUE,
                    moderators = NULL, cat_moderators = TRUE, moderator_type = "simple", impute_method = "bootstrap_mod",
                    decimals = 2, hs_override = FALSE,
                    use_all_arts = FALSE, supplemental_ads_y = NULL, data = NULL, ...){

     ##### Get inputs #####
     call <- match.call()
     inputs <- list(wt_type = wt_type, error_type = error_type,
                    correct_bias = correct_bias, correct_rGg = correct_rGg, correct_ryy = correct_ryy,
                    conf_level = conf_level, cred_level = cred_level, cred_method = cred_method, var_unbiased = var_unbiased,
                    cat_moderators = cat_moderators, moderator_type = moderator_type, data = data)
     inputs <- append(inputs, list(...))

     sign_rgz <- scalar_arg_warning(arg = sign_rgz, arg_name = "sign_rgz")
     sign_ryz <- scalar_arg_warning(arg = sign_ryz, arg_name = "sign_ryz")
     correct_bias <- scalar_arg_warning(arg = correct_bias, arg_name = "correct_bias")
     correct_rGg <- scalar_arg_warning(arg = correct_rGg, arg_name = "correct_rGg")
     correct_ryy <- scalar_arg_warning(arg = correct_ryy, arg_name = "correct_ryy")

     moderator_type <- scalar_arg_warning(arg = moderator_type, arg_name = "moderator_type")
     wt_type <- scalar_arg_warning(arg = wt_type, arg_name = "wt_type")
     error_type <- scalar_arg_warning(arg = error_type, arg_name = "error_type")
     use_all_arts <- scalar_arg_warning(arg = use_all_arts, arg_name = "use_all_arts")

     conf_level <- interval_warning(interval = conf_level, interval_name = "conf_level", default = .95)
     cred_level <- interval_warning(interval = cred_level, interval_name = "cred_level", default = .8)

     formal_args <- formals(ma_d)
     formal_args[["..."]] <- NULL
     for(i in names(formal_args)) if(i %in% names(call)) formal_args[[i]] <- NULL
     call_full <- as.call(append(as.list(call), formal_args))

     if(!is.null(data)){
          data <- as.data.frame(data)

          d <- match_variables(call = call_full[[match("d",  names(call_full))]], arg = d, data = data)

          n1 <- match_variables(call = call_full[[match("n1",  names(call_full))]], arg = n1, data = data)

          if(deparse(substitute(n2))[1] != "NULL")
               n2 <- match_variables(call = call_full[[match("n2",  names(call_full))]], arg = n2, data = data)

          if(deparse(substitute(n_adj))[1] != "NULL")
               n_adj <- match_variables(call = call_full[[match("n_adj",  names(call_full))]], arg = n_adj, data = data)

          if(deparse(substitute(rGg))[1] != "NULL")
               rGg <- match_variables(call = call_full[[match("rGg",  names(call_full))]], arg = rGg, data = data)

          if(deparse(substitute(ryy))[1] != "NULL")
               ryy <- match_variables(call = call_full[[match("ryy",  names(call_full))]], arg = ryy, data = data)

          if(deparse(substitute(ryy_restricted))[1] != "NULL")
               ryy_restricted <- match_variables(call = call_full[[match("ryy_restricted",  names(call_full))]], arg = ryy_restricted, data = data)

          if(deparse(substitute(ryy_type))[1] != "NULL")
               ryy_type <- match_variables(call = call_full[[match("ryy_type", names(call_full))]], arg = ryy_type, data = data)

          if(deparse(substitute(uy))[1] != "NULL")
               uy <- match_variables(call = call_full[[match("uy",  names(call_full))]], arg = uy, data = data)

          if(deparse(substitute(uy_observed))[1] != "NULL")
               uy_observed <- match_variables(call = call_full[[match("uy_observed",  names(call_full))]], arg = uy_observed, data = data)

          if(deparse(substitute(sample_id))[1] != "NULL")
               sample_id <- match_variables(call = call_full[[match("sample_id",  names(call_full))]], arg = sample_id, data = data)

          if(deparse(substitute(moderators))[1] != "NULL")
               moderators <- match_variables(call = call_full[[match("moderators",  names(call_full))]], arg = moderators, data = as_tibble(data), as_array = TRUE)

          if(deparse(substitute(correct_rr_g))[1] != "NULL")
               correct_rr_g <- match_variables(call = call_full[[match("correct_rr_g",  names(call_full))]], arg = correct_rr_g, data = data)

          if(deparse(substitute(correct_rr_y))[1] != "NULL")
               correct_rr_y <- match_variables(call = call_full[[match("correct_rr_y",  names(call_full))]], arg = correct_rr_y, data = data)

          if(deparse(substitute(indirect_rr_g))[1] != "NULL")
               indirect_rr_g <- match_variables(call = call_full[[match("indirect_rr_g",  names(call_full))]], arg = indirect_rr_g, data = data)

          if(deparse(substitute(indirect_rr_y))[1] != "NULL")
               indirect_rr_y <- match_variables(call = call_full[[match("indirect_rr_y",  names(call_full))]], arg = indirect_rr_y, data = data)
     }

     ## Reliabilities of grouping variables are correlations, so we will square them to put them in the same metric as other reliability statistics
     if(!is.null(rGg)){
          rxxi <- rGg^2
     }else{
          rxxi <- rep(NA, length(d))
     }

     if(!is.null(pi)){
          if(length(pi) > 1 & length(pi) < length(d))
               stop("pi must either be a scalar or a vector with as many elements as there are d values", call. = FALSE)
          if(length(pi) == 1) pi <- rep(pi, length(d))

     }else{
          pi <- rep(NA, length(d))
     }

     if(all(!correct_rr_g)) pa <- NULL

     if(!is.null(pa)){
          if(length(pa) > 1 & length(pa) < length(d))
               stop("pa must either be a scalar or a vector with as many elements as there are d values", call. = FALSE)
          if(length(pa) == 1) pa <- rep(pa, length(d))
     }else{
          correct_rr_g <- FALSE
          pa <- rep(NA, length(d))
     }

     if(any(correct_rr_g)) pa[!correct_rr_g] <- NA

     if(any(!is.na(pi))) if(any(pi[!is.na(pi)] <= 0 | pi[!is.na(pi)] >= 1)) stop("Incumbent subgroup proportions must be between 0 and 1 (exclusive)", call. = FALSE)
     if(any(!is.na(pa))) if(any(pa[!is.na(pa)] <= 0 | pa[!is.na(pa)] >= 1)) stop("Applicant subgroup proportions must be between 0 and 1 (exclusive)", call. = FALSE)

     if(is.null(n2)) n2 <- rep(NA, length(n1))
     n <- n1
     n[!is.na(n2)] <- n[!is.na(n2)] + n2[!is.na(n2)]

     if(is.null(n_adj)) n_adj <- n
     n1_i <- n1
     n2_i <- n2
     n1_i[is.na(n2)] <- n2_i[is.na(n2)] <- n_adj[is.na(n2)] / 2
     n1[n != n_adj] <- n_adj[n != n_adj]
     pi[is.na(pi)] <- (n1_i / n_adj)[is.na(pi)]

     rxyi <- convert_es.q_d_to_r(d = d, p = pi)

     ## The variance of a dichotomous variable is pq = p(1-p), so we will estimate u ratios accordingly
     ux <- sqrt((pi * (1 - pi)) / (pa * (1 - pa)))
     pa[is.na(pa)] <- pi[is.na(pa)]

     ## Compute meta-analysis
     out <- ma_r_ic(rxyi = rxyi, n = n, n_adj = n_adj, sample_id = sample_id,
                    construct_order = NULL,
                    wt_type = wt_type, error_type = error_type,
                    correct_bias = correct_bias, correct_rxx = correct_rGg, correct_ryy = correct_ryy,
                    correct_rr_x = correct_rr_g, correct_rr_y = correct_rr_y,
                    indirect_rr_x = indirect_rr_g, indirect_rr_y = indirect_rr_y,
                    rxx = rxxi, rxx_restricted = TRUE, rxx_type = "group_treatment",
                    ryy = ryy, ryy_restricted = ryy_restricted, ryy_type = ryy_type,
                    ux = ux, ux_observed = TRUE,
                    uy = uy, uy_observed = uy_observed,
                    sign_rxz = sign_rgz, sign_ryz = sign_ryz,
                    conf_level = conf_level, cred_level = cred_level, conf_method = conf_method, cred_method = cred_method, var_unbiased = var_unbiased,
                    moderators = moderators, cat_moderators = cat_moderators, moderator_type = moderator_type, impute_method = impute_method,
                    hs_override = hs_override, decimals = decimals,
                    use_all_arts = use_all_arts, supplemental_ads_x = NULL, supplemental_ads_y = supplemental_ads_y, data = NULL,

                    ## Ellipsis arguments - pass d value information to ma_r to facilitate effect-size metric conversions
                    es_d = TRUE, treat_as_d = treat_as_d, d_orig = d, n1_d = n1, n2_d = n2, pi_d = pi, pa_d = pa)
     if(treat_as_d){
          class(out)[2] <- "ma_d_as_r"
     }else{
          class(out)[2] <- "ma_r_as_r"
     }
     out$call_history <- append(list(call), out$call_history)
     out <- convert_ma(ma_obj = out)
     return(out)
}

