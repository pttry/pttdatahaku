#' Print full query from table url
#'
#' @param url A url to the table
#' @param time_all if TRUE (default) will print time variable as \code{c("*")}.
#'
#' @export
#'
#' @examples
#'   pxweb_print_full_query(url = statfi_url("StatFin", "tyokay/statfin_tyokay_pxt_115u.px"))
#'
pxweb_print_full_query <- function(url, time_all = TRUE){

  full_query <- pxweb_prepare_full_query(url, time_all)

  cat(pxweb:::pxweb_query_as_rcode(full_query), sep ="\n")
}

#' Print a code to get a full query from table url
#'
#' @param url An api url to the table or an url to web page.
#' @param time_all if TRUE (default) will print time variable as \code{c("*")}.
#' @param target A connection, "" to standard output, "clipboard-128" to clipboard.
#'
#' @export
#'
#' @examples
#'   pxweb_print_code_full_query(url = statfi_url("StatFin", "tyokay/statfin_tyokay_pxt_115u.px"))
#'
pxweb_print_code_full_query <- function(url, time_all = TRUE, target = ""){

  if (!grepl("api", url)) {
    if (grepl("Passiivi", url))
      {url <- statfi_parse_url_arch(url)}
    else
      {url <- statfi_parse_url(url)}}

  full_query <- pxweb_prepare_full_query(url = url, time_all = time_all)

  table_code <- get_table_code(url)

  cat("dat_", table_code, " <- ptt_get_statfi(\n",
      "  url = \"", url, "\",\n",
      "  query = \n  ",
      paste0(pxweb:::pxweb_query_as_rcode(full_query)[-1], collapse = "\n"),
      ")",
      sep = "",
      file = target)
}

#' @describeIn pxweb_print_code_full_query Prints to clipboard
#'
#' @export

pxweb_print_code_full_query_c <- function(url, time_all = TRUE, target = "clipboard-128"){

  pxweb_print_code_full_query(url = url, time_all = time_all, target = target)
}

#' prepare query to print
#'
#' @describeIn pxweb_print_full_query
#'
pxweb_prepare_full_query <- function(url, time_all = TRUE) {
  meta <- pxweb::pxweb_get(url)
  codes <- sapply(meta$variables, "[[", "code")
  query_list <- as.list(rep("*", times = length(codes)))
  names(query_list) <- codes

  pxq <- pxweb::pxweb_query(query_list)

  full_query <- pxweb:::pxweb_add_metadata_to_query(pxq, meta)

  if (time_all) {
    time_position <- na.omit(match(c("vuosi", "vuosineljannes", "kuukausi"),
                                   statfitools::make_names(
                                     purrr::map_chr(full_query$query, ~.x$code))))
    full_query$query[[time_position]]$selection$values <- "*"
  }
  full_query
}

#' Return full query as a list
#'
#' @describeIn pxweb_print_full_query
#'
pxweb_full_query_as_list <- function(url, time_all = TRUE) {

  url <- statfi_parse_url(url)
  full_query_r_expr <- pxweb:::pxweb_query_as_rcode(pxweb_prepare_full_query(url, time_all = time_all))
  eval(parse(text = paste0(full_query_r_expr[-1], collapse = "\n")))

}
