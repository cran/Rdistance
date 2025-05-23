#' @title mlEstimates - Distance function maximum likelihood estimates
#' 
#' @description
#' Estimate parameters of a distance function using maximum likelihood.
#' 
#' @inheritParams startLimits
#' 
#' @param strt.lims A list containing start, low, and high limits for 
#' parameters of the requested likelihood. This list is typically produced
#' by a call to \code{\link{startLimits}}.
#' 
#' @return An Rdistance fitted model object. This object contains the 
#' raw object returned by the optimization routine (e.g., \code{nlming}), 
#' and additional components specific to Rdistance.
#' 
#' @export
#' @importFrom stats nlminb optim

mlEstimates <- function( ml
                       , strt.lims
                       ){

  # Missing observations: 
  #  (1) there can be missing responses (distances); but, Rdistance::distances drops them
  #      i.e., model.response(ml$mf) has missings (potentially), but Rdistance::distances(ml) does not
  #  (2) There are missing group sized in the model frame for transects with missing lengths. 
  #      These don't matter here.
  
  optimFunc <- getOption("Rdistance_optimizer")
  
  contRl <- list(trace = 0
               , eval.max = getOption("Rdistance_evalMax")
               , iter.max = getOption("Rdistance_maxIters")
               , rel.tol = getOption("Rdistance_likeTol")
               , x.tol = getOption("Rdistance_coefTol")
               )

  if (optimFunc == "optim"){
      fit <- stats::optim(
          strt.lims$start
          , nLL
          , lower = units::drop_units(strt.lims$low) # safe
          , upper = units::drop_units(strt.lims$high)
          , hessian = TRUE
          , control = contRl
          , method = c("L-BFGS-B")
          , ml = ml
          )
  } else if (optimFunc == "nlminb"){
      fit <- stats::nlminb(
            start = strt.lims$start
          , objective = nLL
          , lower = strt.lims$low
          , upper = strt.lims$high
          , control = contRl
          , ml = ml
          )

      hessian <- Rdistance::secondDeriv(
            x = fit$par
          , FUN = nLL
          , eps = getOption("Rdistance_hessEps")
          , ml = ml
          )
  } else {
      stop(paste("Unknown optimizer function. Found", optimFunc))
  }

  warn <- getOption("Rdistance_warn")
  if (fit$convergence != 0) {
    if (warn) warning("Distance function did not converge, or converged to (Inf,-Inf)")
    varcovar <- matrix(NaN, nrow(hessian), ncol(hessian))
  } else if (!any(is.na(hessian)) & !any(is.infinite(hessian))){
      qrh <- qr(hessian)
      if (qrh$rank < nrow(hessian)) {
        if (warn) warning("Singular variance-covariance matrix.")
        varcovar <- matrix(NaN, nrow(hessian), ncol(hessian))
      } else {
        varcovar <- tryCatch(solve(hessian), error = function(e){NaN})
        if (length(varcovar) == 1 && is.nan(varcovar)){
          if (warn) warning("Singular variance-covariance matrix.")
          varcovar <- matrix(NaN, nrow(hessian), ncol(hessian))
        }
      }
  } else {
    if (warn) warning("Covariance matrix has Inf or NA elemetns.")
    varcovar <- matrix(NaN, nrow(hessian), ncol(hessian))
  }
  dimnames(varcovar) <- list(strt.lims$names, strt.lims$names)
  fit$varcovar <- varcovar
  
  # final few things ----
  fit$limits <- strt.lims[c("low", "high")]
  names(fit$par) <- strt.lims$names
  # Flip over objective: object$logLike is true logLike, -LL was minimized
  names(fit)[names(fit) == "objective"] <- "loglik"
  fit$loglik <- -fit$loglik  
 
  fit 

}