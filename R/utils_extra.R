#' To copy to the clipboard aka Ctrl + c
#' 
#' To copy an object to the clipboard.
#' 
#' To mimic ctrl + c. Currently defined as \code{conc <- function(x)
#' write.table(x, "clipboard-128", sep="\t", dec=",", col.names=NA, row.names =
#' if (is.ts(x)) gsub('\.',",",as.character(time(x))) else TRUE)}
#' @param x An object
#' @export
#' @keywords manip utilities
#' @seealso \code{\link{write.table}}
#' @examples
#'   \dontrun{
#'    x <- data.frame(a = c(1,2), b = c(3,4))
#'    conc(x)
#'   }
conc <- function(x){
  write.table(x, "clipboard-128", sep="\t", dec=",", col.names=NA, row.names = if (is.ts(x)) gsub('\\.',",",as.character(time(x))) else TRUE)
}


#' List of levels of all factors in object
#' 
#' Work at least for data.frames
#'
#' @param x an object
#' @export
#' @return Namede list of factory levels.
#' @keywords utilities
alevels <- function(x){
  y <- lapply(x[sapply(x, is.factor)], levels)
  y
}
