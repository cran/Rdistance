#' @title Print a distance function object
#' 
#' @description Print method for distance functions produced by \code{dfuncEstim},
#' which are of class \code{dfunc}.
#' 
#' @param x An estimated distance function resulting from a call to \code{dfuncEstim}.
#' 
#' @param \dots Included for compatibility with other print methods.  Ignored here.
#' 
#' @return The input distance function (\code{x}) is returned invisibly.
#' 
#' @seealso \code{\link{dfuncEstim}}, \code{\link{plot.dfunc}}, 
#' \code{\link{print.abund}}, \code{\link{summary.dfunc}}
#' 
#' @examples
#' # Load example sparrow data (line transect survey type)
#' data(sparrowDetectionData)
#' 
#' # Fit half-normal detection function
#' dfunc <- dfuncEstim(formula=dist~1,
#'                     detectionData=sparrowDetectionData)
#' 
#' dfunc
#' 
#' @keywords models
#' @export
#' @importFrom stats pnorm

print.dfunc <- function( x, ... ){

    is.smoothed <- inherits( x$fit, "density" )

    callLine <- deparse(x$call)
    callLine <- paste(callLine, collapse = " ")
    callLine <- strwrap(paste0("Call: ",callLine),exdent=2)

    cat(paste0(callLine,"\n"))
    if ( length(coef.dfunc(x)) & !is.smoothed ) {
      if( x$convergence == 0 ) {
        vcDiag <- diag(x$varcovar)
        if( any(is.na(vcDiag)) | any(vcDiag < 0.0)) {
          mess <- colorize("FAILURE", bg = "bgYellow")
          mess <- paste(mess, "(singular variance-covariance matrix)")
          seCoef <- rep(NA, length(diag(x$varcovar)))
          waldZ <- rep(NA, length(diag(x$varcovar)))
        } else {
          mess <- colorize("Success")
          seCoef <- sqrt(diag(x$varcovar))
          waldZ <- coef.dfunc(x) / seCoef
        }
      } else {
        mess <- colorize("FAILURE", col="white", bg = "bgRed")
        mess <- paste( mess, "(Exit code=", x$convergence, ", ", x$fit$message, ")")
        seCoef <- rep(NA, length(diag(x$varcovar)))
        waldZ <- rep(NA, length(diag(x$varcovar)))
      }
      pWaldZ <- 2*pnorm(-abs(waldZ), 0, 1 )
      coefMat <- cbind(format(coef.dfunc(x)), format(seCoef), format(waldZ), format(pWaldZ))
      dimnames(coefMat)[[2]] <- c("Estimate", "SE", "z", "p(>|z|)")
      cat("Coefficients:\n")
      print.default(coefMat, print.gap = 2, quote = FALSE)
      if( !grepl("Success", mess) ){
        cat("\n")
        cat(paste("Convergence: ", mess,  "\n", sep=""))
      }
    } else if( is.smoothed ){
      cat(paste(x$fit$call[["kernel"]], "kernel smooth\n"))
      cat(paste(" Bandwidth method:", x$fit$call[["bw"]], "with adjustment factor", 
                  format(x$fit$call[["adjust"]]),"\n"))
      cat(paste(" Actual bandwidth =", format(x$fit$bw), "\n"))
    } else {
      cat("No coefficients\n")
    }

    invisible(x)
}
