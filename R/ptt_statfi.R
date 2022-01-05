#' Get PTT data from statfi
#'
#' Downloads data from statfi and modifies data to ptt-form.
#'
#' @param url A pxweb object or url that can be coherced to a pxweb object
#' @param query A json string, json file or list object that can be coherced to a pxweb_query object.
#' @param names Whether to add columns for names. "all", "none" or vector of variable names.
#' @param check_classifications A locigal whether to check region classification.
#' @param renames to rename variables.
#'
#' @import pxweb
#' @import dplyr
#' @export
#'
#' @examples
#'   url = "https://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/kou/vkour/statfin_vkour_pxt_12bq.px"
#'   query <-
#'     list("Vuosi"=c("1970","1975"),
#'          "Alue"=c("SSS","KU020","KU005"),
#'          "Ik\U00E4"=c("SSS","15-19"),
#'          "Sukupuoli"=c("SSS","1","2"),
#'          "Koulutusaste"=c("SSS","3T8"),
#'          "Tiedot"=c("vaesto"))
#'
#'   pp <- ptt_get_statfi(url, query)
#'   pp <- ptt_get_statfi(url, query, names = "none")
#'   pp <- ptt_get_statfi(url, query, names = c("Alue"))
#'
#'   url <- "https://pxnet2.stat.fi/PXWeb/api/v1/fi/Kokeelliset_tilastot/nopsu/koeti_nopsu_pxt_11mx.px"
#'   query <-
#'    list("Vuosinelj\U00E4nnes"=c("2019Q1", "2019Q2", "2019Q3", "2019Q4"),
#'         "Tiedot"=c("alkuperainen_euro",
#'                    "tyopaivakorjattu_euro",
#'                    "kausitasoitettu_euro",
#'                    "trendi_euro"))
#'
#'   pp2 <- ptt_get_statfi(url, query)

ptt_get_statfi <- function(url, query, names = "all",
                           check_classifications = TRUE,
                           renames = NULL){

  message("Updating: ", url)

  px_data <- pxweb::pxweb_get(url = url, query = query)

  codes_names <- px_code_name(px_data)

  # rename variables
   #  First to make sure region naming works when renaming
  if (!is.null(renames)){
    names(renames) <- gsub("alue", "Alue", names(renames))
    names(codes_names) <- recode(names(codes_names),
                                 !!!setNames(names(renames), renames))
  }

  # columns to name
  if (names == "all") {
    to_name <- names(codes_names)
  } else if (names == "none") {
    to_name <- NULL
  } else {
    to_name <- names
  }

  if(!is.null(codes_names$Alue)) {
    # Use the region codes of data to bring the region names from classifications
    names_of_codes_names <- names(codes_names$Alue)
    codes_names_orig <- codes_names$Alue
    codes_names$Alue <- statficlassifications::codes_to_names(names(codes_names$Alue))
    # Return any original names if names could not be found
    codes_names$Alue[is.na(codes_names$Alue)] <- codes_names_orig[is.na(codes_names$Alue)]
    names(codes_names$Alue) <- names_of_codes_names
  }

  px_df <- as.data.frame(px_data, column.name.type = "code",
                         variable.value.type = "code") %>%

    # renames variables
    rename(!!!renames) %>%

    # All longer
    tidyr::pivot_longer(where(is.numeric),
                        names_to = setdiff(names(codes_names), names(.)),
                        values_to = "values") %>%
    statfitools::clean_times2() %>%
    codes2names(codes_names, to_name) %>%
    dplyr::mutate(across(where(is.character), ~forcats::as_factor(.x))) %>%
    statfitools::clean_names() %>%
    relocate(time) %>%
    relocate(values, .after = last_col()) %>%
    droplevels()

  attributes(px_df)$citation <- ptt_capture_citation(px_data)
  codes_names <- statfitools::clean_names(codes_names)
  attributes(px_df)$codes_names <- codes_names

  if(check_classifications) {
    if("alue_code" %in% names(px_df) & "alue_name" %in% names(px_df)) {
      statficlassifications::check_region_classification(px_df$alue_name, px_df$alue_code)
    } else {
      message("Region classification check: Either no region variables to check or region variables not with names 'alue_code' and 'alue_name'.")
    }
  }

  px_df
}

