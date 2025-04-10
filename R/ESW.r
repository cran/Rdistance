#' @title ESW - Effective Strip Width (ESW) for line transects
#'   
#' @description Returns effective strip width (ESW) for 
#'   line-transect detection functions. 
#'   See \code{\link{EDR}} is for point transects.  
#'   
#' @inheritParams effectiveDistance
#' 
#' @details ESW is the area under 
#'   the scaled distance function between its
#'   left-truncation limit (\code{obj$w.lo}) and its right-truncation 
#'   limit (\code{obj$w.hi}). \if{latex}{I.e., 
#'     \deqn{ESW = \int_{w.lo}^{w.hi} g(x)dx,} 
#'   where \eqn{g(x)} is the distance
#'   function scaled so that \eqn{g(x.scl) = g.x.scl}
#'   and \eqn{w.lo} and \eqn{w.hi} are the lower
#'   and upper truncation limits.  }
#'   
#'   If detection does not decline with distance, 
#'   the detection function is flat (horizontal), and 
#'   area under the detection  
#'   function is  \eqn{g(0)(w.hi - w.lo)}.  
#'   If, in this case, \eqn{g(0) = 1}, effective sampling distance is 
#'   the half-width of the surveys, \eqn{(w.hi - w.lo)}
#'   
#' @section Numeric Integration: 
#' Rdistance uses Simpson's composite 1/3 rule to numerically 
#' integrate under distance functions. The number of points evaluated 
#' during numerical integration is controlled by 
#' \code{options(Rdistance_intEvalPts)} (default 101).
#' Option 'Rdistance_intEvalPts' must be odd because Simpson's rule
#' requires an even number of intervals (hence, odd number of points). 
#' Lower values of 'Rdistance_intEvalPts' increase calculation speeds; 
#' but, decrease accuracy.
#' 'Rdistance_intEvalPts' must be >= 5.  A warning is thrown if 
#' 'Rdistance_intEvalPts' < 29. Empirical tests by the author 
#' suggest 'Rdistance_intEvalPts' values >= 30 are accurate 
#' to several decimal points and that all 'Rdistance_intEvalPts' >= 101 produce 
#' identical results in all but pathological cases. 
#'   
#' @inherit effectiveDistance return   
#'   
#' @seealso \code{\link{dfuncEstim}}, \code{\link{EDR}}, 
#' \code{\link{effectiveDistance}}
#' 
#' @examples
#' data(sparrowDf)
#' dfunc <- sparrowDf |> dfuncEstim(formula=dist~bare)
#' 
#' ESW(dfunc) # vector length 356 = number of groups
#' ESW(dfunc, newdata = data.frame(bare = c(30,40))) # vector length 2
#' 
#' @keywords modeling
#' @importFrom stats predict
#' @export

ESW <- function( object, newdata = NULL ){
  
  # Issue error if the input detection function was fit to point-transect data

  if( Rdistance::is.points(object) ){
    stop("ESW is for line transects only.  See EDR for the point-transect equivalent.")
  } 

  nInts <- checkNEvalPts(getOption("Rdistance_intEvalPts")) - 1 # nInts MUST BE even!!!
  seqx = seq(object$w.lo, object$w.hi, length=nInts + 1)

  # Default distances used in predict.dfunc is seq(ml$w.lo, ml$w.hi, getOption("Rdistance_intEvalPts")), 
  y <- stats::predict(object = object
                     , newdata = newdata
                     , distances = seqx
                     , type = "dfuncs"
  )
  dx <- attr(y, "distances") # these are 0 to w, but no matter.
  dx <- dx[2] - dx[1]  # or (w.hi - w.lo) / (nInts); could do diff(dx) if unequal intervals
  
  
  # Numerical integration ----
  # Apply composite Simpson's 1/3 rule here because calling 
  # integrationConstant would be too much.  integrationConstant is specialized for likelihood
  # evaluation and input is a model.
  #
  # Simpson's rule coefficients on f(x0), f(x1), ..., f(x(nEvalPts))
  # i.e., 1, 4, 2, 4, 2, ..., 2, 4, 1
  intCoefs <- c(rep( c(2,4), (nInts/2) ), 1) # here is where we need nInts to be even
  intCoefs[1] <- 1
  intCoefs <- matrix(intCoefs, ncol = 1)
  
  esw <- (t(y) %*% intCoefs) * dx / 3
  esw <- drop(esw) # convert from matrix to vector
  
  # Trapazoid rule: Computation used in Rdistance version < 0.2.2
  # y1 <- y[,-1,drop=FALSE]
  # y  <- y[,-ncol(y),drop=FALSE]
  # esw <- dx*rowSums(y + y1)/2
  
  # Trapezoid rule. (dx/2)*(f(x1) + 2f(x_2) + ... + 2f(x_n-1) + f(n)) 
  # Faster than above, maybe.
  # ends <- c(1,nrow(y))
  # esw <- (dx/2) * (colSums( y[ends, ,drop=FALSE] ) + 
  #                  2*colSums(y[-ends, ,drop=FALSE] ))

  esw
  
}
