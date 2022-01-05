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
ptt_search_db <- function(..., path = db_path) {
  ptt_search(..., filetype = "rds", path = path)
}



#' Browse metadata attached to a database list
#'
#' @param db_list_name chr, name of db list
#'
#' @return
#' @export
#'
ptt_glimpse_db <- function(db_list_name) {

  db <- ptt_read_db_list(db_list_name)

  output <-dplyr::bind_cols(table = names(db),
                            title = sapply(names(db), get_title, db_list_name = db_list_name),
                            do.call(rbind, lapply(names(db), get_manual_metadata, db_list_name = db_list_name)),
                            variables = sapply(names(db), get_variables, db_list_name = db_list_name, as_string = TRUE),
                            time_var = sapply(names(db), get_time_var, db_list_name = db_list_name))

  rownames(output) <- NULL
  tibble::tibble(output)
}


#' @describeIn Browse metadata attached to a database list
#' @export
#'
get_pxweb_metadata <- function(table_code, db_list_name) {

  ptt_read_db_list(db_list_name)[[table_code]]$pxweb_metadata

}

#' @describeIn Browse metadata attached to a database list
#' @export
#'
get_variables <- function(table_code, db_list_name, as_string = FALSE) {

  metadata <- get_pxweb_metadata(table_code, db_list_name)
  if(is.null(metadata)) return(NULL)
  output <- sapply(metadata$variables, `[[`, "text")
  if(as_string) {output <- paste(output, collapse = ", ")}
  output
}

#' @describeIn Browse metadata attached to a database list
#' @export
#'
get_time_var <- function(table_code, db_list_name) {

  vars <- get_variables(table_code, db_list_name)
  if(is.null(vars)) return(NULL)
  x <- c("vuosi", "vuosineljannes", "kuukausi")
  x[na.omit(match(statfitools::make_names(vars), x))]

}

#' @describeIn Browse metadata attached to a database list
#' @export
#'
get_manual_metadata <- function(table_code, db_list_name) {
  ptt_read_db_list(db_list_name)[[table_code]]$manual_metadata
}

#' @describeIn Browse metadata attached to a database list
#' @export
#'
get_title <- function(table_code, db_list_name) {

  ptt_read_db_list(db_list_name)[[table_code]]$pxweb_metadata$title

}


