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
statfi_url <- function(..., .base_url = "https://pxnet2.stat.fi/PXWeb/api/v1/fi"){
  file.path(.base_url, ..., fsep = "/")
}


#' Parse Statfi pxweb url from web url
#'
#' @param url An url from web to parse
#'
#' @export
#'
#' @examples
#'   statfi_parse_url("https://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/StatFin__vrm__muutl/statfin_muutl_pxt_119z.px/")
#'   statfi_parse_url("StatFin__vrm__muutl/statfin_muutl_pxt_119z.px/")
#'   statfi_parse_url("https://pxnet2.stat.fi/PXWeb/api/v1/fi/StatFin/vrm/muutl/statfin_muutl_pxt_119z.px")
#'
statfi_parse_url <- function(url, with_base_url = TRUE){

  # Determine which elements of input vector url are already not in the api url form
  to_be_parsed <- !grepl("https://pxnet2.stat.fi/PXWeb/api/v1/fi", url)

  url[to_be_parsed] <- stringr::str_remove(url[to_be_parsed], "https://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/")
  url[to_be_parsed] <- stringr::str_replace_all(url[to_be_parsed], "__", "/")
  if(with_base_url) url[to_be_parsed] <- statfi_url(url[to_be_parsed])
  url
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
