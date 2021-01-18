#' Get PTT data from statfi
#'
#' Downloads data from statfi and modifies data to ptt-form.
#'
#' @param url A pxweb object or url that can be coherced to a pxweb object
#' @param query A json string, json file or list object that can be coherced to a pxweb_query object.
#' @param names Whether to add columns for names. "all", "none" or vector of variable names.
#'
#' @import pxweb
#' @import dplyr
#' @export
#'
#' @examples
#'   url = "http://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/kou/vkour/statfin_vkour_pxt_12bq.px"
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
#'   url <- "http://pxnet2.stat.fi/PXWeb/api/v1/fi/Kokeelliset_tilastot/nopsu/koeti_nopsu_pxt_11mx.px"
#'   query <-
#'    list("Vuosinelj\U00E4nnes"=c("2019Q1", "2019Q2", "2019Q3", "2019Q4"),
#'         "Tiedot"=c("alkuperainen_euro",
#'                    "tyopaivakorjattu_euro",
#'                    "kausitasoitettu_euro",
#'                    "trendi_euro"))
#'
#'   pp2 <- ptt_get_statfi(url, query)

ptt_get_statfi <- function(url, query, names = "all"){
  px_data <- pxweb::pxweb_get(url = url, query = query)

  codes_names <- px_code_name(px_data)

  if (names == "all") {
    to_name <- names(codes_names)
  } else if (names == "none") {
    to_name <- NULL
  } else {
    to_name <- names
  }


  px_df <- as.data.frame(px_data, column.name.type = "code",
                         variable.value.type = "code") %>%
    statfitools::clean_times2() %>%
    tidyr::pivot_longer(where(is.numeric),
                        names_to = dplyr::last(names(codes_names)),
                        values_to = "values") %>%
    codes2names(codes_names, to_name) %>%
    dplyr::mutate(across(where(is.character), ~forcats::as_factor(.x))) %>%
    statfitools::clean_names() %>%
    relocate(time) %>%
    relocate(values, .after = last_col())

    attributes(px_df)$citation <- ptt_capture_citation(px_data)
    px_df
}

utils::globalVariables(c("time", "values", "where"))


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


#' Statfi url
#'
#' Gives full statfi url
#'
#' @param ... Character vectors.
#' @param .base_url A base url for statfi.
#'
#' @export
#'
#' @examples
#'   statfi_url("StatFin", "kou/vkour/statfin_vkour_pxt_12bq.px")
#'
statfi_url <- function(..., .base_url = "http://pxnet2.stat.fi/PXWeb/api/v1/fi"){
  file.path(.base_url, ..., fsep = "/")
}


#' Extract citation information from pxweb_data object.
#'
#' @param x, pxweb_data object
#'
#' @return list, a list containing citation information
#' @export
#'
#' @examples
ptt_capture_citation <- function(x) {

  citation <- capture.output(pxweb::pxweb_cite(x))
  citation[citation == ""] <- "break_here"
  citation <- unlist(stringr::str_split(paste(citation, collapse = " "), pattern = "break_here"))
  api_info <- pxweb_api_catalogue()[[pxweb:::pxweb_api_name.pxweb(pxweb(x$url))]]
  list(full_citation = citation[2],
       bibtex_citation = citation[4],
       table_name = px_data$pxweb_metadata$title,
       table_code = str_remove(
                         str_remove(
                            str_remove(tail(unlist(str_split(x$url, pattern = "/")), n= 1),
                                   pattern = "statfin_"),
                            pattern = "pxt_"),
                         pattern = ".px"),
       author = utils::person(api_info$citation$organization),
       organization = api_info$citation$organization,
       address = api_info$citation$address,
       year = as.POSIXlt(x$time_stamp)$year + 1900L,
       url = x$url,
       note = paste0("[Data accessed ", x$time_stamp,
                     " using pxweb R package ", utils::packageVersion("pxweb"), "]"))
}
