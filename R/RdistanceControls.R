#' @title Rdistance optimization control parameters.
#' 
#' @aliases control controls RdistanceControls
#' 
#' @concept control optimization
#' 
#' @description Optimization control parameters 
#' are set by calls to \code{options()} (see examples). 
#' Optimization parameters used in 
#' \code{Rdistance} are the following:  
#' 
#' \itemize{
#'   \item \code{Rdist_maxIters}: The maximum number of optimization 
#' iterations allowed.
#' 
#'   \item \code{Rdist_evalMax}: The maximum number of objective function
#' evaluations allowed.
#' 
#'   \item \code{Rdist_likeTol}: Minimum change in the likelihood 
#' between iterations required optimization to continue.  
#' If the likelihood changes by less than this amount, 
#' optimization stops and a solution is declared. Iteration 
#' continues when likelihood changes exceed this value.
#' 
#'   \item \code{Rdist_coefTol}: Minimum change in model coefficients 
#' between iterations for optimization to continue.  
#' If the sum of squared coefficient differences changes 
#' by less than this amount between iterations, 
#' optimization stops and a solution is declared. 
#'
#'   \item \code{Rdist_optimizer}: A string specifying the optimizer 
#' to use.  Results can vary between optimizers, so 
#' switching algorithms sometimes makes a poorly 
#' behaved distance function converge.  Valid 
#' values are "optim" which uses \code{optim::optim},
#' and "nlminb" which uses \code{stats:nlminb}.  The authors 
#' have had better luck with "nlminb" than "optim" and "nlminb" 
#' runs noticeably faster.  Problems with solutions near, but not on,
#' parameter boundaries may require use of "optim".   
#'
#'   \item \code{Rdist_hessEps}: A vector of parameter distances used during 
#' computation of numeric second derivatives. These distances control
#' and determine variance estimates, and they may need revision when 
#' the maximum likelihood solution is near a parameter boundary. 
#' Should have length 
#' 1 or the number of parameters in the model. See function 
#' \code{\link{secondDeriv}} for further details. 
#'  
#'   \item \code{Rdist_requireUnits}: A logical specifying whether measurement 
#' units are required on distances and areas.  If TRUE, 
#' measurement units are required on off-transect and radial 
#' distances in the input data frame.  Likewise, measurement 
#' units are required on truncation distances, scale location, 
#' transect lengths, and study area size. If FALSE, no units are 
#' required and input values are used as is.  The FALSE options is 
#' provided for rare cases when \code{Rdistance} functions are called
#' from other functions and the calling functions do not accommodate 
#' units.
#' 
#' Assign units with statement like \code{units(detectionDf$dist) <- "m"}
#' or \code{units::set_units(w.hi, "km")}.  Measurement units of 
#' the various physical quantities need not 
#' be equal because appropriate conversions occur internally.
#' An error is thrown if differing units are not compatible.  
#' For example, "m" (meters) cannot be converted into "ha" (hectares),
#' but "acres" can be converted into "ha".
#' \code{Rdistance} recognizes units listed in \code{units::valid_udunits()}. 
#' 
#'   \item \code{Rdist_maxBSFailPropForWarning}: The proportion of bootstrap 
#' iterations that can fail without a warning. If the proportion 
#' of non-convergent bootstrap iterations exceeds this 
#' parameter, a warning about the validity of CI's is issued in 
#' the abundance print method. 
#' 
#' 
#' }
#' 
#' @examples 
#' # increase number of iterations
#' options(Rdist_maxIters=2000)
#' 
#' # change optimizer and decrease tolerance
#' options(list(Rdist_optimizer="optim", Rdist_likeTol=1e-6)) 
#' 
#' @name RdistanceControls
NULL
