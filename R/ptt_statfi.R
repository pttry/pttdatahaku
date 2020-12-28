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
#'   pp2 <- ptt_get_statfi(url, query, names = )

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
    tidyr::pivot_longer(where(is.numeric), names_to = dplyr::last(names(codes_names)), values_to = "values") %>%
    dplyr::mutate(across(any_of(to_name) & where(is.character),
                           ~factor(.x,
                                   levels = names(codes_names[[cur_column()]]),
                                   labels = codes_names[[cur_column()]]),
                           .names = "{.col}_name")) %>%
    dplyr::rename_with(.cols = any_of(to_name) & where(is.character), ~paste0(.x, "_code")) %>%
    dplyr::mutate(across(where(is.character), ~forcats::as_factor(.x))) %>%
    statfitools::clean_names() %>%
    relocate(time) %>%
    relocate(values, .after = last_col())

    px_df
}

utils::globalVariables(c("time", "values", "where"))


#' Get code name mapping from pxweb_data
#'
#' @param px_data A pxweb_data object.
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


