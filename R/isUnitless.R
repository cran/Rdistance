#' @title isUnitless - Test whether object is unitless
#' 
#' @description Tests whether a 'units' object is actually 
#' unitless.  
#' Unitless objects, such as ratios, should be assigned
#' units of '[1]'.  Often they are, but  
#' sometimes unitless ratios are assigned units like '[m/m]'.
#' The \code{units} package should always convert '[m/m]' to 
#' '[1]', but it does not always. 
#' Sometimes units like '[m/m]' mess things up, so it is 
#' better to remove them before calculations. 
#' 
#' @param obj  A numeric scaler or vector, with or without units. 
#' 
#' @return TRUE if \code{obj} has units and they 
#' are either '[1]' or the denominator units equal
#' the numerator units.  Otherwise, return FALSE.
#' If \code{obj} does not have units, this routine
#' returns TRUE. 
#' 
#' @examples 
#' a <- units::set_units(2, "m")
#' b <- a / a
#' isUnitless(a)
#' isUnitless(b)
#' isUnitless(3)
#' 
#' @export
isUnitless <- function(obj){
  
  if(!is.numeric(obj)){
    stop("'obj' must be numeric.")
  }
  
  if( !inherits(obj, "units") ){
    # Missing units = unitless
    return(TRUE)
  } else if( units(obj) == units::unitless ){
    return(TRUE)
  } else if (isTRUE(all.equal(units(obj)$numerator, units(obj)$denominator))) {
    return(TRUE)
  } else {
    return(FALSE)
  }
  NA
}
