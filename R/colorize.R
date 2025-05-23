#' @title colorize - Add color to result if terminal accepts it
#' 
#' @description Add ANSI color to a string using the 
#' \code{crayon} package, if the R environment accepts color. 
#' This function is needed because of the need to determine whether 
#' output can be colorized.  This determination is left up to 
#' \code{crayon::has_color()}. 
#' 
#' In addition, for Rdistance results, we want to only colorize 
#' numbers, not the reporting units.  Everything between the last set 
#' of square brackets (\code{[...]}) is NOT colorized. 
#' 
#' @param STR The string to colorize. 
#' 
#' @param col A string specifying the desired foreground color.  
#' This is passed straight to \code{crayon::style} and so must be 
#' recognized as one of the 8 base crayon colors. i.e., 
#' "black", "red", "green", "yellow", "blue", "magenta", "cyan", 
#' "white", and "silver" (silver = gray). By default, numbers 
#' are styled in "green".
#' 
#' @param bg A string specifying the desired background color. 
#' Must be one of "bgBlack", "bgRed", "bgGreen", "bgYellow", "bgBlue"
#' "bgMagenta", "bgCyan", or "bgWhite".  By default, no background 
#' is applied. 
#' 
#' @return If color is not allowed in the terminal, the input 
#' string is returned unperturbed.  If color is allowed, the input 
#' string is returned with color and background ANSI code surrounding 
#' the initial part of the string from character 1 to the character 
#' before the [ in the last pair of []. 
#' 
#' @seealso \code{crayon::style}
#' 
#' 
# Do not export. In Rdistance namespace only
#
colorize <- function(STR, col=NULL, bg = NULL){
  if(crayon::has_color()){
    if( is.null(col) ){
      col <- "green"
    }
    if(!is.na(STR)){
      uLoc <- regexpr("\\[(?:.(?!\\[))+\\]", STR, perl = TRUE)  # last occurrence of [ to end of string
    } else {
      uLoc <- 0
    }
    if(uLoc > 0){
      u <- substring(STR, uLoc, uLoc + attr(uLoc, "match.length"))
      STR <- substring(STR, 1, uLoc - 1)
    }
    STR <- crayon::style(STR, as = col, bg = bg)
    if(uLoc > 0){
      STR <- paste0(STR, u)
    }
  } 
  STR
}
