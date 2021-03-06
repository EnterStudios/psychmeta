#' Correct for small-sample bias in Cohen's \emph{d} values
#'
#' Corrects a vector of Cohen's \emph{d} values for small-sample bias, as Cohen's \emph{d} has a slight positive bias.
#'
#' @param d Vector of Cohen's d values.
#' @param n Vector of sample sizes.
#'
#' @return Vector of d values corrected for small-sample bias.
#' @export
#'
#' @references
#' Schmidt, F. L., & Hunter, J. E. (2015).
#' \emph{Methods of meta-analysis: Correcting error and bias in research findings} (3rd ed.).
#' Thousand Oaks, CA: SAGE. \url{https://doi.org/10/b6mg}. pp. 293–295.
#'
#' @details
#' The bias correction is estimated as:
#'
#' \deqn{d_{c}=\frac{d_{obs}}{1+\frac{.75}{n-3}}}{d_c = d / (1 + .75 / (n - 3))}
#'
#' where \eqn{d_{obs}}{d} is the observed effect size, \eqn{d_{c}}{d_c} is the corrected estimate of \emph{d}, and \emph{n} is the total sample size.
#'
#' @examples
#' correct_d_bias(d = .3, n = 30)
#' correct_d_bias(d = .3, n = 300)
#' correct_d_bias(d = .3, n = 3000)
correct_d_bias <- function(d, n){
     out <- d
     out[!is.na(n)] <- d[!is.na(n)] / (1 + .75 / (n[!is.na(n)] - 3))
     out
}


#' Correct for small-sample bias in Glass' \eqn{\Delta}{delta} values
#'
#' @param delta Vector of Glass' \eqn{\Delta}{delta} values.
#' @param nc Vector of control-group sample sizes.
#' @param ne Vector of experimental-group sample sizes.
#' @param use_pooled_sd Logical vector determining whether the pooled standard deviation was used (\code{TRUE}) or not (\code{FALSE}; default).
#'
#' @return Vector of d values corrected for small-sample bias.
#' @export
#'
#' @references
#' Hedges, L. V. (1981). Distribution theory for Glass’s estimator of effect size and related estimators.
#' \emph{Journal of Educational Statistics, 6}(2), 107–128. https://doi.org/10.2307/1164588
#'
#' @details
#' The bias correction is estimated as:
#'
#' \deqn{\Delta_{c}=\Delta_{obs}\frac{\Gamma\left(\frac{n_{control}-1}{2}\right)}{\Gamma\left(\frac{n_{control}-1}{2}\right)\Gamma\left(\frac{n_{control}-2}{2}\right)}}{delta_c = delta * gamma(nc - 1 / 2) / (sqrt(nc - 1 / 2) * gamma((nc - 2) / 2))}
#'
#' where \eqn{\Delta} is the observed effect size, \eqn{\Delta_{c}} is the corrected estimate of \eqn{\Delta}, and \eqn{n_{control}}{nc} is the control-group sample size.
#'
#' @examples
#' correct_glass_bias(delta = .3, nc = 30, ne = 30)
correct_glass_bias <- function(delta, nc, ne, use_pooled_sd = rep(FALSE, length(delta))){
     n <- nc * ne / (nc + ne)
     m <- nc - 1
     m[use_pooled_sd] <- m[use_pooled_sd] + ne[use_pooled_sd] - 1
     cm <- gamma(m / 2) / (sqrt(m / 2) * gamma((m - 1) / 2))
     delta * cm
}



