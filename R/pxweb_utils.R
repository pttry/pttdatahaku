#' Print full query from table url
#'
#' @param url A url to the table
#'
#' @export
#'
#' @examples
#'   pxweb_print_full_query(url = statfi_url("StatFin", "vrm/tyokay/statfin_tyokay_pxt_115u.px"))
#'
pxweb_print_full_query <- function(url){
  meta <- pxweb::pxweb_get(url)
  codes <- sapply(meta$variables, "[[", "code")
  query_list <- as.list(rep("*", times = length(codes)))
  names(query_list) <- codes

  pxq <- pxweb::pxweb_query(query_list)

  full_query <- pxweb:::pxweb_add_metadata_to_query(pxq, meta)
  cat(pxweb:::pxweb_query_as_rcode(full_query), sep ="\n")
}
