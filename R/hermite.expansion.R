#' @title Calculation of Hermite expansion for detection function likelihoods
#' 
#' @description Computes the Hermite expansion terms used in the likelihood of a distance analysis. 
#'   More generally, will compute a Hermite expansion of any numeric vector.
#'   
#' @param x In a distance analysis, \code{x} is a numeric vector containing the proportion of a strip 
#'   transect's half-width at which a group of individuals was sighted.  If \eqn{w} is the strip transect 
#'   half-width or maximum sighting distance, and \eqn{d} is the perpendicular off-transect distance 
#'   to a sighted group (\eqn{d\leq w}{d <= w}), \code{x} is usually \eqn{d/w}.  More generally, \code{x} 
#'   is a vector of numeric values.
#' @param expansions A scalar specifying the number of expansion terms to compute. Must be one of the integers 1, 2, 3, or 4.
#' @details There are, in general, several expansions that can be called Hermite. The Hermite expansion used here is:
#'   \itemize{
#'     \item \bold{First term}: \deqn{h_1(x)=x^4 - 6x^2 + 3,}{h1(x) = x^4 - 6*(x)^2 +3,}
#'     \item \bold{Second term}: \deqn{h_2(x)=x^6 - 15x^4 + 45x^2 - 15,}{h2(x) = (x)^6 - 15*(x)^4 + 45*(x)^2 - 15,}
#'     \item \bold{Third term}: \deqn{h_3(x)=x^8 - 28x^6 + 210x^4 - 420x^2 + 105,}{h3(x) = (x)^8 - 28*(x)^6 + 210*(x)^4 - 420*(x)^2 + 105,}
#'     \item \bold{Fourth term}: \deqn{h_4(x)=x^10 - 45x^8 + 630x^6 - 3150x^4 + 4725x^2 - 945,}{h4(x) = (x)^10 - 45*(x)^8 + 630*(x)^6 - 3150*(x)^4 + 4725*(x)^2 - 945,}
#'   }
#'   The maximum number of expansion terms computed is 4.
#' @return A matrix of size \code{length(x)} X \code{expansions}.  The columns of this matrix are the Hermite polynomial expansions of \code{x}. 
#'   Column 1 is the first expansion term of \code{x}, column 2 is the second expansion term of \code{x}, and so on up to \code{expansions}.
#'   
#' @seealso \code{\link{dfuncEstim}}, \code{\link{cosine.expansion}}, \code{\link{simple.expansion}}, and the discussion 
#'   of user defined likelihoods in \code{\link{dfuncEstim}}.
#'   
#' @examples 
#' x <- seq(0, 1, length = 200)
#' herm.expn <- hermite.expansion(x, 4)
#' plot(range(x), range(herm.expn), type="n")
#' matlines(x, herm.expn, col=rainbow(4), lty = 1) 
#' @keywords model
#' @export

hermite.expansion <- function(x, expansions){

    if (expansions > 4){
        warning("Too many Hermite polynomial expansion terms. Only 4 used.")
        expansions = 4
    }
    
    if( expansions < 1 ) stop( "Number of expansions must be >= 1" )

    x <- 4*x - 2
  
    expansion = matrix(nrow=length(x), ncol=expansions)

    expansion[,1] = x

    if(expansions >= 2){
        expansion[,2] = x^2 - 1
    } 
    if(expansions >= 3){
        expansion[,3] = x^3 - 3*x
    } 
    if(expansions >= 4){
        expansion[,4] =  x^4 - 6*x^2 + 3
    }         
    
    return(expansion)
            
}
