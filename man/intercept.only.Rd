% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/intercept.only.R
\name{intercept.only}
\alias{intercept.only}
\title{intercept.only - Detect intercept-only distance function}
\usage{
intercept.only(object)
}
\arguments{
\item{object}{An Rdistance model frame or fitted distance function,
normally produced by a call to \code{\link{dfuncEstim}}.}
}
\value{
TRUE if \code{object} contains an intercept-only.
FALSE if \code{object} contains at least one detection-level 
or transect-level covariate in the detection function.
}
\description{
Utility function to detect whether a distance function has 
covariates beyond the intercept. If the model contains an 
intercept-only, effective distance is constant across detections
and short-cuts can be implemented in code.
}
