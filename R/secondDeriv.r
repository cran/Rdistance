#' @title Numeric second derivatives
#' 
#' @description Computes numeric second derivatives (hessian) of an 
#' arbitrary multidimensional function at a particular location.
#' 
#' @param x The location (a vector) where the second derivatives 
#' of \code{FUN} are desired.
#' 
#' @param FUN An R function for which the second derivatives are 
#' sought.  
#' This must be a function of the form FUN <- function(x, ...)\{...\}
#' where x is a vector of variable parameters to FUN at which 
#' to evaluate the 2nd derivative, 
#' and ... are additional parameters needed to evaluate the function.
#' FUN must return a single value (scalar), the height of the 
#' surface above \code{x}, i.e., FUN evaluated at x.  
#' 
#' @param eps A vector of small relative 
#' distances to add to \code{x} 
#' when evaluating derivatives.   This determines the '\eqn{dx}' of 
#' the numerical derivatives.  That is, the function 
#' is evaluated at \code{x}, \code{x+dx}, and \code{x+2*dx}, where 
#' \eqn{dx} = \code{x*eps^0.25}, in order to compute the second 
#' derivative. 
#' \code{eps} defaults to 1e-8 for all 
#' dimensions which equates to setting \eqn{dx} to one percent
#' of each \code{x} (i.e., by default the function is 
#' evaluate at \code{x}, \code{1.01*x} and \code{1.02*x} 
#' to compute the second derivative).  
#' 
#' One might want to change \code{eps} if the scale 
#' of dimensions in \code{x} varies wildly (e.g., kilometers and millimeters), 
#' or if changes between 
#' \code{FUN(x)} and \code{FUN(x*1.01)} are below machine precision.
#' If length of \code{eps} is less than length of \code{x},
#' \code{eps} is replicated to the length of \code{x}. 
#' 
#' @param \dots Any arguments passed to \code{FUN}. 
#' 
#' @details This function uses the "5-point" numeric second derivative 
#' method advocated in numerous numerical recipe texts.  During computation
#' of the 2nd derivative, FUN must be 
#' capable of being evaluated at numerous locations within a hyper-ellipsoid 
#' with cardinal radii 2*\code{x}*(\code{eps})^0.25 = 0.02*\code{x} at the 
#' default value of \code{eps}.   
#' 
#' A handy way to use this function is to call an optimization routine 
#' like \code{nlminb} with FUN, then call this function with the 
#' optimized values (solution) and FUN.  This will yield the hessian 
#' at the solution and this is can produce a better 
#' estimate of the variance-covariance
#' matrix than using the hessian returned by some optimization routines. 
#' Some optimization routines return the hessian evaluated 
#' at the next-to-last step of optimization. 
#' 
#' An estimate of the variance-covariance matrix, which is used in 
#' \code{Rdistance}, is \code{solve(hessian)} where \code{hessian} is
#' \code{secondDeriv(<parameter estimates>, <likelihood>)}.  
#' 
#' @examples 
#' 
#'func <- function(x){-x*x} # second derivative should be -2
#'secondDeriv(0,func)
#'secondDeriv(3,func)
#'
#'func <- function(x){3 + 5*x^2 + 2*x^3} # second derivative should be 10+12x
#'secondDeriv(0,func)
#'secondDeriv(2,func)
#'
#'func <- function(x){x[1]^2 + 5*x[2]^2} # should be rbind(c(2,0),c(0,10))
#'secondDeriv(c(1,1),func)
#'
#' @export

secondDeriv <- function(x
                        , FUN
                        , eps=1e-8
                        , ...
                        ){
  d <- length(x)   # number of dimensions
  if(d > length(eps)){
    eps <- rep(eps,ceiling( d/length(eps) ))[1:d]
  } else if( length(eps) > d){
    eps <- eps[1:d]
  }
  FUN <- match.fun(FUN)
  hess <- matrix(0, nrow=d, ncol=d)
  h <- ifelse(x==0, eps^0.25, (eps^(0.25))*x )
  for(i in 1:d){
    ei <- rep(0,d)
    ei[i] <- 1
    # compute diagonal element
    hess[i,i] <- (-FUN(x+2*h*ei, ...) + 
                   16*FUN(x+h*ei, ...) - 
                   30*FUN(x, ...) +
                   16*FUN(x-h*ei, ...) - 
                   FUN(x-2*h*ei, ...)) / (12*h[i]*h[i])
    if((i+1) <= d){
      # compute off diagonal elements in row i
      for(j in (i+1):d){
        ej <- rep(0,d)
        ej[j] <- 1
        hess[i,j] <- (FUN(x+h*ei+h*ej, ...) - 
                        FUN(x+h*ei-h*ej, ...) -
                        FUN(x-h*ei+h*ej, ...) + 
                        FUN(x-h*ei-h*ej, ...)) / (4*h[i]*h[j])
        # Assume symetric
        hess[j,i] <- hess[i,j]
      }
    }
  }
  hess
}
