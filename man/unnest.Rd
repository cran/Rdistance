% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/unnest.R
\name{unnest}
\alias{unnest}
\title{unnest - Unnest an RdistDf data frame}
\usage{
unnest(data, ...)
}
\arguments{
\item{data}{An \code{RdistDf} data frame. \code{RdistDf} data frames 
contain one line per transect and a list-based column. The list-based
column contains a data frame with detection information. 
The detection information data frame on each row contains (at least) distances 
and group sizes of all targets detected on the transect.
Function \code{\link{RdistDf}} creates \code{RdistDf} data frames 
from separate transect and detection data frames. 
\code{\link{is.RdistDf}} checks whether data frames
are \code{RdistDf}'s.}

\item{...}{Additional arguments passed to \code{tidyr::unnest} if
\code{data} is not an RdistDf.}
}
\value{
An expanded data frame, without embedded data frames. Rows 
in the return represent with one detection or one transect.  If multiple
detections were made on one transect, the transect will appear on multiple
rows.  If no detections were made on a transect, it will appear on one 
row with NA detection distance.
}
\description{
Unnest an RdistDf data frame by expanding 
the embedded 'detections' column.  This unnest
includes the so-called zero transects (transects without detections).
}
\examples{
data('sparrowDf')

# tidyr::unnest() does not include zero transects
detectionDf <- tidyr::unnest(sparrowDf, detections)
nrow(detectionDf)
any(detectionDf$siteID == "B2")

# Rdistance::unnest() includes zero transects
fullDf <- unnest(sparrowDf)
nrow(fullDf)
any(fullDf$siteID == "B2")

}