#' Correct \emph{d} values for range restriction and/or measurement error
#'
#' @description
#' This function is a wrapper for the \code{\link{correct_r}} function to correct \emph{d} values for statistical and psychometric artifacts.
#'
#' @param correction Type of correction to be applied. Options are "meas", "uvdrr_g", "uvdrr_y", "uvirr_g", "uvirr_y", "bvdrr", "bvirr"
#' @param d Vector of \emph{d} values.
#' @param ryy Vector of reliability coefficients for Y (the continous variable).
#' @param uy Vector of u ratios for Y (the continous variable).
#' @param uy_observed Logical vector in which each entry specifies whether the corresponding uy value is an observed-score u ratio (\code{TRUE}) or a true-score u ratio. All entries are \code{TRUE} by default.
#' @param ryy_restricted Logical vector in which each entry specifies whether the corresponding rxx value is an incumbent reliability (\code{TRUE}) or an applicant reliability. All entries are \code{TRUE} by default.
#' @param ryy_type String vector identifying the types of reliability estimates supplied (e.g., "alpha", "retest", "interrater_r", "splithalf"). See the documentation for \code{\link{ma_r}} for a full list of acceptable reliability types.
#' @param rGg Vector of reliabilities for the group variable (i.e., the correlations between observed group membership and latent group membership).
#' @param pi Proportion of cases in one of the groups in the observed data (not necessary if \code{n1} and \code{n2} reflect this proportionality).
#' @param pa Proportion of cases in one of the groups in the population.
#' @param sign_rgz Vector of signs of the relationships between grouping variables and the selection mechanism.
#' @param sign_ryz Vector of signs of the relationships between Y variables and the selection mechanism.
#' @param n1 Optional vector of sample sizes associated with group 1 (or the total sample size, if \code{n2} is \code{NULL}).
#' @param n2 Optional vector of sample sizes associated with group 2.
#' @param conf_level Confidence level to define the width of the confidence interval (default = .95).
#' @param correct_bias Logical argument that determines whether to correct error-variance estimates for small-sample bias in correlations (\code{TRUE}) or not (\code{FALSE}).
#' For sporadic corrections (e.g., in mixed artifact-distribution meta-analyses), this should be set to \code{FALSE} (the default).
#'
#' @return Data frame(s) of observed \emph{d} values (\code{dgyi}), operational range-restricted \emph{d} values corrected for measurement error in Y only (\code{dgpi}), operational range-restricted \emph{d} values corrected for measurement error in the grouping only (\code{dGyi}), and range-restricted true-score \emph{d} values (\code{dGpi}),
#' range-corrected observed-score \emph{d} values (\code{dgya}), operational range-corrected \emph{d} values corrected for measurement error in Y only (\code{dgpa}), operational range-corrected \emph{d} values corrected for measurement error in the grouping only (\code{dGya}), and range-corrected true-score \emph{d} values (\code{dGpa}).
#' @export
#'
#' @references
#' Alexander, R. A., Carson, K. P., Alliger, G. M., & Carr, L. (1987).
#' Correcting doubly truncated correlations: An improved approximation for correcting the bivariate normal correlation when truncation has occurred on both variables.
#' \emph{Educational and Psychological Measurement, 47}(2), 309–315. \url{https://doi.org/10.1177/0013164487472002}
#'
#' Dahlke, J. A., & Wiernik, B. M. (2017).
#' \emph{One of these artifacts is not like the others: New methods to account for the unique implications of indirect range-restriction corrections in organizational research}.
#' Unpublished manuscript.
#'
#' Hunter, J. E., Schmidt, F. L., & Le, H. (2006).
#' Implications of direct and indirect range restriction for meta-analysis methods and findings.
#' \emph{Journal of Applied Psychology, 91}(3), 594–612. \url{https://doi.org/10.1037/0021-9010.91.3.594}
#'
#' Le, H., Oh, I.-S., Schmidt, F. L., & Wooldridge, C. D. (2016).
#' Correction for range restriction in meta-analysis revisited: Improvements and implications for organizational research.
#' \emph{Personnel Psychology, 69}(4), 975–1008. \url{https://doi.org/10.1111/peps.12122}
#'
#' Schmidt, F. L., & Hunter, J. E. (2015).
#' \emph{Methods of meta-analysis: Correcting error and bias in research findings} (3rd ed.).
#' Thousand Oaks, CA: SAGE. \url{https://doi.org/10/b6mg}. pp. 43–44, 140–141.
#'
#' @examples
#' ## Correction for measurement error only
#' correct_d(correction = "meas", d = .5, ryy = .8, uy = .7,
#'           rGg = .9, pi = .7, pa = .5)
#' correct_d(correction = "meas", d = .5, ryy = .8, uy = .7,
#'           rGg = .9, pi = NULL, pa = .5, n1 = 100, n2 = 200)
#'
#' ## Correction for direct range restriction in the continuous variable
#' correct_d(correction = "uvdrr_y", d = .5, ryy = .8, uy = .7,
#'           rGg = .9, pi = .7, pa = .5)
#' correct_d(correction = "uvdrr_y", d = .5, ryy = .8, uy = .7,
#'           rGg = .9, pi = NULL, pa = .5, n1 = 100, n2 = 200)
#'
#' ## Correction for direct range restriction in the grouping variable
#' correct_d(correction = "uvdrr_g", d = .5, ryy = .8, uy = .7,
#'           rGg = .9, pi = .7, pa = .5)
#' correct_d(correction = "uvdrr_g", d = .5, ryy = .8, uy = .7,
#'           rGg = .9, pi = NULL, pa = .5, n1 = 100, n2 = 200)
#'
#' ## Correction for indirect range restriction in the continuous variable
#' correct_d(correction = "uvdrr_y", d = .5, ryy = .8, uy = .7,
#'           rGg = .9, pi = .7, pa = .5)
#' correct_d(correction = "uvdrr_y", d = .5, ryy = .8, uy = .7,
#'           rGg = .9, pi = NULL, pa = .5, n1 = 100, n2 = 200)
#'
#' ## Correction for indirect range restriction in the grouping variable
#' correct_d(correction = "uvirr_g", d = .5, ryy = .8, uy = .7,
#'           rGg = .9, pi = .7, pa = .5)
#' correct_d(correction = "uvirr_g", d = .5, ryy = .8, uy = .7,
#'           rGg = .9, pi = NULL, pa = .5, n1 = 100, n2 = 200)
#'
#' ## Correction for indirect range restriction in the continuous variable
#' correct_d(correction = "uvdrr_y", d = .5, ryy = .8, uy = .7,
#'           rGg = .9, pi = .7, pa = .5)
#' correct_d(correction = "uvdrr_y", d = .5, ryy = .8, uy = .7,
#'           rGg = .9, pi = NULL, pa = .5, n1 = 100, n2 = 200)
#'
#' ## Correction for direct range restriction in both variables
#' correct_d(correction = "bvdrr", d = .5, ryy = .8, uy = .7,
#'           rGg = .9, pi = .7, pa = .5)
#' correct_d(correction = "bvdrr", d = .5, ryy = .8, uy = .7,
#'           rGg = .9, pi = NULL, pa = .5, n1 = 100, n2 = 200)
#'
#' ## Correction for indirect range restriction in both variables
#' correct_d(correction = "bvirr", d = .5, ryy = .8, uy = .7,
#'           rGg = .9, pi = .7, pa = .5)
#' correct_d(correction = "bvirr", d = .5, ryy = .8, uy = .7,
#'           rGg = .9, pi = NULL, pa = .5, n1 = 100, n2 = 200)
correct_d <- function(correction = c("meas", "uvdrr_g", "uvdrr_y", "uvirr_g", "uvirr_y", "bvdrr", "bvirr"),
                      d, ryy = 1, uy = 1,
                      rGg = 1, pi = NULL, pa = NULL,
                      uy_observed = TRUE, ryy_restricted = TRUE, ryy_type = "alpha",
                      sign_rgz = 1, sign_ryz = 1,
                      n1 = NULL, n2 = NA, conf_level = .95, correct_bias = FALSE){
     correction <- match.arg(correction)
     correction <- gsub(x = correction, pattern = "_g", replacement = "_x")

     n <- n1
     if(!is.null(n)){
          n[!is.na(n2)] <- n[!is.na(n2)] + n2[!is.na(n2)]
          n1[is.na(n2)] <- n2[is.na(n2)] <- n[is.na(n2)] / 2
          pi <- n1 / n
          pi[is.na(pi)] <- .5
     }

     if(!is.null(pi)){
          rxyi <- convert_es.q_d_to_r(d = d, p = pi)
     }else{
          rxyi <- convert_es.q_d_to_r(d = d, p = .5)
     }

     if(!is.null(rGg)){
          rxx <- rGg^2
     }else{
          rxx <- NULL
     }

     if(!is.null(pi) & !is.null(pa)){
          ux <- sqrt((pi * (1 - pi)) / (pa * (1 - pa)))
     }else{
          ux <- NULL
     }

     if(is.null(pa) & !is.null(pi)){
          if(correction == "uvdrr" | correction == "uvirr"){
               uy_temp <- uy
               if(length(uy_observed) == 1) uy_observed <- rep(uy_observed, length(d))
               if(length(ryy_restricted) == 1) ryy_restricted <- rep(ryy_restricted, length(d))
               if(correction == "uvdrr"){
                    uy_temp[!uy_observed] <- estimate_ux(ut = uy_temp[!uy_observed], rxx = ryy[!uy_observed], rxx_restricted = ryy_restricted[!uy_observed])
                    rxpi <- rxyi
               }
               if(correction == "uvirr"){
                    ryyi_temp <- ryy
                    uy_temp[uy_observed] <- estimate_ut(ux = uy_temp[uy_observed], rxx = ryy[uy_observed], rxx_restricted = ryy_restricted[uy_observed])
                    ryyi_temp[ryy_restricted] <- estimate_rxxa(rxxi = ryy[ryy_restricted], ux = uy[ryy_restricted], ux_observed = uy_observed[ryy_restricted], indirect_rr = TRUE)
                    rxpi <- rxyi / ryyi_temp^.5
               }
               pqa <- pi * (1 - pi) * ((1 / uy_temp^2 - 1) * rxpi^2 + 1)
               pqa[pqa > .25] <- .25
               pa <- convert_pq_to_p(pq = pqa)
          }else{
               pa <- pi
          }
     }

     if(is.null(pi)) pi <- .5
     if(is.null(pa)) pa <- pi

     out <- correct_r(correction = correction,
                      rxyi = rxyi, ux = ux, uy = uy,
                      rxx = rxx, ryy = ryy,
                      ux_observed = TRUE, uy_observed = uy_observed,
                      rxx_restricted = TRUE, rxx_type = "group_treatment",
                      ryy_restricted = ryy_restricted, ryy_type = ryy_type,
                      sign_rxz = sign_rgz, sign_ryz = sign_ryz,
                      n = n, conf_level = conf_level, correct_bias = correct_bias)

     if(is.data.frame(out[["correlations"]])){
          if(!is.null(pi)){
               out[["correlations"]] <- convert_es.q_r_to_d(r = out[["correlations"]], p = matrix(pa, nrow(out[["correlations"]]), ncol(out[["correlations"]])))
          }else{
               out[["correlations"]] <- convert_es.q_r_to_d(r = out[["correlations"]], p = pa)
          }
          new_names <- colnames(out[["correlations"]])
          new_names <- gsub(x = new_names, pattern = "r", replacement = "d")
          new_names <- gsub(x = new_names, pattern = "x", replacement = "g", ignore.case = FALSE)
          new_names <- gsub(x = new_names, pattern = "t", replacement = "G", ignore.case = FALSE)
          colnames(out[["correlations"]]) <- new_names
     }else{
          out_names <- names(out[["correlations"]])
          for(i in out_names){
               if(!is.null(pi)){
                    out[["correlations"]][[i]][,1:3] <- convert_es.q_r_to_d(r = out[["correlations"]][[i]][,1:3], p = matrix(pa, nrow(out[["correlations"]][[i]]), 3))
               }else{
                    out[["correlations"]][[i]][,1:3] <- convert_es.q_r_to_d(r = out[["correlations"]][[i]][,1:3], p = pa)
               }
          }
          new_names <- gsub(x = out_names, pattern = "r", replacement = "d")
          new_names <- gsub(x = new_names, pattern = "x", replacement = "g", ignore.case = FALSE)
          new_names <- gsub(x = new_names, pattern = "t", replacement = "G", ignore.case = FALSE)
          names(out[["correlations"]])[names(out[["correlations"]]) %in% out_names] <- new_names
     }
     names(out)[names(out) == "correlations"] <- "d_values"
     class(out)[2] <- "correct_d"
     out
}
