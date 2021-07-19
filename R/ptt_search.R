# Functions for browsing and searching PTT databases.

#' Search PTT data bases
#'
#' @param ... a search term
#' @param filetype "qs" or "rds"
#'
#' @return
#' @export
#'
ptt_search <- function(..., filetype = NULL) {

  searchterms <- unlist(list(...))
  results <- list.files(db_path)
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
ptt_search_data <- function(...) {
  ptt_search(..., filetype = "qs")
}

#'
#' @describeIn ptt_search Search database lists in PTT database
#' @export
#'
ptt_search_database <- function(...) {
  ptt_search(..., filetype = "rds")
}

