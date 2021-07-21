# Functions for browsing and searching PTT databases.

# These functions assume, .qs-files are data and .rds-files are database lists.

#' Search PTT data bases
#'
#' @param ... a search term
#' @param filetype "qs" or "rds"
#'
#' @return
#' @export
#'
ptt_search <- function(..., filetype = NULL, path = db_path) {

  searchterms <- unlist(list(...))
  results <- list.files(path)
  if(length(searchterms) > 0) {results <- results[grep(searchterms, results)]}

  if(is.null(filetype)) {
    return(results)
  } else {
    filesuffix <- paste0(".", filetype)
    return(stringr::str_remove(results[grep(filesuffix, results)], filesuffix))
  }
}

#'
#' @describeIn ptt_search Search data sets in PTT database
#' @export
#'
ptt_search_data <- function(..., path = db_path) {
  ptt_search(..., filetype = "qs", path = path)
}

#'
#' @describeIn ptt_search Search database lists in PTT database
#' @export
#'
ptt_search_database <- function(..., path = db_path) {
  ptt_search(..., filetype = "rds", path = path)
}
