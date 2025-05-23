#' @title unnest - Unnest an RdistDf data frame
#' 
#' @description Unnest an RdistDf data frame by expanding 
#' the embedded 'detections' column.  This unnest
#' includes the so-called zero transects (transects without detections).
#' 
#' @inheritParams dfuncEstim
#' 
#' @param ... Additional arguments passed to \code{tidyr::unnest} if
#' \code{data} is not an RdistDf.  
#' 
#' @return An expanded data frame, without embedded data frames. Rows 
#' in the return represent with one detection or one transect.  If multiple
#' detections were made on one transect, the transect will appear on multiple
#' rows.  If no detections were made on a transect, it will appear on one 
#' row with NA detection distance. 
#' 
#' @examples
#' data('sparrowDf')
#' 
#' # tidyr::unnest() does not include zero transects
#' detectionDf <- tidyr::unnest(sparrowDf, detections)
#' nrow(detectionDf)
#' any(detectionDf$siteID == "B2")
#' 
#' # Rdistance::unnest() includes zero transects
#' fullDf <- unnest(sparrowDf)
#' nrow(fullDf)
#' any(fullDf$siteID == "B2")
#' 
#' @export
unnest <- function(data, ...){
  
  if( Rdistance::is.RdistDf(data) ){
    
    detectionCol <- attr(data, "detectionColumn")
    rowID <- data |> dplyr::group_vars()
    isNull <- data |> 
      dplyr::mutate(dplyr::across(dplyr::all_of(detectionCol)
                                           , ~ is.null(.x))) |> 
      dplyr::pull(dplyr::all_of(detectionCol))
    
    fullDf <- data |> 
      dplyr::ungroup() |> 
      dplyr::filter(isNull) |> # zero transects
      dplyr::select(-dplyr::all_of(detectionCol)) |> 
      dplyr::bind_rows(tidyr::unnest(data = data
                                   , cols = dplyr::all_of(detectionCol))) |> 
      dplyr::arrange(dplyr::across(dplyr::all_of(rowID)))  
    
  } else {
    warning("Rdistance::unnest called with a non-RdistDf data frame. tidyr::unnest() applied instead.")
    fullDf <- tidyr::unnest(data, ...)
  }
  
  fullDf
}
