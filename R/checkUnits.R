#' @title checkUnits - Check for the presence of units
#' 
#' @description
#' Check for the presence of physical measurement units on key
#' columns of  
#' an \code{RdistDf} data frame. 
#' 
#' @param ml An \code{Rdistance} model list produced by 
#' \code{\link{parseModel}} containing a list
#' of parameters for the distance model. 
#' 
#' @returns The input \code{ml} list, with units of various 
#' quantities converted to common units.  If a check fails, for example, 
#' a quantity does not have units, an error is thrown.
#' 
#' @export
#' 
checkUnits <- function(ml){

  # If we are here, we assume that requireUnits == TRUE
  
  # Units for dist ----
  dist <- dplyr::pull(ml$data, ml$respName)
  if ( !inherits(dist, "units") ){
    stop(paste("Measurement units required on distances.",
          "Assign units by attaching 'units' package then:\n",
          paste0("units(",ml$dataName,"$", ml$respName, ")"), "<- '<units of measurment>',\n",
          "for example 'm' (meters) or 'ft' (feet). See units::valid_udunits()"))
  } 
  # if we are here, dist has units
  # set units for output by converting dist units; 
  # w.lo, w.hi, and x.scl will all be converted later
  # We want outputUnits to be units(dist), not e.g., string "m"
  if ( !is.null(ml$outputUnits) ){
    ml$data <- ml$data |> 
      dplyr::mutate(dplyr::across(.cols = ml$respName
                                , .fns = ~ units::set_units(.x, ml$outputUnits, mode = "standard")))
      # dplyr::mutate( !!ml$respName := units::set_units(!!ml$respName, ml$outputUnits, mode = "standard"))
    ml$outputUnits <- units(units::set_units(1, ml$outputUnits, mode = "standard"))
  } else {
    ml$outputUnits <- units(dist)
  }

  # Units for w.lo ----
  if ( !inherits(ml$w.lo, "units") ){
      if ( is.null(ml$w.lo) || (ml$w.lo[1] != 0) ){
          stop(paste("Measurement units required on minimum distance (w.lo).",
              "Assign units by attaching 'units' package then:",
              "units(w.lo) <- '<units>' or",
              paste0("units::set_units(", 
                     ifelse(is.function(ml$w.lo), "<value>", ml$w.lo),
                     ", <units>) in function call."),
              "See units::valid_udunits() for valid symbolic units."))
      }
      # if we are here, w.lo is 0, it has no units, and we require units
      ml$w.lo <- units::set_units(ml$w.lo, ml$outputUnits, mode = "standard") # assign units to 0
  } 
  # if we are here, w.lo has units and we require units, convert to the output units
  # Technically, I don't think we need to do this.  As long as w.lo has units, we are good.
  # We do this here so that we don't do it later when we print units during output.
  ml$w.lo <- units::set_units(ml$w.lo, ml$outputUnits, mode = "standard")

  # Units on w.hi ----
  if (is.null(ml$w.hi)){
    ml$w.hi <- max(dist, na.rm = TRUE) # units flow through max() automatically
  } else if ( !inherits(ml$w.hi, "units") ){
      stop(paste("Measurement units required on maximum distance (w.hi).",
          "Assign units by attaching 'units' package then:",
          "units(w.hi) <- '<units>' or",
          paste0("units::set_units(", 
                 ifelse(is.function(ml$w.hi), "<value>", ml$w.hi),
                 ", <units>) in function call."),
          "See units::valid_udunits() for valid symbolic units."))
  } 
  # if we are here, w.hi has units and we require them, convert to output units
  # Again, technically I don't think we need to do this.  Happens automatically in computations
  ml$w.hi <- units::set_units(ml$w.hi, ml$outputUnits, mode = "standard")

  # Units on x.scl ---- 
  if( !inherits(ml$x.scl, "units") ){
    if( (ml$x.scl[1] != 0) && (ml$x.scl[1] != "max")){
      stop(paste("Measurement units for x.scl are required.",
                 "Assign units using either:\n", 
                 "units::units(x.scl) <- '<units>' or", 
                 paste0("units::set_units(", 
                        ifelse(is.function(ml$x.scl), "<value>", ml$x.scl),
                        ", <units>) in function call\n"), 
                 "See units::valid_udunits() for valid symbolic units."))
    }
    # if we are here, x.scl is either 0 (w/o units) or "max"
    if(!is.character(ml$x.scl)){
      ml$x.scl <- units::set_units(ml$x.scl, ml$outputUnits, mode = "standard")
    }
  } else {
    # if we are here, x.scl has units, is not "max", so we convert to the output units
    ml$x.scl <- units::set_units(ml$x.scl, ml$outputUnits, mode = "standard")
  }

  ml

}