utils::globalVariables(c("time", "values", "where"))


#' Get PTT statfi data via robonomist
#'
#'
#' @param x robonomist id or a table code as defined in the package. If table_code
#'    give db_list_name.
#' #' @param query, §-filter, defaults to full query, \code{NULL}
#' @param db_list_name in case x is a table code db_list gives the mapping from
#'    table codes to urls. Only use this if x is table_code.
#' @param labels logical, whether to have variables with labels or codes. Defaults
#'    to \code{FALSE}
#'
#' @return robonomist data
#' @export
#'
ptt_get_statfi_robonomist <- function(x, query = NULL, db_list_name = NULL, labels = FALSE) {

  if(!is.null(db_list_name)) {x <- table_code_to_url(x, db_list_name, with_base_url = FALSE)}

  x <- statfi_parse_url(x, with_base_url = FALSE)
  x <- paste0(x, query)
  robonomistClient::data(x, labels = labels, tidy_time = TRUE) |>
    statfitools::clean_names() |>
    dplyr::mutate(dplyr::across(where(is.character), forcats::as_factor)) |>
    droplevels() |>
    rm_empty_cols()

}


#' Get code name mapping from pxweb_data
#'
#' @param px_data A pxweb_data object.
#'
#' @export
#'
#' @return A named (column codes) list of named (codes) vectors (names).
#'
px_code_name <- function(px_data){
  purrr::map(rlang::set_names(px_data$pxweb_metadata$variables,
                              sapply(px_data$pxweb_metadata$variables, "[[", "code")),
             ~rlang::set_names(.x$valueTexts, .x$values))
}




#' Extract citation information from pxweb_data object.
#'
#' @param x, pxweb_data object
#'
#' @return list, a list containing citation information
#' @export
#'
ptt_capture_citation <- function(x) {

  citation <- capture.output(pxweb::pxweb_cite(x))
  citation[citation == ""] <- "break_here"
  citation <- unlist(stringr::str_split(paste(citation, collapse = " "), pattern = "break_here"))
  api_info <- pxweb_api_catalogue()[[pxweb:::pxweb_api_name.pxweb(pxweb(x$url))]]
  list(full_citation = citation[2],
       bibtex_citation = citation[4],
       table_name = x$pxweb_metadata$title,
       table_code = get_table_code(x$url),
       author = utils::person(api_info$citation$organization),
       organization = api_info$citation$organization,
       address = api_info$citation$address,
       year = as.POSIXlt(x$time_stamp)$year + 1900L,
       url = x$url,
       note = paste0("[Data accessed ", x$time_stamp,
                     " using pxweb R package ", utils::packageVersion("pxweb"), "]"))
}

#' Get table code from url
#'
#' @param url A url
get_table_code <- function(url){

  sapply(url,
         function(x) {paste(stringr::str_match(x, "statfin_\\s*(.*?)\\s*pxt_\\s*(.*?)\\s*.px")[,2:3], collapse = "")},
         USE.NAMES = FALSE)

}

#' Get url from table code
#'
#' Inverse of get_table_code. However, a table code is not sufficient information
#' for url so this has to use a db_list to map table codes to urls.
#'
#' TODO: if db_list_name not given, url should be retrievable from statfi.
#'
#' @param url A url
#' @param db_list_name chr
#' @param with_base_url logical. Defaults to \code{FALSE}
#'
#' @export
#'
table_code_to_url <- function(x, db_list_name, with_base_url = FALSE) {

  statfi_parse_url(ptt_read_db_list(db_list_name)[[x]]$url, with_base_url = with_base_url)

}

#' Test if table code in existing db_list
#'
#' @param x chr, potential table code
#'
#' @return logical
#' @export
#'
is_table_code <- function(x) {
    x %in% unlist(lapply(ptt_search_db(), \(x) names(ptt_read_db_list(x))))
}
