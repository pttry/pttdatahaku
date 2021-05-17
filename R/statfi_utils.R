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
#'
statfi_parse_url <- function(url){
  url <- stringr::str_remove(url, "https://pxnet2.stat.fi/PXWeb/pxweb/fi/StatFin/")
  url <- stringr::str_replace_all(url, "__", "/")
  url <- statfi_url(url)
  url
}

