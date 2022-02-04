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


#' Mutate all character variables to factor with as_factor().
#'
#' @param .data
#'
#' @export
#' @examples
#' df <- data.frame(a = c("a", "b"), b = c(1,2))
#' df <- factor_all(df)
#' str(df)
#'
factor_all <- function(.data){
  dplyr::mutate(.data, dplyr::across(where(is.character), forcats::as_factor))
}

#' Rebase (or base) index
#'
#'
#' @param x a numeric vector. An index to rebase
#' @param time a time variable in a Date format.
#' @param baseyear a numeric year or vector of years.
#' @param basevalue index base values. if NULL value of x at base year.
#'
#' @export
rebase <- function(x, time, baseyear, basevalue = 100) {
  time_year <- if (lubridate::is.Date(time)) lubridate::year(time) else time
  if (is.null(basevalue)) basevalue <- mean(x[time_year %in% baseyear])
  y <- basevalue * x / mean(x[time_year %in% baseyear])
  y
}

#' Calculate percentage change
#'
#' @param x A numeric vector
#' @param n Positive integer of length 1, giving the number of positions to lead or lag by
#' @param order_by Override the default ordering to use another vector or column
#'
#' @export
#' @examples
#' df <- data.frame(time = c(1,2,3,4), x = c(100,101,100,98))
#' dplyr::mutate(df, d = pc(x, 1, time))
#' dplyr::mutate(df, d = pc(x, 1))
pc <- function(x, n, order_by = time){
  y <- 100 * (x / dplyr::lag(x, n = n, order_by = order_by) -1)
  y
}



