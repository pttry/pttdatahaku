#' Statfi url
#'
#' Gives full statfi url
#'
#' @param ... Character vectors.
#' @param .base_url A base url for statfi.
#' @param with_base_url logical, whether to add the base of url to the output.
#'    Defaults to \code{TRUE}
#'
#' @export
#'
#' @examples
#'   statfi_url("StatFin", "vkour/statfin_vkour_pxt_12bq.px")
#'
statfi_url <- function(..., with_base_url = TRUE, .base_url = "https://statfin.stat.fi/PXWeb/api/v1/fi"){
  if(with_base_url) {
    file.path(.base_url, ..., fsep = "/")
  } else {
    file.path(..., fsep = "/")
  }
}

#' Parse Statfi pxweb api url from web url
#'
#' Safe in these sense that if the argument is already an api url, returns the
#' argument as such.
#'
#' @param url An url from web to parse
#' @param with_base_url logical, whether the concatenate base_url. Defaults to true.
#'
#' @export
#'
#' @examples
#'   statfi_parse_url("https://pxweb2.stat.fi/PxWeb/pxweb/fi/StatFin/StatFin__muutl/statfin_muutl_pxt_119z.px/")
#'   statfi_parse_url("StatFin__vrm__muutl/statfin_muutl_pxt_119z.px/", with_base_url = FALSE)
#'   statfi_parse_url("StatFin__vrm__muutl/statfin_muutl_pxt_119z.px/")
#'   statfi_parse_url("https://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/vrm/muutl/statfin_muutl_pxt_119z.px")
#'   statfi_parse_url("https://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/vrm/muutl/statfin_muutl_pxt_119z.px", with_base_url = FALSE)
#'
statfi_parse_url <- function(url, with_base_url = TRUE){

  url <- stringr::str_remove(url, "https://pxweb2.stat.fi/PxWeb/pxweb/fi/StatFin/")
  url <- stringr::str_remove(url, "https://statfin.stat.fi/PXWeb/api/v1/fi")
  url <- stringr::str_replace_all(url, "__", "/")
  statfi_url(url, with_base_url = with_base_url)

}



#' @describeIn statfi_parse_url Parsing function for archived databases.
#'
#' @export
#' @examples
#'   statfi_parse_url_arch("https://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin_Passiivi/StatFin_Passiivi__tym__atp/statfinpas_atp_pxt_901_2012q4_fi.px/")
statfi_parse_url_arch <- function(url){
  url <- stringr::str_remove(url, "https://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin_Passiivi/")
  url <- stringr::str_replace_all(url, "__", "/")
  url <- statfi_url(url)
  url
}

#' Parse Statfi pxweb qui url from api url
#'
#' @param url character, url
#'
#' @export
#'
#' @examples
#'
#'   statfi_parse_qui_url("StatFin__vrm__muutl/statfin_muutl_pxt_119z.px/")
#'
statfi_parse_qui_url <- function(url){

  url <- stringr::str_remove(url, "https://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/")
  url <- stringr::str_remove(url, "https://pxnet2.stat.fi/PXWeb/api/v1/fi/")
  end <- stringr::str_match(url, "/statfin.*")
  start <- stringr::str_remove(url, end)
  start <- stringr::str_replace_all(start, "/", "__")
  statfi_url(paste0(start, end), with_base_url = TRUE, .base_url = "https://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin")

}

#' Open table in QUI PxWeb
#'
#' @param x character, url or table code. If table code, set db_list_name
#' @param db_list_name character, database of the table
#'
#' @export
#'
#' @examples
#'
#'   open_statfi_qui("StatFin__vrm__muutl/statfin_muutl_pxt_119z.px/")
#'
open_statfi_qui <- function(x = "", db_list_name = NULL) {

  if(!is.null(db_list_name)) {
    x <- table_code_to_url(x, db_list_name = db_list_name)
  }

  x <- statfi_parse_qui_url(x)
  browseURL(x)

}
